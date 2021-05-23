//
//  Yields.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class Yields {
    
    public var food: Double
    public var production: Double
    public var gold: Double
    
    public var science: Double
    public var culture: Double
    public var faith: Double
    
    public var housing: Double
    public var appeal: Double
    
    init(food: Double, production: Double, gold: Double, science: Double = 0.0, culture: Double = 0.0, faith: Double = 0.0, housing: Double = 0.0, appeal: Double = 0.0) {
        
        self.food = food
        self.production = production
        self.gold = gold
        
        self.science = science
        self.culture = culture
        self.faith = faith
        
        self.housing = housing
        self.appeal = appeal
    }
    
    public func value(of yieldType: YieldType) -> Double {
        
        switch yieldType {
        
        case .none: return 0.0
        case .food: return self.food
        case .production: return self.production
        case .gold: return self.gold
        case .science: return self.science
            
        case .culture: return self.culture
        case .faith: return self.faith
        }
    }
    
    public func list() -> YieldList {
        
        let yieldList: YieldList = YieldList()
        
        for yieldType in YieldType.all {
            
            yieldList.set(weight: self.value(of: yieldType), for: yieldType)
        }
        
        return yieldList
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
        lhs.appeal += rhs.appeal
    }
    
    static func -=(lhs: inout Yields, rhs: Yields) {
        lhs.food -= rhs.food
        lhs.production -= rhs.production
        lhs.gold -= rhs.gold
        
        lhs.science -= rhs.science
        lhs.culture -= rhs.culture
        lhs.faith -= rhs.faith
        
        lhs.housing -= rhs.housing
        lhs.appeal -= rhs.appeal
    }
    
    static func -(lhs: Yields, rhs: Yields) -> Yields {
        
        return Yields(food: lhs.food - rhs.food, production: lhs.production - rhs.production, gold: lhs.gold - rhs.gold, science: lhs.science - rhs.science, culture: lhs.culture - rhs.culture, faith: lhs.faith - rhs.faith, housing: lhs.housing - rhs.housing, appeal: lhs.appeal - rhs.appeal)
    }
}
