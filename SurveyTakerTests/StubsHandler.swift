//
//  StubsHandler.swift
//  SurveyTakerTests
//
//  Created by Arun Jose on 09/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
import OHHTTPStubs
@testable import SurveyTaker_Debug

public class StubHandler {
    
    public static var jsonStubWithToken: OHHTTPStubsDescriptor?
    public static var jsonStub: OHHTTPStubsDescriptor?
    public static var accessStub: OHHTTPStubsDescriptor?
    public static var token = Token(accessToken: "8deea7d0056fb56e40523a4dfc7847680d94ee36709827a7e8d98a65bce2934c",
                                    type: "bearer",
                                    expiresIn: 7200,
                                    createdAt: 1554287545)
    
    public static func installSurveyJSONStubWithToken() {
        guard let stubPath = OHPathForFile("test_survey_list_count.json", StubHandler.self) else {
            return
        }
        jsonStubWithToken = stub(condition: isExtension("json") &&
            isHost("nimble-survey-api.herokuapp.com") &&
            hasHeaderNamed("Authorization", value: "\(token.type ?? "") \(token.accessToken ?? "")")) {_ in
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }
        jsonStubWithToken?.name = "Survey JSON stub With token"
    }
    
    public static func uninstallJSONStubWithToken() {
        if let jsonStubWithToken = jsonStubWithToken {
            OHHTTPStubs.removeStub(jsonStubWithToken)
        }
    }
    
    public static func installJSONStub() {
        guard let stubPath = OHPathForFile("test_survey_list_count.json", StubHandler.self) else {
            return
        }
        jsonStub = stub(condition: isExtension("json") && isHost("nimble-survey-api.herokuapp.com")) {_ in
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }
        jsonStub?.name = "Survey JSON stub"
    }
    
    public static func uninstallJSONStub() {
        if let jsonStub = jsonStub {
            OHHTTPStubs.removeStub(jsonStub)
        }
    }
    
    public static func installAccessTokenStub() {
        guard let stubPath = OHPathForFile("test_access_token.json", StubHandler.self) else {
            return
        }
        accessStub = stub(condition: isMethodPOST() && isHost("nimble-survey-api.herokuapp.com")) {_ in
            return fixture(filePath: stubPath, headers: ["Content-Type": "application/json"])
                .requestTime(0.0, responseTime: OHHTTPStubsDownloadSpeedWifi)
        }
        accessStub?.name = "Survey Access Token stub"
    }
    
    public static func uninstallAccessTokenStub() {
        if let accessStub = accessStub {
            OHHTTPStubs.removeStub(accessStub)
        }
    }
    
}
