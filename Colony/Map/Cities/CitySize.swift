//
//  CitySize.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum CitySize {
    
    case small
    case medium
    case large
    
    static let all: [CitySize] = [.small, .medium, .large]
    
    var textureName: String {
        
        switch self {
            
        case .small:
            return "city_1"
        case .medium:
            return "city_2"
        case .large:
            return "city_3"
        }
    }
}
