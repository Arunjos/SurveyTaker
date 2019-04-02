//
//  Dynamic.swift
//  SurveyTaker
//
//  Created by Arun Jose on 31/03/19.
//  Copyright © 2019 __ORGANIZATION NAME__. All rights reserved.
//

import Foundation

class Dynamic<T>{
    typealias Listener = (T) -> ()
    
    var listeners:[Listener] = []
    var value:T {
        didSet{
            listeners.forEach{
                $0(value)
            }
        }
    }
    
    init(_ value:T) {
        self.value = value
    }
    func bind(_ listener: @escaping Listener){
        self.listeners.append(listener)
    }
}
