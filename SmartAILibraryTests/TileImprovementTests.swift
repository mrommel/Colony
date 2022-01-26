//
//  TileImprovementTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 06.10.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import XCTest

@testable import SmartAILibrary

// swiftlint:disable force_try

class TileImprovementTests: XCTestCase {

    func testFishingBoatsCanBeBuilt() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 4))
        mapModel.set(hills: true, at: HexPoint(x: 2, y: 4))

        mapModel.set(resource: .wheat, at: HexPoint(x: 3, y: 4))
        mapModel.set(terrain: .plains, at: HexPoint(x: 3, y: 4))

        mapModel.set(resource: .iron, at: HexPoint(x: 3, y: 3))
        mapModel.set(hills: true, at: HexPoint(x: 3, y: 3))

        mapModel.set(feature: .forest, at: HexPoint(x: 4, y: 4))
        mapModel.set(resource: .furs, at: HexPoint(x: 4, y: 4))

        mapModel.set(hills: true, at: HexPoint(x: 4, y: 5))
        mapModel.set(resource: .wine, at: HexPoint(x: 4, y: 5))

        mapModel.set(terrain: .shore, at: HexPoint(x: 4, y: 3))
        mapModel.set(resource: .fish, at: HexPoint(x: 4, y: 3))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // AI
        aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)
        aiPlayer.found(at: HexPoint(x: 12, y: 10), named: "AI City", in: gameModel)

        // Human
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .bronzeWorking, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .irrigation, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .animalHusbandry, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .sailing, in: gameModel)
        try! humanPlayer.techs?.setCurrent(tech: .archery, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

        if let humanCity = gameModel.city(at: HexPoint(x: 3, y: 5)) {
            humanCity.buildQueue.add(item: BuildableItem(buildingType: .granary))

            for pointToClaim in HexPoint(x: 3, y: 5).areaWith(radius: 2) {
                if let tileToClaim = gameModel.tile(at: pointToClaim) {
                    if !tileToClaim.hasOwner() {
                        do {
                            try tileToClaim.set(owner: humanPlayer)
                            try tileToClaim.setWorkingCity(to: humanCity)

                            humanPlayer.addPlot(at: pointToClaim)

                            gameModel.userInterface?.refresh(tile: tileToClaim)
                        } catch {
                            fatalError("cant set owner")
                        }
                    }
                }
            }
        }

        MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)

        // WHEN
        let builderUnit = Unit(at: HexPoint(x: 3, y: 4), type: .builder, owner: humanPlayer)
        _ = builderUnit.doMove(on: HexPoint(x: 4, y: 3), in: gameModel)
        gameModel.add(unit: builderUnit)
        gameModel.userInterface?.show(unit: builderUnit, at: HexPoint(x: 3, y: 4))
        let canBuildFishingBoats = builderUnit.canDo(command: .buildFishingBoats, in: gameModel)

        // THEN
        XCTAssertTrue(canBuildFishingBoats)
    }

    // Cannot build mine on resource in open terrain (not on hills) #129
    func testMineCanBeBuiltOnResourceInOpenTerrain() {

        // GIVEN
        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: .victoria, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: .alexander, isHuman: true)
        humanPlayer.initialize()

        let mapModel = MapUtils.mapFilled(with: .grass, sized: .small)

        mapModel.set(terrain: .plains, at: HexPoint(x: 2, y: 4))
        mapModel.set(hills: false, at: HexPoint(x: 2, y: 4))
        mapModel.set(resource: .salt, at: HexPoint(x: 2, y: 4))

        let gameModel = GameModel(
            victoryTypes: [.domination],
            handicap: .king,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        // AI
        aiPlayer.found(at: HexPoint(x: 20, y: 8), named: "AI Capital", in: gameModel)

        // Human
        humanPlayer.found(at: HexPoint(x: 3, y: 5), named: "Human Capital", in: gameModel)
        try! humanPlayer.techs?.discover(tech: .pottery, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .bronzeWorking, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .irrigation, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .animalHusbandry, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .sailing, in: gameModel)
        try! humanPlayer.techs?.discover(tech: .mining, in: gameModel)
        try! humanPlayer.techs?.setCurrent(tech: .archery, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .codeOfLaws, in: gameModel)
        try! humanPlayer.civics?.discover(civic: .foreignTrade, in: gameModel)
        try! humanPlayer.civics?.setCurrent(civic: .craftsmanship, in: gameModel)

        // WHEN
        let canBuildMine = humanPlayer.canBuild(build: .mine, at: HexPoint(x: 2, y: 4), testGold: true, in: gameModel)

        // THEN
        XCTAssertTrue(canBuildMine)
    }
}
