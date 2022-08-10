//
//  MenuViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartColonyMacOSUILibrary
import SmartAssets

protocol MenuViewModelDelegate: AnyObject {

    func showTutorials()
    func canResumeGame() -> Bool
    func resumeGame()
    func newGameStarted()
    func loadGame()
    // ..
    func showDebug()
    func showPedia()
    func showOptions()
}

class MenuViewModel: ObservableObject {

    @Published
    var showingQuitConfirmationAlert: Bool

    weak var delegate: MenuViewModelDelegate?

    init() {
        self.showingQuitConfirmationAlert = false

        // init button graphics
        let bundle = Bundle.init(for: Textures.self)

        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-disabled"), for: "grid9-button-disabled")
        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-active"), for: "grid9-button-active")
        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-highlighted"), for: "grid9-button-highlighted")
        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-clicked"), for: "grid9-button-clicked")
    }

    func showTutorials() {

        self.delegate?.showTutorials()
    }

    func canResumeGame() -> Bool {

        return self.delegate?.canResumeGame() ?? false
    }

    func resumeGame() {

        self.delegate?.resumeGame()
    }

    func startNewGame() {

        self.delegate?.newGameStarted()
    }

    func loadGame() {

        self.delegate?.loadGame()
    }

    // ...

    func startDebug() {

        self.delegate?.showDebug()
    }

    func showOptions() {

        self.delegate?.showOptions()
    }

    func startPedia() {

        self.delegate?.showPedia()
    }
}
