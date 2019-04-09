//
//  SurveyViewModelFromSurvey.swift
//  SurveyTakerTests
//
//  Created by Arun Jose on 04/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import XCTest
import Alamofire
@testable import SurveyTaker_Debug

class SurveyViewModelFromSurvey: XCTestCase {
    var viewModel: SurveyTaker_Debug.SurveyViewModelFromSurvey?
    var params = [String: Any]()
    override func setUp() {
        super.setUp()
        StubHandler.installJSONStub()
        StubHandler.installAccessTokenStub()
        params = [
            "page": 1,
            "per_page": 6
        ]
        viewModel = SurveyTaker_Debug.SurveyViewModelFromSurvey()
    }
    
    override func tearDown() {
        params = [:]
        viewModel = nil
        StubHandler.uninstallJSONStub()
        StubHandler.uninstallAccessTokenStub()
        super.tearDown()
    }
    
//    func testGetSurveyListCount() {
//
//        let promise = expectation(description: "Succefully fetch survey through API")
//        let surveysListFetchCompletionHanlder: ([Survey]) -> Void = { prefetchedSurveyList in
//            XCTAssertTrue(prefetchedSurveyList.count == 6)
//            promise.fulfill()
//        }
//
//        self.getAccessToken { [unowned self] token in
//            self.viewModel?.getSurveyList(witAccessToken: token,
//                                          withParams: self.params,
//                                          forUrl: Constants.SurveyAPIURL,
//                                          completionHandler: surveysListFetchCompletionHanlder )
//        }
//
//        waitForExpectations(timeout: 5, handler: nil)
//    }
    
    func testfetchSurveysFirstValue() {
        
        let testSurvey = Survey(title: "Scarlett Bangkok",
                                description: "We'd love ot hear from you!",
                                bgImage: "https://dhdbhh0jsld0o.cloudfront.net/m/1ea51560991bcb7d00d0_")
        
        let promise = expectation(description: "Succefully completed fetchSurveys")
        viewModel?.noOfSurveys.bind { [unowned self] _ in
            let firstSurvey = self.viewModel?.prefetchedSurveyList[0]
            XCTAssertTrue(firstSurvey == testSurvey)
            promise.fulfill()
        }
        viewModel?.fetchSurveys()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testfetchSurveys() {
        let promise = expectation(description: "Succefully completed fetchSurveys")
        viewModel?.noOfSurveys.bind { count in
            XCTAssertTrue(count == 6)
            promise.fulfill()
        }
        viewModel?.fetchSurveys()
        waitForExpectations(timeout: 5, handler: nil)
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
    
}
