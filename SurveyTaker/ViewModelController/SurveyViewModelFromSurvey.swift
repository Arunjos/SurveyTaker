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
    
    var page = 1
    var pageCount = 10
    var surveyList = [Survey]()
    
    init() {
        isOffline = Dynamic(false)
        isSurveyDataLoading = Dynamic(false)
        noOfSurveys = Dynamic(0)
        error = Dynamic("")
    }
    
    func getSurveyDetail(atIndex indexpath: IndexPath) -> Survey? {
        return surveyList[indexpath.row]
    }
    
    func fetchSurvey() {
        print("ARunnsss test")
        let params = [
            "grant_type": "password",
            "username": "carlos@nimbl3.com",
            "password": "antikera"
        ]
        self.getAccessToken(WithURL: Constants.AccessTokenAPIURL, withParams: params, completionHandler: {[unowned self] token in
            print("hello")
            print(token?.accessToken)
            self.fetchSurvey1(witAccessToken: token, forUrl: Constants.SurveyAPIURL)
        })
    }
    
    func fetchSurvey1(witAccessToken accessToken:Token?, forUrl url:String) {
        self.isSurveyDataLoading.value = true
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        if let token = accessToken, let type = token.type, let accessToken = token.accessToken {
            headers["Authorization"] = "\(type) \(accessToken)"
        }
        Alamofire.request(url, method:.get,parameters:nil, headers: headers).validate(contentType: ["application/json"]).responseJSON { [unowned self] response in
            self.isSurveyDataLoading.value = false
            print("kello")
            print(response)
            guard let responseArray = response.result.value as? [[String : Any]] else {
                self.error.value = "Failed to parse code list response"
                return
            }
            self.surveyList = Survey.getSurveyListFrom(jsonArray: responseArray)
            self.noOfSurveys.value = self.surveyList.count
        }
    }
    
    func getAccessToken(WithURL url:String, withParams params:[String:Any], completionHandler:@escaping (Token?)->()) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        Alamofire.request(url, method:.post,parameters:params, headers: headers).validate(contentType: ["application/json"]).responseJSON { [unowned self] response in
            self.isSurveyDataLoading.value = false
            guard let responseObj = response.result.value as? [String : Any] else {
                self.error.value = "Failed to parse code list response"
                completionHandler(nil)
                return
            }
            let token = Token.getTokenFrom(jsonObj:responseObj)
            completionHandler(token)
        }
    }
    
    func refreshSurveys(witAccessToken accessToken:String, forUrl url:String) {
        
    }
    
    
}
