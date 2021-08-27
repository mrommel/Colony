//
//  MapBrushSize.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 15.12.20.
//

import Foundation

enum MapBrushSize {

    case small
    case medium
    case large
    case huge

    func name() -> String {

        switch self {

        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .huge:
            return "Huge"
        }
    }

    static func from(name: String) -> MapBrushSize? {

        for mapBrushSize in MapBrushSize.all {
            if mapBrushSize.name() == name {
                return mapBrushSize
            }
        }

        return nil
    }

    static var all: [MapBrushSize] {
        return [.small, .medium, .large, .huge]
    }

    func radius() -> Int {

        switch self {

        case .small:
            return 0
        case .medium:
            return 1
        case .large:
            return 2
        case .huge:
            return 3
        }
    }
}
