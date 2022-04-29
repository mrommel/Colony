//
//  GameMenuViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.02.22.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

enum GameMenuAction {

    case backToGame
    case restartGame
    case quickSaveGame
    case saveGame
    case loadGame
    case gameOptions
    case retireGame
    case backToMainMenu
}

protocol GameMenuViewModelDelegate: AnyObject {

    func handle(action: GameMenuAction)
    func saveGame(as filename: String)
}

class GameMenuViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var confirmationDialogViewModel: ConfirmationDialogViewModel

    @Published
    var showConfirmationDialog: Bool = false

    @Published
    var nameInputDialogViewModel: NameInputDialogViewModel

    @Published
    var showNameInputDialog: Bool = false

    weak var delegate: GameMenuViewModelDelegate?

    init() {

        self.confirmationDialogViewModel = ConfirmationDialogViewModel()
        self.nameInputDialogViewModel = NameInputDialogViewModel()
    }

    func canClick(on action: GameMenuAction) -> Bool {

        switch action {

        case .backToGame:
            return true

        case .restartGame:
            guard let gameModel = self.gameEnvironment.game.value else {
                return false
            }

            // cannot restart game in first turn
            guard !gameModel.isStartTurn() else {
                return false
            }

            return true

        case .quickSaveGame:
            return true

        case .saveGame:
            return true

        case .loadGame:
            return true

        case .gameOptions:
            return false // not implemented yet

        case .retireGame:
            guard let gameModel = self.gameEnvironment.game.value else {
                return false
            }

            guard gameModel.gameState() == .on else {
                return false
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                return false
            }

            guard humanPlayer.isAlive() else {
                return false
            }

            guard !humanPlayer.isEndTurn() else {
                return false
            }

            return false // true - not implemented yet

        case .backToMainMenu:
            return true
        }
    }

    func handle(action: GameMenuAction) {

        switch action {

        case .restartGame:
            self.showConfirmationDialog = true

            self.confirmationDialogViewModel.update(
                title: "Restart Game",
                question: "Do you really want to restart? Everything will be lost.",
                confirm: "Restart",
                cancel: "Cancel",
                completion: { confirmed in

                    self.showConfirmationDialog = false

                    if confirmed {
                        self.delegate?.handle(action: .restartGame)
                    }
                }
            )

        case .saveGame:
            self.showNameInputDialog = true

            guard let gameModel = self.gameEnvironment.game.value else {
                print("cant save game: game not set")
                return
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                print("cant human player")
                return
            }

            let defaultFilename = "\(humanPlayer.leader.name().localized()) \(gameModel.turnYear()).clny"

            self.nameInputDialogViewModel.update(
                title: "Save Game",
                summary: "Please insert name for ",
                value: defaultFilename,
                confirm: "Save Game",
                completion: { filename in

                    self.showNameInputDialog = false
                    self.delegate?.saveGame(as: filename)
                    self.delegate?.handle(action: .backToGame)
                }
            )

        case .retireGame:
            self.showConfirmationDialog = true

            self.confirmationDialogViewModel.update(
                title: "Retire Game",
                question: "Do you really want to retire?",
                confirm: "Retire",
                cancel: "Cancel",
                completion: { confirmed in

                    self.showConfirmationDialog = false

                    if confirmed {
                        self.delegate?.handle(action: .retireGame)
                    }
                }
            )

        case .backToMainMenu:
            self.showConfirmationDialog = true

            self.confirmationDialogViewModel.update(
                title: "Quit Game",
                question: "Do you really want to quit? Everything will be lost.",
                confirm: "Quit",
                cancel: "Cancel",
                completion: { confirmed in

                    self.showConfirmationDialog = false

                    if confirmed {
                        self.delegate?.handle(action: .backToMainMenu)
                    }
                }
            )

        default:
            self.delegate?.handle(action: action)
        }
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
