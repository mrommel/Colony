//
//  MapMarkerTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 30.04.22.
//

import Foundation
import SmartAILibrary

extension MapMarkerType {

    public func name() -> String {

        switch self {

        case .none:
            return "None"

        // districts

        case .cityCenter:
            return DistrictType.cityCenter.name()

        case .holySite:
            return DistrictType.holySite.name()

        case .campus:
            return DistrictType.campus.name()

        // wonders

        case .stonehenge:
            return WonderType.stonehenge.name()
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .none:
            return ""

        // districts

        case .cityCenter:
            return DistrictType.cityCenter.iconTexture()

        case .holySite:
            return DistrictType.holySite.iconTexture()

        case .campus:
            return DistrictType.campus.iconTexture()

        // wonders

        case .stonehenge:
            return WonderType.stonehenge.iconTexture()
        }
    }
}
