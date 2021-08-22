//
//  RankingData.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class RankingData: Codable {

    // MARK: properties

    enum CodingKeys: CodingKey {

        case data
    }

    public var data: [RankingLeaderData]

    // MARK: internal types

    public class RankingLeaderData: Codable {

        enum CodingKeys: CodingKey {

            case leader
            case data
        }

        public let leader: LeaderType
        public var data: [Int] // one value per turn

        init(leader: LeaderType) {

            self.leader = leader
            self.data = []
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.leader = try container.decode(LeaderType.self, forKey: .leader)
            self.data = try container.decode([Int].self, forKey: .data)
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.leader, forKey: .leader)
            try container.encode(self.data, forKey: .data)
        }

        func add(score: Int) {
            self.data.append(score)
        }
    }

    // MARK: constructors

    public init(players: [AbstractPlayer]) {

        self.data = []

        for player in players {

            self.data.append(RankingLeaderData(leader: player.leader))
        }
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.data = try container.decode([RankingLeaderData].self, forKey: .data)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.data, forKey: .data)
    }

    public func add(score: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(score: score)
        } else {
            fatalError("cannot happen")
        }
    }
}
