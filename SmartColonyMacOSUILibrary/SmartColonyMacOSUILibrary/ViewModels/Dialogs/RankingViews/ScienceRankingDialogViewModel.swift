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

        self.title = "Science Victory"
        self.summary =
            "To achieve a science victory, you must accomplish 5 major milestones:\n" +
            "- Launch a satellite.\n" +
            "- Land a human on the Moon.\n" +
            "- Establish a Martian Colony.\n" +
            "- Launch an Exoplanet Expedition.\n" +
            "- Help the Exoplanet Expedition to travel 50 light years."
        self.scienceRankingViewModels = []
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: RankingViewType.science.iconTexture())
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        /*guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }*/

        var tmpScienceRankingViewModels: [ScienceRankingViewModel] = []

        for player in gameModel.players {

            let civilizationType: CivilizationType = player.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

            let scoreRankingViewModel = ScienceRankingViewModel(
                civilization: civilizationType,
                leader: player.leader,
                science: 0 // 0...5 - each a space project
            )

            tmpScienceRankingViewModels.append(scoreRankingViewModel)
        }

        tmpScienceRankingViewModels.sort(by: { (lhs, rhs) in return lhs.science > rhs.science })

        self.scienceRankingViewModels = tmpScienceRankingViewModels
    }
}
