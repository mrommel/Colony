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

// swiftlint:disable identifier_name
public enum ContinentType: Int, Codable {

    case none = 0

    case africa
    case amasia
    case america
    case antarctica
    case arctica
    case asia
    case asiamerica
    case atlantica
    case atlantis
    case australia
    case avalonia
    case azania
    case baltica
    case cimmeria
    case columbia
    case congoCraton
    case euramerica
    case europe
    case gondwana
    case kalaharia
    case kazakhstania
    case kernorland
    case kumariKandam
    case laurasia
    case laurentia
    case lemuria
    case mu
    case nena
    case novoPangaea
    case nuna
    case pangaea
    case pangaeaUltima
    case pannotia
    case rodinia
    case siberia
    case terraAustralis
    case ur
    case vaalbara
    case vendian
    case zealandia
}

public class Continent: Codable {

    enum CodingKeys: CodingKey {

        case identifier
        case name
        case type
        case points
    }

    var identifier: Int
    var name: String
    var typeVal: ContinentType
    var points: [HexPoint]
    var map: MapModel?

    init() {

        self.identifier = ContinentConstants.kNotAnalyzed
        self.name = "NoName"
        self.typeVal = .none
        self.points = []
        self.map = nil
    }

    init(identifier: Int, name: String, on map: MapModel?) {

        self.identifier = identifier
        self.typeVal = .none
        self.name = name
        self.points = []
        self.map = map
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.identifier = try container.decode(Int.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        self.typeVal = try container.decode(ContinentType.self, forKey: .type)
        self.points = try container.decode([HexPoint].self, forKey: .points)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.typeVal, forKey: .type)
        try container.encode(self.points, forKey: .points)
    }

    func add(point: HexPoint) {

        self.points.append(point)
    }

    public func type() -> ContinentType {

        return self.typeVal
    }
}
