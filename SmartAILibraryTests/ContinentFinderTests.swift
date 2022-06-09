//
//  ContinentFinderTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 09.06.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class ContinentFinderTests: XCTestCase {

    func testWrappedContinentIsJoined() throws {

        // GIVEN
        let mapModel = MapUtils.mapFilled(with: .ocean, sized: .custom(width: 20, height: 20), seed: 42)

        MapUtils.add(area: HexArea(center: HexPoint(x: 3, y: 5), radius: 5), with: .grass, to: mapModel)
        MapUtils.add(area: HexArea(center: HexPoint(x: 18, y: 5), radius: 5), with: .grass, to: mapModel)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: .alexander,
            aiLeaders: [.trajan],
            handicap: .chieftain
        )

        let mapGenerator = MapGenerator(with: mapOptions)

        // WHEN
        mapGenerator.identifyContinents(on: mapModel)

        // THEN
        XCTAssertEqual(mapModel.tile(at: HexPoint(x: 3, y: 5))?.continentIdentifier(), "0")
        XCTAssertEqual(mapModel.tile(at: HexPoint(x: 18, y: 5))?.continentIdentifier(), "0")
    }
}
