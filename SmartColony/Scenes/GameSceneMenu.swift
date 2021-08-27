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

        GameStorage.storeCurrent(game: self.viewModel?.game)
    }

    func handleGameSave() {

        // ask file name to save
        let gameNameDialog = GameNameDialog()
        gameNameDialog.zPosition = 250

        gameNameDialog.addOkayAction(handler: {

            if gameNameDialog.isValid() {

                let gameName = gameNameDialog.gameName()

                if GameStorage.store(game: self.viewModel?.game, named: gameName) {
                    gameNameDialog.close()
                } else {
                    print("could not save")
                }
            } else {
                print("name is not valid")
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

        // are you sure?
        let viewModel = ConfirmationDialogViewModel(question: "Do you really want to quit?")

        let confirmationDialog = ConfirmationDialog(with: viewModel)
        confirmationDialog.zPosition = 250

        confirmationDialog.addOkayAction(handler: {

            confirmationDialog.close()
            self.gameDelegate?.exitAndLoad()
        })

        confirmationDialog.addCancelAction(handler: {
            confirmationDialog.close()
        })

        self.cameraNode.add(dialog: confirmationDialog)
    }

    func handleGameRetire() {

        print("Retire")

        // are you sure?
    }

    func handleGameRestart() {

        print("Restart")

        // are you sure?
    }

    func handleGameExit() {

        // are you sure?
        let viewModel = ConfirmationDialogViewModel(question: "Do you really want to quit?")

        let confirmationDialog = ConfirmationDialog(with: viewModel)
        confirmationDialog.zPosition = 250

        confirmationDialog.addOkayAction(handler: {

            confirmationDialog.close()
            self.gameDelegate?.exit()
        })

        confirmationDialog.addCancelAction(handler: {
            confirmationDialog.close()
        })

        self.cameraNode.add(dialog: confirmationDialog)
    }
}
