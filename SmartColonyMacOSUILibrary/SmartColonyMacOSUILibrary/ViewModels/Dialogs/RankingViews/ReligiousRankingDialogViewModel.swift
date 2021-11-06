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

        self.title = "Religious Victory"
        self.summary =
            "To achieve a RELIGIOUS victory, your Religion must become the PREDOMINANT Religion for every civilization in the game.\n\n" +
            "A Religion is PREDOMINANT if it is followed by more than 50% of the cities in a civilization."
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

                    if loopPlayer.isBarbarian() || player.isEqual(to: loopPlayer) {
                        continue
                    }

                    var numCitiesFollowingReligion: Int = 0
                    var numCitiesAll: Int = 0
                    for cityRef in gameModel.cities(of: loopPlayer) {

                        guard let city = cityRef else {
                            continue
                        }

                        numCitiesAll += 1

                        if city.religiousMajority() == playerReligion {
                            numCitiesFollowingReligion += 1
                        }
                    }

                    if numCitiesFollowingReligion >= numCitiesAll / 2 {
                        convertedCivilizations[player.leader]?.append(loopPlayer.leader.civilization())
                    }
                }
            }
        }

        for player in gameModel.players {

            let civilizationType: CivilizationType = player.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

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
