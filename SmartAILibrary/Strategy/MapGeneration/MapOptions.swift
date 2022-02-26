//
//  MapOptions.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public struct MapOptionsEnhanced {

    public var age: MapOptionAge
    public var climate: MapOptionClimate
    public var sealevel: MapOptionSeaLevel
    public var rainfall: MapOptionRainfall
    public var resources: MapOptionResources

    public init() {

        self.age = .normal
        self.climate = .temperate
        self.sealevel = .normal
        self.rainfall = .normal
        self.resources = .abundant
    }
}

public class MapOptions {

    let seed: Int
    let size: MapSize
    let type: MapType
    public var enhanced: MapOptionsEnhanced
    public let leader: LeaderType
    public var aiLeaders: [LeaderType]
    public let handicap: HandicapType
    public let wrapX: Bool = true

    required public init(withSize size: MapSize, type: MapType, leader: LeaderType, aiLeaders: [LeaderType] = [], handicap: HandicapType, enhanced: MapOptionsEnhanced = MapOptionsEnhanced(), seed: Int = Int(Date.timeIntervalSinceReferenceDate)) {

        self.size = size
        self.type = type
        self.enhanced = enhanced
        self.leader = leader
        self.aiLeaders = aiLeaders
        self.handicap = handicap
        self.seed = seed
    }

    var rivers: Int {

        switch self.size {

        case .duel:
            return 14
        case .tiny:
            return 16
        case .small:
            return 18
        case .standard:
            return 20
        case .large:
            return 24
        case .huge:
            return 28
        default:
            return 8
        }
    }

    var waterPercentage: Double {

        switch self.type {

        case .continents:
            return 0.52 // low

        case .empty:
            return 0.65

        case .earth:
            return 0.65

        case .pangaea:
            return 0.65

        case .archipelago:
            return 0.65

        case .inlandsea:
            return 0.65

        case .custom:

            switch enhanced.sealevel {

            case .low:
                return 0.52
            case .normal:
                return 0.65
            case .high:
                return 0.81
            }
        }
    }

    var landPercentage: Double {

        return 1.0 - self.waterPercentage
    }

    // Percentage of mountain on land
    var mountainsPercentage: Double {

        switch enhanced.age {

        case .young:
            return 0.08
        case .normal:
            return 0.06
        case .old:
            return 0.04
        }
    }

    // Percentage of hills on land
    var hillsPercentage: Double {

        switch enhanced.age {

        case .young:
            return 0.20
        case .normal:
            return 0.16
        case .old:
            return 0.12
        }
    }
}
