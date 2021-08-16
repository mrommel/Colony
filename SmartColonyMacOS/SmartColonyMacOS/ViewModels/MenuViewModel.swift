//
//  MenuViewModel.swift
//  SmartColonyMacOS
//
//  Created by Michael Rommel on 22.03.21.
//

import SwiftUI
import SmartMacOSUILibrary
import SmartAssets

protocol MenuViewModelDelegate: AnyObject {

    func newGameStarted()
    func showPedia()
}

class MenuViewModel: ObservableObject {

    @Published
    var showingQuitConfirmationAlert: Bool

    weak var delegate: MenuViewModelDelegate?

    init() {
        self.showingQuitConfirmationAlert = false

        let bundle = Bundle.init(for: Textures.self)

        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-active"), for: "grid9-button-active")
        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-highlighted"), for: "grid9-button-highlighted")
        ImageCache.shared.add(image: bundle.image(forResource: "grid9-button-clicked"), for: "grid9-button-clicked")
    }

    func startNewGame() {

        self.delegate?.newGameStarted()
    }

    // ...

    func startPedia() {

        self.delegate?.showPedia()
    }
}
