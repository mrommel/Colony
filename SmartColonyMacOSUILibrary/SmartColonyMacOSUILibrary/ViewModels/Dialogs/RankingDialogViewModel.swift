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

    @Published
    var scienceRankingDialogViewModel: ScienceRankingDialogViewModel

    @Published
    var cultureRankingDialogViewModel: CultureRankingDialogViewModel

    @Published
    var dominationRankingDialogViewModel: DominationRankingDialogViewModel

    @Published
    var religiousRankingDialogViewModel: ReligiousRankingDialogViewModel

    weak var delegate: GameViewModelDelegate?

    init() {

        self.rankingViewType = .overall
        self.overallRankingDialogViewModel = OverallRankingDialogViewModel()
        self.scoreRankingDialogViewModel = ScoreRankingDialogViewModel()
        self.scienceRankingDialogViewModel = ScienceRankingDialogViewModel()
        self.cultureRankingDialogViewModel = CultureRankingDialogViewModel()
        self.dominationRankingDialogViewModel = DominationRankingDialogViewModel()
        self.religiousRankingDialogViewModel = ReligiousRankingDialogViewModel()
    }

    func update() {

        self.rankingViewType = .overall

        self.overallRankingDialogViewModel.update()
        self.scoreRankingDialogViewModel.update()
        self.scienceRankingDialogViewModel.update()
        self.cultureRankingDialogViewModel.update()
        self.dominationRankingDialogViewModel.update()
        self.religiousRankingDialogViewModel.update()
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
