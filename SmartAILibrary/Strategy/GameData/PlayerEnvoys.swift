//
//  PlayerEnvoys.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractPlayerEnvoys: AnyObject, Codable {

    var player: AbstractPlayer? { get set }

    func unassignedEnvoys() -> Int
    func meet(cityState: CityStateType, isFirst: Bool)
    func envoys(in cityState: CityStateType) -> Int
    func changeUnassignedEnvoys(by value: Int)
    func assignEnvoy(to cityState: CityStateType) -> Bool
    func unassignEnvoy(from cityState: CityStateType) -> Bool

    func envoyEffects(in gameModel: GameModel?) -> [EnvoyEffect]
    func isSuzerain(of cityState: CityStateType, in gameModel: GameModel?) -> Bool
}

public class PlayerEnvoys: AbstractPlayerEnvoys {

    enum CodingKeys: CodingKey {

        case envoyArray
        case unassignedEnvoys
    }

    // user properties / values
    public var player: AbstractPlayer?

    private let envoyArray: WeightedList<CityStateType>
    private var unassignedEnvoysValue: Int

    // MARK: constructor

    init(player: Player?) {

        self.player = player

        self.envoyArray = WeightedList<CityStateType>()
        self.unassignedEnvoysValue = 0
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.envoyArray = try container.decode(WeightedList<CityStateType>.self, forKey: .envoyArray)
        self.unassignedEnvoysValue = try container.decode(Int.self, forKey: .unassignedEnvoys)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.envoyArray, forKey: .envoyArray)
        try container.encode(self.unassignedEnvoysValue, forKey: .unassignedEnvoys)
    }

    public func unassignedEnvoys() -> Int {

        return self.unassignedEnvoysValue
    }

    public func meet(cityState: CityStateType, isFirst: Bool) {

        self.envoyArray.add(weight: isFirst ? 1 : 0, for: cityState)
    }

    public func envoys(in cityState: CityStateType) -> Int {

        return Int(self.envoyArray.weight(of: cityState))
    }

    public func changeUnassignedEnvoys(by value: Int) {

        if self.unassignedEnvoysValue + value < 0 {
            fatalError("unhandled yet - need to unassign envoys until unassignedEnvoys is zero")
        }

        self.unassignedEnvoysValue += value
    }

    /// assigns an envoy to `cityState
    /// - Parameter cityState: cityState to assign the envoy to
    public func assignEnvoy(to cityState: CityStateType) -> Bool {

        // check that there are unassigned envoys to assign to the selected city state
        guard self.unassignedEnvoysValue > 0 else {
            return false
        }

        self.changeUnassignedEnvoys(by: -1)
        self.envoyArray.add(weight: 1, for: cityState)
        return true
    }

    /// unasigns an envoy from `cityState
    /// - Parameter cityState: cityState to unassign the envoy from
    public func unassignEnvoy(from cityState: CityStateType) -> Bool {

        // check that there is at least one envoy currently assigned to this city state
        guard self.envoyArray.weight(of: cityState) > 0 else {
            return false
        }

        self.changeUnassignedEnvoys(by: 1)
        self.envoyArray.add(weight: -1, for: cityState)
        return true
    }

    public func envoyEffects(in gameModel: GameModel?) -> [EnvoyEffect] {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get human diplomacyAI")
        }

        var effects: [EnvoyEffect] = []

        for player in gameModel.players {

            if player.isCityState() {
                if diplomacyAI.hasMet(with: player) {
                    if case .cityState(type: let cityState) = player.leader {

                        let envoys = self.envoys(in: cityState)
                        if envoys >= 1 {
                            effects.append(EnvoyEffect(cityState: cityState, level: .first))
                        }

                        if envoys >= 3 {
                            effects.append(EnvoyEffect(cityState: cityState, level: .third))
                        }

                        if envoys >= 6 {
                            effects.append(EnvoyEffect(cityState: cityState, level: .sixth))
                        }

                        if let suzerainLeader = player.suzerain() {
                            if let suzerainPlayer = gameModel.player(for: suzerainLeader) {
                                if suzerainPlayer.isEqual(to: self.player) {
                                    effects.append(EnvoyEffect(cityState: cityState, level: .suzerain))
                                }
                            }
                        }
                    }
                }
            }
        }

        return effects
    }

    public func isSuzerain(of cityState: CityStateType, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let diplomacyAI = self.player?.diplomacyAI else {
            fatalError("cant get human diplomacyAI")
        }

        guard let cityStatePlayer = gameModel.cityStatePlayer(for: cityState) else {
            return false
        }

        guard diplomacyAI.hasMet(with: cityStatePlayer) else {
            return false
        }

        let envoys = self.envoys(in: cityState)

        if envoys < 3 {
            return false
        }

        if let suzerainLeader = cityStatePlayer.suzerain() {
            if let suzerainPlayer = gameModel.player(for: suzerainLeader) {
                if suzerainPlayer.isEqual(to: self.player) {
                    return true
                }
            }
        }

        return false
    }
}
