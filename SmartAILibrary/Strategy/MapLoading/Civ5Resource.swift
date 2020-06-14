//
//  Civ5Resource.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension ResourceType {
    
    static func fromCiv5String(value: String) -> ResourceType? {
        
        switch value {
        
        default:
            fatalError("case \(value) must be handled")
        }
    }
}
