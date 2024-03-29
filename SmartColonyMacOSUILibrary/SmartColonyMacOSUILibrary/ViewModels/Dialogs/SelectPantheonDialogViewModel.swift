//
//  SelectPantheonPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.07.21.
//

import SwiftUI
import SmartAILibrary

class SelectPantheonDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var pantheonViewModels: [PantheonViewModel] = []

    weak var delegate: GameViewModelDelegate?

    init(game: GameModel? = nil) {

        if game != nil {
            self.update(game: game)
        }
    }

    func update(game: GameModel? = nil) {

        var gameRef: GameModel? = game

        if gameRef == nil {
            gameRef = self.gameEnvironment.game.value
        }

        self.rebuildPantheons(for: gameRef)
    }

    private func rebuildPantheons(for game: GameModel?) {

        guard let pantheons = game?.availablePantheons() else {
            fatalError("cant get pantheons")
        }

        self.pantheonViewModels = []

        for pantheonType in pantheons {

            let pantheonViewModel = PantheonViewModel(pantheonType: pantheonType)
            pantheonViewModel.delegate = self
            self.pantheonViewModels.append(pantheonViewModel)
        }
    }

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}

extension SelectPantheonDialogViewModel: PantheonViewModelDelegate {

    func selected(pantheon: PantheonType) {

        let gameModel = self.gameEnvironment.game.value

        guard let religion = gameModel?.humanPlayer()?.religion else {
            fatalError("cant get player religion")
        }

        religion.foundPantheon(with: pantheon, in: gameModel)

        self.delegate?.closeDialog()
    }
}
