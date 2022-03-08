//
//  ScienceRankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ScienceRankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var scienceRankingViewModels: [ScienceRankingViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_RANKING_SCIENCE_VICTORY_TITLE".localized()
        self.summary = "TXT_KEY_RANKING_SCIENCE_VICTORY_BODY".localized()
        self.scienceRankingViewModels = []
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: RankingViewType.science.iconTexture())
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        var tmpScienceRankingViewModels: [ScienceRankingViewModel] = []

        for player in gameModel.players {

            if player.isBarbarian() || player.isFreeCity() || player.isCityState() {
                continue
            }

            let civilizationType: CivilizationType = player.leader.civilization()

            let scoreRankingViewModel = ScienceRankingViewModel(
                civilization: civilizationType,
                leader: player.leader,
                science: player.scienceVictoryProgress(in: gameModel)
            )

            tmpScienceRankingViewModels.append(scoreRankingViewModel)
        }

        tmpScienceRankingViewModels.sort(by: { (lhs, rhs) in return lhs.science > rhs.science })

        self.scienceRankingViewModels = tmpScienceRankingViewModels
    }
}
