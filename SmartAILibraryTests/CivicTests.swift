//
//  CivicTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 31.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import XCTest
@testable import SmartAILibrary

class CivicTests: XCTestCase {

    var objectToTest: AbstractCivics?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testPossibleCivics() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        self.objectToTest = Civics(player: playerAlexander)
        try! self.objectToTest?.discover(civic: .codeOfLaws)
        try! self.objectToTest?.discover(civic: .foreignTrade)

        // WHEN
        let possibleCivics = self.objectToTest?.possibleCivics()

        // THEN
        XCTAssertTrue(possibleCivics!.contains(.craftsmanship))
        XCTAssertTrue(possibleCivics!.contains(.earlyEmpire))
        XCTAssertTrue(possibleCivics!.contains(.mysticism))
    }

    func testChooseNextCivicAlexander() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        self.objectToTest = Civics(player: playerAlexander)
        try! self.objectToTest?.discover(civic: .codeOfLaws)
        try! self.objectToTest?.discover(civic: .foreignTrade)

        // WHEN
        let nextCivic = self.objectToTest?.chooseNextCivic()

        // THEN
        //print("nextCivic: \(nextCivic)")
        XCTAssertTrue([.craftsmanship, .mysticism, .earlyEmpire].contains(nextCivic))
    }

    func testEurekaOfCraftsmanship() {

        // GIVEN
        let playerAlexander = Player(leader: .victoria)
        playerAlexander.initialize()
        self.objectToTest = playerAlexander.civics
        try! self.objectToTest?.discover(civic: .codeOfLaws)

        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination],
                                   handicap: .chieftain,
                                   turnsElapsed: 0,
                                   players: [playerAlexander],
                                   on: mapModel)

        let tile0 = mapModel.tile(at: HexPoint(x: 0, y: 0))
        try! tile0?.set(owner: playerAlexander)
        let tile1 = mapModel.tile(at: HexPoint(x: 1, y: 0))
        try! tile1?.set(owner: playerAlexander)
        let tile2 = mapModel.tile(at: HexPoint(x: 0, y: 1))
        try! tile2?.set(owner: playerAlexander)

        // WHEN
        let beforeEureka = self.objectToTest?.eurekaTriggered(for: .craftsmanship)
        tile0?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        tile1?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        tile2?.changeBuildProgress(of: BuildType.farm, change: 1000, for: playerAlexander, in: gameModel)
        let afterEureka = self.objectToTest?.eurekaTriggered(for: .craftsmanship)

        // THEN
        XCTAssertEqual(beforeEureka, false)
        XCTAssertEqual(afterEureka, true)
    }
}
