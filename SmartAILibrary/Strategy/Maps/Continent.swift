//
//  Continent.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum ContinentConstants {

    static let kNotAnalyzed: Int = 254
    static let kNoContinent: Int = 255
}

class Continent {

    var identifier: Int
    var name: String
    var points: [HexPoint]
    var map: MapModel?

    init() {
        self.identifier = ContinentConstants.kNotAnalyzed
        self.name = "NoName"
        self.points = []
        self.map = nil
    }

    init(identifier: Int, name: String, on map: MapModel?) {
        self.identifier = identifier
        self.name = name
        self.points = []
        self.map = map
    }

    func add(point: HexPoint) {
        self.points.append(point)
    }
}
