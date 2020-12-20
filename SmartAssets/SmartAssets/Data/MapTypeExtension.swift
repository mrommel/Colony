//
//  MapTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 15.12.20.
//

import SmartAILibrary

extension MapType {
    
    public static func from(name: String) -> MapType? {
        
        for mapType in MapType.all {
            if mapType.name() == name {
                return mapType
            }
        }
        
        return nil
    }
    
    public func name() -> String {
        
        switch self {
        
        case .empty:
            return "Empty"
        case .earth:
            return "Earth"
        case .pangaea:
            return "Pangaea"
        case .continents:
            return "Continents"
        case .archipelago:
            return "Archipelago"
        case .inlandsea:
            return "Inlandsea"
        case .custom:
            return "Custom"
        }
    }
    
    public func textureName() -> String {
        
        switch self {
        
        case .empty:
            return "MapType_Empty"
        case .earth:
            return "MapType_Earth"
        case .pangaea:
            return "MapType_Pangaea"
        case .continents:
            return "MapType_Continents"
        case .archipelago:
            return "MapType_Archipelago"
        case .inlandsea:
            return "MapType_InlandSea"
        case .custom:
            return "MapType_Custom"
        }
    }
}
