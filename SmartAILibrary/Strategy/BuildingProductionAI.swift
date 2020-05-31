//
//  BuildingProductionAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class BuildingTypeWeight: Codable {

    enum CodingKeys: String, CodingKey {
        
        case buildingType
        case weight
    }
    
    let buildingType: BuildingType
    var weight: Int

    init(buildingType: BuildingType, weight: Int) {

        self.buildingType = buildingType
        self.weight = weight
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.buildingType = try container.decode(BuildingType.self, forKey: .buildingType)
        self.weight = try container.decode(Int.self, forKey: .weight)
    }
    
    func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.buildingType, forKey: .buildingType)
        try container.encode(self.weight, forKey: .weight)
    }
}

class BuildingProductionAI: Codable {

    enum CodingKeys: String, CodingKey {
        
        case buildingWeights
    }

    private var buildingWeights: [BuildingTypeWeight]

    init() {

        self.buildingWeights = []

        for buildingType in BuildingType.all {
            self.buildingWeights.append(BuildingTypeWeight(buildingType: buildingType, weight: 0))
        }
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.buildingWeights = try container.decode([BuildingTypeWeight].self, forKey: .buildingWeights)
    }
    
    func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.buildingWeights, forKey: .buildingWeights)
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
}
