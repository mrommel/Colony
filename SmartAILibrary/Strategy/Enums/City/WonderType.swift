//
//  WonderType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum WonderType: Int, Codable {

    case none

    // ancient
    case greatBath
    case pyramids
    case hangingGardens
    case oracle
    case stonehenge
    case templeOfArtemis

    public static var all: [WonderType] {

        return [
            // ancient
            .greatBath, .pyramids, .hangingGardens, .oracle, .stonehenge, .templeOfArtemis
        ]
    }

    public func name() -> String {

        return self.data().name
    }
    
    public func era() -> EraType {

        return self.data().era
    }

    public func productionCost() -> Int {

        return self.data().productionCost
    }

    public func requiredTech() -> TechType? {

        return self.data().requiredTech
    }

    public func requiredCivic() -> CivicType? {

        return self.data().requiredCivic
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let flavor = self.flavours().first(where: { $0.type == flavorType }) {
            return flavor.value
        }

        return 0
    }

    private func flavours() -> [Flavor] {

        return self.data().flavours
    }

    func amenities() -> Double {

        return self.data().amenities
    }

    private struct WonderTypeData {

        let name: String
        let era: EraType
        let productionCost: Int
        let requiredTech: TechType?
        let requiredCivic: CivicType?
        let amenities: Double
        let flavours: [Flavor]
    }

    private func data() -> WonderTypeData {

        switch self {

        case .none:
            return WonderTypeData(name: "",
                                  era: .none,
                                  productionCost: -1,
                                  requiredTech: nil,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  flavours: [])

            // ancient
        case .greatBath:
            return WonderTypeData(name: "Great Bath",
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .pottery,
                                  requiredCivic: nil,
                                  amenities: 1.0,
                                  flavours: [Flavor(type: .wonder, value: 15), Flavor(type: .religion, value: 10)])
        case .hangingGardens:
            return WonderTypeData(name: "Hanging Gardens",
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .irrigation,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  flavours: [Flavor(type: .wonder, value: 20), Flavor(type: .growth, value: 20)])
        case .stonehenge:
            return WonderTypeData(name: "Stonehenge",
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .astrology,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  flavours: [Flavor(type: .wonder, value: 25), Flavor(type: .culture, value: 20)])
        case .templeOfArtemis:
            return WonderTypeData(name: "Temple of Artemis",
                                  era: .ancient,
                                  productionCost: 180,
                                  requiredTech: .archery,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  flavours: [Flavor(type: .wonder, value: 20), Flavor(type: .growth, value: 10)])
        case .pyramids:
            return WonderTypeData(name: "Pyramids",
                                  era: .ancient,
                                  productionCost: 220,
                                  requiredTech: .masonry,
                                  requiredCivic: nil,
                                  amenities: 0.0,
                                  flavours: [Flavor(type: .wonder, value: 25), Flavor(type: .culture, value: 20)])
        case .oracle:
            return WonderTypeData(name: "Oracle",
                                  era: .ancient,
                                  productionCost: 290,
                                  requiredTech: nil,
                                  requiredCivic: .mysticism,
                                  amenities: 0.0,
                                  flavours: [Flavor(type: .wonder, value: 20), Flavor(type: .culture, value: 15)])

        }
    }
}
