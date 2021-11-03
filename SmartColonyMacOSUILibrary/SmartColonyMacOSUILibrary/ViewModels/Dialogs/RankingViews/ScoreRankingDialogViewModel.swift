//
//  ScoreRankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ScoreRankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var scoreRankingViewModels: [ScoreRankingViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.scoreRankingViewModels = []
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: RankingViewType.score.iconTexture())
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        /*guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }*/

        var tmpScoreRankingViewModels: [ScoreRankingViewModel] = []

        for player in gameModel.players {

            let civilizationType: CivilizationType = player.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

            let scoreRankingViewModel = ScoreRankingViewModel(
                civilization: civilizationType,
                leader: player.leader,
                score: player.score(for: gameModel)
            )

            tmpScoreRankingViewModels.append(scoreRankingViewModel)
        }

        tmpScoreRankingViewModels.sort(by: { (lhs, rhs) in return lhs.score > rhs.score })

        self.scoreRankingViewModels = tmpScoreRankingViewModels
    }
}
