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
    var minScore: Int

    @Published
    var maxScore: Int

    @Published
    var selected: Bool

    init(index: Int, name: String, minScore: Int, maxScore: Int, selected: Bool = false) {

        self.index = index
        self.name = name
        self.minScore = minScore
        self.maxScore = maxScore
        self.selected = selected
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
            VictoryRankingViewModel(index: 1, name: "August Caesar", minScore: 2500, maxScore: 10000),
            VictoryRankingViewModel(index: 2, name: "Hammurabi", minScore: 2250, maxScore: 2499),
            VictoryRankingViewModel(index: 3, name: "Abraham Lincoln", minScore: 2000, maxScore: 2249),
            VictoryRankingViewModel(index: 4, name: "Winston Churchill", minScore: 1900, maxScore: 1999),
            VictoryRankingViewModel(index: 5, name: "Nelson Mandela", minScore: 1800, maxScore: 1899),
            VictoryRankingViewModel(index: 6, name: "Catheine the Great", minScore: 1700, maxScore: 1799),
            VictoryRankingViewModel(index: 7, name: "Ashoka", minScore: 1600, maxScore: 1699),
            VictoryRankingViewModel(index: 8, name: "Marcus Aurelius", minScore: 1500, maxScore: 1599),
            VictoryRankingViewModel(index: 9, name: "Lech Waleca", minScore: 1400, maxScore: 1499),
            VictoryRankingViewModel(index: 10, name: "Hatshepsut", minScore: 1300, maxScore: 1399),
            VictoryRankingViewModel(index: 11, name: "Charles de Gaulle", minScore: 1200, maxScore: 1299),
            VictoryRankingViewModel(index: 12, name: "Eleanor of Aquitaine", minScore: 1100, maxScore: 1199),
            VictoryRankingViewModel(index: 13, name: "Ivan the Terrible", minScore: 1000, maxScore: 1099),
            VictoryRankingViewModel(index: 14, name: "Herbert Hoover", minScore: 900, maxScore: 999),
            VictoryRankingViewModel(index: 15, name: "Louis XVI", minScore: 800, maxScore: 899),
            VictoryRankingViewModel(index: 16, name: "Neville Chamberlain", minScore: 700, maxScore: 799),
            VictoryRankingViewModel(index: 17, name: "Nero", minScore: 600, maxScore: 699),
            VictoryRankingViewModel(index: 18, name: "Warren G. Harding", minScore: 500, maxScore: 599),
            VictoryRankingViewModel(index: 19, name: "Ethelred the Unready", minScore: 400, maxScore: 499),
            VictoryRankingViewModel(index: 20, name: "May Tudor I", minScore: 300, maxScore: 399),
            VictoryRankingViewModel(index: 21, name: "Dan Quayle", minScore: 0, maxScore: 299)
        ]

        // charts
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

        if humanPlayer.leader == victoryLeader {

            // victory of human player
            self.title = "Victory"
            self.civilizationTitle = "of the \(victoryLeader.civilization().name()) empire"

            let score = humanPlayer.score(for: gameModel)
            if let selectedVictoryRankingViewModel = self.victoryRankingViewModels.first(where: { $0.minScore < score && score < $0.maxScore }) {
                selectedVictoryRankingViewModel.selected = true
            }

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

            self.updateGraph()
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
