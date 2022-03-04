//
//  ReligiousRankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class ReligiousRankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var religiousRankingViewModels: [ReligiousRankingViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_RANKING_RELIGIOUS_VICTORY_TITLE".localized()
        self.summary = "TXT_KEY_RANKING_RELIGIOUS_VICTORY_BODY".localized()
        self.religiousRankingViewModels = []
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: RankingViewType.religion.iconTexture())
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        /*guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }*/

        var tmpReligiousRankingViewModels: [ReligiousRankingViewModel] = []

        // Calculate who owns the most original capitals by iterating through all civs
        // and finding out who owns their original capital now.
        var convertedCivilizations: [LeaderType: [CivilizationType]] = [:]

        for player in gameModel.players {

            if player.isBarbarian() {
                continue
            }

            convertedCivilizations[player.leader] = []

            if let playerReligion = player.religion?.currentReligion() {

                if playerReligion == .none {
                    // players that dont have a religion yet, are not counted
                    continue
                }

                for loopPlayer in gameModel.players {

                    if loopPlayer.isBarbarian() || loopPlayer.isFreeCity() || loopPlayer.isCityState() {
                        continue
                    }

                    if player.isEqual(to: loopPlayer) {
                        continue
                    }

                    if loopPlayer.majorityOfCitiesFollows(religion: playerReligion, in: gameModel) {
                        convertedCivilizations[player.leader]?.append(loopPlayer.leader.civilization())
                    }
                }
            }
        }

        for player in gameModel.players {

            if player.isBarbarian() || player.isFreeCity() || player.isCityState() {
                continue
            }

            let civilizationType: CivilizationType = player.leader.civilization()

            let religion: ReligionType = player.religion?.currentReligion() ?? .none

            let dominationRankingViewModel = ReligiousRankingViewModel(
                civilization: civilizationType,
                leader: player.leader,
                religion: religion,
                convertedCivilizations: convertedCivilizations[player.leader] ?? []
            )

            tmpReligiousRankingViewModels.append(dominationRankingViewModel)
        }

        tmpReligiousRankingViewModels.sort(by: { (lhs, rhs) in

            return lhs.convertedCivilizations.count > rhs.convertedCivilizations.count
        })

        self.religiousRankingViewModels = tmpReligiousRankingViewModels
    }
}
