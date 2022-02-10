//
//  MainViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets
import SmartMacOSUILibrary

enum PresentedViewType {

    case menu
    case newGameMenu
    case loadingGame
    case game
    case replay
    case debug
    case pedia
    case spriteKit // debug
}

class MainViewModel: ObservableObject {

    @Published
    var presentedView: PresentedViewType

    @Published
    var mapMenuDisabled: Bool

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    // sub view models
    var menuViewModel: MenuViewModel
    var createGameMenuViewModel: CreateGameMenuViewModel
    var generateGameViewModel: GenerateGameViewModel
    var gameViewModel: GameViewModel
    var replayViewModel: ReplayGameViewModel
    let debugViewModel: DebugViewModel
    var pediaViewModel: PediaViewModel

    // private
    private var progressTimer: Timer?
    private var restartURL: UserDefaultStorage<URL>

    init(presentedView: PresentedViewType = .menu,
         menuViewModel: MenuViewModel = MenuViewModel(),
         createGameMenuViewModel: CreateGameMenuViewModel = CreateGameMenuViewModel(),
         generateGameViewModel: GenerateGameViewModel = GenerateGameViewModel(),
         gameViewModel: GameViewModel = GameViewModel(/*mapViewModel: MapViewModel()*/),
         pediaViewModel: PediaViewModel = PediaViewModel()) {

        self.presentedView = presentedView
        self.mapMenuDisabled = true

        self.menuViewModel = menuViewModel
        self.createGameMenuViewModel = createGameMenuViewModel
        self.generateGameViewModel = generateGameViewModel
        self.gameViewModel = gameViewModel
        self.replayViewModel = ReplayGameViewModel()
        self.debugViewModel = DebugViewModel()
        self.pediaViewModel = pediaViewModel

        self.restartURL = UserDefaultStorage<URL>(key: "restartURL", default: URL(fileURLWithPath: "backup.sc"))

        // connect delegates
        self.menuViewModel.delegate = self
        self.createGameMenuViewModel.delegate = self
        self.generateGameViewModel.delegate = self
        self.gameViewModel.delegate = self // later: replay
        self.debugViewModel.delegate = self
        self.pediaViewModel.delegate = self
    }

    func centerCapital() {

        guard self.presentedView == .game else {
            return
        }

        // add center on capital (or start location)
        self.gameViewModel.centerCapital()
    }

    func centerOnCursor() {

        guard self.presentedView == .game else {
            return
        }

        // add center on cursor
        self.gameViewModel.centerOnCursor()
    }

    func zoomIn() {

        guard self.presentedView == .game else {
            return
        }

        self.gameViewModel.zoomIn()
    }

    func zoomOut() {

        guard self.presentedView == .game else {
            return
        }

        self.gameViewModel.zoomOut()
    }

    func zoomReset() {

        guard self.presentedView == .game else {
            return
        }

        self.gameViewModel.zoomReset()
    }

    @objc private func runTimedCode() {

        self.generateGameViewModel.progressValue += 0.1

        if self.generateGameViewModel.progressValue > 1.0 {

            self.generateGameViewModel.progressValue = 0.0
        }
    }
}

extension MainViewModel: MenuViewModelDelegate {

    func newGameStarted() {

        self.presentedView = .newGameMenu
        self.mapMenuDisabled = true
    }

    func showDebug() {

        DispatchQueue.global(qos: .userInitiated).async {

            self.debugViewModel.prepare()

            DispatchQueue.main.async {
                self.presentedView = .debug
            }
        }
    }

    func showPedia() {

        DispatchQueue.global(qos: .userInitiated).async {

            self.pediaViewModel.prepare()

            DispatchQueue.main.async {
                self.presentedView = .pedia
            }
        }
    }
}

extension MainViewModel: CreateGameMenuViewModelDelegate {

    func started(with leaderType: LeaderType, on handicapType: HandicapType, with mapType: MapType, and mapSize: MapSize) {

        self.generateGameViewModel.start(with: leaderType, on: handicapType, with: mapType, and: mapSize)
        self.presentedView = .loadingGame
        self.mapMenuDisabled = true
    }

    func canceled() {

        self.presentedView = .menu
        self.mapMenuDisabled = true
    }
}

extension MainViewModel: GenerateGameViewModelDelegate {

    func created(game gameModel: GameModel?) {

        self.gameViewModel.loadAssets()

        // backup the newly created game for restart
        let writer = GameWriter()
        if !writer.write(game: gameModel, to: self.restartURL.wrappedValue) {
            fatalError("could not store game for restart backup")
        }

        self.gameEnvironment.assign(game: gameModel)

        self.presentedView = .game
        self.mapMenuDisabled = false
    }
}

extension MainViewModel: PediaViewModelDelegate {

}

extension MainViewModel: CloseGameViewModelDelegate {

    func closeGame() {

        self.presentedView = .menu
        self.gameEnvironment.assign(game: nil)
    }

    /*func showReplay(for game: GameModel?) {

        fatalError("not implemented: showReplay")
    }*/

    func closeAndRestartGame() {

        let loader = GameLoader()
        if let gameModel = loader.load(from: self.restartURL.wrappedValue) {

            self.gameEnvironment.assign(game: gameModel)

            self.presentedView = .game
            self.mapMenuDisabled = false
        }
    }
}

extension MainViewModel: DebugViewModelDelegate {

    func preparing() {

        self.presentedView = .loadingGame
        self.mapMenuDisabled = false

        self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }

    func prepared(game gameModel: GameModel?) {

        self.gameViewModel.loadAssets()

        self.gameEnvironment.assign(game: gameModel)

        self.progressTimer?.invalidate()

        self.presentedView = .game
        self.mapMenuDisabled = false
    }

    func preparedSkriteKit() {

        self.presentedView = .spriteKit
    }

    func closed() {

        self.presentedView = .menu
        self.mapMenuDisabled = true
    }
}
