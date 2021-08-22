//
//  DiplomaticPact.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class DiplomaticPact: Codable {

    enum CodingKeys: CodingKey {

        case enabled
        case turnOfActivation
        case duration
    }

    static let noStarted = -1
    static let noDuration = -1

    private var enabled: Bool
    private var turnOfActivation: Int
    private let duration: Int

    init(with duration: Int = DiplomaticPact.noDuration) {

        self.enabled = false
        self.turnOfActivation = DiplomaticPact.noStarted
        self.duration = duration
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.enabled = try container.decode(Bool.self, forKey: .enabled)
        self.turnOfActivation = try container.decode(Int.self, forKey: .turnOfActivation)
        self.duration = try container.decode(Int.self, forKey: .duration)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.enabled, forKey: .enabled)
        try container.encode(self.turnOfActivation, forKey: .turnOfActivation)
        try container.encode(self.duration, forKey: .duration)
    }

    func isActive() -> Bool {

        return self.enabled
    }

    func isExpired(in turn: Int) -> Bool {

        // it can't expire, when it is not active
        if !self.enabled {
            return false
        }

        // it can't expire, if no duration
        if self.duration == DiplomaticPact.noDuration {
            return false
        }

        return self.turnOfActivation + self.duration <= turn
    }

    func abandon() {

        self.enabled = false
        self.turnOfActivation = DiplomaticPact.noStarted
    }

    func activate(in turn: Int = DiplomaticPact.noStarted) {

        self.enabled = true
        self.turnOfActivation = turn
    }

    func pactIsActiveSince() -> Int {

        return self.turnOfActivation
    }
}
