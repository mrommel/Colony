//
//  Promotions.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum PromotionError: Error {
    
    case alreadyEarned
}

protocol AbstractPromotions {
    
    // promotions
    func has(promotion: UnitPromotionType) -> Bool
    func earn(promotion: UnitPromotionType) throws
    
    func count() -> Int
    func possiblePromotions() -> [UnitPromotionType]
}

class Promotions: AbstractPromotions {
      
    private var promotions: [UnitPromotionType]
    private var unit: AbstractUnit?
    
    init(unit: AbstractUnit?) {
        
        self.unit = unit
        self.promotions = []
    }

    func has(promotion: UnitPromotionType) -> Bool {
        
        return self.promotions.contains(promotion)
    }
    
    func earn(promotion: UnitPromotionType) throws {
        
        if self.has(promotion: promotion) {
            throw PromotionError.alreadyEarned
        }
        
        self.promotions.append(promotion)
    }
    
    func count() -> Int {
        
        return self.promotions.count
    }
    
    func possiblePromotions() -> [UnitPromotionType] {
        
        guard let unit = self.unit else {
            fatalError("cant get unit")
        }
        
        var promotionList: [UnitPromotionType] = []
        
        for promotion in UnitPromotionType.all {
            
            if !unit.isOf(unitClass: promotion.unitClass()) {
                continue
            }
            
            if self.has(promotion: promotion) {
                continue
            }
            
            var valid = true
            for requiredPromotion in promotion.required() {
                if !self.has(promotion: requiredPromotion) {
                    valid = false
                }
            }
            
            if !valid {
                continue
            }
            
            promotionList.append(promotion)
        }
        
        return promotionList
    }
}

