//
//  Constants.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation

struct Constants {
    static let SurveyCellID = "survey_cell_id"
    struct Params {
        public static let TITLE = "title"
        public static let DESCRIPTION = "description"
        public static let CoverImageURL = "cover_image_url"
        public static let AccessToken = "access_token"
        public static let TokenType = "token_type"
        public static let ExpiresIn = "expires_in"
        public static let CreatedAt = "created_at"
    }
    
    public static let SurveyTakerBaseURL = URL(string: "https://nimble-survey-api.herokuapp.com")!
    public static let SurveyAPIURL = "https://nimble-survey-api.herokuapp.com/surveys.json"
    public static let AccessTokenAPIURL = "https://nimble-survey-api.herokuapp.com/oauth/token"
}
