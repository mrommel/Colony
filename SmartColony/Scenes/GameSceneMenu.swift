//
//  GameSceneMenu.swift
//  SmartColony
//
//  Created by Michael Rommel on 27.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

extension GameScene {
    
    func handleGameQuickSave() {
        
        GameStorage.store(game: self.viewModel?.game, named: "current.game")
    }
    
    func handleGameSave() {
    
        // ask file name to save
        let gameNameDialog = GameNameDialog()
        gameNameDialog.zPosition = 250

        gameNameDialog.addOkayAction(handler: {

            if gameNameDialog.isValid() {
                
                /*let location = selectedUnit.location
                selectedUnit.doFound(with: cityNameDialog.getCityName(), in: self.viewModel?.game)
                self.unselect()
                cityNameDialog.close()
                self.restoreFromCityScreen()

                if let city = self.viewModel?.game?.city(at: location) {
                    self.showScreen(screenType: .city, city: city)
                }*/
            }
        })

        gameNameDialog.addCancelAction(handler: {
            gameNameDialog.close()
        })

        self.cameraNode.add(dialog: gameNameDialog)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let gameName = dateFormatter.string(from: Date())
        gameNameDialog.set(textFieldInput: gameName)
    }
    
    func handleGameLoad() {
    
        // select file from list
    }
    
    func handleGameRetire() {
        
        print("Retire")
    }
    
    func handleGameRestart() {
        
        print("Restart")
    }
    
    func handleGameExit() {
        
        print("Exit")
    }
}
