//
//  MapLoadingTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 02.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class MapLoadingTests: XCTestCase {

    func testLoadMap() throws {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "Earth_Duel", ofType: "Civ5Map")
        let url = URL(fileURLWithPath: path!)

        let civ5mapLoader = Civ5MapReader()
        let map = mapLoader.load(from: url)
        
        XCTAssertNotNil(map)
    }
}
