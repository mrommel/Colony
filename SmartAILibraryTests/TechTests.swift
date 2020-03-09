//
//  TechTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class TechTests: XCTestCase {

    var objectToTest: AbstractTechs?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testPossibleTechs() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let possibleTechs = self.objectToTest?.possibleTechs()

        // THEN
        XCTAssertFalse(possibleTechs!.contains(.animalHusbandry))
        XCTAssertFalse(possibleTechs!.contains(.pottery))
        XCTAssertTrue(possibleTechs!.contains(.mining))
        XCTAssertTrue(possibleTechs!.contains(.sailing))
        XCTAssertTrue(possibleTechs!.contains(.astrology))
        XCTAssertTrue(possibleTechs!.contains(.irrigation))
        XCTAssertTrue(possibleTechs!.contains(.writing))
        XCTAssertTrue(possibleTechs!.contains(.archery))
        XCTAssertTrue(possibleTechs!.contains(.horsebackRiding))
    }

    func testChooseNextTechAlexander() {

        // GIVEN
        let playerAlexander = Player(leader: .alexander)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()
        
        // THEN
        //print("nextTech: \(nextTech)")
        XCTAssertTrue([.mining, .writing, .sailing].contains(nextTech))
    }
    
    func testChooseNextTechAugustusInitial() {

        // GIVEN
        let playerAlexander = Player(leader: .augustus)
        self.objectToTest = Techs(player: playerAlexander)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()
        
        // THEN
        XCTAssertTrue([.mining, .pottery, .animalHusbandry].contains(nextTech))
    }
    
    func testChooseNextTechAugustusLater() {

        // GIVEN
        let playerAlexander = Player(leader: .augustus)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()
        
        // THEN
        //print("nextTech: \(nextTech)")
        XCTAssertTrue([.mining, .sailing, .writing].contains(nextTech))
    }
    
    func testChooseNextTechElizabeth() {

        // GIVEN
        let playerAlexander = Player(leader: .elizabeth)
        self.objectToTest = Techs(player: playerAlexander)
        try! self.objectToTest?.discover(tech: .pottery)
        try! self.objectToTest?.discover(tech: .animalHusbandry)

        // WHEN
        let nextTech = self.objectToTest?.chooseNextTech()
        
        // THEN
        //print("nextTech: \(nextTech)")
        XCTAssertTrue([.mining, .writing, .sailing].contains(nextTech))
    }
}
