//
//  FlavorsTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class FlavorsTests: XCTestCase {

    var objectToTest: Flavors?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testInitialValue() {

        // GIVEN
        self.objectToTest = Flavors()

        // WHEN
        let cultureValue = self.objectToTest?.value(of: .culture)

        // THEN
        XCTAssertEqual(cultureValue, 0)
    }

    func testAddValue() {

        // GIVEN
        self.objectToTest = Flavors()
        self.objectToTest! += Flavor(type: .culture, value: 5)

        // WHEN
        let cultureValue = self.objectToTest?.value(of: .culture)

        // THEN
        XCTAssertEqual(cultureValue, 5)
    }

    func testAddTwoValues() {

        // GIVEN
        self.objectToTest = Flavors()
        self.objectToTest! += Flavor(type: .culture, value: 5)
        self.objectToTest! += Flavor(type: .culture, value: 2)

        // WHEN
        let cultureValue = self.objectToTest?.value(of: .culture)

        // THEN
        XCTAssertEqual(cultureValue, 7)
    }

    func testAddValues() {

        // GIVEN
        self.objectToTest = Flavors()
        self.objectToTest! += Flavor(type: .culture, value: 5)
        self.objectToTest!.add(value: 3, for: .culture)

        // WHEN
        let cultureValue = self.objectToTest?.value(of: .culture)

        // THEN
        XCTAssertEqual(cultureValue, 8)
    }

    func testReset() {

        // GIVEN
        self.objectToTest = Flavors()
        self.objectToTest!.add(value: 3, for: .culture)
        self.objectToTest?.reset()
        self.objectToTest!.add(value: 2, for: .culture)

        // WHEN
        let cultureValue = self.objectToTest?.value(of: .culture)

        // THEN
        XCTAssertEqual(cultureValue, 2)
    }
}
