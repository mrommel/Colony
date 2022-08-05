//
//  GameGenerator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.07.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GameGenerator: GenericGenerator {

    public override init() {}

    // swiftlint:disable force_try
    public func generate(map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []

        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        players.prepend(playerBarbar)

        for startLocation in map?.startLocations ?? [] {

            // print("startLocation: \(startLocation.leader) (\(startLocation.isHuman ? "human" : "AI")) => \(startLocation.point)")

            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()

            // free techs
            if startLocation.isHuman {
                for tech in handicap.freeHumanTechs() {
                    try! player.techs?.discover(tech: tech, in: nil)
                }

                for civic in handicap.freeHumanCivics() {
                    try! player.civics?.discover(civic: civic, in: nil)
                }
            } else {
                for tech in handicap.freeAITechs() {
                    try! player.techs?.discover(tech: tech, in: nil)
                }

                for civic in handicap.freeAICivics() {
                    try! player.civics?.discover(civic: civic, in: nil)
                }
            }

            // set first government
            player.government?.set(governmentType: .chiefdom, in: nil)

            players.append(player)

            // units
            if startLocation.isHuman {
                self.allocate(units: &units, at: startLocation.point, of: handicap.freeHumanStartingUnitTypes(), for: player)
            } else {
                self.allocate(units: &units, at: startLocation.point, of: handicap.freeAIStartingUnitTypes(), for: player)
            }
        }

        // handle city states
        for startLocation in map?.cityStateStartLocations ?? [] {

            let cityStatePlayer = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            cityStatePlayer.initialize()
            players.insert(cityStatePlayer, at: 1)

            self.allocate(units: &units, at: startLocation.point, of: self.freeCityStateStartingUnitTypes(), for: cityStatePlayer)
        }

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // add units
        self.add(units: units, to: gameModel)

        return gameModel
    }
    // swiftlint:enable force_try
}
