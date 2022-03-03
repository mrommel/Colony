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

            let ranking: LeaderWeightList = LeaderWeightList()
            ranking.removeAll()

            for player in gameModel.players {

                if player.isBarbarian() || player.isFreeCity() || player.isCityState() {
                    continue
                }

                let leaderType: LeaderType = player.leader

                switch rankingViewType {

                case .overall:
                    // NOOP
                    break
                case .score:
                    ranking.add(weight: player.score(for: gameModel), for: leaderType)
                case .science:
                    ranking.add(weight: self.scienceValue(for: player), for: leaderType)
                case .culture:
                    ranking.add(weight: self.cultureValue(for: player), for: leaderType)
                case .domination:
                    ranking.add(weight: self.dominationValue(for: player), for: leaderType)
                case .religion:
                    ranking.add(weight: self.religionValue(for: player), for: leaderType)
                }
            }

            let sortedValues: [LeaderType] = ranking.sortedValues()
            let leadingLeaderType: LeaderType = sortedValues[0]

            var summary = ""

            if leadingLeaderType == humanPlayer.leader {
                summary = "You are leading"
            } else {
                let leaderingPlayer = gameModel.player(for: leadingLeaderType)
                if humanPlayer.hasMet(with: leaderingPlayer) {
                    summary = "\(leadingLeaderType.name()) is leading"
                } else {
                    summary = "An unmet player is leading"
                }
            }

            let overallRankingViewModel = OverallRankingViewModel(
                type: rankingViewType,
                summary: summary,
                civilizations: sortedValues.map { $0.civilization() }
            )
            tmpOverallRankingViewModels.append(overallRankingViewModel)
        }

        self.overallRankingViewModels = tmpOverallRankingViewModels
    }

    private func scienceValue(for playerRef: AbstractPlayer?) -> Int {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = playerRef else {
            fatalError("cant get player")
        }

        return player.scienceVictoryProgress(in: gameModel)
    }

    private func cultureValue(for playerRef: AbstractPlayer?) -> Double {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = playerRef else {
            fatalError("cant get player")
        }

        var tourismDict: [LeaderType: TourismSummary] = [:]

        for loopPlayer in gameModel.players {

            let civilizationType: CivilizationType = loopPlayer.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

            tourismDict[loopPlayer.leader] = TourismSummary(
                domestic: loopPlayer.domesticTourists(),
                visiting: loopPlayer.visitingTourists(in: gameModel)
            )
        }

        let visitingTourists: Int = tourismDict[player.leader]?.visiting ?? 0

        let maxOtherDomesticTourists: Int = tourismDict
            .filter { $0.key != player.leader }
            .map { $0.value.domestic }
            .max() ?? 0

        return Double(visitingTourists) / Double(maxOtherDomesticTourists)
    }

    private func dominationValue(for playerRef: AbstractPlayer?) -> Int {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = playerRef else {
            fatalError("cant get player")
        }

        var numOriginalCapitals: [LeaderType: [CivilizationType]] = [:]

        for loopPlayer in gameModel.players {

            if loopPlayer.originalCapitalLocation() != HexPoint.invalid {

                if let capitalCity = gameModel.city(at: loopPlayer.originalCapitalLocation()),
                    let capitalOwner = capitalCity.player {

                    // is the current owner the original owner?
                    if !loopPlayer.isEqual(to: capitalOwner) {

                        numOriginalCapitals[capitalOwner.leader]?.append(loopPlayer.leader.civilization())
                    }
                }
            }
        }

        return numOriginalCapitals[player.leader]?.count ?? 0
    }

    private func religionValue(for playerRef: AbstractPlayer?) -> Int {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let player = playerRef else {
            fatalError("cant get player")
        }

        var convertedCivilizations: [CivilizationType] = []

        if player.isBarbarian() {
            return 0
        }

        if let playerReligion = player.religion?.currentReligion() {

            if playerReligion == .none {
                // players that dont have a religion yet, are not counted
                return 0
            }

            for loopPlayer in gameModel.players {

                if loopPlayer.isBarbarian() || player.isEqual(to: loopPlayer) {
                    continue
                }

                if loopPlayer.majorityOfCitiesFollows(religion: playerReligion, in: gameModel) {
                    convertedCivilizations.append(loopPlayer.leader.civilization())
                }
            }
        }

        return convertedCivilizations.count
    }
}
