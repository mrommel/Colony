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

public protocol AbstractDistricts {
    
    // districts
    func has(district: DistrictType) -> Bool
    func build(district: DistrictType) throws
}

class Districts: AbstractDistricts {
    
    private var districts: [DistrictType]
    private var city: AbstractCity?

    init(city: AbstractCity?) {
    
        self.city = city
        self.districts = []
    }
    
    func has(district: DistrictType) -> Bool {
        
        return self.districts.contains(district)
    }
    
    func build(district: DistrictType) throws {
        
        if self.districts.contains(district) {
            throw DistrictError.alreadyBuild
        }
        
        self.districts.append(district)
    }
}
