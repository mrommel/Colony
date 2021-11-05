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

    func currentTourism(in gameModel: GameModel?) -> Double
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
    var lifetimeTourismValue: Double

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.lifetimeCultureValue = 0.0
        self.lifetimeTourismValue = 0.0
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.lifetimeCultureValue = try container.decode(Double.self, forKey: .lifetimeCulture)
        self.lifetimeTourismValue = try container.decode(Double.self, forKey: .lifetimeTourism)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.lifetimeCultureValue, forKey: .lifetimeCulture)
        try container.encode(self.lifetimeTourismValue, forKey: .lifetimeTourism)
    }

    // methods

    func doTurn(in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let turnCulture = player.culture(in: gameModel)
        self.lifetimeCultureValue += turnCulture

        let turnTourism = self.baseTourism(in: gameModel)
        self.lifetimeTourismValue += turnTourism
    }

    func domesticTourists() -> Int {

        // eurekas?

        return Int(self.lifetimeCultureValue / 100.0)
    }

    func baseTourism(in gameModel: GameModel?) -> Double {

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

        guard let player = self.player else {
            fatalError("cant get player")
        }

        let baseTourism = self.baseTourism(in: gameModel)

        // modifiers ?



        return baseTourism
    }
}
