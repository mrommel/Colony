//
//  MapSizeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.12.20.
//

import Foundation
import SmartAILibrary

extension MapSize {
    
    public static var all: [MapSize] {
        return [.duel, .tiny, .small, .standard, .large, .huge]
    }
    
    public func name() -> String {
        
        switch self {
        
        case .duel: return "Duel"
        case .tiny: return "Tiny"
        case .small: return "Small"
        case .standard: return "Standard"
        case .large: return "Large"
        case .huge: return "Huge"
            
        case .custom(width: let width, height: let height):
            return "Custom(\(width), \(height))"
        }
    }

    public static func from(name: String) -> MapSize? {
        
        for mapSize in MapSize.all {
            if mapSize.name() == name {
                return mapSize
            }
        }
        
        return nil
    }
}
