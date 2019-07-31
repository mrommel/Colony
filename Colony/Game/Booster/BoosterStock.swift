//
//  BoosterStock.swift
//  Colony
//
//  Created by Michael Rommel on 28.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class BoosterStock: Decodable {

    private var amountTelescopeBooster: Int
    private var amountTimeBooster: Int
    
    enum CodingKeys: String, CodingKey {
        case amountTelescopeBooster
        case amountTimeBooster
    }
    
    init() {
        self.amountTelescopeBooster = 0
        self.amountTimeBooster = 0
    }
    
    func isAvailable(boosterType: BoosterType) -> Bool {
        
        switch boosterType {
        case .telescope:
            return self.amountTelescopeBooster > 0
        case .time:
            return self.amountTimeBooster > 0
        }
    }
    
    func amount(of boosterType: BoosterType) -> Int {
        
        switch boosterType {
            
        case .telescope:
            return self.amountTelescopeBooster
        case .time:
            return self.amountTimeBooster
        }
    }
    
    func update(amount: Int, of boosterType: BoosterType) {
        
        switch boosterType {
            
        case .telescope:
            self.amountTelescopeBooster = amount
        case .time:
            self.amountTimeBooster = amount
        }
    }
    
    func decrement(boosterType: BoosterType) {
        
        switch boosterType {
            
        case .telescope:
            self.amountTelescopeBooster -= 1
        case .time:
            self.amountTimeBooster -= 1
        }
    }
    
    func increment(boosterType: BoosterType) {
        
        switch boosterType {
            
        case .telescope:
            self.amountTelescopeBooster += 1
        case .time:
            self.amountTimeBooster += 1
        }
    }
}

extension BoosterStock: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.amountTelescopeBooster, forKey: .amountTelescopeBooster)
        try container.encode(self.amountTimeBooster, forKey: .amountTimeBooster)
    }
}

extension BoosterStock: NSCopying {
    
    func copy(with zone: NSZone? = nil) -> Any {
        
        let boosterStockCopy = BoosterStock()
        
        for boosterType in BoosterType.all {
            boosterStockCopy.update(amount: self.amount(of: boosterType), of: boosterType)
        }
        
        return boosterStockCopy
    }
}
