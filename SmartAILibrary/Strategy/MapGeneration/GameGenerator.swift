//
//  GameGenerator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 01.07.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GameGenerator {

    public init() {}

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
                let settlerUnit = Unit(at: startLocation.point, type: .settler, owner: player)
                units.append(settlerUnit)

                let warriorUnit = Unit(at: startLocation.point, type: .warrior, owner: player)
                units.append(warriorUnit)

                let builderUnit = Unit(at: startLocation.point, type: .builder, owner: player)
                units.append(builderUnit)
            } else {
                for unitType in handicap.freeAIStartingUnitTypes() {

                    let unit = Unit(at: startLocation.point, type: unitType, owner: player)
                    units.append(unit)
                }
            }

            // debug
            if startLocation.isHuman {
                // print("remove me - this is cheating")
                // MapUtils.discover(mapModel: &map, by: player)
            }
        }

        // handle city states
        for startLocation in map?.cityStateStartLocations ?? [] {

            let cityStatePlayer = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            cityStatePlayer.initialize()
            players.insert(cityStatePlayer, at: 1)

            let settlerUnit = Unit(at: startLocation.point, type: .settler, owner: cityStatePlayer)
            units.append(settlerUnit)

            let warriorUnit = Unit(at: startLocation.point, type: .warrior, owner: cityStatePlayer)
            units.append(warriorUnit)
        }

        let game = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // add units
        var lastLeader: LeaderType? = LeaderType.none
        for unit in units {

            game.add(unit: unit)
            game.sight(at: unit.location, sight: unit.sight(), for: unit.player)

            if lastLeader == unit.player?.leader {
                let jumped = unit.jumpToNearestValidPlotWithin(range: 2, in: game)
                if !jumped {
                    print("--- could not jump unit to nearest valid plot ---")
                }
            }

            lastLeader = unit.player?.leader
        }

        return game
    }
}
