//
//  TileDiscoveredTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class TileDiscoveredTests: XCTestCase {

    var objectToTest: TileDiscovered?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testDiscoverNoPlayer() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .trajan)

        self.objectToTest = TileDiscovered()

        // WHEN
        let discoveredAlexander = self.objectToTest?.isDiscovered(by: playerAlexander)
        let discoveredAugustus = self.objectToTest?.isDiscovered(by: playerAugustus)

        // THEN
        XCTAssertEqual(discoveredAlexander, false)
        XCTAssertEqual(discoveredAugustus, false)
    }

    func testDiscoverOnePlayer() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .trajan)

        self.objectToTest = TileDiscovered()
        self.objectToTest?.discover(by: playerAlexander)

        // WHEN
        let discoveredAlexander = self.objectToTest?.isDiscovered(by: playerAlexander)
        let discoveredAugustus = self.objectToTest?.isDiscovered(by: playerAugustus)

        // THEN
        XCTAssertEqual(discoveredAlexander, true)
        XCTAssertEqual(discoveredAugustus, false)
    }

    func testDiscoverTwoPlayers() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        let playerAugustus = Player(leader: .trajan)

        self.objectToTest = TileDiscovered()
        self.objectToTest?.discover(by: playerAlexander)
        self.objectToTest?.discover(by: playerAugustus)

        // WHEN
        let discoveredAlexander = self.objectToTest?.isDiscovered(by: playerAlexander)
        let discoveredAugustus = self.objectToTest?.isDiscovered(by: playerAugustus)

        // THEN
        XCTAssertEqual(discoveredAlexander, true)
        XCTAssertEqual(discoveredAugustus, true)
    }

    func testDiscoverTwice() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)

        self.objectToTest = TileDiscovered()
        self.objectToTest?.discover(by: playerAlexander)
        self.objectToTest?.discover(by: playerAlexander)

        // WHEN
        let discoveredAlexander = self.objectToTest?.isDiscovered(by: playerAlexander)

        // THEN
        XCTAssertEqual(discoveredAlexander, true)
    }
}
