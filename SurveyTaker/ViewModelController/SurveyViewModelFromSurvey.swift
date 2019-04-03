//
//  SurveyViewModelFromSurvey.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
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
        print("indexpaths", self.prefetchedSurveyIndexpaths)
        return self.prefetchedSurveyIndexpaths
    }
    
    func fetchSurveys() {
        
        self.page += 1
        isSurveyDataLoading.value = true
        let surveysListFetchCompletionHanlder: ([Survey]) -> Void = {prefetchedSurveyList in
            let lowerBound = self.surveyList.count
            let upperBound = lowerBound + prefetchedSurveyList.count
            self.prefetchedSurveyIndexpaths = (lowerBound ..< upperBound).flatMap { row -> ([IndexPath]) in
                return [IndexPath(row: row, section: 0)]
            }
            if !prefetchedSurveyList.isEmpty {
                self.surveyList.append(contentsOf: prefetchedSurveyList)
                self.noOfSurveys.value = self.surveyList.count
            }
            self.isSurveyDataLoading.value = false
        }
        
        let params = [
            "grant_type": "password",
            "username": "carlos@nimbl3.com",
            "password": "antikera"
        ]
        self.getAccessToken(WithURL: Constants.AccessTokenAPIURL,
                            withParams: params) { [unowned self] token in
                                let params = [
                                    "page": self.page,
                                    "per_page": self.pageCount
                                ]
                                self.getSurveyList(witAccessToken: token,
                                                   withParams: params,
                                                   forUrl: Constants.SurveyAPIURL,
                                                   completionHandler: surveysListFetchCompletionHanlder )
        }
    }
    
    func getSurveyList(witAccessToken accessToken: Token?, withParams param: [String: Any], forUrl url: String, completionHandler: @escaping ([Survey]) -> Void) {
        self.isSurveyDataLoading.value = true
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if let token = accessToken, let type = token.type, let accessToken = token.accessToken {
            headers["Authorization"] = "\(type) \(accessToken)"
        }
        Alamofire.request(url, method: .get, parameters: param, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { [unowned self] response in
                self.isSurveyDataLoading.value = false
                if let error = response.result.error {
                    self.error.value = error.localizedDescription
                    completionHandler([])
                    return
                }
                guard let responseArray = response.result.value as? [[String: Any]] else {
                    completionHandler([])
                    return
                }
                let surveyList = Survey.getSurveyListFrom(jsonArray: responseArray)
                completionHandler(surveyList)
            }
    }
    
    func getAccessToken(WithURL url: String, withParams params: [String: Any], completionHandler: @escaping (Token?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        Alamofire.request(url, method: .post, parameters: params, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { [unowned self] response in
                self.isSurveyDataLoading.value = false
                if let error = response.result.error {
                    self.error.value = error.localizedDescription
                    completionHandler(nil)
                    return
                }
                guard let responseObj = response.result.value as? [String: Any] else {
                    completionHandler(nil)
                    return
                }
                let token = Token.getTokenFrom(jsonObj: responseObj)
                completionHandler(token)
            }
    }
    
    func refreshSurveys() {
        self.page = 0
        self.surveyList.removeAll()
        self.noOfSurveys.value = 0
        self.fetchSurveys()
    }
}
