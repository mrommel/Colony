//
//  Flavor.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Flavor {

    let type: FlavorType
    var value: Int
    
    init(type: FlavorType, value: Int) {
        
        self.type = type
        self.value = value
    }
}

extension Flavor: CustomDebugStringConvertible {
    
    var debugDescription: String {
        
        return "(Flavor: \(self.type), \(self.value))"
    }
}
