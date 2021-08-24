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

public protocol AbstractDistricts: Codable {

    var city: AbstractCity? { get set }

    // districts
    func has(district: DistrictType) -> Bool
    func hasAny() -> Bool
    func build(district: DistrictType) throws

    func numberOfBuildDistricts() -> Int

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

    private var districts: [DistrictType]
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
        self.districts = try container.decode([DistrictType].self, forKey: .districts)

        self.housingVal = try container.decode(Double.self, forKey: .housing)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.districts, forKey: .districts)

        try container.encode(self.housingVal, forKey: .housing)
    }

    func has(district: DistrictType) -> Bool {

        return self.districts.contains(district)
    }

    func hasAny() -> Bool {

        return self.districts.count > 1 // cityCenter does not count
    }

    func build(district: DistrictType) throws {

        if self.districts.contains(district) {
            throw DistrictError.alreadyBuild
        }

        self.districts.append(district)
    }

    func numberOfBuildDistricts() -> Int {

        return self.districts.count
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
