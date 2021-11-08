//
//  RankingData.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum RankingDataType {

    case culturePerTurn
    case goldBalance
    case totalCitiesFounded

    public static var all: [RankingDataType] = [

        .culturePerTurn,
        .goldBalance,
        .totalCitiesFounded
    ]

    public func title() -> String {

        switch self {

        case .culturePerTurn:
            return "Culture per-turn" // LOC_REPLAYDATASET_CULTURE_NAME
        case .goldBalance:
            return "Gold balance" // LOC_REPLAYDATASET_TOTALGOLD_NAME
        case .totalCitiesFounded:
            return "Total cities founded" // LOC_REPLAYDATASET_TOTALCITIESBUILT_NAME
        }
    }

    /*
             <Row Tag="LOC_REPLAYDATASET_TOTALDISTRICTSBUILT_NAME">
                 <Text>Total districts constructed</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALWONDERSBUILT_NAME">
                 <Text>Total wonders constructed</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALBUILDINGSBUILT_NAME">
                 <Text>Total buildings constructed</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALCITIESCAPTURED_NAME">
                 <Text>Total cities captured</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALCITIESLOST_NAME">
                 <Text>Total cities lost</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALCITIESDESTROYED_NAME">
                 <Text>Total cities destroyed</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALWARSDECLARED_NAME">
                 <Text>Total wars declared</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALWARSWON_NAME">
                 <Text>Total wars won</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALCOMBATS_NAME">
                 <Text>Total number of combats</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALUNITSDESTROYED_NAME">
                 <Text>Total units killed</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALPLAYERUNITSDESTROYED_NAME">
                 <Text>Total units lost</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALRELIGIONSFOUNDED_NAME">
                 <Text>Total religions founded</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_GREATPEOPLEEARNED_NAME">
                 <Text>Total great people earned</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALWARSAGAINSTPLAYER_NAME">
                 <Text>Total war declarations received</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_TOTALPANTHEONSFOUNDED_NAME">
                 <Text>Total pantheons founded</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_SCOREPERTURN_NAME">
                 <Text>Score per-turn</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_SCIENCEPERTURN_NAME">
                 <Text>Science per-turn</Text>
             </Row>
             <Row Tag="LOC_REPLAYDATASET_FAITHPERTURN_NAME">
                 <Text>Faith per-turn</Text>
             </Row>
     */
}

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
            case score
            case culturePerTurn
        }

        public let leader: LeaderType

        // one value per turn
        public var score: [Int]
        public var culturePerTurn: [Double]

        init(leader: LeaderType) {

            self.leader = leader

            self.score = []
            self.culturePerTurn = []
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.leader = try container.decode(LeaderType.self, forKey: .leader)
            self.score = try container.decode([Int].self, forKey: .score)
            self.culturePerTurn = try container.decode([Double].self, forKey: .culturePerTurn)
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.leader, forKey: .leader)
            try container.encode(self.score, forKey: .score)
            try container.encode(self.culturePerTurn, forKey: .culturePerTurn)
        }

        func add(score: Int) {

            self.score.append(score)
        }

        func add(culturePerTurn: Double) {

            self.culturePerTurn.append(culturePerTurn)
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

    public func add(culturePerTurn: Double, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(culturePerTurn: culturePerTurn)
        } else {
            fatalError("cannot happen")
        }
    }

    public func data(type: RankingDataType, for leader: LeaderType) -> [Double] {

        guard let leaderData = self.data.first(where: { $0.leader == leader }) else {
            fatalError("no data for leader: \(leader)")
        }

        switch type {

        case .culturePerTurn:
            return leaderData.culturePerTurn
        case .goldBalance:
            return []
        case .totalCitiesFounded:
            return []
        }
    }
}
