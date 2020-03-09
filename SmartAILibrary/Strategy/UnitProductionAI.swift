//
//  UnitProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class UnitTypeWeight {

    let unitType: UnitType
    var weight: Int

    init(unitType: UnitType, weight: Int) {

        self.unitType = unitType
        self.weight = weight
    }
}

class UnitProductionAI {
    
    private var city: AbstractCity?
    private var unitWeights: [UnitTypeWeight]

    init(city: AbstractCity?) {

        self.city = city
        self.unitWeights = []

        for unitType in UnitType.all {
            self.unitWeights.append(UnitTypeWeight(unitType: unitType, weight: 0))
        }
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
