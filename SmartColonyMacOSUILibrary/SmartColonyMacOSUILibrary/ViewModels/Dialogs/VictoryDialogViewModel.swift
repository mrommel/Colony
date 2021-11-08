//
//  VictoryDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 06.11.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

enum VictoryDialogDetailType {

    case info
    case ranking
    case graphs
}

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

    @Published
    var detailType: VictoryDialogDetailType

    private var victoryTypeIconTexture: String
    private var victoryBannerIconTexture: String

    // graphs
    @Published
    var selectedGraphValueIndex: Int = 0 {
        didSet {
            self.updateGraph()
        }
    }

    @Published
    var graphData: ScoreData

    weak var delegate: GameViewModelDelegate?

    init() {

        self.title = "-"
        self.victoryTitle = "-"
        self.civilizationTitle = "-"
        self.victorySummary = "-"
        self.victoryTypeIconTexture = RankingViewType.religion.iconTexture()
        self.victoryBannerIconTexture = "defeat-banner"

        self.detailType = .info
        self.graphData = ScoreData(lines: [])
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

        self.detailType = .info

        switch victoryType {

        case .domination:
            self.victoryTitle = RankingViewType.domination.name()
            self.victoryTypeIconTexture = RankingViewType.domination.iconTexture()
        case .cultural:
            self.victoryTitle = RankingViewType.culture.name()
            self.victoryTypeIconTexture = RankingViewType.culture.iconTexture()
        case .science:
            self.victoryTitle = RankingViewType.science.name()
            self.victoryTypeIconTexture = RankingViewType.science.iconTexture()
        case .diplomatic:
            // NOOP
            break
        case .religious:
            self.victoryTitle = RankingViewType.religion.name()
            self.victoryTypeIconTexture = RankingViewType.religion.iconTexture()
        case .score:
            self.victoryTitle = RankingViewType.score.name()
            self.victoryTypeIconTexture = RankingViewType.score.iconTexture()
        case .none:
            // NOOP
            break
        }

        if humanPlayer.leader == victoryLeader {

            // victory of human player
            self.title = "Victory"
            self.civilizationTitle = "of the \(victoryLeader.civilization().name()) empire"

            switch victoryType {

            case .domination:
                self.victorySummary = "Though its face may change throughout the ages, history is written from " +
                    "the hand of the victor. By your actions this day, you ensure our people are glorious tomorrow." // LOC_VICTORY_DOMINATION_TEXT
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .cultural:
                self.victorySummary = "The worth of a culture is not measured by its accomplishments, but in " +
                    "how those accomplishments last, and how they are remembered. The beauty that you have inspired " +
                    "our people to create will ensure that our culture stands for all time." // LOC_VICTORY_CULTURE_TEXT
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .science:
                self.victorySummary = "Much as our ancestors did ages ago, we thrust forward into the unknown. " +
                    "The first pioneers set forth on an uneasy course, and yet once again our people thrive." // LOC_VICTORY_SCIENCE_TEXT
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .diplomatic:
                // NOOP
                break
            case .religious:
                self.victorySummary = "We have a basic need to believe in something greater than ourselves. " +
                    "We crave solace in the darkness, a light unto our path. Thanks to you, we’ve found meaning " +
                    "amid the Cosmos." // LOC_VICTORY_RELIGION_TEXT
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .score:
                self.victorySummary = "From our humble beginnings ages ago have you forged a civilization that " +
                    "has withstood time itself. Though countless civilizations rise and fall around us, we do not " +
                    "just survive. We prosper." // LOC_VICTORY_SCORE_TEXT
                self.victoryBannerIconTexture = "victory-culture-banner"
            case .none:
                // NOOP
                break
            }

        } else {
            // defeat of human player
            self.title = "Defeat"
            self.civilizationTitle = "by the \(victoryLeader.civilization().name()) empire"
            self.victorySummary = "You have run out of time." // LOC_DEFEAT_TIME_TEXT
            self.victoryBannerIconTexture = "defeat-banner"
        }
    }

    var graphValues: [PickerData] {

        return RankingDataType.all.map { PickerData(name: $0.title(), image: NSImage()) }
    }

    func updateGraph() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        let type: RankingDataType = RankingDataType.all[self.selectedGraphValueIndex]

        switch type {

        case .culturePerTurn:

            var lines: [ScoreDataLine] = []

            for player in gameModel.players {

                let color: NSColor = player.leader.civilization().accent
                let values: [Double] = gameModel.rankingData.data(type: .culturePerTurn, for: player.leader)
                let line: ScoreDataLine = ScoreDataLine(color: color, values: values)
                lines.append(line)
            }

            self.graphData = ScoreData(lines: lines)
        case .goldBalance:
            self.graphData = ScoreData(lines: [])
        case .totalCitiesFounded:
            self.graphData = ScoreData(lines: [])
        }
    }

    func set(detailType: VictoryDialogDetailType) {

        self.detailType = detailType

        if self.detailType == .graphs {

            self.update()
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
