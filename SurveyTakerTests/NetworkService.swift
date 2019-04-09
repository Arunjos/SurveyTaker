//
//  NetworkService.swift
//  SurveyTakerTests
//
//  Created by Arun Jose on 09/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import XCTest
import Moya
@testable import SurveyTaker_Debug

class NetworkService: XCTestCase {
    
    private let surveyFetcher = MoyaProvider<SurveyFetcher>()
    override func setUp() {
        super.setUp()
        StubHandler.installSurveyJSONStubWithToken()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        StubHandler.uninstallJSONStubWithToken()
        super.tearDown()
    }
    
    func testSurveyFetcher() {
        
        let promise = expectation(description: "Succefully fetch survey through API")
        let surveyFetchompletionHandler: Completion = { response in
            switch response {
            case .success(let result):
                do {
                    let jsonObject = try JSONSerialization.jsonObject(with: result.data, options: [])
                    guard let responseArray = jsonObject as? [[String: Any]] else {
                        return
                    }
                    let surveyFetchResult = Survey.getSurveyListFrom(jsonArray: responseArray)
                    
                    XCTAssertTrue(surveyFetchResult.count == 6)
                    promise.fulfill()
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.surveyFetcher.request(.surveys(page: 1,
                                            pageCount: 6,
                                            token: StubHandler.token),
                                   completion: surveyFetchompletionHandler)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
