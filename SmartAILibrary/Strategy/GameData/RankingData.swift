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

    case totalCities
    case totalCitiesFounded
    case totalCitiesLost

    case totalDistrictsConstructed
    case totalWondersConstructed
    case totalBuildingsConstructed
    // ...
    case scorePerTurn
    case sciencePerTurn
    case faithPerTurn

    case totalWarDeclarationsReceived

    case totalReligionsFounded
    case totalPantheonsFounded
    case totalGreatPeopleEarned

    public static var all: [RankingDataType] = [

        .culturePerTurn,
        .goldBalance,

        .totalCities,
        .totalCitiesFounded,
        .totalCitiesLost,

        .totalDistrictsConstructed,
        .totalWondersConstructed,
        .totalBuildingsConstructed,
        // ...
        .scorePerTurn,
        .sciencePerTurn,
        .faithPerTurn,

        .totalWarDeclarationsReceived,

        .totalReligionsFounded,
        .totalPantheonsFounded,
        .totalGreatPeopleEarned
    ]

    public func title() -> String {

        switch self {

        case .culturePerTurn:
            return "Culture per-turn" // LOC_REPLAYDATASET_CULTURE_NAME
        case .goldBalance:
            return "Gold balance" // LOC_REPLAYDATASET_TOTALGOLD_NAME

        case .totalCities:
            return "Total cities" // LOC_REPLAYDATASET_TOTALCITIESBUILT_NAME
        case .totalCitiesFounded:
            return "Total cities founded" // LOC_REPLAYDATASET_TOTALCITIESBUILT_NAME
        case .totalCitiesLost:
            return "Total cities lost" // LOC_REPLAYDATASET_TOTALCITIESLOST_NAME
        /*
        <Row Tag="LOC_REPLAYDATASET_TOTALCITIESCAPTURED_NAME">
            <Text>Total cities captured</Text>
        </Row>
        <Row Tag="LOC_REPLAYDATASET_TOTALCITIESDESTROYED_NAME">
            <Text>Total cities destroyed</Text>
        </Row>
         */

        case .totalDistrictsConstructed:
            return "Total districts constructed" // LOC_REPLAYDATASET_TOTALDISTRICTSBUILT_NAME
        case .totalWondersConstructed:
            return "Total wonders constructed" // LOC_REPLAYDATASET_TOTALWONDERSBUILT_NAME
        case .totalBuildingsConstructed:
            return "Total buildings constructed" // LOC_REPLAYDATASET_TOTALBUILDINGSBUILT_NAME
            // ...
        case .scorePerTurn:
            return "Score per-turn" // LOC_REPLAYDATASET_SCOREPERTURN_NAME
        case .sciencePerTurn:
            return "Science per-turn" // LOC_REPLAYDATASET_SCIENCEPERTURN_NAME
        case .faithPerTurn:
            return "Faith per-turn" // LOC_REPLAYDATASET_FAITHPERTURN_NAME

        case .totalWarDeclarationsReceived:
            return "Total war declarations received" // LOC_REPLAYDATASET_TOTALWARSAGAINSTPLAYER_NAME
        /*
         <Row Tag="LOC_REPLAYDATASET_TOTALWARSDECLARED_NAME">
             <Text>Total wars declared</Text>
         </Row>
         <Row Tag="LOC_REPLAYDATASET_TOTALWARSWON_NAME">
             <Text>Total wars won</Text>
         </Row>
         */

        case .totalReligionsFounded:
            return "Total religions founded" // LOC_REPLAYDATASET_TOTALRELIGIONSFOUNDED_NAME
        case .totalPantheonsFounded:
            return "Total pantheons founded" // LOC_REPLAYDATASET_TOTALPANTHEONSFOUNDED_NAME
        case .totalGreatPeopleEarned:
            return "Total great people earned" // LOC_REPLAYDATASET_GREATPEOPLEEARNED_NAME

        /*
         <Row Tag="LOC_REPLAYDATASET_TOTALCOMBATS_NAME">
             <Text>Total number of combats</Text>
         </Row>
         <Row Tag="LOC_REPLAYDATASET_TOTALUNITSDESTROYED_NAME">
             <Text>Total units killed</Text>
         </Row>
         <Row Tag="LOC_REPLAYDATASET_TOTALPLAYERUNITSDESTROYED_NAME">
             <Text>Total units lost</Text>
         </Row>
         */
        }
    }
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

            case culturePerTurn
            case goldBalance

            case totalCities
            case totalCitiesFounded
            case totalCitiesLost

            case totalDistrictsConstructed
            case totalWondersConstructed
            case totalBuildingsConstructed
            // ...
            case totalScore
            case sciencePerTurn
            case faithPerTurn
            case totalReligionsFounded
            case totalGreatPeopleEarned
            case totalWarDeclarationsReceived
            case totalPantheonsFounded
        }

        public let leader: LeaderType

        // one value per turn
        public var culturePerTurn: [Double]
        public var goldBalance: [Double]

        public var totalCities: [Int]
        public var totalCitiesFounded: [Int]
        public var totalCitiesLost: [Int]

        public var totalDistrictsConstructed: [Int]
        public var totalWondersConstructed: [Int]
        public var totalBuildingsConstructed: [Int]
        // ...
        public var totalScore: [Int]
        public var sciencePerTurn: [Double]
        public var faithPerTurn: [Double]
        public var totalReligionsFounded: [Int]
        public var totalGreatPeopleEarned: [Int]
        public var totalWarDeclarationsReceived: [Int]
        public var totalPantheonsFounded: [Int]

        // MARK: constructors

        init(leader: LeaderType) {

            self.leader = leader

            self.culturePerTurn = []
            self.goldBalance = []

            self.totalCities = []
            self.totalCitiesFounded = []
            self.totalCitiesLost = []

            self.totalDistrictsConstructed = []
            self.totalWondersConstructed = []
            self.totalBuildingsConstructed = []
            // ...
            self.totalScore = []
            self.sciencePerTurn = []
            self.faithPerTurn = []
            self.totalReligionsFounded = []
            self.totalGreatPeopleEarned = []
            self.totalWarDeclarationsReceived = []
            self.totalPantheonsFounded = []
        }

        public required init(from decoder: Decoder) throws {

            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.leader = try container.decode(LeaderType.self, forKey: .leader)

            self.culturePerTurn = try container.decode([Double].self, forKey: .culturePerTurn)
            self.goldBalance = try container.decode([Double].self, forKey: .goldBalance)

            self.totalCities = try container.decode([Int].self, forKey: .totalCities)
            self.totalCitiesFounded = try container.decode([Int].self, forKey: .totalCitiesFounded)
            self.totalCitiesLost = try container.decode([Int].self, forKey: .totalCitiesLost)

            self.totalDistrictsConstructed = try container.decode([Int].self, forKey: .totalDistrictsConstructed)
            self.totalWondersConstructed = try container.decode([Int].self, forKey: .totalWondersConstructed)
            self.totalBuildingsConstructed = try container.decode([Int].self, forKey: .totalBuildingsConstructed)
            // ...
            self.totalScore = try container.decode([Int].self, forKey: .totalScore)
            self.sciencePerTurn = try container.decode([Double].self, forKey: .sciencePerTurn)
            self.faithPerTurn = try container.decode([Double].self, forKey: .faithPerTurn)
            self.totalReligionsFounded = try container.decode([Int].self, forKey: .totalReligionsFounded)
            self.totalGreatPeopleEarned = try container.decode([Int].self, forKey: .totalGreatPeopleEarned)
            self.totalWarDeclarationsReceived = try container.decode([Int].self, forKey: .totalWarDeclarationsReceived)
            self.totalPantheonsFounded = try container.decode([Int].self, forKey: .totalPantheonsFounded)
        }

        public func encode(to encoder: Encoder) throws {

            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(self.leader, forKey: .leader)

            try container.encode(self.culturePerTurn, forKey: .culturePerTurn)
            try container.encode(self.goldBalance, forKey: .goldBalance)

            try container.encode(self.totalCities, forKey: .totalCities)
            try container.encode(self.totalCitiesFounded, forKey: .totalCitiesFounded)
            try container.encode(self.totalCitiesLost, forKey: .totalCitiesLost)

            try container.encode(self.totalDistrictsConstructed, forKey: .totalDistrictsConstructed)
            try container.encode(self.totalWondersConstructed, forKey: .totalWondersConstructed)
            try container.encode(self.totalBuildingsConstructed, forKey: .totalBuildingsConstructed)
            // ...
            try container.encode(self.totalScore, forKey: .totalScore)
            try container.encode(self.sciencePerTurn, forKey: .sciencePerTurn)
            try container.encode(self.faithPerTurn, forKey: .faithPerTurn)
            try container.encode(self.totalReligionsFounded, forKey: .totalReligionsFounded)
            try container.encode(self.totalGreatPeopleEarned, forKey: .totalGreatPeopleEarned)
            try container.encode(self.totalWarDeclarationsReceived, forKey: .totalWarDeclarationsReceived)
            try container.encode(self.totalPantheonsFounded, forKey: .totalPantheonsFounded)
        }

        func add(culturePerTurn: Double) {

            self.culturePerTurn.append(culturePerTurn)
        }

        func add(goldBalance: Double) {

            self.goldBalance.append(goldBalance)
        }

        func add(totalCities: Int) {

            self.totalCities.append(totalCities)
        }

        func add(totalCitiesFounded: Int) {

            self.totalCitiesFounded.append(totalCitiesFounded)
        }

        func add(totalCitiesLost: Int) {

            self.totalCitiesLost.append(totalCitiesLost)
        }

        func add(totalDistrictsConstructed: Int) {

            self.totalDistrictsConstructed.append(totalDistrictsConstructed)
        }

        func add(totalWondersConstructed: Int) {

            self.totalWondersConstructed.append(totalWondersConstructed)
        }

        func add(totalBuildingsConstructed: Int) {

            self.totalBuildingsConstructed.append(totalBuildingsConstructed)
        }

        // ...

        func add(totalScore: Int) {

            self.totalScore.append(totalScore)
        }

        func add(sciencePerTurn: Double) {

            self.sciencePerTurn.append(sciencePerTurn)
        }

        func add(faithPerTurn: Double) {

            self.faithPerTurn.append(faithPerTurn)
        }

        func add(totalReligionsFounded: Int) {

            self.totalReligionsFounded.append(totalReligionsFounded)
        }

        func add(totalGreatPeopleEarned: Int) {

            self.totalGreatPeopleEarned.append(totalGreatPeopleEarned)
        }

        func add(totalWarDeclarationsReceived: Int) {

            self.totalWarDeclarationsReceived.append(totalWarDeclarationsReceived)
        }

        func add(totalPantheonsFounded: Int) {

            self.totalPantheonsFounded.append(totalPantheonsFounded)
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

    // MARK: setter

    public func add(culturePerTurn: Double, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(culturePerTurn: culturePerTurn)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(goldBalance: Double, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(goldBalance: goldBalance)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalCities: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalCities: totalCities)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalCitiesFounded: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalCitiesFounded: totalCitiesFounded)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalCitiesLost: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalCitiesLost: totalCitiesLost)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalDistrictsConstructed: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalDistrictsConstructed: totalDistrictsConstructed)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalWondersConstructed: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalWondersConstructed: totalWondersConstructed)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalBuildingsConstructed: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalBuildingsConstructed: totalBuildingsConstructed)
        } else {
            fatalError("cannot happen")
        }
    }

    // ...

    public func add(totalScore: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalScore: totalScore)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(sciencePerTurn: Double, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(sciencePerTurn: sciencePerTurn)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(faithPerTurn: Double, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(faithPerTurn: faithPerTurn)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalReligionsFounded: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalReligionsFounded: totalReligionsFounded)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalGreatPeopleEarned: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalGreatPeopleEarned: totalGreatPeopleEarned)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalWarDeclarationsReceived: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalWarDeclarationsReceived: totalWarDeclarationsReceived)
        } else {
            fatalError("cannot happen")
        }
    }

    public func add(totalPantheonsFounded: Int, for leader: LeaderType) {

        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(totalPantheonsFounded: totalPantheonsFounded)
        } else {
            fatalError("cannot happen")
        }
    }

    // MARK: getter

    public func data(type: RankingDataType, for leader: LeaderType) -> [Double] {

        guard let leaderData = self.data.first(where: { $0.leader == leader }) else {
            fatalError("no data for leader: \(leader)")
        }

        switch type {

        case .culturePerTurn:
            return leaderData.culturePerTurn
        case .goldBalance:
            return leaderData.goldBalance

        case .totalCities:
            return leaderData.totalCities.map { Double($0) }
        case .totalCitiesFounded:
            return leaderData.totalCitiesFounded.map { Double($0) }

        case .totalDistrictsConstructed:
            return leaderData.totalDistrictsConstructed.map { Double($0) }
        case .totalWondersConstructed:
            return leaderData.totalWondersConstructed.map { Double($0) }
        case .totalBuildingsConstructed:
            return leaderData.totalBuildingsConstructed.map { Double($0) }
            // ...
        case .scorePerTurn:
            return leaderData.totalScore.map { Double($0) }
        case .sciencePerTurn:
            return leaderData.sciencePerTurn
        case .faithPerTurn:
            return leaderData.faithPerTurn
        case .totalReligionsFounded:
            return leaderData.totalReligionsFounded.map { Double($0) }
        case .totalGreatPeopleEarned:
            return leaderData.totalGreatPeopleEarned.map { Double($0) }
        case .totalWarDeclarationsReceived:
            return leaderData.totalWarDeclarationsReceived.map { Double($0) }
        case .totalPantheonsFounded:
            return leaderData.totalPantheonsFounded.map { Double($0) }
        }
    }
}
