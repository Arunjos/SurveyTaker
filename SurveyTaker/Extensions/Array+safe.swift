//
//  Array+safe.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation

extension Array {
    public subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        
        return self[index]
    }
}
