//
//  StrategicAI.swift
//  Colony
//
//  Created by Michael Rommel on 09.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// FIXME move to seperate classes

/*protocol StrategicMission {
    
    func predict() -> Double
}

class StrategicMissionRun: StrategicMission {
    
    let player: Player?
    let game: Game?
    
    init(for player: Player?, in game: Game?) {
        
        self.player = player
        self.game = game
    }
    
    func predict() -> Double {
        
        guard let civilization = self.player?.leader.civilization else {
            fatalError("can't get civilization")
        }
        
        guard let rating = game?.gameRating else {
            fatalError("can't get rating function")
        }
        
        
        
        //game?.gameRating?.value(for: civilization)
        return 0
    }
}*/


protocol StrategicAIProtocol {

    func update(for game: Game?)
}

class StrategicAI {
    
    // MARK: properties
    
    private let player: Player?
    private var game: Game? = nil
    private var stateMachine: StrategicStateMachine? = nil
    
    //private var strategyMap: [StrategicAIState: StrategicMission] = [:]
    
    // MARK: constructors

    init(player: Player?) {
        
        self.player = player
        
        self.stateMachine = StrategicStateMachine(ai: self)
        self.stateMachine?.push(state: .waitingForOrders)
    }
    
    func setup(in game: Game?) {
        
        //self.strategyMap[.run] = StrategicMissionRun(for: self.player, in: game)
    }
    
    // MARK: handlers
    
    func doWaitOrders() {
        
        if let playerName = player?.leader.name {
            logAI("[Player: \(playerName)]: wait for orders")
        }
        
        self.findStrategy()
    }
    
    // MARK: private methods
    
    private func findStrategy() {
        
        /*var bestValue = -Double.greatestFiniteMagnitude
        var bestState: StrategicAIState = .waitingForOrders
        
        for (state, strategy) in self.strategyMap {
            
            let prediction = strategy.predict(in: self.game)
            
            if prediction > bestValue {
            
                bestValue = prediction
                bestState = state
            }
        }
        
        self.stateMachine?.push(state: bestState)*/
    }
}

extension StrategicAI: StrategicAIProtocol {
    
    func update(for game: Game?) {
        
        self.game = game
        
        self.stateMachine?.update()
    }
}
