//
//  MainViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets
import SmartColonyMacOSUILibrary

enum PresentedViewType {

    case menu
    case newGameMenu
    case loadGameMenu
    case loadingGame // progress
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
    var loadGameViewModel: LoadGameViewModel
    var generateGameViewModel: GenerateGameViewModel
    var gameViewModel: GameViewModel
    var replayViewModel: ReplayGameViewModel
    let debugViewModel: DebugViewModel
    var pediaViewModel: PediaViewModel

    // private
    private var progressTimer: Timer?

    init(presentedView: PresentedViewType = .menu,
         menuViewModel: MenuViewModel = MenuViewModel(),
         createGameMenuViewModel: CreateGameMenuViewModel = CreateGameMenuViewModel(),
         loadGameViewModel: LoadGameViewModel = LoadGameViewModel(),
         generateGameViewModel: GenerateGameViewModel = GenerateGameViewModel(),
         gameViewModel: GameViewModel = GameViewModel(),
         pediaViewModel: PediaViewModel = PediaViewModel()) {

        self.presentedView = presentedView
        self.mapMenuDisabled = true

        self.menuViewModel = menuViewModel
        self.createGameMenuViewModel = createGameMenuViewModel
        self.loadGameViewModel = loadGameViewModel
        self.generateGameViewModel = generateGameViewModel
        self.gameViewModel = gameViewModel
        self.replayViewModel = ReplayGameViewModel()
        self.debugViewModel = DebugViewModel()
        self.pediaViewModel = pediaViewModel

        // connect delegates
        self.menuViewModel.delegate = self
        self.createGameMenuViewModel.delegate = self
        self.loadGameViewModel.delegate = self
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

    func resumeGame() {

        let directory = NSTemporaryDirectory()
        let fileName = "current.clny"

        // This returns a URL? even though it is an NSURL class method
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])

        let reader = GameLoader()
        let gameModel = reader.load(from: fullURL)

        self.created(game: gameModel)
    }

    func newGameStarted() {

        self.presentedView = .newGameMenu
        self.mapMenuDisabled = true
    }

    func loadGame() {

        self.loadGameViewModel.update() 

        self.presentedView = .loadGameMenu
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

    func showOptions() {

    }
}

extension MainViewModel: CreateGameMenuViewModelDelegate {

    func started(with leaderType: LeaderType, on handicapType: HandicapType, with mapType: MapType, and mapSize: MapSize, with seed: Int) {

        self.generateGameViewModel.start(with: leaderType, on: handicapType, with: mapType, and: mapSize, with: seed)
        self.presentedView = .loadingGame
        self.mapMenuDisabled = true
    }

    func canceled() {

        self.presentedView = .menu
        self.mapMenuDisabled = true
    }
}

extension MainViewModel: LoadGameViewModelDelegate {

    // func canceled()

    func load(filename: String) {

        do {
            let applicationSupport = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )

            let bundleID = "SmartColonyMacOS"
            var appSupportSubDirectory = applicationSupport.appendingPathComponent(bundleID, isDirectory: true)

            var isDirectory: ObjCBool = true
            if !FileManager.default.fileExists(atPath: appSupportSubDirectory.path, isDirectory: &isDirectory) {
                try FileManager.default.createDirectory(at: appSupportSubDirectory, withIntermediateDirectories: true, attributes: nil)
            }

            appSupportSubDirectory.appendPathComponent(filename)

            let reader = GameLoader()
            let gameModel = reader.load(from: appSupportSubDirectory)

            self.created(game: gameModel)
        } catch {
            print("cant load game: \(error)")
        }
    }
}

extension MainViewModel: GenerateGameViewModelDelegate {

    func created(game gameModel: GameModel?) {

        self.gameViewModel.loadAssets()

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

    func closeGameAndLoad() {

        self.presentedView = .loadGameMenu
        self.gameEnvironment.assign(game: nil)
    }

    func closeAndRestartGame() {

        // keep seed
        guard let oldGameModel = self.gameEnvironment.game.value else {
            fatalError("cant get old game data")
        }

        let leader = oldGameModel.humanPlayer()?.leader ?? .alexander
        // let victoryTypes = oldGameModel.victoryTypes
        let handicap = oldGameModel.handicap
        let mapSize = oldGameModel.mapSize()
        let seed = oldGameModel.seed()

        self.started(with: leader, on: handicap, with: MapType.continents, and: mapSize, with: seed)
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
