//
//  SurveyFetcher.swift
//  SurveyTaker
//
//  Created by Arun Jose on 09/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
import Moya

public enum SurveyFetcher {
    
    case surveys(page:Int, pageCount:Int, token:Token?)
}

extension SurveyFetcher: TargetType {
    public var baseURL: URL {
        return Constants.SurveyTakerBaseURL
    }
    
    public var path: String {
        switch self {
        case .surveys: return "/surveys.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .surveys: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .surveys(let(page, pageCount, _)) :
            let params = [
                "page": page,
                "per_page": pageCount
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .surveys( _, _, let token) :
            var headers = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            if let token = token, let type = token.type, let accessToken = token.accessToken {
                headers["Authorization"] = "\(type) \(accessToken)"
            }
            return headers
        }
    }
        
}
