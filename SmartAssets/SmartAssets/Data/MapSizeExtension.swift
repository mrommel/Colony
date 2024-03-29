//
//  MapSizeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.12.20.
//

import Foundation
import SmartAILibrary

extension MapSize {

    public static func from(name: String) -> MapSize? {

        for mapSize in MapSize.all {
            if mapSize.name() == name {
                return mapSize
            }
        }

        return nil
    }

    public func textureName() -> String {

        switch self {

        case .duel:
            return "mapsize-duel"
        case .tiny:
            return "mapsize-tiny"
        case .small:
            return "mapsize-small"
        case .standard:
            return "mapsize-standard"
        case .large:
            return "mapsize-large"
        case .huge:
            return "mapsize-huge"
        case .custom(width: _, height: _):
            return "mapsize-unknown"
        }
    }
}
