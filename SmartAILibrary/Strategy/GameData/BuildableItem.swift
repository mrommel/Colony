//
//  BuildableItem.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum BuildableItemType {
    
    case unit
    case building
    case project
}

enum ProjecType {
    
}

class BuildableItem {
    
    let type: BuildableItemType
    
    // one or the other
    let unitType: UnitType?
    let buildingType: BuildingType?
    let projectType: ProjectType?
    
    var production: Double

    init(unitType: UnitType) {
        
        self.type = .unit
        self.unitType = unitType
        self.buildingType = nil
        self.projectType = nil
        
        self.production = 0.0
    }
    
    init(buildingType: BuildingType) {
        
        self.type = .building
        self.unitType = nil
        self.buildingType = buildingType
        self.projectType = nil
        
        self.production = 0.0
    }
    
    init(projectType: ProjectType) {
        
        self.type = .building
        self.unitType = nil
        self.buildingType = nil
        self.projectType = projectType
        
        self.production = 0.0
    }
    
    func add(production productionDelta: Double) {
        
        self.production += productionDelta
    }
    
    func productionLeft() -> Double {
        
        switch self.type {
            
        case .unit:
            if let unitType = self.unitType {
                return Double(unitType.productionCost()) - self.production
            }
            
            return 0.0
        case .building:
            if let buildingType = self.buildingType {
                return Double(buildingType.productionCost()) - self.production
            }
            
            return 0.0
        case .project:
            if let projectType = self.projectType {
                return Double(projectType.productionCost()) - self.production
            }
            
            return 0.0
        }
    }
    
    func ready() -> Bool {
        
        return self.productionLeft() <= 0
    }
}

extension BuildableItem: Equatable {
    
    static func == (lhs: BuildableItem, rhs: BuildableItem) -> Bool {
        
        if lhs.type != rhs.type {
            return false
        }
        
        switch lhs.type {
            
        case .unit:
            return lhs.unitType == rhs.unitType
        case .building:
            return lhs.buildingType == rhs.buildingType
        case .project:
            return lhs.projectType == rhs.projectType
        }
    }
}

extension BuildableItem: CustomDebugStringConvertible {
    
    var debugDescription: String {
        
        switch self.type {
            
        case .unit:
            if let unitType = self.unitType {
                return "Unit: \(unitType)"
            }
            
            return "Unit: ???"
        case .building:
            if let buildingType = self.buildingType {
                return "Building: \(buildingType)"
            }
            
            return "Building: ???"
        case .project:
            if let projectType = self.projectType {
                return "Project: \(projectType)"
            }
            
            return "Project: n/a"
        }
    }
}
