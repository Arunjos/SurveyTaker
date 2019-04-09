//
//  TokeFetcher.swift
//  SurveyTaker
//
//  Created by Arun Jose on 09/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
import Moya

public enum TokenFetcher {
    
    case token
}

extension TokenFetcher: TargetType {
    public var baseURL: URL {
        return Constants.SurveyTakerBaseURL
    }
    
    public var path: String {
        switch self {
        case .token: return "/oauth/token"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .token: return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .token :
            let params = [
                "grant_type": "password",
                "username": "carlos@nimbl3.com",
                "password": "antikera"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .token :
            let headers = [
                "Content-Type": "application/x-www-form-urlencoded",
                "Accept": "application/json"
            ]
            return headers
        }
    }
    
}
