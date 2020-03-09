//
//  BuildQueue.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BuildQueue {
    
    private var items: [BuildableItem]
    
    init() {
        
        self.items = []
    }
    
    func add(item: BuildableItem) {
        
        self.items.append(item)
    }
    
    func building(of buildingType: BuildingType) -> BuildableItem? {
        
        if let item = self.items.first(where: { $0.type == .building && $0.buildingType == buildingType }) {
            return item
        }
        
        return nil
    }
    
    func unit(of unitType: UnitType) -> BuildableItem? {
        
        if let item = self.items.first(where: { $0.type == .unit && $0.unitType == unitType }) {
            return item
        }
        
        return nil
    }
    
    func peek() -> BuildableItem? {
        
        return self.items.first
    }
    
    func pop() {
        
        self.items.removeFirst()
    }
}
