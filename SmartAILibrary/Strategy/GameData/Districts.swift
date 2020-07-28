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
    
    func numberOfBuildDsitricts() -> Int 
}

class Districts: AbstractDistricts {
    
    enum CodingKeys: String, CodingKey {
        
        case districts
    }
    
    private var districts: [DistrictType]
    internal var city: AbstractCity?

    init(city: AbstractCity?) {
    
        self.city = city
        self.districts = []
    }
    
    required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.city = nil
        self.districts = try container.decode([DistrictType].self, forKey: .districts)
    }
    
    func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.districts, forKey: .districts)
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
    
    func numberOfBuildDsitricts() -> Int {
        
        return self.districts.count
    }
}
