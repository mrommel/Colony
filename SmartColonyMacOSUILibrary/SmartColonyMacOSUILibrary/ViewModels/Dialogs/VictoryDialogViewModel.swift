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

class VictoryRankingViewModel: ObservableObject {

    private var id: UUID = UUID()

    @Published
    var index: Int

    @Published
    var name: String

    @Published
    var quote: String

    @Published
    var minScore: Int

    @Published
    var maxScore: Int

    @Published
    var selected: Bool

    init(index: Int, name: String, quote: String, minScore: Int, maxScore: Int, selected: Bool = false) {

        self.index = index
        self.name = name.localized()
        self.quote = quote
        self.minScore = minScore
        self.maxScore = maxScore
        self.selected = selected
    }

    func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.quote.localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        return toolTipText
    }
}

extension VictoryRankingViewModel: Hashable {

    static func == (lhs: VictoryRankingViewModel, rhs: VictoryRankingViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
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

    @Published
    var victoryRankingViewModels: [VictoryRankingViewModel]

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

    @Published
    var legendData: ScoreLegendViewModel

    weak var delegate: GameViewModelDelegate?

    init() {

        self.detailType = .info
        self.title = "-"
        self.victoryBannerIconTexture = "defeat-banner"

        // info
        self.victoryTitle = "-"
        self.civilizationTitle = "-"
        self.victorySummary = "-"
        self.victoryTypeIconTexture = RankingViewType.religion.iconTexture()

        // ranking - https://civilization.fandom.com/wiki/Victory_(Civ6)#Ranking
        self.victoryRankingViewModels = [
            VictoryRankingViewModel(
                index: 1,
                name: "TXT_KEY_LEADER_1_NAME",
                quote: "TXT_KEY_LEADER_1_QUOTE",
                minScore: 2500,
                maxScore: 10000
            ),
            VictoryRankingViewModel(
                index: 2,
                name: "TXT_KEY_LEADER_2_NAME",
                quote: "TXT_KEY_LEADER_2_QUOTE",
                minScore: 2250,
                maxScore: 2499
            ),
            VictoryRankingViewModel(
                index: 3,
                name: "TXT_KEY_LEADER_3_NAME",
                quote: "TXT_KEY_LEADER_3_QUOTE",
                minScore: 2000,
                maxScore: 2249
            ),
            VictoryRankingViewModel(
                index: 4,
                name: "TXT_KEY_LEADER_4_NAME",
                quote: "TXT_KEY_LEADER_4_QUOTE",
                minScore: 1900,
                maxScore: 1999
            ),
            VictoryRankingViewModel(
                index: 5,
                name: "TXT_KEY_LEADER_5_NAME",
                quote: "TXT_KEY_LEADER_5_QUOTE",
                minScore: 1800,
                maxScore: 1899
            ),
            VictoryRankingViewModel(
                index: 6,
                name: "TXT_KEY_LEADER_6_NAME",
                quote: "TXT_KEY_LEADER_6_QUOTE",
                minScore: 1700,
                maxScore: 1799
            ),
            VictoryRankingViewModel(
                index: 7,
                name: "TXT_KEY_LEADER_7_NAME",
                quote: "TXT_KEY_LEADER_7_QUOTE",
                minScore: 1600,
                maxScore: 1699
            ),
            VictoryRankingViewModel(
                index: 8,
                name: "TXT_KEY_LEADER_8_NAME",
                quote: "TXT_KEY_LEADER_8_QUOTE",
                minScore: 1500,
                maxScore: 1599
            ),
            VictoryRankingViewModel(
                index: 9,
                name: "TXT_KEY_LEADER_9_NAME",
                quote: "TXT_KEY_LEADER_9_QUOTE",
                minScore: 1400,
                maxScore: 1499
            ),
            VictoryRankingViewModel(
                index: 10,
                name: "TXT_KEY_LEADER_10_NAME",
                quote: "TXT_KEY_LEADER_10_QUOTE",
                minScore: 1300,
                maxScore: 1399
            ),
            VictoryRankingViewModel(
                index: 11,
                name: "TXT_KEY_LEADER_11_NAME",
                quote: "TXT_KEY_LEADER_11_QUOTE",
                minScore: 1200,
                maxScore: 1299
            ),
            VictoryRankingViewModel(
                index: 12,
                name: "TXT_KEY_LEADER_12_NAME",
                quote: "TXT_KEY_LEADER_12_QUOTE",
                minScore: 1100,
                maxScore: 1199
            ),
            VictoryRankingViewModel(
                index: 13,
                name: "TXT_KEY_LEADER_13_NAME",
                quote: "TXT_KEY_LEADER_13_QUOTE",
                minScore: 1000,
                maxScore: 1099
            ),
            VictoryRankingViewModel(
                index: 14,
                name: "TXT_KEY_LEADER_14_NAME",
                quote: "TXT_KEY_LEADER_14_QUOTE",
                minScore: 900,
                maxScore: 999
            ),
            VictoryRankingViewModel(
                index: 15,
                name: "TXT_KEY_LEADER_15_NAME",
                quote: "TXT_KEY_LEADER_15_QUOTE",
                minScore: 800,
                maxScore: 899
            ),
            VictoryRankingViewModel(
                index: 16,
                name: "TXT_KEY_LEADER_16_NAME",
                quote: "TXT_KEY_LEADER_16_QUOTE",
                minScore: 700,
                maxScore: 799
            ),
            VictoryRankingViewModel(
                index: 17,
                name: "TXT_KEY_LEADER_17_NAME",
                quote: "TXT_KEY_LEADER_17_QUOTE",
                minScore: 600,
                maxScore: 699
            ),
            VictoryRankingViewModel(
                index: 18,
                name: "TXT_KEY_LEADER_18_NAME",
                quote: "TXT_KEY_LEADER_18_QUOTE",
                minScore: 500,
                maxScore: 599
            ),
            VictoryRankingViewModel(
                index: 19,
                name: "TXT_KEY_LEADER_19_NAME",
                quote: "TXT_KEY_LEADER_19_QUOTE",
                minScore: 400,
                maxScore: 499
            ),
            VictoryRankingViewModel(
                index: 20,
                name: "TXT_KEY_LEADER_20_NAME",
                quote: "TXT_KEY_LEADER_20_QUOTE",
                minScore: 300,
                maxScore: 399
            ),
            VictoryRankingViewModel(
                index: 21,
                name: "TXT_KEY_LEADER_21_NAME",
                quote: "TXT_KEY_LEADER_21_QUOTE",
                minScore: 0,
                maxScore: 299
            )
        ]

        // charts
        self.graphData = ScoreData(lines: [])
        self.legendData = ScoreLegendViewModel(legendItemViewModels: [])
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

        case .domination, .conquest:
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

        // ranking tab
        let score = humanPlayer.score(for: gameModel)
        if let selectedVictoryRankingViewModel = self.victoryRankingViewModels.first(where: { $0.minScore < score && score < $0.maxScore }) {
            selectedVictoryRankingViewModel.selected = true
        }

        if humanPlayer.leader == victoryLeader {

            // victory of human player
            self.title = "Victory"
            self.civilizationTitle = "of the \(victoryLeader.civilization().name()) empire"

            // info tab
            switch victoryType {

            case .domination, .conquest:
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

    func updateGraphLegend() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        self.legendData = ScoreLegendViewModel(
            legendItemViewModels: gameModel.players
                .filter { !$0.isBarbarian() && !$0.isFreeCity() }
                .map {
                    ScoreLegendDataItem(
                        name: $0.leader.name(),
                        accent: $0.leader.civilization().accent,
                        main: $0.leader.civilization().main
                    )
                }
            )
    }

    func updateGraph() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        let type: RankingDataType = RankingDataType.all[self.selectedGraphValueIndex]

        var lines: [ScoreDataLine] = []

        for player in gameModel.players {

            if player.isBarbarian() || player.isFreeCity() {
                continue
            }

            let colors: [NSColor] = [player.leader.civilization().accent, player.leader.civilization().main]
            let values: [Double] = gameModel.rankingData.data(type: type, for: player.leader)
            let line: ScoreDataLine = ScoreDataLine(colors: colors, values: values)
            lines.append(line)
        }

        self.graphData = ScoreData(lines: lines)
    }

    func set(detailType: VictoryDialogDetailType) {

        self.detailType = detailType

        if self.detailType == .graphs {

            self.updateGraph()
            self.updateGraphLegend()
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
        self.delegate?.closeGame()
    }
}
