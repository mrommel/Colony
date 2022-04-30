//
//  MapMarker.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.04.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class MapMarker: Codable {

    enum CodingKeys: CodingKey {

        case location
        case name
        case type
    }

    public var location: HexPoint
    public var name: String
    public var type: MapMarkerType

    init() {

        self.location = HexPoint.invalid
        self.name = "NoName"
        self.type = .none
    }

    init(location: HexPoint, name: String, type: MapMarkerType) {

        self.location = location
        self.name = name
        self.type = type
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.location =  try container.decode(HexPoint.self, forKey: .location)
        self.name =  try container.decode(String.self, forKey: .name)
        self.type =  try container.decode(MapMarkerType.self, forKey: .type)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.location, forKey: .location)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.type, forKey: .type)
    }
}
