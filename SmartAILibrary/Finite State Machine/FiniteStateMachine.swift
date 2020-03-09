//
//  FiniteStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class FiniteStateMachine {
    
    var current: FiniteState
    
    var currentIdentifier: String {
        return self.current.identifier
    }
    
    init(initialState: FiniteState) {
        
        self.current = initialState
        self.current.began()
    }

    func update() {
        
        var triggeredTransition: FiniteStateTransition? = nil
        
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
