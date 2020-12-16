//
//  Civ5Feature.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 03.08.19.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension FeatureType {
    
    static func fromCiv5String(value: String) -> FeatureType? {
        
        switch value {
        case "FEATURE_ICE": // FIXME
            return .ice
        case "FEATURE_FOREST":
            return .forest
        case "FEATURE_JUNGLE":
            return .rainforest
        case "FEATURE_MARSH":
            return .marsh
        case "FEATURE_OASIS":
            return .oasis
        case "FEATURE_FLOOD_PLAINS": // FIXME
            return .floodplains
            
        // special
        case "FEATURE_FALLOUT":
            return .fallout
        case "FEATURE_ATOLL":
            return .atoll
        case "FEATURE_REEF":
            return .reef
        case "FEATURE_ULURU":
            return .uluru
        case "FEATURE_CRATER":
            return .barringCrater
        case "FEATURE_FUJI":
            return .fuji
        case "FEATURE_MESA":
            return .mesa
        case "FEATURE_VOLCANO": 
            return .volcano
        case "FEATURE_GIBRALTAR":
            return .gibraltar
        case "FEATURE_GEYSER":
            return .geyser
        case "FEATURE_FOUNTAIN_YOUTH": // FIXME
            return .fountainOfYouth
        case "FEATURE_POTOSI": // FIXME
            return .potosi
        case "FEATURE_EL_DORADO": // FIXME
            return nil
        case "FEATURE_SRI_PADA": // FIXME
            return nil
        case "FEATURE_MT_SINAI": // FIXME
            return nil
        case "FEATURE_MT_KAILASH": // FIXME
            return nil
        case "FEATURE_LAKE_VICTORIA": // FIXME
            return nil
        case "FEATURE_KILIMANJARO": 
            return .mountKilimanjaro
        case "FEATURE_SOLOMONS_MINES": // FIXME
            return nil
        default:
            fatalError("case must be handled")
        }
    }
}

