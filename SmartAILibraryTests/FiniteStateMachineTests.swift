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

    case A = 0
    case B = 1

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
        let stateA = FiniteState(identifier: TestState.A, transitions: [])
        self.objectToTest = FiniteStateMachine(initialState: stateA)

        // WHEN
        self.objectToTest?.update() // NOOP

        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, TestState.A)
    }

    func testAlwaysTransitions() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.A)
        let stateB = FiniteState(identifier: TestState.B)

        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return true }))

        self.objectToTest = FiniteStateMachine(initialState: stateA)

        // WHEN
        self.objectToTest?.update()

        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, TestState.B)
    }

    func testNeverTransitions() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.A)
        let stateB = FiniteState(identifier: TestState.B)

        stateA.add(transition: FiniteStateTransition(state: stateB, trigger: { return false }))

        self.objectToTest = FiniteStateMachine(initialState: stateA)

        // WHEN
        self.objectToTest?.update()

        // THEN
        XCTAssertEqual(self.objectToTest!.currentIdentifier, TestState.A)
    }

    func testLoopedTransitions() {

        // GIVEN
        let stateA = FiniteState(identifier: TestState.A)
        let stateB = FiniteState(identifier: TestState.B)

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
        XCTAssertEqual(checkStateIdentifier1, TestState.B)
        XCTAssertEqual(checkStateIdentifier2, TestState.A)
        XCTAssertEqual(checkStateIdentifier3, TestState.B)
    }

    func testTimedTransitions() {

        // GIVEN
        var triggerVal = false
        let stateA = FiniteState(identifier: TestState.A)
        let stateB = FiniteState(identifier: TestState.B)

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
        XCTAssertEqual(checkStateIdentifier1, TestState.A)
        XCTAssertEqual(checkStateIdentifier2, TestState.A)
        XCTAssertEqual(checkStateIdentifier3, TestState.B)
    }

    func testUnitStates() {

        // GIVEN
        var hasMovingOrder = false
        var hasMovementLeft = true
        let stateIdle = FiniteState(identifier: TestState.A)
        let stateMoving = FiniteState(identifier: TestState.B)
        //let stateMoving = FiniteState(identifier: "Moving")

        stateIdle.add(transition: FiniteStateTransition(state: stateMoving, trigger: { return hasMovingOrder && hasMovementLeft }))

        self.objectToTest = FiniteStateMachine(initialState: stateIdle)
    }
}
