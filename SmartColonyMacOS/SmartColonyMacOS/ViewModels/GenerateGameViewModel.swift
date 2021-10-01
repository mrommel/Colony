//
//  GenerateGameViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 23.03.21.
//

import Cocoa
import SmartAILibrary

// swiftlint:disable force_try

protocol GenerateGameViewModelDelegate: AnyObject {

    func created(game: GameModel?)
}

class GenerateGameViewModel: ObservableObject {

    @Published
    var progressValue: CGFloat

    @Published
    var progressText: String

    weak var delegate: GenerateGameViewModelDelegate?

    init(initialProgress: CGFloat = 0.0, initialText: String = "") {

        self.progressValue = initialProgress
        self.progressText = initialText
    }

    func start(with leader: LeaderType, on handicap: HandicapType, with mapType: MapType, and mapSize: MapSize) {

        switch mapType {

        case .continents:
            self.generatingContinents(with: mapSize, with: leader, on: handicap)
        default:
            self.generatingEmpty(with: mapSize, with: leader, on: handicap)
        }
    }

    func generatingContinents(with mapSize: MapSize, with leader: LeaderType, on handicap: HandicapType) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {

            self.progressValue = 0.0
            self.progressText = "Start"

            DispatchQueue.global(qos: .background).async {

                // generate map
                let mapOptions = MapOptions(withSize: mapSize, leader: leader, handicap: handicap)
                mapOptions.enhanced.sealevel = .low

                let generator = MapGenerator(with: mapOptions)
                generator.progressHandler = { progress, text in
                    DispatchQueue.main.async {
                        self.progressValue = CGFloat(progress)
                        self.progressText = text
                    }
                }

                let map = generator.generate()

                self.generateGame(map: map, with: leader, on: handicap)
            }
        })
    }

    func generatingEmpty(with mapSize: MapSize, with leader: LeaderType, on handicap: HandicapType) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {

            self.progressValue = 0.0
            self.progressText = "Start"

            DispatchQueue.global(qos: .background).async {

                self.progressValue = 1.0
                self.progressText = "End"

                let map = MapModel(width: mapSize.width(), height: mapSize.height())

                self.generateGame(map: map, with: leader, on: handicap)
            }
        })
    }

    func generateGame(map: MapModel?, with leader: LeaderType, on handicap: HandicapType) {

        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []

        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        players.prepend(playerBarbar)

        for startLocation in map?.startLocations ?? [] {

            //print("startLocation: \(startLocation.leader) (\(startLocation.isHuman ? "human" : "AI")) => \(startLocation.point)")

            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()

            // free techs
            if startLocation.isHuman {
                for tech in handicap.freeHumanTechs() {
                    try! player.techs?.discover(tech: tech)
                }

                for civic in handicap.freeHumanCivics() {
                    try! player.civics?.discover(civic: civic)
                }
            } else {
                for tech in handicap.freeAITechs() {
                    try! player.techs?.discover(tech: tech)
                }

                for civic in handicap.freeAICivics() {
                    try! player.civics?.discover(civic: civic)
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

            // debug - FIXME - TODO
            if startLocation.isHuman {
                // print("remove me - this is cheating")
                // MapUtils.discover(mapModel: &map, by: player)
            }
        }

        let game = GameModel(victoryTypes: [VictoryType.cultural], handicap: handicap, turnsElapsed: 0, players: players, on: map!)

        // add units
        var lastLeader: LeaderType? = LeaderType.none
        for unit in units {

            game.add(unit: unit)

            game.sight(at: unit.location, sight: unit.sight(), for: unit.player)

            if lastLeader == unit.player?.leader {
                let jumped = unit.jumpToNearestValidPlotWithin(range: 2, in: game)
                print("--- jumped: \(jumped)")
            }

            lastLeader = unit.player?.leader
        }

        // cheat
        // MapUtils.discover(mapModel: &map, by: playerBarbar, in: self.game)

        DispatchQueue.main.async {

            self.progressValue = 1.0
            self.progressText = "Ready"

            self.delegate?.created(game: game)
        }
    }
}
