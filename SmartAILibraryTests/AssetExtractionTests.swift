//
//  AssetExtractionTests.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
import XMLParsing
@testable import SmartAILibrary

class AssetExtractionTests: XCTestCase {

    func testLoadImageArbalest() {
        
        let bundle = Bundle(for: type(of: self))

        if let image = UIImage(named: "arbalest", in: bundle, with: nil) {
            XCTAssertEqual(image.size.width, 782)
            XCTAssertEqual(image.size.height, 782)
        } else {
            XCTFail()
        }
    }
    
    func testLoadAtlasArbalest() throws {
    
        let bundle = Bundle(for: type(of: self))
        let atlas = TextureAtlasLoader.load(named: "arbalest", in: bundle)
        
        XCTAssertEqual(atlas?.unit.id, "arbalest")
    }
}
