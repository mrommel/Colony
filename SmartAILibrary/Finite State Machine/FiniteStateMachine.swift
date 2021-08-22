//
//  FiniteStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

open class FiniteStateMachine<E: RawRepresentable> where E.RawValue: Equatable {

    public var current: FiniteState<E>

    public var currentIdentifier: E {
        return self.current.identifier
    }

    public init(initialState: FiniteState<E>) {

        self.current = initialState
        self.current.began()
    }

    public func update() {

        var triggeredTransition: FiniteStateTransition<E>?

        if let currentTransitions = self.current.getTransitions() {
            for transition in currentTransitions {
                if transition.isTriggered() {
                    triggeredTransition = transition
                }
            }
        }

        if let transition = triggeredTransition {

            self.current.ended()
            self.current = transition.state
            self.current.began()
        }
    }
}
