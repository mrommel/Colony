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
    case wonder
    case district
    case project
}

enum ProjecType {
    
}

enum WonderType {
    
    case pyramids
    
    func productionCost() -> Int {

        return 0
    }
}

class BuildableItem {
    
    let type: BuildableItemType
    
    // one or the other
    let unitType: UnitType?
    let buildingType: BuildingType?
    let wonderType: WonderType?
    let districtType: DistrictType?
    let projectType: ProjectType?
    
    var production: Double

    init(unitType: UnitType) {
        
        self.type = .unit
        self.unitType = unitType
        self.buildingType = nil
        self.wonderType = nil
        self.districtType = nil
        self.projectType = nil
        
        self.production = 0.0
    }
    
    init(buildingType: BuildingType) {
        
        self.type = .building
        self.unitType = nil
        self.buildingType = buildingType
        self.wonderType = nil
        self.districtType = nil
        self.projectType = nil
        
        self.production = 0.0
    }
    
    init(wonderType: WonderType) {
        
        self.type = .building
        self.unitType = nil
        self.buildingType = nil
        self.wonderType = wonderType
        self.districtType = nil
        self.projectType = nil
        
        self.production = 0.0
    }
    
    init(districtType: DistrictType) {
        
        self.type = .district
        self.unitType = nil
        self.buildingType = nil
        self.wonderType = nil
        self.districtType = districtType
        self.projectType = nil
        
        self.production = 0.0
    }
    
    init(projectType: ProjectType) {
        
        self.type = .building
        self.unitType = nil
        self.buildingType = nil
        self.wonderType = nil
        self.districtType = nil
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
        case .wonder:
            if let wonderType = self.wonderType {
                return Double(wonderType.productionCost()) - self.production
            }
                   
            return 0.0
        case .district:
            if let districtType = self.districtType {
                return Double(districtType.productionCost()) - self.production
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
        case .wonder:
            return lhs.wonderType == rhs.wonderType
        case .project:
            return lhs.projectType == rhs.projectType
        case .district:
            return lhs.districtType == rhs.districtType
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
        case .wonder:
            if let wonderType = self.wonderType {
                return "wonder: \(wonderType)"
            }
        
        return "wonder: ???"
        case .district:
            if let districtType = self.districtType {
                return "District: \(districtType)"
            }
            
            return "District: ???"
        case .project:
            if let projectType = self.projectType {
                return "Project: \(projectType)"
            }
            
            return "Project: n/a"
        
        }
    }
}
