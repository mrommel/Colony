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

    let typeValue: GossipItemType
    let turn: Int
    let sourceValue: GossipSourceType

    init(type: GossipItemType, turn: Int, source: GossipSourceType) {

        self.typeValue = type
        self.turn = turn
        self.sourceValue = source
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.typeValue = try container.decode(GossipItemType.self, forKey: .type)
        self.turn = try container.decode(Int.self, forKey: .turn)
        self.sourceValue = try container.decode(GossipSourceType.self, forKey: .source)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.typeValue, forKey: .type)
        try container.encode(self.turn, forKey: .turn)
        try container.encode(self.sourceValue, forKey: .source)
    }

    public func type() -> GossipItemType {

        return self.typeValue
    }

    public func source() -> GossipSourceType {

        return self.sourceValue
    }

    public func isLastTenTurns(in gameModel: GameModel?) -> Bool {

        return self.turn + 10 >= gameModel?.currentTurn ?? 0
    }
}
