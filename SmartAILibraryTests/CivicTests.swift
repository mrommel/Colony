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

// swiftlint:disable force_try

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
}
