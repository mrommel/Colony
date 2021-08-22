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

    let size: MapSize
    public var enhanced: MapOptionsEnhanced
    public let leader: LeaderType
    public let handicap: HandicapType
    public let wrapX: Bool = true

    required public init(withSize size: MapSize, leader: LeaderType, handicap: HandicapType, enhanced: MapOptionsEnhanced = MapOptionsEnhanced()) {

        self.size = size
        self.enhanced = enhanced
        self.leader = leader
        self.handicap = handicap
    }

    var octaves: Int {

        switch self.enhanced.age {

        case .young:
            return 3
        case .normal:
            return 2
        case .old:
            return 1
        }
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

        switch enhanced.sealevel {

        case .low:
            return 0.52
        case .normal:
            return 0.65
        case .high:
            return 0.81
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

    var numberOfPlayers: Int {

        switch self.size {

        case .duel:
            return 2
        case .tiny:
            return 3
        case .small:
            return 4
        case .standard:
            return 6
        case .large:
            return 8
        case .huge:
            return 10
        default:
            return 2
        }
    }
}
