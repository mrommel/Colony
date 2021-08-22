//
//  HierarchicalState.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class HierarchicalState {

    let identifier: String
    var transitions: [HierarchicalStateTransition]?

    init(identifier: String) {

        self.identifier = identifier
        self.transitions = nil
    }

    init(identifier: String, transitions: [HierarchicalStateTransition]?) {

        self.identifier = identifier
        self.transitions = transitions
    }

    func add(transition: HierarchicalStateTransition) {

        if self.transitions == nil {
            self.transitions = []
        }

        self.transitions?.append(transition)
    }

    func getTransitions() -> [HierarchicalStateTransition]? {

        return self.transitions
    }

    func began() {

    }

    func ended() {

    }
}

extension HierarchicalState: Equatable {

    static func == (lhs: HierarchicalState, rhs: HierarchicalState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
