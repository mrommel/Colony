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
    var currentScoreText: String

    @Published
    var currentAgeText: String

    @Published
    var darkAgeImage: NSImage

    @Published
    var darkAgeLimitText: String

    @Published
    var darkAgeCheckmarkImage: NSImage

    @Published
    var normalAgeImage: NSImage

    @Published
    var normalAgeLimitText: String

    @Published
    var normalAgeCheckmarkImage: NSImage

    @Published
    var goldenAgeImage: NSImage

    @Published
    var goldenAgeLimitText: String

    @Published
    var goldenAgeCheckmarkImage: NSImage

    @Published
    var currentAgeEffectText: String

    @Published
    var loyaltyEffectText: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "Era Progress"
        self.eraTitle = "The Ancient Era"
        self.leaderViewModel = LeaderViewModel(leaderType: .alexander)
        self.currentScoreText = "?"
        self.currentAgeText = "?"

        self.darkAgeImage = Globals.Icons.darkAge
        self.darkAgeLimitText = "0 - ?"
        self.darkAgeCheckmarkImage = NSImage()

        self.normalAgeImage = Globals.Icons.normalAge
        self.normalAgeLimitText = "? - ?"
        self.normalAgeCheckmarkImage = NSImage()

        self.goldenAgeImage = Globals.Icons.goldenAge
        self.goldenAgeLimitText = "? - ?"
        self.goldenAgeCheckmarkImage = NSImage()

        self.currentAgeEffectText = ""
        self.loyaltyEffectText = ""
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
        self.currentScoreText = "\(humanPlayer.eraScore())"
        self.currentAgeText = "\(humanPlayer.currentAge())"

        let ageThresholds = humanPlayer.ageThresholds(in: gameModel)
        let nextAge = humanPlayer.estimateNextAge(in: gameModel)

        self.darkAgeLimitText = "0 - \(ageThresholds.lower-1)"
        if nextAge == .dark {
            self.darkAgeCheckmarkImage = Globals.Icons.checkmark
        } else {
            self.darkAgeCheckmarkImage = NSImage()
        }

        self.normalAgeLimitText = "\(ageThresholds.lower) - \(ageThresholds.upper)"
        if nextAge == .normal {
            self.normalAgeCheckmarkImage = Globals.Icons.checkmark
        } else {
            self.normalAgeCheckmarkImage = NSImage()
        }

        self.goldenAgeLimitText = "\(ageThresholds.upper+1)+"
        if nextAge == .normal {
            self.goldenAgeCheckmarkImage = Globals.Icons.checkmark
        } else {
            self.goldenAgeCheckmarkImage = NSImage()
        }

        self.currentAgeEffectText = humanPlayer.currentAge().summaryText().localized()
        self.loyaltyEffectText = humanPlayer.currentAge().loyaltyEffect().localized()
    }
}

extension EraProgressDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
