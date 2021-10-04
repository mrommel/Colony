//
//  ReligionDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.10.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ReligionDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var hasFoundedPantheon: Bool = false

    @Published
    var pantheonViewModel: PantheonViewModel

    @Published
    var hasFoundedReligion: Bool = false

    // @Published
    // var religionViewModels: [ReligionViewModel] = []

    weak var delegate: GameViewModelDelegate?

    init() {

        self.pantheonViewModel = PantheonViewModel(pantheonType: .divineSpark)
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        guard let playerReligion = player.religion else {
            fatalError("cant get player religion")
        }

        self.hasFoundedPantheon = playerReligion.pantheon() != .none
        self.hasFoundedReligion = playerReligion.currentReligion() != .none

        // var tmpReligionViewModels: [ReligionViewModel] = []

        // self.religionViewModels = tmpReligionViewModels
    }
}

extension ReligionDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
