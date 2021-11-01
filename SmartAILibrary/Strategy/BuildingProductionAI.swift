//
//  BuildingProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BuildingProductionAI: WeightedList<BuildingType> {

    override init() {

        super.init()

        for buildingType in BuildingType.all {
            self.add(weight: 0.0, for: buildingType)
        }
    }

    required public init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    func reset() {

        self.items.removeAll()

        for buildingType in BuildingType.all {
            self.add(weight: 0.0, for: buildingType)
        }
    }

    func add(weight: Int, for flavorType: FlavorType) {

        for buildingType in BuildingType.all {

            if let flavor = buildingType.flavours().first(where: { $0.type == flavorType }) {
                self.add(weight: flavor.value * weight, for: buildingType)
            }
        }
    }
}
