//
//  UnitProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class UnitTypeWeight: Codable {

    enum CodingKeys: String, CodingKey {

        case unitType
        case weight
    }

    let unitType: UnitType
    var weight: Int

    init(unitType: UnitType, weight: Int) {

        self.unitType = unitType
        self.weight = weight
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.unitType = try container.decode(UnitType.self, forKey: .unitType)
        self.weight = try container.decode(Int.self, forKey: .weight)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.unitType, forKey: .unitType)
        try container.encode(self.weight, forKey: .weight)
    }
}

class UnitProductionAI: Codable {

    enum CodingKeys: String, CodingKey {

        case unitWeights
    }

    private var unitWeights: [UnitTypeWeight]

    init() {

        self.unitWeights = []

        for unitType in UnitType.all {
            self.unitWeights.append(UnitTypeWeight(unitType: unitType, weight: 0))
        }
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.unitWeights = try container.decode([UnitTypeWeight].self, forKey: .unitWeights)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.unitWeights, forKey: .unitWeights)
    }

    func reset() {

        self.unitWeights.removeAll()

        for unitType in UnitType.all {
            self.unitWeights.append(UnitTypeWeight(unitType: unitType, weight: 0))
        }
    }

    func add(weight: Int, for flavorType: FlavorType) {

        for unitType in UnitType.all {

            if let unitWeight = self.unitWeights.first(where: { $0.unitType == unitType }) {

                if let flavor = unitType.flavours().first(where: { $0.type == flavorType }) {
                    unitWeight.weight = flavor.value * weight
                }
            }
        }
    }

    func weight(for unitType: UnitType) -> Int {

        if let unitWeight = self.unitWeights.first(where: { $0.unitType == unitType }) {
            return unitWeight.weight
        }

        return 0
    }
}
