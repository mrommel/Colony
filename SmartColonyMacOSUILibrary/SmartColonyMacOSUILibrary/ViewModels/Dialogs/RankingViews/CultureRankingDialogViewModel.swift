//
//  CultureRankingDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 04.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

struct TourismSummary {

    var domestic: Int
    var visiting: Int
}

class CultureRankingDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var summary: String

    @Published
    var cultureRankingViewModels: [CultureRankingViewModel]

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "Culture Victory"
        self.summary =
            "To achieve a CULTURE victory, you must attract VISITING TOURISTS by generating high amount " +
            "of culture and tourism. Victory is achieved when you attract more VISITING TOURISTS to your " +
            "civilization than any other civilization has DOMESTIC TOURISTS at home.\n" +
            "- Your DOMESTIC TOURISTS represent the tourists from your civilization thta are currently happy " +
            "vacationing within your borders.\n" +
            "- Your VISITING TOURISTS represent the number of citizens you've attracted from the DOMESTIC " +
            "TOURIST pools of other civilizations."
        self.cultureRankingViewModels = []
    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: RankingViewType.culture.iconTexture())
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        /*guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }*/

        var tourismDict: [LeaderType: TourismSummary] = [:]

        for player in gameModel.players {

            let civilizationType: CivilizationType = player.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

            tourismDict[player.leader] = TourismSummary(
                domestic: player.domesticTourists(),
                visiting: player.visitingTourists()
            )
        }

        var tmpCultureRankingViewModels: [CultureRankingViewModel] = []

        for player in gameModel.players {

            let civilizationType: CivilizationType = player.leader.civilization()

            if civilizationType == .barbarian {
                continue
            }

            let domesticTourists: Int = tourismDict[player.leader]?.domestic ?? 0
            let visitingTourists: Int = tourismDict[player.leader]?.visiting ?? 0

            let maxOtherDomesticTourists: Int = tourismDict
                .filter { $0.key != player.leader }
                .map { $0.value.domestic }
                .max()

            let cultureRankingViewModel = CultureRankingViewModel(
                civilization: civilizationType,
                leader: player.leader,
                domesticTourists: domesticTourists,
                visitingTourists: visitingTourists,
                maxOtherDomesticTourists: maxOtherDomesticTourists
            )

            tmpCultureRankingViewModels.append(cultureRankingViewModel)
        }

        tmpCultureRankingViewModels.sort(by: { (lhs, rhs) in

            let lhsRatio: Double = Double(lhs.visitingTourists) / Double(lhs.maxOtherDomesticTourists)
            let rhsRatio: Double = Double(rhs.visitingTourists) / Double(rhs.maxOtherDomesticTourists)
            return lhsRatio > rhsRatio
        })

        self.cultureRankingViewModels = tmpCultureRankingViewModels
    }
}
