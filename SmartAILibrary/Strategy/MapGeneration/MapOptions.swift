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
    
    public init() {
        self.age = .normal
        self.climate = .temperate
        self.sealevel = .normal
        self.rainfall = .normal
    }
}

public class MapOptions {

    let size: MapSize
    public var enhanced: MapOptionsEnhanced

    required public init(withSize size: MapSize, enhanced: MapOptionsEnhanced = MapOptionsEnhanced()) {

        self.size = size
        self.enhanced = enhanced
    }
    
    var rivers: Int {
        
        switch self.size {

        case .duel:
            return 4
        case .tiny:
            return 5
        case .small:
            return 6
        case .standard:
            return 10
        case .large:
            return 15
        case .huge:
            return 20
        default:
            return 0
        }
    }
    
    var waterPercentage: Double {
        
        switch enhanced.sealevel {
            
        case .low:
            return 0.4
        case .normal:
            return 0.6
        case .high:
            return 0.6
        }
    }
}