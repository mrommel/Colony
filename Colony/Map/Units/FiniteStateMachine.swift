//
//  FiniteStateMachine.swift
//  Colony
//
//  Created by Michael Rommel on 06.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
 
class FiniteStateMachine<Element: Equatable> {
    
    private var states: Stack<Element>
    private var args: Stack<Any?>
    
    init() {
        self.states = Stack<Element>()
        self.args = Stack<Any?>()
    }
    
    func peek() -> (Element, Any?)? {
        
        if self.states.isEmpty {
            return nil
        }
        
        return (self.states.peek()!, self.args.peek()!)
    }
    
    func push(state: Element, arg: Any? = nil) {

        if self.states.isEmpty || self.states.peek() != state {
            self.states.push(state)
            self.args.push(arg)
        }
    }

    func popState() {
        self.states.pop()
        self.args.pop()
    }

    func popAll() {

        self.states.clear()
        self.args.clear()
    }
    
    var isEmpty: Bool {
        
        return self.states.isEmpty
    }

    func update() {
    }
}
