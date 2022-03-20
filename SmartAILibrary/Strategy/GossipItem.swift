//
//  GossipItem.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GossipItem: Codable {

    enum CodingKeys: CodingKey {

        case type
        case turn
        case source
    }

    let type: GossipItemType
    let turn: Int
    let source: GossipSourceType

    init(type: GossipItemType, turn: Int, source: GossipSourceType) {

        self.type = type
        self.turn = turn
        self.source = source
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(GossipItemType.self, forKey: .type)
        self.turn = try container.decode(Int.self, forKey: .turn)
        self.source = try container.decode(GossipSourceType.self, forKey: .source)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.turn, forKey: .turn)
        try container.encode(self.source, forKey: .source)
    }
}
