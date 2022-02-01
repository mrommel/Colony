//
//  PlayerMoments.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 17.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class Moment: Codable {

    public let type: MomentType
    public let turn: Int

    public init(type: MomentType, turn: Int) {

        self.type = type
        self.turn = turn
    }
}

public protocol AbstractPlayerMoments: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func add(moment: Moment)
    func addMoment(of type: MomentType, in turn: Int)
    func moments() -> [Moment]

    func eraScore() -> Int
    func resetEraScore()
}

public class PlayerMoments: AbstractPlayerMoments {

    enum CodingKeys: CodingKey {

        case moments
        case currentEraScore
    }

    // user properties / values
    public var player: AbstractPlayer?

    var momentsArray: [Moment]
    var currentEraScore: Int

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.momentsArray = []
        self.currentEraScore = 0
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.momentsArray = try container.decode([Moment].self, forKey: .moments)
        self.currentEraScore = try container.decode(Int.self, forKey: .currentEraScore)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.momentsArray, forKey: .moments)
        try container.encode(self.currentEraScore, forKey: .currentEraScore)
    }

    public func add(moment: Moment) {

        self.momentsArray.append(moment)

        self.currentEraScore += moment.type.eraScore()
    }

    public func addMoment(of type: MomentType, in turn: Int) {

        self.momentsArray.append(Moment(type: type, turn: turn))

        self.currentEraScore += type.eraScore()
    }

    public func moments() -> [Moment] {

        return self.momentsArray
    }

    public func eraScore() -> Int {

        return self.currentEraScore
    }

    public func resetEraScore() {

        self.currentEraScore = 0
    }
}
