//
//  DistrictType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum DistrictType: Int, Codable {
    
    case cityCenter
    case campus
    case holySite
    case encampment
    case harbor
    
    public static var all: [DistrictType] {
        return [.cityCenter, .campus, .holySite, .encampment, .harbor]
    }
    
    public func name() -> String {

        return self.data().name
    }
    
    // in production units
    public func productionCost() -> Int {

        return self.data().productionCost
    }
    
    public func required() -> TechType? {
        
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
            
        case .campus: return DistrictTypeData(name: "Campus", productionCost: 54, required: .writing)
        case .holySite: return DistrictTypeData(name: "HolySite", productionCost: 54, required: .astrology)
        case .encampment:  return DistrictTypeData(name: "Encampment", productionCost: 54, required: .bronzeWorking)
        case .harbor: return DistrictTypeData(name: "Harbor", productionCost: 54, required: .celestialNavigation)
        }
    }

    func canConstruct(on neighbor: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        if self == .harbor {
            if let neighborTile = gameModel.tile(at: neighbor) {
                return neighborTile.terrain().isWater()
            }
        }
        
        return true // FIXME
    }
}
