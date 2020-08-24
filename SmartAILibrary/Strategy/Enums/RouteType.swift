//
//  RouteType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum RouteType: Int, Codable {
    
    case none
    
    case ancientRoad
    case classicalRoad
    case industrialRoad
    case modernRoad
    
    func era() -> EraType? {

        switch self {
            
        case .none: return nil
            
        case .ancientRoad: return .ancient
        case .classicalRoad: return .classical
        case .industrialRoad: return .industrial
        case .modernRoad: return .modern
        }
    }
}
