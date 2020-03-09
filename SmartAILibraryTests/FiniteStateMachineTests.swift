//
//  FiniteStateMachineTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 20.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

class FiniteStateMachineTests: XCTestCase {

    var objectToTest: FiniteStateMachine?
    
    override func setUp() {
    }

    override func tearDown() {
        
        self.objectToTest = nil
    }

    func testInitialState() {
        
        // GIVEN
        let stateA = FiniteState(identifier: "A", transitions: [])
        self.objectToTest = FiniteStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // NOOP
        
        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, "A")
    }
    
    func testAlwaysTransitions() {
        
        // GIVEN
        let stateA = FiniteState(identifier: "A")
        let stateB = FiniteState(identifier: "B")
        
        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = FiniteStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update()
        
        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, "B")
    }
    
    func testNeverTransitions() {
        
        // GIVEN
        let stateA = FiniteState(identifier: "A")
        let stateB = FiniteState(identifier: "B")
        
        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return false }))
        
        self.objectToTest = FiniteStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update()
        
        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, "A")
    }
    
    func testLoopedTransitions() {
        
        // GIVEN
        let stateA = FiniteState(identifier: "A")
        let stateB = FiniteState(identifier: "B")
        
        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return true }))
        stateB.add(transition: FiniteStateTransition(state: stateA, trigger: { return true }))
        
        self.objectToTest = FiniteStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update()
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update()
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update()
        let checkStateIdentifier3 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "B")
        XCTAssertEqual(checkStateIdentifier2, "A")
        XCTAssertEqual(checkStateIdentifier3, "B")
    }
    
    func testTimedTransitions() {
        
        // GIVEN
        var triggerVal = false
        let stateA = FiniteState(identifier: "A")
        let stateB = FiniteState(identifier: "B")
        
        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return triggerVal }))
        
        self.objectToTest = FiniteStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update()
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update()
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        triggerVal = true
        self.objectToTest?.update()
        let checkStateIdentifier3 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "A")
        XCTAssertEqual(checkStateIdentifier2, "A")
        XCTAssertEqual(checkStateIdentifier3, "B")
    }
    
    func testUnitStates() {
        
        // GIVEN
        var hasMovingOrder = false
        var hasMovementLeft = true
        let stateIdle = FiniteState(identifier: "Idle")
        let stateMoving = FiniteState(identifier: "Moving")
        //let stateMoving = FiniteState(identifier: "Moving")
        
        stateIdle.add(transition: FiniteStateTransition(state: stateMoving, trigger: { return hasMovingOrder && hasMovementLeft }))
        
        self.objectToTest = FiniteStateMachine(initialState: stateIdle)
    }
}
