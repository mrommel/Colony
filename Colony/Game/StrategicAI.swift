//
//  StrategicAI.swift
//  Colony
//
//  Created by Michael Rommel on 09.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol StrategicAIProtocol {

    func update(for game: Game?)
}

class StrategicAI {
    
    // MARK: properties
    
    private let player: Player?
    private var game: Game? = nil
    private var stateMachine: StrategicStateMachine? = nil
    
    // MARK: constructors

    init(player: Player?) {
        
        self.player = player
        
        self.stateMachine = StrategicStateMachine(ai: self)
        self.stateMachine?.push(state: .waitingForOrders)
    }
    
    // MARK: handlers
    
    func doWaitOrders() {
        
    }
    
    // MARK: private methods
    
    //private func 
}

extension StrategicAI: StrategicAIProtocol {
    
    func update(for game: Game?) {
        
        self.game = game
    }
}
