//
//  SurveyViewModelFromSurvey.swift
//  SurveyTakerTests
//
//  Created by Arun Jose on 04/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import XCTest
import Alamofire
import OHHTTPStubs
@testable import SurveyTaker_Debug

class SurveyViewModelFromSurvey: XCTestCase {
    let viewModel = SurveyTaker_Debug.SurveyViewModelFromSurvey()
    var params = [String: Any]()
    override func setUp() {
        super.setUp()
        self.installJSONStub()
        params = [
            "page": 1,
            "per_page": 6
        ]
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetSurveyListCount() {
        
        let promise = expectation(description: "Succefully fetch survey through API")
        let surveysListFetchCompletionHanlder: ([Survey]) -> Void = { prefetchedSurveyList in
            XCTAssertTrue(prefetchedSurveyList.count == 6)
            promise.fulfill()
        }
        
        self.getAccessToken { [unowned self] token in
            self.viewModel.getSurveyList(witAccessToken: token,
                                         withParams: self.params,
                                         forUrl: Constants.SurveyAPIURL,
                                         completionHandler: surveysListFetchCompletionHanlder )
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    private func getAccessToken(completionHandler: @escaping (Token?) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept": "application/json"
        ]
        let params = [
            "grant_type": "password",
            "username": "carlos@nimbl3.com",
            "password": "antikera"
        ]
        Alamofire.request(Constants.AccessTokenAPIURL, method: .post, parameters: params, headers: headers)
            .validate(contentType: ["application/json"])
            .responseJSON { response in
                
                guard let responseObj = response.result.value as? [String: Any] else {
                    completionHandler(nil)
                    return
                }
                let token = Token.getTokenFrom(jsonObj: responseObj)
                completionHandler(token)
            }
    }
    
    func installJSONStub() {
        guard let stubPath = OHPathForFile("test_survey_list_count.json", type(of: self)) else {
            return
        }
        let textStub = stub(condition: isExtension("json") && isHost("nimble-survey-api.herokuapp.com")) {_ in
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }
        textStub.name = "Survey JSON stub"
    }
    
}
