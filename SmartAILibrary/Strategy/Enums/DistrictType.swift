//
//  DistrictType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum DistrictType {
    
    case cityCenter
    case campus
    case holySite
    case encampment
    case harbor
    
    var all: [DistrictType] {
        return [ .cityCenter, .campus, .holySite, .encampment, .harbor]
    }
    
    func name() -> String {

        return self.data().name
    }
    
    // in production units
    func productionCost() -> Int {

        return self.data().productionCost
    }
    
    func required() -> TechType? {
        
        return self.data().required
    }
    
    // MARK: private methods / classes
    
    struct DistrictTypeData {
        
        let name: String
        let productionCost: Int
        let required: TechType?
    }
    
    func data() -> DistrictTypeData {
        
        switch self {
            
        case .cityCenter: return DistrictTypeData(name: "CityCenter", productionCost: 0, required: nil)
        case .campus: return DistrictTypeData(name: "campus", productionCost: 54, required: .writing)
        case .holySite: return DistrictTypeData(name: "holySite", productionCost: 54, required: .astrology)
        case .encampment:  return DistrictTypeData(name: "encampment", productionCost: 54, required: .bronzeWorking)
        case .harbor: return DistrictTypeData(name: "harbor", productionCost: 54, required: .celestialNavigation)
        }
    }
}
