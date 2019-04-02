//
//  Survey.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation
import ObjectMapper

public class Survey: Mappable {
    public var title:String?
    public var description:String?
    public var bgImage:String?
    
    required public init?(map: Map){
        
    }
    
    init(title:String?, description:String?, bgImage:String?) {
        self.title = title
        self.description = description
        self.bgImage = bgImage
    }
    
    public func mapping(map: Map) {
        title <- map[Constants.Params.TITLE]
        description <- map[Constants.Params.DESCRIPTION]
        bgImage <- map[Constants.Params.CoverImageURL]
    }
}

extension Survey {
    public static func getSurveyListFrom(jsonArray:[[String:Any]]) -> [Survey] {
        let surveyList = Mapper<Survey>().mapArray(JSONArray: jsonArray)
        return surveyList
    }
}
