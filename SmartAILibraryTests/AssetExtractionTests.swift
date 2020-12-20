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

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

class AssetExtractionTests: XCTestCase {

    func testLoadImageArbalest() {

        #if os(iOS)
        let bundle = Bundle(for: type(of: self))
        if let image = UIImage(named: "arbalest", in: bundle, with: nil) {
            XCTAssertEqual(image.size.width, 782)
            XCTAssertEqual(image.size.height, 782)
        } else {
            XCTFail()
        }
        #elseif os(OSX)
        let bundle = Bundle.init(for: type(of: self))
        if let image = bundle.image(forResource: "arbalest") {
            XCTAssertEqual(image.size.width, 782)
            XCTAssertEqual(image.size.height, 782)
        } else {
            XCTFail()
        }
        #endif
            
    }
    
    func testLoadAtlasArbalest() throws {
    
        let bundle = Bundle(for: type(of: self))
        let atlas = TextureAtlasLoader.load(named: "arbalest", in: bundle)
        
        XCTAssertEqual(atlas?.unit.id, "arbalest")
    }
}
