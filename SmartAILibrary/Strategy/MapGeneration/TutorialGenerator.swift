//
//  TutorialGenerator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 02.08.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

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
            return self.generateImprovingCityTutorial(on: map, with: leader, on: handicap)

        case .establishTradeRoute:
            return self.generateEstablishTradeRouteTutorial(on: map, with: leader, on: handicap)

        case .combatAndConquest:
            return self.generateCombatAndConquestTutorial(on: map, with: leader, on: handicap)

        case .basicDiplomacy:
            return self.generateBasicDiplomacyTutorial(on: map, with: leader, on: handicap)
        }
    }

    /// this method fill all policy card slots of all players - even if the player has additional slots from wonders oder traits
    private func fillAllPolicyCards(in gameModel: GameModel) {

        for player in gameModel.players {

            guard player.isMajorAI() || player.isHuman() else {
                continue
            }

            player.government?.fillPolicyCards(in: gameModel)
        }
    }

    /// generate 1st tutorial: movement and exploration
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

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        return gameModel
    }
    // swiftlint:enable force_try

    /// generate 2nd tutorial: found first cities
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

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        return gameModel
    }
    // swiftlint:enable force_try

    /// generate 3rd tutorial: improving city
    // swiftlint:disable force_try
    private func generateImprovingCityTutorial(on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

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
                let unit = Unit(at: startLocation.point, type: .warrior, owner: player)
                units.append(unit)
            } else {
                let unit = Unit(at: startLocation.point, type: .scout, owner: player)
                units.append(unit)
            }
        }

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        // add human player city
        guard let cityName = leader.civilization().cityNames().first,
              let startLocation = map?.startLocations.first(where: { $0.leader == leader }),
              let humanPlayer = gameModel.humanPlayer() else {

            fatalError("cant get human properties")
        }
        let city = City(name: cityName, at: startLocation.point, capital: true, owner: humanPlayer)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        return gameModel
    }
    // swiftlint:enable force_try

    /// generate 4th tutorial: establish trade routes
    // swiftlint:disable force_try
    private func generateEstablishTradeRouteTutorial(on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

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
                try! player.civics?.discover(civic: .foreignTrade, in: nil)
            } else {
                let unit = Unit(at: startLocation.point, type: .scout, owner: player)
                units.append(unit)
            }
        }

        // handle city states
        /*for startLocation in map?.cityStateStartLocations ?? [] {

            let cityStatePlayer = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            cityStatePlayer.initialize()
            players.insert(cityStatePlayer, at: 1)

            // no units !
        }*/

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        //
        // add human player city
        guard let cityName = leader.civilization().cityNames().first,
              let startLocation = map?.startLocations.first(where: { $0.leader == leader }),
              let humanPlayer = gameModel.humanPlayer() else {

            fatalError("cant get human properties")
        }
        let city = City(name: cityName, at: startLocation.point, capital: true, owner: humanPlayer)
        city.initialize(in: gameModel)
        gameModel.add(city: city)

        // todo: foreign city, connect civs, sight to this city

        return gameModel
    }
    // swiftlint:enable force_try

    /// generate 5th tutorial: combat and conquest
    // swiftlint:disable force_try
    private func generateCombatAndConquestTutorial(on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

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

            self.allocate(units: &units, at: startLocation.point, of: [.settler], for: cityStatePlayer)
        }

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        // todo: add human and enemy city and some units to conquest enemy city (but no enemy units)

        return gameModel
    }
    // swiftlint:enable force_try

    /// generate 6th tutorial: basic diplomacy
    // swiftlint:disable force_try
    private func generateBasicDiplomacyTutorial(on map: MapModel?, with leader: LeaderType, on handicap: HandicapType) -> GameModel {

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

            self.allocate(units: &units, at: startLocation.point, of: [.settler], for: cityStatePlayer)
        }

        let gameModel = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // fill policy cards
        self.fillAllPolicyCards(in: gameModel)

        // add units
        self.add(units: units, to: gameModel)

        // todo:
        // - add human and enemy city and let them get to know each other
        // - discover early empire
        // goal: reach good relations with enemy

        return gameModel
    }
    // swiftlint:enable force_try
}
