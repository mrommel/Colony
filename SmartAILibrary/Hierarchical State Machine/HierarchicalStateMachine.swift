//
//  HierarchicalStateMachine.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

typealias HierarchicalStateExitTrigger = () -> Bool

class HierarchicalStateMachine: HierarchicalState {

    // MARK: variables

    let initial: HierarchicalState
    var current: HierarchicalState?
    var previousState: HierarchicalState?
    var exitTrigger: HierarchicalStateExitTrigger?

    // MARK: properties

    var currentIdentifier: String {

        if let hierarchyState = self.current as? HierarchicalStateMachine {

            return hierarchyState.currentIdentifier
        }

        if let currentState = self.current {
            return currentState.identifier
        }

        fatalError("can't happen")
    }

    // MARK: constructors

    init(initialState: HierarchicalState, identifier: String = "root") {

        self.initial = initialState
        self.current = initialState

        super.init(identifier: identifier)
    }

    // MARK: public methods

    func update() {

        var triggeredTransition: HierarchicalStateTransition?

        if let hierarchyState = self.current as? HierarchicalStateMachine {

            hierarchyState.update()
            if hierarchyState.hasExited() {
                self.current = hierarchyState.previousState!
            }
            return

        } else {
            if let currentTransitions = self.current?.getTransitions() {

                // handle hierarchy transitions
                for transition in currentTransitions {
                    if transition.isTriggered() {
                        triggeredTransition = transition
                    }
                }
            }
        }

        if let transition = triggeredTransition {

            // if new state is a hierarchical state machine itself ...
            if let hierarchyState = transition.state as? HierarchicalStateMachine {

                // ... store current state (to be able to restore on exit)
                hierarchyState.previousState = self.current
                //print("\(hierarchyState.identifier) store state: \(self.current!.identifier)")
            }

            //print("\(self.current!.identifier) -> \(transition.state.identifier)")

            self.current?.ended()
            self.current = transition.state
            self.current?.began()
        }
    }

    override func began() {

        if self.current == nil {
            self.current = self.initial
        }
    }

    func set(exitTrigger: HierarchicalStateExitTrigger?) {

        self.exitTrigger = exitTrigger
    }

    // MARK: private methods

    private func hasExited() -> Bool {

        if let trigger = self.exitTrigger {
            return trigger()
        }

        return false
    }
}
