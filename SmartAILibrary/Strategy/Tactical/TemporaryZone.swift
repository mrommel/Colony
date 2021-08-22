//
//  TemporaryZone.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.09.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TemporaryZone: Codable {

    enum CodingKeys: String, CodingKey {

        case location
        case lastTurn
        case targetType
        case navalMission
    }

    var location: HexPoint = HexPoint(x: -1, y: -1)
    var lastTurn: Int = -1
    var targetType: TacticalTargetType = .none
    var navalMission: Bool = false

    init(location: HexPoint = HexPoint(x: -1, y: -1), lastTurn: Int = -1, targetType: TacticalTargetType = .none, navalMission: Bool = false) {

        self.location = location
        self.lastTurn = lastTurn
        self.targetType = targetType
        self.navalMission = navalMission
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.lastTurn = try container.decode(Int.self, forKey: .lastTurn)
        self.targetType = try container.decode(TacticalTargetType.self, forKey: .targetType)
        self.navalMission = try container.decode(Bool.self, forKey: .navalMission)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.location, forKey: .location)
        try container.encode(self.lastTurn, forKey: .lastTurn)
        try container.encode(self.targetType, forKey: .targetType)
        try container.encode(self.navalMission, forKey: .navalMission)
    }
}
