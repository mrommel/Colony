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
            return "TXT_KEY_MAP_TYPE_EMPTY"
        case .earth:
            return "TXT_KEY_MAP_TYPE_EARTH"
        case .pangaea:
            return "TXT_KEY_MAP_TYPE_PANGAEA"
        case .continents:
            return "TXT_KEY_MAP_TYPE_CONTINENTS"
        case .archipelago:
            return "TXT_KEY_MAP_TYPE_ARCHIPELAGO"
        case .inlandsea:
            return "TXT_KEY_MAP_TYPE_INLANDSEA"
        case .custom:
            return "TXT_KEY_MAP_TYPE_CUSTOM"
        }
    }

    public func textureName() -> String {

        switch self {

        case .empty:
            return "maptype-random"
        case .earth:
            return "maptype-earth"
        case .pangaea:
            return "maptype-pangaea"
        case .continents:
            return "maptype-continents"
        case .archipelago:
            return "maptype-archipelago"
        case .inlandsea:
            return "maptype-inlandSea"
        case .custom:
            return "maptype-random"
        }
    }
}
