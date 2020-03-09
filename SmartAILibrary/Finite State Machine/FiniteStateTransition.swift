//
//  FiniteStateTransition.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

typealias FiniteStateTrigger = () -> Bool
//typealias FiniteStateAction = () -> Void

class FiniteStateTransition {
    
    var trigger: FiniteStateTrigger?
    var state: FiniteState
    
    init(state: FiniteState, trigger: FiniteStateTrigger?) {
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
