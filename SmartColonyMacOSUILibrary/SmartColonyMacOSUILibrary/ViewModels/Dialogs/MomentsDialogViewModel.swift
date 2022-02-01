//
//  MomentsDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.01.22.
//

import SwiftUI
import SmartAILibrary

class MomentsDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var momentViewModels: [MomentViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "Moments"
        self.momentViewModels = []
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        self.momentViewModels = humanPlayer.moments()
            .map { MomentViewModel(moment: $0) }
    }
}

extension MomentsDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
