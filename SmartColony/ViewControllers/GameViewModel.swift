//
//  GameViewModel.swift
//  SmartColony
//
//  Created by Michael Rommel on 03.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class GameViewModel {

    var game: GameModel?

    init(with game: GameModel?) {

        self.game = game

        // keep backup
        self.storeBackup()
    }

    init(with map: MapModel?, handicap: HandicapType) {

        guard var map = map else {
            fatalError("cant get map")
        }

        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []

        for startLocation in map.startLocations {

            //print("startLocation: \(startLocation.leader) (\(startLocation.isHuman ? "human" : "AI")) => \(startLocation.point)")

            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()

            // free techs
            if startLocation.isHuman {
                for tech in handicap.freeHumanTechs() {
                    do {
                        try player.techs?.discover(tech: tech)
                    } catch { }
                }

                for civic in handicap.freeHumanCivics() {
                    do {
                        try player.civics?.discover(civic: civic)
                    } catch { }
                }
            } else {
                for tech in handicap.freeAITechs() {
                    do {
                        try player.techs?.discover(tech: tech)
                    } catch { }
                }

                for civic in handicap.freeAICivics() {
                    do {
                        try player.civics?.discover(civic: civic)
                    } catch { }
                }
            }

            // set first government
            player.government?.set(governmentType: .chiefdom)

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

        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()

        players.prepend(playerBarbar)

        // game
        self.game = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic, .science],
            handicap: handicap,
            turnsElapsed: 0,
            players: players,
            on: map
        )

        // add units
        var lastLeader: LeaderType? = LeaderType.none
        for unit in units {

            self.game?.sight

            self.game?.add(unit: unit)

            if lastLeader == unit.player?.leader {
                let jumped = unit.jumpToNearestValidPlotWithin(range: 2, in: self.game)
                print("--- jumped: \(jumped)")
            }

            lastLeader = unit.player?.leader
        }

        // cheat
        MapUtils.discover(mapModel: &map, by: playerBarbar, in: self.game)

        // keep backup
        self.storeBackup()
    }

    func storeBackup() {

        GameStorage.storeRestart(game: self.game)
    }
}
