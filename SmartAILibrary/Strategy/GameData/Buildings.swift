//
//  Buildings.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum BuildingError: Error {
    case alreadyBuild
}

public protocol AbstractBuildings: Codable {

    var city: AbstractCity? { get set }

    // buildings
    func has(building: BuildingType) -> Bool
    func build(building: BuildingType) throws
    func numOfBuildings(of buildingCategoryType: BuildingCategoryType) -> Int

    // stats
    func defense() -> Int
    func defenseModifier() -> Int
    func housing() -> Double
    func updateHousing()
    func numOfBuildings() -> Int
}

class Buildings: AbstractBuildings {

    enum CodingKeys: String, CodingKey {

        case buildings

        case defense
        case defenseModifier
        case housing
    }

    private var buildings: [BuildingType]
    internal var city: AbstractCity?

    private var defenseVal: Int
    private var defenseModifierVal: Int
    private var housingVal: Double

    init(city: AbstractCity?) {

        self.city = city
        self.buildings = []

        self.defenseVal = 0
        self.defenseModifierVal = 0
        self.housingVal = 0.0
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.buildings = try container.decode([BuildingType].self, forKey: .buildings)

        self.defenseVal = try container.decode(Int.self, forKey: .defense)
        self.defenseModifierVal = try container.decode(Int.self, forKey: .defenseModifier)
        self.housingVal = try container.decode(Double.self, forKey: .housing)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.buildings, forKey: .buildings)

        try container.encode(self.defenseVal, forKey: .defense)
        try container.encode(self.defenseModifierVal, forKey: .defenseModifier)
        try container.encode(self.housingVal, forKey: .housing)
    }

    func has(building: BuildingType) -> Bool {

        return self.buildings.contains(building)
    }

    func build(building: BuildingType) throws {

        if self.buildings.contains(building) {
            throw BuildingError.alreadyBuild
        }

        self.updateDefense()
        self.updateHousing()

        self.buildings.append(building)
    }

    func numOfBuildings(of buildingCategoryType: BuildingCategoryType) -> Int {

        var num: Int = 0

        for buildingType in BuildingType.all {

            if self.has(building: buildingType) && buildingType.categoryType() == buildingCategoryType {
                num += 1
            }
        }

        return num
    }

    private func updateDefense() {

        self.defenseVal = 0
        for building in BuildingType.all {

            if self.has(building: building) {
                self.defenseVal += building.defense()
            }
        }
    }

    func defense() -> Int {

        return self.defenseVal
    }

    func defenseModifier() -> Int {

        return self.defenseModifierVal
    }

    func updateHousing() {

        guard let government = self.city?.player?.government else {
            fatalError("cant get government")
        }

        self.housingVal = 0.0
        for building in BuildingType.all {

            if self.has(building: building) {
                self.housingVal += building.yields().housing
            }
        }

        // +1 Housing6 Housing per level of Walls.
        if government.currentGovernment() == .monarchy {

            if self.has(building: .ancientWalls) {
                housingVal += 1.0
            }

            if self.has(building: .medievalWalls) {
                housingVal += 2.0
            }

            if self.has(building: .renaissanceWalls) {
                housingVal += 3.0
            }
        }
    }

    func housing() -> Double {

        return self.housingVal
    }

    func numOfBuildings() -> Int {

        return self.buildings.count
    }
}
