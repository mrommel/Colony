//
//  GovernmentTypeTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GovernmentTypeTests: XCTestCase {

    var objectToTest: AbstractGovernment?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testInitial() {
        
        // GIVEN
        self.objectToTest = Government()
        
        // WHEN
        let initialGovernment = self.objectToTest?.currentGovernment()
        
        // THEN
        XCTAssertNil(initialGovernment)
    }
    
    func testCurrentGovernment() {
        
        // GIVEN
        self.objectToTest = Government()
        self.objectToTest?.set(governmentType: .chiefdom)
        
        // WHEN
        let chiefdomGovernment = self.objectToTest?.currentGovernment()
        
        // THEN
        XCTAssertEqual(chiefdomGovernment, .chiefdom)
    }
}
