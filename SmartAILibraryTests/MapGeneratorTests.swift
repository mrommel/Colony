//
//  MapGeneratorTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 31.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class MapGeneratorTests: XCTestCase {

    func testBasic() {
        
        // GIVEN
        let options = MapOptions(withSize: .custom(width: 20, height: 20))
        let mapGenerator = MapGenerator(with: options)
        mapGenerator.progressHandler = { progress, text in
            print("progress: \(progress) - \(text)")
        }
        
        // WHEN
        let map = mapGenerator.generate()
        
        // THEN
        XCTAssertEqual(map!.size.width(), 20)
        XCTAssertEqual(map!.size.height(), 20)
    }
}
