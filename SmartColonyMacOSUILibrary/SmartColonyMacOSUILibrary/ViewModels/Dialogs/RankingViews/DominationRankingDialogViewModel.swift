//
//  DominationRankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class DominationRankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var dominationRankingViewModels: [DominationRankingViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "TXT_KEY_RANKING_DOMINATION_VICTORY_TITLE".localized()
        self.summary = "TXT_KEY_RANKING_DOMINATION_VICTORY_BODY".localized()
        self.dominationRankingViewModels = []
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: RankingViewType.domination.iconTexture())
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        /*guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }*/

        var tmpDominationRankingViewModels: [DominationRankingViewModel] = []

        // Calculate who owns the most original capitals by iterating through all civs
        // and finding out who owns their original capital now.
        var numOriginalCapitals: [LeaderType: [CivilizationType]] = [:]

        for player in gameModel.players {

            if player.isBarbarian() || player.isFreeCity() || player.isCityState() {
                continue
            }

            if player.originalCapitalLocation() != HexPoint.invalid {

                if let capitalCity = gameModel.city(at: player.originalCapitalLocation()),
                    let capitalOwner = capitalCity.player {

                    // is the current owner the original owner?
                    if !player.isEqual(to: capitalOwner) {

                        numOriginalCapitals[capitalOwner.leader]?.append(player.leader.civilization())
                    }
                }
            }
        }

        for player in gameModel.players {

            let civilizationType: CivilizationType = player.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

            let dominationRankingViewModel = DominationRankingViewModel(
                civilization: civilizationType,
                leader: player.leader,
                capturedCapitals: numOriginalCapitals[player.leader] ?? []
            )

            tmpDominationRankingViewModels.append(dominationRankingViewModel)
        }

        tmpDominationRankingViewModels.sort(by: { (lhs, rhs) in

            return lhs.capturedCapitals.count > rhs.capturedCapitals.count
        })

        self.dominationRankingViewModels = tmpDominationRankingViewModels
    }
}
