//
//  FeatureTypeExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.11.20.
//

import SmartAILibrary

extension FeatureType {

    public static func from(name: String) -> FeatureType? {

        for feature in FeatureType.all {
            if feature.name() == name {
                return feature
            }
        }

        return nil
    }

    public func textureNames() -> [String] {

        switch self {

        case .none:
            return []
        case .forest:
            return ["feature-forest1", "feature-forest2"]
        case .rainforest:
            return ["feature-rainforest1", "feature-rainforest2"]
        case .floodplains:
            return ["feature-floodplains"]
        case .marsh:
            return ["feature-marsh1", "feature-marsh2"]
        case .oasis:
            return ["feature-oasis"]
        case .reef:
            return ["feature-reef"]
        case .ice:
            return ["feature-ice1", "feature-ice2", "feature-ice3", "feature-ice4", "feature-ice5", "feature-ice6"]
        case .atoll:
            return ["feature-atoll"]
        case .volcano:
            return ["feature-volcano"]

        case .mountains:
            return ["feature-mountains1", "feature-mountains2", "feature-mountains3"]
        case .lake:
            return ["feature-lake"]
        case .fallout:
            return ["feature-fallout"]

        case .delicateArch:
            return ["feature-delicateArch"]
        case .galapagos:
            return ["feature-galapagos"]
        case .greatBarrierReef:
            return ["feature-greatBarrierReef"]
        case .mountEverest:
            return ["feature-mountEverest"]
        case .mountKilimanjaro:
            return ["feature-mountKilimanjaro"]
        case .pantanal:
            return ["feature-pantanal"]
        case .yosemite:
            return ["feature-yosemite"]
        case .uluru:
            return ["feature-uluru"]
        case .fuji:
            return ["feature-fuji"]
        case .barringCrater:
            return ["feature-barringCrater"]
        case .mesa:
            return ["feature-mesa"]
        case .gibraltar:
            return ["feature-gibraltar"]
        case .geyser:
            return ["feature-geyser"]
        case .potosi:
            return ["feature-potosi"]
        case .fountainOfYouth:
            return ["feature-fountainOfYouth"]
        case .lakeVictoria:
            return ["feature-lakeVictoria"]
        case .cliffsOfDover:
            return ["feature-cliffsOfDover"]
        }
    }
}
