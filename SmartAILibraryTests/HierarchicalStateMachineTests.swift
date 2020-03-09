//
//  HierarchicalStateMachineTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class HierarchicalStateMachineTests: XCTestCase {

    var objectToTest: HierarchicalStateMachine?
    
    override func setUp() {
    }

    override func tearDown() {
        
        self.objectToTest = nil
    }

    func testInitialState() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A", transitions: [])
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // NOOP
        
        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, "A")
    }
    
    func testAlwaysTransitions() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        let stateB = HierarchicalState(identifier: "B")
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update()
        
        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, "B")
    }
    
    func testNeverTransitions() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        let stateB = HierarchicalState(identifier: "B")
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return false }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update()
        
        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, "A")
    }
    
    func testBasicHierarchy() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        
        let subB1 = HierarchicalState(identifier: "B1")
        let subB2 = HierarchicalState(identifier: "B2")
        subB1.add(transition: HierarchicalStateTransition(state: subB2, trigger: { return true }))
        
        let stateB = HierarchicalStateMachine(initialState: subB1)
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // A -> B (==B1)
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B1 -> B2
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "B1")
        XCTAssertEqual(checkStateIdentifier2, "B2")
    }
    
    func testBasicHierarchyJumpBack() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        
        let subB1 = HierarchicalState(identifier: "B1")
        let subB2 = HierarchicalState(identifier: "B2")
        subB1.add(transition: HierarchicalStateTransition(state: subB2, trigger: { return true }))
        subB2.add(transition: HierarchicalStateTransition(state: stateA, trigger: { return true })) // <-- jump back
        
        let stateB = HierarchicalStateMachine(initialState: subB1)
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // A -> B (==B1)
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B1 -> B2
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B2 -> A  jump back
        let checkStateIdentifier3 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "B1")
        XCTAssertEqual(checkStateIdentifier2, "B2")
        XCTAssertEqual(checkStateIdentifier3, "A")
    }
    
    // A -> B1 -> B2 -> B1 -> A
    func testBasicHierarchyLoopJumpBack() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        
        let subB1 = HierarchicalState(identifier: "B1")
        let subB2 = HierarchicalState(identifier: "B2")
        subB1.add(transition: HierarchicalStateTransition(state: subB2, trigger: { return true }))
        subB2.add(transition: HierarchicalStateTransition(state: subB1, trigger: { return true }))
        
        let stateB = HierarchicalStateMachine(initialState: subB1, identifier: "B")
        var exitTriggerValue = false
        stateB.set(exitTrigger: { return exitTriggerValue })
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // A -> B (==B1)
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B1 -> B2
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B2 -> B1
        let checkStateIdentifier3 = self.objectToTest!.currentIdentifier
        exitTriggerValue = true
        self.objectToTest?.update() // B1 -> A
        let checkStateIdentifier4 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "B1")
        XCTAssertEqual(checkStateIdentifier2, "B2")
        XCTAssertEqual(checkStateIdentifier3, "B1")
        XCTAssertEqual(checkStateIdentifier4, "A")
    }
    
    func test3LevelHierarchy() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        
        let subC1 = HierarchicalState(identifier: "C1")
        let subC2 = HierarchicalState(identifier: "C2")
        subC1.add(transition: HierarchicalStateTransition(state: subC2, trigger: { return true }))
        
        let stateC = HierarchicalStateMachine(initialState: subC1)
        
        let subB1 = HierarchicalState(identifier: "B1")
        let subB2 = HierarchicalState(identifier: "B2")
        subB1.add(transition: HierarchicalStateTransition(state: subB2, trigger: { return true }))
        subB2.add(transition: HierarchicalStateTransition(state: stateC, trigger: { return true }))
        
        let stateB = HierarchicalStateMachine(initialState: subB1)
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // A -> B (==B1)
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B1 -> B2
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B2 -> C (==C1)
        let checkStateIdentifier3 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // C1 -> C2
        let checkStateIdentifier4 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "B1")
        XCTAssertEqual(checkStateIdentifier2, "B2")
        XCTAssertEqual(checkStateIdentifier3, "C1")
        XCTAssertEqual(checkStateIdentifier4, "C2")
    }
    
    func test3LevelHierarchyJumpBack() {
        
        // GIVEN
        let stateA = HierarchicalState(identifier: "A")
        
        let subC1 = HierarchicalState(identifier: "C1")
        let subC2 = HierarchicalState(identifier: "C2")
        subC1.add(transition: HierarchicalStateTransition(state: subC2, trigger: { return true }))
        subC2.add(transition: HierarchicalStateTransition(state: stateA, trigger: { return true })) // <-- jump back
        
        let stateC = HierarchicalStateMachine(initialState: subC1)
        
        let subB1 = HierarchicalState(identifier: "B1")
        let subB2 = HierarchicalState(identifier: "B2")
        subB1.add(transition: HierarchicalStateTransition(state: subB2, trigger: { return true }))
        subB2.add(transition: HierarchicalStateTransition(state: stateC, trigger: { return true }))
        
        let stateB = HierarchicalStateMachine(initialState: subB1)
        
        stateA.add(transition: HierarchicalStateTransition(state: stateB, trigger: { return true }))
        
        self.objectToTest = HierarchicalStateMachine(initialState: stateA)
        
        // WHEN
        self.objectToTest?.update() // A -> B (==B1)
        let checkStateIdentifier1 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B1 -> B2
        let checkStateIdentifier2 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // B2 -> C (==C1)
        let checkStateIdentifier3 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // C1 -> C2
        let checkStateIdentifier4 = self.objectToTest!.currentIdentifier
        self.objectToTest?.update() // C2 -> A jump back
        let checkStateIdentifier5 = self.objectToTest!.currentIdentifier
        
        // THEN
        XCTAssertEqual(checkStateIdentifier1, "B1")
        XCTAssertEqual(checkStateIdentifier2, "B2")
        XCTAssertEqual(checkStateIdentifier3, "C1")
        XCTAssertEqual(checkStateIdentifier4, "C2")
        XCTAssertEqual(checkStateIdentifier5, "A")
    }
}
