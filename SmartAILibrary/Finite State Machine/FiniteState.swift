//
//  FiniteState.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class FiniteState<E: RawRepresentable> where E.RawValue: Equatable {

    public let identifier: E
    var transitions: [FiniteStateTransition<E>]?
    var action: (() -> Void)?

    public init(identifier: E, action: (() -> Void)? = nil, transitions: [FiniteStateTransition<E>]? = nil) {

        self.identifier = identifier
        self.action = action
        self.transitions = transitions ?? []
    }

    public func add(transition: FiniteStateTransition<E>) {

        self.transitions?.append(transition)
    }

    public func getTransitions() -> [FiniteStateTransition<E>]? {

        return self.transitions
    }

    public func began() {

        self.action?()
    }

    public func ended() {

    }
}

extension FiniteState: Equatable {

    public static func == (lhs: FiniteState, rhs: FiniteState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
