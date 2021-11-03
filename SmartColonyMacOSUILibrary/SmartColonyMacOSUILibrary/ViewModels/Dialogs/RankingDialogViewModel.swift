//
//  RankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class RankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var rankingViewType: RankingViewType

    @Published
    var overallRankingDialogViewModel: OverallRankingDialogViewModel

    @Published
    var scoreRankingDialogViewModel: ScoreRankingDialogViewModel

    weak var delegate: GameViewModelDelegate?

    init() {

        self.rankingViewType = .overall
        self.overallRankingDialogViewModel = OverallRankingDialogViewModel()
        self.scoreRankingDialogViewModel = ScoreRankingDialogViewModel()
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        self.rankingViewType = .overall

        self.overallRankingDialogViewModel.update()
        self.scoreRankingDialogViewModel.update()
    }

    func show(detail: RankingViewType) {

        self.rankingViewType = detail
    }
}

extension RankingDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
    }
}
