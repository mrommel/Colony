//
//  Buildings.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum BuildingError: Error {
    case alreadyBuild
}

protocol AbstractBuildings {
    
    // buildings
    func has(building: BuildingType) -> Bool
    func build(building: BuildingType) throws
    
    // stats
    func defense() -> Int
    func defenseModifier() -> Int
}

class Buildings: AbstractBuildings {
    
    private var buildings: [BuildingType]
    private var city: AbstractCity?
    
    private var defenseVal: Int
    private var defenseModifierVal: Int
    
    init(city: AbstractCity?) {
        
        self.city = city
        self.buildings = []
        
        self.defenseVal = 0
        self.defenseModifierVal = 0
    }
    
    func has(building: BuildingType) -> Bool {
        
        return self.buildings.contains(building)
    }
    
    func build(building: BuildingType) throws {
        
        if self.buildings.contains(building) {
            throw BuildingError.alreadyBuild
        }
        
        self.updateDefense()
        
        self.buildings.append(building)
    }
    
    private func updateDefense() {
        
        var defenseVal = 0
        for building in BuildingType.all {
            
            if self.has(building: building) {
                defenseVal += building.defense()
            }
        }
    }
    
    func defense() -> Int {
        
        return self.defenseVal
    }
    
    func defenseModifier() -> Int {
        
        return self.defenseModifierVal
    }
}
