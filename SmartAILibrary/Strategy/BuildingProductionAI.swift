//
//  BuildingProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BuildingTypeWeight {

    let buildingType: BuildingType
    var weight: Int

    init(buildingType: BuildingType, weight: Int) {

        self.buildingType = buildingType
        self.weight = weight
    }
}

class BuildingProductionAI {

    private var city: AbstractCity?
    private var buildingWeights: [BuildingTypeWeight]

    init(city: AbstractCity?) {

        self.city = city
        self.buildingWeights = []

        for buildingType in BuildingType.all {
            self.buildingWeights.append(BuildingTypeWeight(buildingType: buildingType, weight: 0))
        }
    }

    func reset() {

        self.buildingWeights.removeAll()

        for buildingType in BuildingType.all {
            self.buildingWeights.append(BuildingTypeWeight(buildingType: buildingType, weight: 0))
        }
    }

    func add(weight: Int, for flavorType: FlavorType) {

        for buildingType in BuildingType.all {

            if let buildingWeight = self.buildingWeights.first(where: { $0.buildingType == buildingType }) {

                if let flavor = buildingType.flavours().first(where: { $0.type == flavorType }) {
                    buildingWeight.weight += flavor.value * weight
                }
            }
        }
    }

    func weight(for buildingType: BuildingType) -> Int {

        if let buildingWeight = self.buildingWeights.first(where: { $0.buildingType == buildingType }) {
            return buildingWeight.weight
        }

        return 0
    }

    /*func recommend() -> BuildingType? {

        return nil
    }*/
}
