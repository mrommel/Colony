//
//  HexPointTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 24.04.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class HexPointTests: XCTestCase {

    func testNormalDistance() throws {

        // GIVEN
        let point0 = HexPoint(x: 4, y: 5)
        let point1 = HexPoint(x: 13, y: 23)

        // WHEN
        let distance = point0.distance(to: point1)

        // THEN
        XCTAssertEqual(distance, 18)
    }

    func testWrappedNormalDistance() throws {

        // GIVEN
        let point0 = HexPoint(x: 2, y: 5)
        let point1 = HexPoint(x: 19, y: 5)

        // WHEN
        let distance = point0.distance(to: point1, wrapX: 20)

        // THEN
        XCTAssertEqual(distance, 3)
    }
}
