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
    var momentsHeaderViewModel: HeaderButtonViewModel

    @Published
    var governorsHeaderViewModel: HeaderButtonViewModel

    @Published
    var rankingHeaderViewModel: HeaderButtonViewModel

    @Published
    var cityStateHeaderViewModel: HeaderButtonViewModel

    @Published
    var tradeRoutesHeaderViewModel: HeaderButtonViewModel

    @Published
    var eraProgressHeaderViewModel: HeaderButtonViewModel

    @Published
    var techProgressViewModel: TechProgressViewModel

    @Published
    var civicProgressViewModel: CivicProgressViewModel

    @Published
    var leaderViewModels: [LeaderViewModel]

    weak var delegate: GameViewModelDelegate?

    private var displayedTechType: TechType = .none
    private var displayedTechProgress: Double = 0.0

    private var displayedCivicType: CivicType = .none
    private var displayedCivicProgress: Double = 0.0

    init() {

        self.scienceHeaderViewModel = HeaderButtonViewModel(type: .science)
        self.cultureHeaderViewModel = HeaderButtonViewModel(type: .culture)
        self.governmentHeaderViewModel = HeaderButtonViewModel(type: .government)
        self.religionHeaderViewModel = HeaderButtonViewModel(type: .religion)
        self.greatPeopleHeaderViewModel = HeaderButtonViewModel(type: .greatPeople)
        self.momentsHeaderViewModel = HeaderButtonViewModel(type: .moments)
        self.governorsHeaderViewModel = HeaderButtonViewModel(type: .governors)
        self.rankingHeaderViewModel = HeaderButtonViewModel(type: .ranking)
        self.cityStateHeaderViewModel = HeaderButtonViewModel(type: .cityStates)
        self.tradeRoutesHeaderViewModel = HeaderButtonViewModel(type: .tradeRoutes)
        self.eraProgressHeaderViewModel = HeaderButtonViewModel(type: .eraProgress)

        self.techProgressViewModel = TechProgressViewModel()
        self.civicProgressViewModel = CivicProgressViewModel()

        self.leaderViewModels = []

        // connect delegates
        self.scienceHeaderViewModel.delegate = self
        self.cultureHeaderViewModel.delegate = self
        self.governmentHeaderViewModel.delegate = self
        self.religionHeaderViewModel.delegate = self
        self.greatPeopleHeaderViewModel.delegate = self
        self.momentsHeaderViewModel.delegate = self
        self.governorsHeaderViewModel.delegate = self

        self.rankingHeaderViewModel.delegate = self
        self.cityStateHeaderViewModel.delegate = self
        self.tradeRoutesHeaderViewModel.delegate = self
        self.eraProgressHeaderViewModel.delegate = self
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

                if self.displayedCivicType != currentCivic || self.displayedCivicProgress < civics.currentCultureProgress() {

                    let progressPercentage: Int = Int(civics.currentCultureProgress() / Double(currentCivic.cost()) * 100.0)
                    let culturePerTurn = humanPlayer.culture(in: gameModel)
                    let turns: Int = culturePerTurn > 0.0 ? Int((Double(currentCivic.cost()) - civics.currentCultureProgress()) / culturePerTurn) : 0
                    let boosted: Bool = civics.inspirationTriggered(for: currentCivic)
                    self.civicProgressViewModel.update(
                        civicType: currentCivic,
                        progress: progressPercentage,
                        turns: turns,
                        boosted: boosted
                    )

                    self.displayedCivicType = currentCivic
                    self.displayedCivicProgress = civics.currentCultureProgress()
                }
            } else {
                self.civicProgressViewModel.update(civicType: .none, progress: 0, turns: 0, boosted: false)
            }
        }

        if self.leaderViewModels.isEmpty {

            var tmpLeaderViewModels: [LeaderViewModel] = []

            for player in gameModel.players {

                let leaderViewModel = LeaderViewModel(leaderType: player.leader)
                leaderViewModel.show = false
                leaderViewModel.delegate = self
                tmpLeaderViewModels.append(leaderViewModel)
            }

            self.leaderViewModels = tmpLeaderViewModels
        }

        for (index, player) in gameModel.players.enumerated() {

            if player.isMinorCiv() || player.isBarbarian() || player.isFreeCity() {
                continue
            }

            if humanPlayer.isEqual(to: player) || !diplomacyAI.hasMet(with: player) {
                self.leaderViewModels[index].show = false
            } else {
                self.leaderViewModels[index].update()
                self.leaderViewModels[index].show = true
            }
        }
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
        case .moments:
            self.delegate?.showMomentsDialog()
        case .governors:
            self.delegate?.showGovernorsDialog()

        case .ranking:
            self.delegate?.showRankingDialog()
        case .cityStates:
            self.delegate?.showCityStateDialog()
        case .tradeRoutes:
            self.delegate?.showTradeRouteDialog()
        case .eraProgress:
            self.delegate?.showEraProgressDialog()
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
