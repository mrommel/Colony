//
//  FiniteState.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class FiniteState {
    
    let identifier: String
    var transitions: [FiniteStateTransition]?
    
    init(identifier: String) {
        
        self.identifier = identifier
        self.transitions = []
    }
    
    init(identifier: String, transitions: [FiniteStateTransition]?) {
        
        self.identifier = identifier
        self.transitions = transitions
    }
    
    func add(transition: FiniteStateTransition) {
        
        self.transitions?.append(transition)
    }
    
    func getTransitions() -> [FiniteStateTransition]? {
        
        return self.transitions
    }
    
    func began() {
        
    }
    
    func ended() {
        
    }
}

extension FiniteState: Equatable {
    
    static func == (lhs: FiniteState, rhs: FiniteState) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
