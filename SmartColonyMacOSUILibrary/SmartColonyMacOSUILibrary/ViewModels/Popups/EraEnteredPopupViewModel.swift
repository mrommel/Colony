//
//  EraEnteredPopupViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 02.06.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class EraEnteredPopupViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var summaryText: String

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

        self.title = "New Era started"
        self.summaryText = "The World has entered a new Era"

        self.eraTitle = ""
        self.leaderViewModel = LeaderViewModel(leaderType: .alexander)
        self.currentScoreText = ""
        self.currentAgeText = ""
        self.darkAgeImage = NSImage()
        self.darkAgeLimitText = ""
        self.darkAgeCheckmarkImage = NSImage()
        self.normalAgeImage = NSImage()
        self.normalAgeLimitText = ""
        self.normalAgeCheckmarkImage = NSImage()
        self.goldenAgeImage = NSImage()
        self.goldenAgeLimitText = ""
        self.goldenAgeCheckmarkImage = NSImage()
        self.currentAgeEffectText = ""
        self.loyaltyEffectText = ""
    }

    func update(for eraType: EraType) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game model")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        self.summaryText = "The World has entered the \(eraType) Era"

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
        if nextAge == .golden {
            self.goldenAgeCheckmarkImage = Globals.Icons.checkmark
        } else {
            self.goldenAgeCheckmarkImage = NSImage()
        }

        self.currentAgeEffectText = humanPlayer.currentAge().summaryText().localized()
        self.loyaltyEffectText = humanPlayer.currentAge().loyalityEffect().localized()
    }
}

extension EraEnteredPopupViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closePopup()
        self.delegate?.showSelectDedicationDialog()
    }
}
