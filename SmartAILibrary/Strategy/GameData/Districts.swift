//
//  Districts.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum DistrictError: Error {
    case alreadyBuild
}

struct DistrictItem: Codable {

    let type: DistrictType
    let location: HexPoint
}

extension DistrictItem: Equatable {

    public static func == (lhs: DistrictItem, rhs: DistrictItem) -> Bool {

        return lhs.type == rhs.type && lhs.location == rhs.location
    }
}

public protocol AbstractDistricts: Codable {

    var city: AbstractCity? { get set }

    // districts
    func has(district: DistrictType) -> Bool
    func hasAny() -> Bool
    func hasAnySpecialtyDistrict() -> Bool
    func numberOfSpecialtyDistricts() -> Int

    func build(district: DistrictType, at location: HexPoint) throws
    func location(of district: DistrictType) -> HexPoint?

    func numberOfBuiltDistricts() -> Int
    func clear()

    func housing() -> Double
    func updateHousing()

    // trade route methods
    func domesticTradeYields() -> Yields
    func foreignTradeYields() -> Yields
}

class Districts: AbstractDistricts {

    enum CodingKeys: String, CodingKey {

        case districts
        case housing
    }

    private var districts: [DistrictItem]
    internal var city: AbstractCity?

    private var housingVal: Double

    init(city: AbstractCity?) {

        self.city = city
        self.districts = []

        self.housingVal = 0.0
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.city = nil
        self.districts = try container.decode([DistrictItem].self, forKey: .districts)

        self.housingVal = try container.decode(Double.self, forKey: .housing)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.districts, forKey: .districts)

        try container.encode(self.housingVal, forKey: .housing)
    }

    func has(district: DistrictType) -> Bool {

        return self.districts.contains(where: { $0.type == district })
    }

    func hasAny() -> Bool {

        // cityCenter does not count
        return !self.districts
            .filter { $0.type != .cityCenter }
            .isEmpty
    }

    func hasAnySpecialtyDistrict() -> Bool {

        return !self.districts
            .filter { $0.type.isSpecialty() }
            .isEmpty
    }

    func numberOfSpecialtyDistricts() -> Int {

        return self.districts
            .filter { $0.type.isSpecialty() }
            .count
    }

    func build(district: DistrictType, at location: HexPoint) throws {

        let newItem = DistrictItem(type: district, location: location)

        if self.districts.contains(newItem) {
            throw DistrictError.alreadyBuild
        }

        self.districts.append(newItem)
    }

    func location(of district: DistrictType) -> HexPoint? {

        if let item = self.districts.first(where: { $0.type == district }) {
            return item.location
        }

        return nil
    }

    func numberOfBuiltDistricts() -> Int {

        return self.districts.count
    }

    func clear() {

        self.districts.removeAll()
    }

    func housing() -> Double {

        return self.housingVal
    }

    func updateHousing() {

        self.housingVal = 0.0
        for district in DistrictType.all {

            if self.has(district: district) {
                //self.housingVal += district.yields().housing
            }
        }
    }

    func domesticTradeYields() -> Yields {

        var yields = Yields(food: 0.0, production: 0.0, gold: 0.0)

        for district in DistrictType.all {

            if self.has(district: district) {
                yields += district.domesticTradeYields()
            }
        }

        return yields
    }

    func foreignTradeYields() -> Yields {

        var yields = Yields(food: 0.0, production: 0.0, gold: 0.0)

        for district in DistrictType.all {

            if self.has(district: district) {
                yields += district.foreignTradeYields()
            }
        }

        return yields
    }
}
