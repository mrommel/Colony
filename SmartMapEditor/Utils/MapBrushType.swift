//
//  MapBrushType.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 15.12.20.
//

import Foundation

enum MapBrushType {

    case terrain
    case feature
    case resource

    func name() -> String {

        switch self {

        case .terrain:
            return "Terrain"
        case .feature:
            return "Feature"
        case .resource:
            return "Resource"
        }
    }

    static func from(name: String) -> MapBrushType? {

        for mapBrushType in MapBrushType.all {
            if mapBrushType.name() == name {
                return mapBrushType
            }
        }

        return nil
    }

    static var all: [MapBrushType] {
        return [.terrain, .feature, .resource]
    }
}
