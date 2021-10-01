//
//  RegionFinderTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 08.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class RegionFinderTests: XCTestCase {

    func testRegionSplit() {

        // GIVEN
        let mapModel = MapUtils.mapFilled(with: .grass, sized: .standard)

        let continentFinder = ContinentFinder(size: mapModel.size)
        mapModel.continents = continentFinder.execute(on: mapModel)

        let fertilityEvaluator = CitySiteEvaluator(map: mapModel)
        let finder: RegionFinder = RegionFinder(map: mapModel, evaluator: fertilityEvaluator, for: nil)

        // WHEN
        let regions = finder.divideInto(regions: 2)

        // THEN
        XCTAssertEqual(regions.count, 2)
        XCTAssertEqual(regions[0].points.count, 1612)
        XCTAssertEqual(regions[1].points.count, 1612)
    }
}
