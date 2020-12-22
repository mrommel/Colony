//
//  ResourcePlacingTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 21.12.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class ResourcePlacingTests: XCTestCase {
    
    private var grid: MapModel?
    
    override func setUp() {
        
        self.grid = MapModel(width: 3, height: 3)
    }
    
    func testPlacingFish() {

        // GIVEN
        let tile = Tile(point: HexPoint(x: 1, y: 1), terrain: TerrainType.shore, hills: false, feature: FeatureType.none)
        
        // WHEN
        let canPlace = tile.canHave(resource: .fish, ignoreLatitude: false, in: grid)
        
        // THEN
        XCTAssertTrue(canPlace)
    }
}
