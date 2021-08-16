//
//  PolicyCardsTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class PolicyCardsTests: XCTestCase {

    var objectToTest: AbstractPolicyCardSet?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testIsValidEmpty() {

        // GIVEN
        self.objectToTest = PolicyCardSet()
        let slots = PolicyCardSlots(military: 2, economic: 1, diplomatic: 0, wildcard: 0)

        // WHEN
        let isValid = self.objectToTest!.valid(in: slots)

        // THEN
        XCTAssertTrue(isValid)
    }

    func testIsValidFilled() {

        // GIVEN
        self.objectToTest = PolicyCardSet()
        self.objectToTest?.add(card: .survey) // mil
        self.objectToTest?.add(card: .godKing) // eco
        self.objectToTest?.add(card: .discipline) // mil
        let slots = PolicyCardSlots(military: 2, economic: 1, diplomatic: 0, wildcard: 0)

        // WHEN
        let isValid = self.objectToTest!.valid(in: slots)

        // THEN
        XCTAssertTrue(isValid)
    }

    func testIsInvalidFilled() {

        // GIVEN
        self.objectToTest = PolicyCardSet()
        self.objectToTest?.add(card: .survey) // mil
        self.objectToTest?.add(card: .godKing) // eco
        self.objectToTest?.add(card: .discipline) // mil
        let slots = PolicyCardSlots(military: 1, economic: 2, diplomatic: 0, wildcard: 0)

        // WHEN
        let isValid = self.objectToTest!.valid(in: slots)

        // THEN
        XCTAssertFalse(isValid)
    }

    func testIsValidFilledWithWildcard() {

        // GIVEN
        self.objectToTest = PolicyCardSet()
        self.objectToTest?.add(card: .survey) // mil
        self.objectToTest?.add(card: .godKing) // eco
        self.objectToTest?.add(card: .discipline) // mil
        let slots = PolicyCardSlots(military: 1, economic: 1, diplomatic: 0, wildcard: 1)

        // WHEN
        let isValid = self.objectToTest!.valid(in: slots)

        // THEN
        XCTAssertTrue(isValid)
    }

    func testIsInvalidFilledWithWildcard() {

        // GIVEN
        self.objectToTest = PolicyCardSet()
        self.objectToTest?.add(card: .godKing) // eco
        self.objectToTest?.add(card: .urbanPlanning) // eco
        self.objectToTest?.add(card: .ilkum) // eco
        let slots = PolicyCardSlots(military: 1, economic: 1, diplomatic: 0, wildcard: 1)

        // WHEN
        let isValid = self.objectToTest!.valid(in: slots)

        // THEN
        XCTAssertFalse(isValid)
    }
}
