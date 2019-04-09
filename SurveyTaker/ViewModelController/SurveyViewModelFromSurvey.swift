//
//  SurveyViewModelFromSurvey.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
import Moya
import Alamofire

class SurveyViewModelFromSurvey: SurveyViewModel {
    
    var isOffline: Dynamic<Bool>
    var noOfSurveys: Dynamic<Int>
    var isSurveyDataLoading: Dynamic<Bool>
    var error: Dynamic<String>
    
    var page = 0
    var pageCount = 6
    var surveyList = [Survey]()
    var prefetchedSurveyIndexpaths = [IndexPath]()
    
    private let tokenFetcher = MoyaProvider<TokenFetcher>()
    private let surveyFetcher = MoyaProvider<SurveyFetcher>()
    
    var prefetchedSurveyList = [Survey]() {
        didSet {
//            if prefetchedSurveyList.isEmpty {
//                return
//            }
            let lowerBound = self.surveyList.count
            let upperBound = lowerBound + prefetchedSurveyList.count
            self.prefetchedSurveyIndexpaths = (lowerBound ..< upperBound).flatMap { row -> ([IndexPath]) in
                return [IndexPath(row: row, section: 0)]
            }
            if !prefetchedSurveyList.isEmpty {
                self.surveyList.append(contentsOf: prefetchedSurveyList)
            }
            self.noOfSurveys.value = self.surveyList.count
            self.isSurveyDataLoading.value = false
        }
    }
    
    init() {
        isOffline = Dynamic(false)
        isSurveyDataLoading = Dynamic(false)
        noOfSurveys = Dynamic(0)
        error = Dynamic("")
    }
    
    func getSurveyDetail(atIndex indexpath: IndexPath) -> Survey? {
        return surveyList[indexpath.row]
    }
    
    func getPrefectchedIndexPaths() -> [IndexPath] {
        return self.prefetchedSurveyIndexpaths
    }
    
    func fetchSurveys() {
        self.page += 1
        isSurveyDataLoading.value = true
        
        let surveyFetchompletionHandler: Completion = { [unowned self] response in
            switch response {
            case .success(let result):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: result.data, options: [])
                    guard let responseArray = jsonObject as? [[String: Any]] else {
                        self.error.value = "Failed to fetch surveys"
                        return
                    }
                    self.prefetchedSurveyList = Survey.getSurveyListFrom(jsonArray: responseArray)
                } catch {
                    self.prefetchedSurveyList = []
                }
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
        
        let tokenFetchCompletionHandler: Completion = { [unowned self] response in
            switch response {
            case .success(let result):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: result.data, options: [])
                    guard let responseDict = jsonObject as? [String: Any] else {
                        self.error.value = "Failed to fetch token"
                        return
                    }
                    let token = Token.getTokenFrom(jsonObj: responseDict)
                    self.surveyFetcher.request(.surveys(page: self.page,
                                                        pageCount: self.pageCount,
                                                        token: token),
                                               completion: surveyFetchompletionHandler)
                } catch {
                    self.error.value = error.localizedDescription
                }
            case .failure: break
            }
        }
        //Call the token api and start processing
        self.tokenFetcher.request(.token, completion: tokenFetchCompletionHandler)
    }
    
    func refreshSurveys() {
        self.page = 0
        self.surveyList.removeAll()
        self.noOfSurveys.value = 0
        self.fetchSurveys()
    }
}
