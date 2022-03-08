//
//  HierarchicalStateTransition.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 21.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

typealias HierarchicalStateTrigger = () -> Bool
// typealias HierarchicalStateAction = () -> Void

class HierarchicalStateTransition {

    var trigger: HierarchicalStateTrigger?
    var state: HierarchicalState

    init(state: HierarchicalState, trigger: HierarchicalStateTrigger?) {
        self.state = state
        self.trigger = trigger
    }

    func isTriggered() -> Bool {

        if let trigger = self.trigger {
            return trigger()
        }

        return false
    }
}
