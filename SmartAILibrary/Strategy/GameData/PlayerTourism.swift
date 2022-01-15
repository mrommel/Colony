//
//  PlayerTourism.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.11.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public struct Tourists {

    var domestic: Int
    var visiting: Int
}

public protocol AbstractPlayerTourism: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func doTurn(in gameModel: GameModel?)

    func domesticTourists() -> Int
    func visitingTourists(in gameModel: GameModel?) -> Int

    func currentTourism(in gameModel: GameModel?) -> Double

    // test methods
    func set(lifetimeCulture value: Double)
    func set(lifetimeTourism value: Double, for leader: LeaderType)
}

// https://civilization.fandom.com/wiki/Tourism_(Civ6)
class PlayerTourism: AbstractPlayerTourism {

    enum CodingKeys: CodingKey {

        case lifetimeCulture
        case lifetimeTourism
    }

    // user properties / values
    var player: AbstractPlayer?

    var lifetimeCultureValue: Double
    var lifetimeTourismValue: [LeaderType: Double]

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.lifetimeCultureValue = 0.0
        self.lifetimeTourismValue = [:]
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lifetimeCultureValue = try container.decode(Double.self, forKey: .lifetimeCulture)
        self.lifetimeTourismValue = try container.decode([LeaderType: Double].self, forKey: .lifetimeTourism)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.lifetimeCultureValue, forKey: .lifetimeCulture)
        try container.encode(self.lifetimeTourismValue, forKey: .lifetimeTourism)
    }

    // methods

    func doTurn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let turnCulture = player.culture(in: gameModel)
        self.lifetimeCultureValue += turnCulture

        for loopPlayer in gameModel.players {

            if loopPlayer.isBarbarian() || player.isEqual(to: loopPlayer) {
                continue
            }

            var loopPlayerTourism: Int = Int(loopPlayer.currentTourism(in: gameModel))

            let tourismModifier = loopPlayer.tourismModifier(towards: player, in: gameModel)

            loopPlayerTourism *= tourismModifier
            loopPlayerTourism /= 100

            self.lifetimeTourismValue[loopPlayer.leader] = (self.lifetimeTourismValue[loopPlayer.leader] ?? 0.0) + Double(loopPlayerTourism)
        }
    }

    func domesticTourists() -> Int {

        guard let civics = self.player?.civics else {
            fatalError("cant get civics")
        }

        // eurekas
        var eurekaValue: Double = 0.0

        for civic in CivicType.all {

            // dont hav civic but eureka enabled
            if !civics.has(civic: civic) && civics.inspirationTriggered(for: civic) {

                eurekaValue += Double(civic.cost()) / 2.0
            }
        }

        return Int((self.lifetimeCultureValue + eurekaValue) / 100.0)
    }

    func visitingTourists(from otherPlayer: AbstractPlayer?, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let otherLeader = otherPlayer?.leader else {
            fatalError("cant get other leader")
        }

        guard let cumulatedTourismValue = self.lifetimeTourismValue[otherLeader] else {
            print("WARNING: cant get cumulated tourism value for \(otherLeader)")
            return 0
        }

        let divider = gameModel.players.count * 200

        return Int(cumulatedTourismValue) / divider
    }

    func visitingTourists(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var tourists: Int = 0

        for loopPlayer in gameModel.players {

            if loopPlayer.isBarbarian() || player.isEqual(to: loopPlayer) {
                continue
            }

            tourists += self.visitingTourists(from: loopPlayer, in: gameModel)
        }

        return tourists
    }

    public func baseTourism(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var rtnValue: Double = 0.0

        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            rtnValue += city.baseTourism(in: gameModel)
        }

        return rtnValue
    }

    func currentTourism(in gameModel: GameModel?) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }

        let baseTourism = self.baseTourism(in: gameModel)

        // modifiers ?

        return baseTourism
    }

    // MARK: testing methods

    func set(lifetimeCulture value: Double) {

        if !Thread.current.isRunningXCTest {
            fatalError("--- WARNING: THIS IS FOR TESTING ONLY ---")
        }

        self.lifetimeCultureValue = value
    }

    func set(lifetimeTourism value: Double, for leader: LeaderType) {

        if !Thread.current.isRunningXCTest {
            fatalError("--- WARNING: THIS IS FOR TESTING ONLY ---")
        }

        self.lifetimeTourismValue[leader] = value
    }
}
