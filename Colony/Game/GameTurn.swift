//
//  GameTurn.swift
//  Colony
//
//  Created by Michael Rommel on 26.11.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameTurnUIDelegate {
    
    func showTurnDialog()
    func hideTurnDialog()
    
    func setCurrentPlayer(civilization: Civilization)
}

protocol GameTurnMechanicsDelegate {
    
    func notifyPlayer(with civilization: Civilization)
}

class GameTurn {
    
    var currentTurn: Int = 0
    var currentCivilization: Civilization
    
    var turnUIDelegate: GameTurnUIDelegate?
    var turnMechanicsDelegate: GameTurnMechanicsDelegate?
    
    // private
    private var turnOrder: [Civilization] = []
    private let userUsecase: UserUsecase?
    
    init(currentTurn: Int) {
        
        self.currentTurn = currentTurn

        self.userUsecase = UserUsecase()
        guard let userCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("can't get user civilization")
        }
        
        self.currentCivilization = userCivilization  // we start with the user
        
        self.turnOrder.append(userCivilization)
        
        for civ in Civilization.all {
            if civ != userCivilization {
                self.turnOrder.append(civ)
            }
        }
    }
    
    // user does his moves first - ai last
    func doTurn() {
        
        // finish last turn
        self.endTurn()

        // get next civ
        guard let currentCivIndex = self.turnOrder.firstIndex(where: { $0 == self.currentCivilization }) else {
            fatalError("can't get current civ index")
        }
        
        if currentCivIndex + 1 < self.turnOrder.count {
            self.currentCivilization = self.turnOrder[currentCivIndex + 1]
        } else {
            self.currentTurn = self.currentTurn + 1
            self.currentCivilization = self.turnOrder.first!
        }
        
        self.startTurn()
    }
    
    func startTurn() {
        
        // inform UI to hide the turn dialog
        if self.isUserPlayer() {
            self.turnUIDelegate?.hideTurnDialog()
        }
        
        // update the lock UI
        if self.isAIPlayer() {
            self.turnUIDelegate?.setCurrentPlayer(civilization: self.currentCivilization)
        }
        
        // inform player that he is on duty
        self.turnMechanicsDelegate?.notifyPlayer(with: self.currentCivilization)
        
    }
    
    func endTurn() {
        
        // inform UI to show the turn dialog
        if self.isUserPlayer() {
            self.turnUIDelegate?.showTurnDialog()
        }
    }
    
    func isUserPlayer() -> Bool {
        
        guard let userCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("can't get user civilization")
        }
        
        return self.currentCivilization == userCivilization
    }
    
    func isFirstAIPlayer() -> Bool {
        
        return self.currentCivilization == self.turnOrder[1]
    }
    
    func isAIPlayer() -> Bool {
        
        guard let userCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("can't get user civilization")
        }
        
        return self.currentCivilization != userCivilization
    }
}
