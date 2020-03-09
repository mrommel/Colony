//
//  Yields.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class Yields {
    
    var food: Double
    var production: Double
    var gold: Double
    
    var science: Double
    var culture: Double
    var faith: Double
    
    var housing: Double
    
    init(food: Double, production: Double, gold: Double, science: Double = 0.0, culture: Double = 0.0, faith: Double = 0.0, housing: Double = 0.0) {
        
        self.food = food
        self.production = production
        self.gold = gold
        
        self.science = science
        self.culture = culture
        self.faith = faith
        
        self.housing = housing
    }
}

extension Yields {
    
    static func +=(lhs: inout Yields, rhs: Yields) {
        lhs.food += rhs.food
        lhs.production += rhs.production
        lhs.gold += rhs.gold
        
        lhs.science += rhs.science
        lhs.culture += rhs.culture
        lhs.faith += rhs.faith
        
        lhs.housing += rhs.housing
    }
}
