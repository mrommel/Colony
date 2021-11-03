//
//  OverallRankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import SwiftUI
import SmartAILibrary

class OverallRankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var overallRankingViewModels: [OverallRankingViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.overallRankingViewModels = []
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        var tmpOverallRankingViewModels: [OverallRankingViewModel] = []

        for rankingViewType in RankingViewType.values {

            let ranking: WeightedList<CivilizationType> = WeightedList<CivilizationType>()

            for player in gameModel.players {

                let civilizationType: CivilizationType = player.leader.civilization()

                if civilizationType == .barbarian {
                    continue
                }

                switch rankingViewType {

                case .overall:
                    // NOOP
                    break
                case .score:
                    ranking.add(weight: player.score(for: gameModel), for: civilizationType)
                case .science:
                    ranking.add(weight: Int.random(number: 100), for: civilizationType)
                case .culture:
                    ranking.add(weight: Int.random(number: 100), for: civilizationType)
                case .domination:
                    ranking.add(weight: Int.random(number: 100), for: civilizationType)
                case .religion:
                    ranking.add(weight: Int.random(number: 100), for: civilizationType)
                }
            }

            let sortedValues: [CivilizationType] = ranking.sortedValues()
            let leadingCivilizationType: CivilizationType = sortedValues[0]

            var summary = ""

            if leadingCivilizationType == humanPlayer.leader.civilization() {
                summary = "You are leading"
            } else {
                summary = "\(leadingCivilizationType.name()) is leading"
            }

            let overallRankingViewModel = OverallRankingViewModel(
                type: rankingViewType,
                summary: summary,
                civilizations: sortedValues
            )
            tmpOverallRankingViewModels.append(overallRankingViewModel)
        }

        self.overallRankingViewModels = tmpOverallRankingViewModels
    }
}
