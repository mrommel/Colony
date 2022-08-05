//
//  TutorialGenerator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 02.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GenericGenerator {

    init() {}

    func add(units: [AbstractUnit], to gameModel: GameModel) {

        var lastLeader: LeaderType? = LeaderType.none
        for unit in units {

            gameModel.add(unit: unit)
            gameModel.sight(at: unit.location, sight: unit.sight(), for: unit.player)

            if lastLeader == unit.player?.leader {
                if gameModel.units(at: unit.location).count > 1 {
                    let jumped = unit.jumpToNearestValidPlotWithin(range: 2, in: gameModel)
                    if !jumped {
                        print("--- could not jump unit to nearest valid plot ---")
                    }
                }
            }

            lastLeader = unit.player?.leader
        }
    }
}

public class TutorialGenerator: GenericGenerator {

    public override init() {}

    public func generate(tutorial: TutorialType, on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

        switch tutorial {

        case .none:
            fatalError("cant generate tutorial for 'none'")

        case .movementAndExploration:
            return self.generateMovementAndExplorationTutorial(on: map, with: leader, on: handicap)

        case .foundFirstCity:
            return self.generateFoundFirstCityTutorial(on: map, with: leader, on: handicap)

        case .improvingCity:
            fatalError("cant generate tutorial for 'improvingCity'")

        case .combatAndConquest:
            fatalError("cant generate tutorial for 'combatAndConquest'")

        case .basicDiplomacy:
            fatalError("cant generate tutorial for 'basicDiplomacy'")
        }
    }

    private func fillAllPolicyCards(in gameModel: GameModel) {

        for player in gameModel.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            player.government?.fillPolicyCards(in: gameModel)
        }
    }

    // swiftlint:disable force_try
    private func generateMovementAndExplorationTutorial(on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []

        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        players.prepend(playerBarbar)

        for startLocation in map?.startLocations ?? [] {

            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()

            // set first government
            player.government?.set(governmentType: .chiefdom, in: nil)
            try! player.civics?.discover(civic: .codeOfLaws, in: nil)

            players.append(player)

            // units
            if startLocation.isHuman {
                let unit = Unit(at: startLocation.point, type: .scout, owner: player)
                units.append(unit)
            } else {
                let unit = Unit(at: startLocation.point, type: .warrior, owner: player)
                units.append(unit)
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

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        return gameModel
    }
    // swiftlint:enable force_try

    // swiftlint:disable force_try
    private func generateFoundFirstCityTutorial(on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []

        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        players.prepend(playerBarbar)

        for startLocation in map?.startLocations ?? [] {

            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()

            // set first government
            player.government?.set(governmentType: .chiefdom, in: nil)
            try! player.civics?.discover(civic: .codeOfLaws, in: nil)

            players.append(player)

            // units
            if startLocation.isHuman {
                let unit = Unit(at: startLocation.point, type: .settler, owner: player)
                units.append(unit)

                let unit2 = Unit(at: startLocation.point, type: .settler, owner: player)
                units.append(unit2)
            } else {
                let unit = Unit(at: startLocation.point, type: .scout, owner: player)
                units.append(unit)
            }
        }

        // handle city states
        for startLocation in map?.cityStateStartLocations ?? [] {

            let cityStatePlayer = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            cityStatePlayer.initialize()
            players.insert(cityStatePlayer, at: 1)

            let settlerUnit = Unit(at: startLocation.point, type: .settler, owner: cityStatePlayer)
            units.append(settlerUnit)
        }

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        return gameModel
    }
    // swiftlint:enable force_try
}
