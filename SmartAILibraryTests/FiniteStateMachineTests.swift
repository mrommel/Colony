//
//  FiniteStateMachineTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 20.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAILibrary

enum TestState: Int, Equatable {

    case stateA = 0
    case stateB = 1

    static func == (lhs: TestState, rhs: TestState) -> Bool {

        return lhs.rawValue == rhs.rawValue
    }
}

class FiniteStateMachineTests: XCTestCase {

    var objectToTest: FiniteStateMachine<TestState>?

    override func setUp() {
    }

    override func tearDown() {

        self.objectToTest = nil
    }

    func testInitialState() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.stateA, transitions: [])
        self.objectToTest = FiniteStateMachine(initialState: stateA)

        // WHEN
        self.objectToTest?.update() // NOOP

        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, TestState.stateA)
    }

    func testAlwaysTransitions() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.stateA)
        let stateB = FiniteState(identifier: TestState.stateB)

        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return true }))

        self.objectToTest = FiniteStateMachine(initialState: stateA)

        // WHEN
        self.objectToTest?.update()

        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, TestState.stateB)
    }

    func testNeverTransitions() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.stateA)
        let stateB = FiniteState(identifier: TestState.stateB)

        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return false }))

        self.objectToTest = FiniteStateMachine(initialState: stateA)

        // WHEN
        self.objectToTest?.update()

        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, TestState.stateA)
    }

    func testLoopedTransitions() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.stateA)
        let stateB = FiniteState(identifier: TestState.stateB)

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
        XCTAssertEqual(checkStateIdentifier1, TestState.stateB)
        XCTAssertEqual(checkStateIdentifier2, TestState.stateA)
        XCTAssertEqual(checkStateIdentifier3, TestState.stateB)
    }

    func testTimedTransitions() {

        // GIVEN
        var triggerVal = false
        let stateA = FiniteState(identifier: TestState.stateA)
        let stateB = FiniteState(identifier: TestState.stateB)

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
        XCTAssertEqual(checkStateIdentifier1, TestState.stateA)
        XCTAssertEqual(checkStateIdentifier2, TestState.stateA)
        XCTAssertEqual(checkStateIdentifier3, TestState.stateB)
    }

    func testUnitStates() {

        // GIVEN
        let hasMovingOrder = false
        let hasMovementLeft = true
        let stateIdle = FiniteState(identifier: TestState.stateA)
        let stateMoving = FiniteState(identifier: TestState.stateB)
        // let stateMoving = FiniteState(identifier: "Moving")

        stateIdle.add(transition: FiniteStateTransition(state: stateMoving, trigger: { return hasMovingOrder && hasMovementLeft }))

        self.objectToTest = FiniteStateMachine(initialState: stateIdle)
    }
}
