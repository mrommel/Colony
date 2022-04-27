//
//  GameMenuViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.02.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

protocol GameMenuViewModelDelegate: AnyObject {

    func backToGameClicked()
    func restartGameClicked()
    func quitToMainMenuClicked()
}

class GameMenuViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var confirmationDialogViewModel: ConfirmationDialogViewModel

    @Published
    var showConfirmationDialog: Bool = false

    weak var delegate: GameMenuViewModelDelegate?

    init() {

        self.confirmationDialogViewModel = ConfirmationDialogViewModel()
    }

    func clickBackToGame() {

        self.delegate?.backToGameClicked()
    }

    func clickRestartGame() {

        self.showConfirmationDialog = true

        self.confirmationDialogViewModel.update(
            title: "Restart Game",
            question: "Do you really want to restart? Everything will be lost.",
            confirm: "Restart",
            cancel: "Cancel",
            completion: { confirmed in

                self.showConfirmationDialog = false

                if confirmed {
                    self.delegate?.restartGameClicked()
                }
            }
        )
    }

    func clickToMainMenu() {

        self.showConfirmationDialog = true

        self.confirmationDialogViewModel.update(
            title: "Quit Game",
            question: "Do you really want to quit? Everything will be lost.",
            confirm: "Quit",
            cancel: "Cancel",
            completion: { confirmed in

                self.showConfirmationDialog = false

                if confirmed {
                    self.delegate?.quitToMainMenuClicked()
                }
            }
        )
    }

    func civilizationImage() -> NSImage {

        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSImage()
        }

        return ImageCache.shared.image(for: humanPlayer.leader.civilization().iconTexture())
    }

    func civilizationToolTip() -> String {

        guard let gameModel = self.gameEnvironment.game.value else {
            return ""
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            return ""
        }

        return humanPlayer.leader.civilization().name()
    }

    func leaderImage() -> NSImage {

        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            return NSImage()
        }

        return ImageCache.shared.image(for: humanPlayer.leader.iconTexture())
    }

    func leaderToolTip() -> String {

        guard let gameModel = self.gameEnvironment.game.value else {
            return ""
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            return ""
        }

        return humanPlayer.leader.name()
    }

    func handicapImage() -> NSImage {

        guard let gameModel = self.gameEnvironment.game.value else {
            return NSImage()
        }

        return ImageCache.shared.image(for: gameModel.handicap.iconTexture())
    }

    func handicapToolTip() -> String {

        guard let gameModel = self.gameEnvironment.game.value else {
            return ""
        }

        return gameModel.handicap.name()
    }

    func speedImage() -> NSImage {

        return ImageCache.shared.image(for: "speed-standard")
    }
}
