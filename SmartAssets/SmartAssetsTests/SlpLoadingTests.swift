//
//  SlpLoadingTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 23.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAssets

class SlpLoadingTests: XCTestCase {

    func testLoadMerchant() throws {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "merchant-idle", ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        guard let slpFile = SlpFileReader().load(from: url) else {
            XCTFail("Could not load file")
            return
        }

        XCTAssertEqual(slpFile.frames.count, 50)
    }
}
