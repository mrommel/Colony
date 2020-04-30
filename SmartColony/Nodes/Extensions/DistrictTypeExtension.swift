//
//  DistrictTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension DistrictType {
    
    func iconTexture() -> String {
        
        switch self {
            
        case .cityCenter: return "district_cityCenter"
        case .campus: return "district_campus"
        case .holySite: return "district_holySite"
        case .encampment: return "district_encampment"
        case .harbor: return "district_harbor"
        case .entertainment: return "district_entertainment"
        case .commercialHub: return "district_commercialHub"
        }
    }
}
