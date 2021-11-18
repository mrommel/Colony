//
//  BuildingProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BuildingWeigths: WeightedList<BuildingType> {

    override func fill() {

        for buildingType in BuildingType.all {
            self.add(weight: 0.0, for: buildingType)
        }
    }

    func reset() {

        self.items.removeAll()

        self.fill()
    }
}

class DistrictWeigths: WeightedList<DistrictType> {

    override func fill() {

        for districtType in DistrictType.all {
            self.add(weight: 0.0, for: districtType)
        }
    }

    func reset() {

        self.items.removeAll()

        self.fill()
    }
}

class BuildingProductionAI: Codable {

    enum CodingKeys: String, CodingKey {

        case buildingWeights
        case districtWeights
    }

    internal var player: AbstractPlayer?

    private var buildingWeights: BuildingWeigths
    private var districtWeights: DistrictWeigths

    init(player: AbstractPlayer?) {

        self.player = player

        self.buildingWeights = BuildingWeigths()
        self.districtWeights = DistrictWeigths()

        self.initWeights()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.buildingWeights = try container.decode(BuildingWeigths.self, forKey: .buildingWeights)
        self.districtWeights = try container.decode(DistrictWeigths.self, forKey: .districtWeights)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.buildingWeights, forKey: .buildingWeights)
        try container.encode(self.districtWeights, forKey: .districtWeights)
    }

    private func initWeights() {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        for flavorType in FlavorType.all {

            let leaderFlavor = player.personalAndGrandStrategyFlavor(for: flavorType)

            for buildingType in BuildingType.all {

                let buildingFlavor = buildingType.flavor(for: flavorType)

                self.buildingWeights.add(weight: buildingFlavor * leaderFlavor, for: buildingType)
            }

            for districtType in DistrictType.all {

                let districtFlavor = districtType.flavor(for: flavorType)

                self.districtWeights.add(weight: districtFlavor * leaderFlavor, for: districtType)
            }
        }
    }

    func reset() {

        self.buildingWeights.reset()
        self.districtWeights.reset()
    }

    /*func add(weight: Int, for flavorType: FlavorType) {

        for buildingType in BuildingType.all {

            if let flavor = buildingType.flavours().first(where: { $0.type == flavorType }) {
                self.add(weight: flavor.value * weight, for: buildingType)
            }
        }
    }*/

    func weight(of buildingType: BuildingType) -> Double {

        return self.buildingWeights.weight(of: buildingType)
    }

    func weight(of districtType: DistrictType) -> Double {

        return self.districtWeights.weight(of: districtType)
    }
}
