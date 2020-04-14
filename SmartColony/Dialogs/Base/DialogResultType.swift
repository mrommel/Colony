//
//  DialogResultType.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

enum DialogResultType: String, Codable {

    case none
    case okay = "OKAY"
    case cancel = "CANCEL"

    // map types
    case mapTypeEarth = "EARTH"
    case mapTypePangaea = "PANGAEA"
    case mapTypeContinents = "CONTINENTS"
    case mapTypeArchipelago = "ARCHIPELAGO"
    case mapTypeInlandsea = "INLANDSEA"
    case mapTypeRandom = "TYPERANDOM"

    // map sizes
    case mapSizeHuge = "HUGE"
    case mapSizeLarge = "LARGE"
    case mapSizeStandard = "STANDARD"
    case mapSizeSmall = "SMALL"
    case mapSizeTiny = "TINY"

    // map ages
    case mapAgeYoung = "AGE_YOUNG"
    case mapAgeNormal = "AGE_NORMAL"
    case mapAgeOld = "AGE_OLD"

    // map rainfall
    case mapRainfallWet = "RAINFALL_WET"
    case mapRainfallNormal = "RAINFALL_NORMAL"
    case mapRainfallDry = "RAINFALL_DRY"

    // map climate
    case mapClimateHot = "CLIMATE_HOT"
    case mapClimateTemperate = "CLIMATE_TEMPERATE"
    case mapClimateCold = "CLIMATE_COLD"

    // map climate
    case mapSeaLevelLow = "SEALEVEL_LOW"
    case mapSeaLevelNormal = "SEALEVEL_NORMAL"
    case mapSeaLevelHigh = "SEALEVEL_HIGH"

    // commands
    case commandFound = "COMMAND_FOUND"
    case commandBuildFarm = "COMMAND_BUILD_FARM"
    case commandBuildMine = "COMMAND_BUILD_MINE"
    case commandBuildRoute = "COMMAND_BUILD_ROUTE"
    case commandPillage = "COMMAND_PILLAGE"
    case commandFortify = "COMMAND_FORTIFY"
    case commandHold = "COMMAND_HOLD"
    case commandGarrison = "COMMAND_GARRISON"

    func toMapType() -> MapType {

        if self == .mapTypeEarth {
            return .earth
        } else if self == .mapTypePangaea {
            return .pangaea
        } else if self == .mapTypeInlandsea {
            return .inlandsea
        } else if self == .mapTypeContinents {
            return .continents
        } else if self == .mapTypeArchipelago {
            return .archipelago
        } else if self == .mapTypeRandom {
            return .random
        }

        fatalError("niy")
    }

    func toMapSize() -> MapSize {

        if self == .mapSizeHuge {
            return .huge
        } else if self == .mapSizeLarge {
            return .large
        } else if self == .mapSizeStandard {
            return .standard
        } else if self == .mapSizeSmall {
            return .small
        } else if self == .mapSizeTiny {
            return .tiny
        }

        fatalError("niy")
    }

    func toMapOptionAge() -> MapOptionAge {

        if self == .mapAgeOld {
            return .old
        } else if self == .mapAgeNormal {
            return .normal
        } else if self == .mapAgeYoung {
            return .young
        }

        fatalError("niy")
    }

    func toMapOptionClimate() -> MapOptionClimate {

        if self == .mapClimateHot {
            return .hot
        } else if self == .mapClimateTemperate {
            return .temperate
        } else if self == .mapClimateCold {
            return .cold
        }

        fatalError("niy")
    }

    func toMapOptionRainfall() -> MapOptionRainfall {

        if self == .mapRainfallDry {
            return .dry
        } else if self == .mapRainfallNormal {
            return .normal
        } else if self == .mapRainfallWet {
            return .wet
        }

        fatalError("niy")
    }

    func toMapOptionSeaLevel() -> MapOptionSeaLevel {

        if self == .mapSeaLevelLow {
            return .low
        } else if self == .mapSeaLevelNormal {
            return .normal
        } else if self == .mapSeaLevelHigh {
            return .high
        }

        fatalError("niy")
    }
}
