//
//  EraProgressDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.12.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class EraProgressDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var eraTitle: String

    @Published
    var leaderViewModel: LeaderViewModel

    @Published
    var darkAgeImage: NSImage

    @Published
    var darkAgeCheckmarkImage: NSImage

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "Era Progress"
        self.eraTitle = "The Ancient Era"
        self.leaderViewModel = LeaderViewModel(leaderType: .alexander)
        self.darkAgeImage = Globals.Icons.questionmark // todo Globals.Icons.darkAge
        self.darkAgeCheckmarkImage = NSImage()
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        self.eraTitle = humanPlayer.currentEra().title()
        self.leaderViewModel = LeaderViewModel(leaderType: humanPlayer.leader)
        self.leaderViewModel.show = true

        let nextAge = humanPlayer.estimateNextAge(in: gameModel)
        if nextAge == .dark {
            self.darkAgeCheckmarkImage = Globals.Icons.questionmark // todo checkmark
        } else {
            self.darkAgeCheckmarkImage = NSImage()
        }
    }
}

extension EraProgressDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
