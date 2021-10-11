//
//  GameReplay.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

enum GameReplayEventType: Int, Codable {

    case major = 0
}

class GameReplayEvent: Codable {

    enum CodingKeys: CodingKey {

        case type
        case message
        case point
        case turn
    }

    let type: GameReplayEventType
    let message: String
    let point: HexPoint
    let turn: Int

    init(type: GameReplayEventType, message: String, at point: HexPoint, turn: Int) {

        self.type = type
        self.message = message
        self.point = point
        self.turn = turn
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(GameReplayEventType.self, forKey: .type)
        self.message = try container.decode(String.self, forKey: .message)
        self.point = try container.decode(HexPoint.self, forKey: .point)
        self.turn = try container.decode(Int.self, forKey: .turn)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.message, forKey: .message)
        try container.encode(self.point, forKey: .point)
        try container.encode(self.turn, forKey: .turn)
    }
}

public class GameReplay: Codable {

    enum CodingKeys: CodingKey {

        case events
    }

    private var events: [GameReplayEvent]

    init() {

        self.events = []
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.events = try container.decode([GameReplayEvent].self, forKey: .events)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.events, forKey: .events)
    }

    func addReplayEvent(type: GameReplayEventType, message: String, at point: HexPoint, turn: Int) {

        let replayEvent = GameReplayEvent(type: type, message: message, at: point, turn: turn)
        self.events.append(replayEvent)
    }
}
