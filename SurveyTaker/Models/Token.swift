//
//  Token.swift
//  SurveyTaker
//
//  Created by Arun Jose on 01/04/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
import ObjectMapper

public class Token: Mappable {
    public var accessToken:String?
    public var type:String?
    public var expiresIn:Int?
    public var createdAt:Int?
    
    required public init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        accessToken <- map[Constants.Params.AccessToken]
        type <- map[Constants.Params.TokenType]
        expiresIn <- map[Constants.Params.ExpiresIn]
        createdAt <- map[Constants.Params.CreatedAt]
    }
}

extension Token {
    public static func getTokenFrom(jsonObj:[String:Any]) -> Token? {
        let token = Mapper<Token>().map(JSON: jsonObj)
        return token
    }
}
