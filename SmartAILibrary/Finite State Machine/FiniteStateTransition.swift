//
//  FiniteStateTransition.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public typealias FiniteStateTrigger = () -> Bool
//typealias FiniteStateAction = () -> Void

public class FiniteStateTransition<E: RawRepresentable> where E.RawValue: Equatable {

    var trigger: FiniteStateTrigger?
    var state: FiniteState<E>

    public init(state: FiniteState<E>, trigger: FiniteStateTrigger?) {
        self.state = state
        self.trigger = trigger
    }

    public func isTriggered() -> Bool {

        if let trigger = self.trigger {
            return trigger()
        }

        return false
    }
}
