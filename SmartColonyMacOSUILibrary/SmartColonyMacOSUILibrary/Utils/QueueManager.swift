//
//  QueueManager.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 20.05.21.
//

import SmartAILibrary

class QueueManager {
    
}

extension QueueManager: UnitViewModelDelegate {
    
    func clicked(on unitType: UnitType, at index: Int) {
        print("remove unitType: \(unitType) at \(index)")
    }
}

extension QueueManager: DistrictViewModelDelegate {
    
    func clicked(on districtType: DistrictType, at index: Int) {
        print("remove districtType: \(districtType) at \(index)")
    }
}

extension QueueManager: BuildingViewModelDelegate {
    
    func clicked(on buildingType: BuildingType, at index: Int) {
        print("remove buildingType: \(buildingType) at \(index)")
    }
}

extension QueueManager: WonderViewModelDelegate {
    
    func clicked(on wonderType: WonderType, at index: Int) {
        print("remove wonderType: \(wonderType) at \(index)")
    }
}
