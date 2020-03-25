//
//  Wonders.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum WonderError: Error {
    case alreadyBuild
}

protocol AbstractWonders {
    
    // wonders
    func has(wonder: WonderType) -> Bool
    func build(wonder: WonderType) throws
}

class Wonders: AbstractWonders {
    
    private var wonders: [WonderType]
    private var city: AbstractCity?
    
    init(city: AbstractCity?) {
        
        self.city = city
        self.wonders = []
    }
    
    func has(wonder: WonderType) -> Bool {
        
        return self.wonders.contains(wonder)
    }
    
    func build(wonder: WonderType) throws {
        
        if self.wonders.contains(wonder) {
            throw WonderError.alreadyBuild
        }
        
        self.wonders.append(wonder)
    }
}
