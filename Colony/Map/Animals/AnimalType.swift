//
//  AnimalType.swift
//  Colony
//
//  Created by Michael Rommel on 23.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum AnimalType: String, Codable {
    
    case shark
    case wulf
    case monster
    
    var movementType: MovementType {
        
        switch self {
        case .monster:
            return .swimOcean
        case .shark:
            return .swimOcean
        case .wulf:
            return .walk
        }
    }
}
