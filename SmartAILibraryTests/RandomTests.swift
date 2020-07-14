//
//  RandomTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 14.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class RandomTests: XCTestCase {

    func testRandomNumbers() {
        
        for _ in 0..<10 {
            //print("\(Double.random)")
            print("\(Int.random(in: 0 ... 10))")
        }
    }
}

