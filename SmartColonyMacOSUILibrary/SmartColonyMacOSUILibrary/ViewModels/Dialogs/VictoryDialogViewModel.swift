//
//  VictoryDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

class VictoryDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var victoryTitle: String

    @Published
    var civilizationTitle: String

    @Published
    var victorySummary: String

    private var victoryTypeIconTexture: String
    private var victoryBannerIconTexture: String

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "-"
        self.victoryTitle = "-"
        self.civilizationTitle = "-"
        self.victorySummary = "-"
        self.victoryTypeIconTexture = RankingViewType.religion.iconTexture()
        self.victoryBannerIconTexture = "defeat-banner"
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        let victoryType = gameModel.winnerVictory()
        guard let victoryLeader = gameModel.winnerLeader() else {
            fatalError("no winner")
        }

        if humanPlayer.leader == victoryLeader {

            // victory of human player
            self.title = "Victory"
            self.civilizationTitle = victoryLeader.name()

            switch victoryType {

            case .domination:
                self.victoryTitle = RankingViewType.domination.name()
                self.victorySummary = "Though its face may change throughout the ages, history is written from " +
                    "the hand of the victor. By your actions this day, you ensure our people are glorious tomorrow." // LOC_VICTORY_DOMINATION_TEXT
                self.victoryTypeIconTexture = RankingViewType.domination.iconTexture()
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .cultural:
                self.victoryTitle = RankingViewType.culture.name()
                self.victorySummary = "The worth of a culture is not measured by its accomplishments, but in " +
                    "how those accomplishments last, and how they are remembered. The beauty that you have inspired " +
                    "our people to create will ensure that our culture stands for all time." // LOC_VICTORY_CULTURE_TEXT
                self.victoryTypeIconTexture = RankingViewType.culture.iconTexture()
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .science:
                self.victoryTitle = RankingViewType.science.name()
                self.victorySummary = "Much as our ancestors did ages ago, we thrust forward into the unknown. " +
                    "The first pioneers set forth on an uneasy course, and yet once again our people thrive." // LOC_VICTORY_SCIENCE_TEXT
                self.victoryTypeIconTexture = RankingViewType.science.iconTexture()
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .diplomatic:
                // NOOP
                break
            case .religious:
                self.victoryTitle = RankingViewType.religion.name()
                self.victorySummary = "We have a basic need to believe in something greater than ourselves. " +
                    "We crave solace in the darkness, a light unto our path. Thanks to you, we’ve found meaning " +
                    "amid the Cosmos." // LOC_VICTORY_RELIGION_TEXT
                self.victoryTypeIconTexture = RankingViewType.religion.iconTexture()
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .score:
                self.victoryTitle = RankingViewType.score.name()
                self.victorySummary = "From our humble beginnings ages ago have you forged a civilization that " +
                    "has withstood time itself. Though countless civilizations rise and fall around us, we do not " +
                    "just survive. We prosper." // LOC_VICTORY_SCORE_TEXT
                self.victoryTypeIconTexture = RankingViewType.score.iconTexture()
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .none:
                // NOOP
                break
            }

        } else {
            // defeat of human player
            self.title = "Defeat"
            self.victoryTitle = "Defeat"
            self.victorySummary = "You have run out of time." // LOC_DEFEAT_TIME_TEXT
            self.victoryTypeIconTexture = RankingViewType.domination.iconTexture()
            self.victoryBannerIconTexture = "defeat-banner"
        }
    }

    func bannerImage() -> NSImage {

        if !ImageCache.shared.exists(key: self.victoryBannerIconTexture) {
            let bundle = Bundle.init(for: Textures.self)
            ImageCache.shared.add(
                image: bundle.image(forResource: self.victoryBannerIconTexture),
                for: self.victoryBannerIconTexture
            )
        }

        return ImageCache.shared.image(for: self.victoryBannerIconTexture)

    }

    func image() -> NSImage {

        return ImageCache.shared.image(for: self.victoryTypeIconTexture)
    }
}

extension VictoryDialogViewModel: BaseDialogViewModel {

    func closeDialog() {

        self.delegate?.closeDialog()
        //self.delegate?
    }
}
