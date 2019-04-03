//
//  SurveyViewModel.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation

protocol SurveyViewModel {
    var isOffline: Dynamic<Bool> { get }
    var noOfSurveys: Dynamic<Int> { get }
    var isSurveyDataLoading: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }
    
    func getSurveyDetail(atIndex indexpath: IndexPath) -> Survey?
    func getPrefectchedIndexPaths() -> [IndexPath]
    func fetchSurveys()
    func refreshSurveys()
}
