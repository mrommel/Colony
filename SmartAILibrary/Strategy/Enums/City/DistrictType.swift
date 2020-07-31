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
    case entertainment
    case commercialHub
    case industrial
    
    public static var all: [DistrictType] {
        return [.cityCenter, .campus, .holySite, .encampment, .harbor, .entertainment, .commercialHub, .industrial]
    }
    
    public func name() -> String {

        return self.data().name
    }
    
    // in production units
    public func productionCost() -> Int {

        return self.data().productionCost
    }
    
    public func requiredTech() -> TechType? {
        
        return self.data().requiredTech
    }
    
    public func requiredCivic() -> CivicType? {
        
        return self.data().requiredCivic
    }
    
    // MARK: private methods / classes
    
    struct DistrictTypeData {
        
        let name: String
        let productionCost: Int
        let requiredTech: TechType?
        let requiredCivic: CivicType?
    }
    
    func data() -> DistrictTypeData {
        
        switch self {
            
        case .cityCenter: return DistrictTypeData(name: "CityCenter", productionCost: 0, requiredTech: nil, requiredCivic: nil)
            
        case .campus: return DistrictTypeData(name: "Campus", productionCost: 54, requiredTech: .writing, requiredCivic: nil)
        case .holySite: return DistrictTypeData(name: "HolySite", productionCost: 54, requiredTech: .astrology, requiredCivic: nil)
        case .encampment:  return DistrictTypeData(name: "Encampment", productionCost: 54, requiredTech: .bronzeWorking, requiredCivic: nil)
        case .harbor: return DistrictTypeData(name: "Harbor", productionCost: 54, requiredTech: .celestialNavigation, requiredCivic: nil)
        case .entertainment: return DistrictTypeData(name: "Entertainment", productionCost: 54, requiredTech: nil, requiredCivic: .dramaAndPoetry)
        case .commercialHub: return DistrictTypeData(name: "Commercial Hub", productionCost: 54, requiredTech: .currency, requiredCivic: nil)
        case .industrial:
            // https://civilization.fandom.com/wiki/Industrial_Zone_(Civ6)
            return DistrictTypeData(name: "Industrial Zone",
                                    productionCost: 54,
                                    requiredTech: .apprenticeship,
                                    requiredCivic: nil)
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
    
    // in gold
    func maintenanceCost() -> Int {

        switch self {

        case .cityCenter: return 0
        case .campus: return 1
        case .holySite: return 1
        case .encampment: return 0
        case .harbor: return 0
        case .entertainment: return 1 // ???
        case .commercialHub: return 0
        case .industrial: return 1
        }
    }
}
