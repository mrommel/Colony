//
//  HeaderViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.09.21.
//

import SwiftUI
import SmartAssets
import SmartAILibrary

class HeaderViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    // MARK: header view models

    @Published
    var scienceHeaderViewModel: HeaderButtonViewModel

    @Published
    var cultureHeaderViewModel: HeaderButtonViewModel

    @Published
    var governmentHeaderViewModel: HeaderButtonViewModel

    @Published
    var religionHeaderViewModel: HeaderButtonViewModel

    @Published
    var greatPeopleHeaderViewModel: HeaderButtonViewModel

    @Published
    var logHeaderViewModel: HeaderButtonViewModel

    @Published
    var governorsHeaderViewModel: HeaderButtonViewModel

    @Published
    var rankingHeaderViewModel: HeaderButtonViewModel

    @Published
    var tradeRoutesHeaderViewModel: HeaderButtonViewModel

    @Published
    var techProgressViewModel: TechProgressViewModel

    @Published
    var civicProgressViewModel: CivicProgressViewModel

    @Published
    var leaderViewModels: [LeaderViewModel]

    weak var delegate: GameViewModelDelegate?

    private var displayedTechType: TechType = .none
    private var displayedTechProgress: Double = 0.0

    init() {

        self.scienceHeaderViewModel = HeaderButtonViewModel(type: .science)
        self.cultureHeaderViewModel = HeaderButtonViewModel(type: .culture)
        self.governmentHeaderViewModel = HeaderButtonViewModel(type: .government)
        self.religionHeaderViewModel = HeaderButtonViewModel(type: .religion)
        self.greatPeopleHeaderViewModel = HeaderButtonViewModel(type: .greatPeople)
        self.logHeaderViewModel = HeaderButtonViewModel(type: .log)
        self.governorsHeaderViewModel = HeaderButtonViewModel(type: .governors)
        self.rankingHeaderViewModel = HeaderButtonViewModel(type: .ranking)
        self.tradeRoutesHeaderViewModel = HeaderButtonViewModel(type: .tradeRoutes)

        self.techProgressViewModel = TechProgressViewModel()
        self.civicProgressViewModel = CivicProgressViewModel()

        self.leaderViewModels = []

        // connect delegates
        self.scienceHeaderViewModel.delegate = self
        self.cultureHeaderViewModel.delegate = self
        self.governmentHeaderViewModel.delegate = self
        self.religionHeaderViewModel.delegate = self
        self.greatPeopleHeaderViewModel.delegate = self
        self.logHeaderViewModel.delegate = self
        self.governorsHeaderViewModel.delegate = self
        self.rankingHeaderViewModel.delegate = self
        self.tradeRoutesHeaderViewModel.delegate = self
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human")
        }

        guard let diplomacyAI = humanPlayer.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        self.logHeaderViewModel.active = false
        self.governorsHeaderViewModel.alert = (humanPlayer.governors?.numTitlesAvailable() ?? 0) > 0
        self.greatPeopleHeaderViewModel.alert = humanPlayer.canRecruitGreatPerson(in: gameModel)

        if let techs = humanPlayer.techs {
            if let currentTech = techs.currentTech() {

                if self.displayedTechType != currentTech || self.displayedTechProgress < techs.currentScienceProgress() {

                    let progressPercentage: Int = Int(techs.currentScienceProgress() / Double(currentTech.cost()) * 100.0)
                    let sciencePerTurn = humanPlayer.science(in: gameModel)
                    let turns: Int = sciencePerTurn > 0.0 ? Int((Double(currentTech.cost()) - techs.currentScienceProgress()) / sciencePerTurn) : 0
                    let boosted: Bool = techs.eurekaTriggered(for: currentTech)
                    self.techProgressViewModel.update(
                        techType: currentTech,
                        progress: progressPercentage,
                        turns: turns,
                        boosted: boosted
                    )

                    self.displayedTechType = currentTech
                    self.displayedTechProgress = techs.currentScienceProgress()
                }
            } else {
                self.techProgressViewModel.update(techType: .none, progress: 0, turns: 0, boosted: false)
            }
        }

        if let civics = humanPlayer.civics {
            if let currentCivic = civics.currentCivic() {

                let progressPercentage: Int = Int(civics.currentCultureProgress() / Double(currentCivic.cost()) * 100.0)
                let culturePerTurn = humanPlayer.culture(in: gameModel)
                let turns: Int = culturePerTurn > 0.0 ? Int((Double(currentCivic.cost()) - civics.currentCultureProgress()) / culturePerTurn) : 0
                let boosted: Bool = civics.eurekaTriggered(for: currentCivic)
                self.civicProgressViewModel.update(civicType: currentCivic, progress: progressPercentage, turns: turns, boosted: boosted)
            } else {
                self.civicProgressViewModel.update(civicType: .none, progress: 0, turns: 0, boosted: false)
            }
        }

        var tmpLeaderViewModels: [LeaderViewModel] = []

        for player in gameModel.players {

            if humanPlayer.isEqual(to: player) {
                continue
            }

            if diplomacyAI.hasMet(with: player) {

                let leaderViewModel = LeaderViewModel(leaderType: player.leader)
                leaderViewModel.delegate = self
                tmpLeaderViewModels.append(leaderViewModel)
            }
        }

        self.leaderViewModels = tmpLeaderViewModels
    }
}

extension HeaderViewModel: HeaderButtonViewModelDelegate {

    func clicked(on type: HeaderButtonType) {

        switch type {

        case .science:
            self.delegate?.showTechListDialog()
        case .culture:
            self.delegate?.showCivicListDialog()
        case .government:
            self.delegate?.showGovernmentDialog()
        case .religion:
            self.delegate?.showReligionDialog()
        case .greatPeople:
            self.delegate?.showGreatPeopleDialog()
        case .log:
            print("log")
        case .governors:
            self.delegate?.showGovernorsDialog()
        case .ranking:
            self.delegate?.showRankingDialog()
        case .tradeRoutes:
            self.delegate?.showTradeRouteDialog()
        }
    }
}

extension HeaderViewModel: LeaderViewModelDelegate {

    func clicked(on leaderType: LeaderType) {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        let otherPlayer = gameModel.player(for: leaderType)

        let state = DiplomaticRequestState.blankDiscussion
        let message = DiplomaticRequestMessage.messageIntro
        let emotion = LeaderEmotionType.neutral
        let data = DiplomaticData(state: state, message: message, emotion: emotion)

        self.delegate?.showDiplomaticDialog(with: otherPlayer, data: data, deal: nil)
    }
}
