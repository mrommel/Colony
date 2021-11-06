//
//  TopBarViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI

protocol TopBarViewModelDelegate: AnyObject {

    func religionClicked()
    func treasuryClicked()
}

public class TopBarViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var scienceYieldValueViewModel: YieldValueViewModel

    @Published
    var cultureYieldValueViewModel: YieldValueViewModel

    @Published
    var faithYieldValueViewModel: YieldValueViewModel

    @Published
    var goldYieldValueViewModel: YieldValueViewModel

    @Published
    var tourismYieldValueViewModel: YieldValueViewModel

    @Published
    var tradeRoutesLabelText: String

    // resources

    @Published
    var horsesValueViewModel: ResourceValueViewModel

    @Published
    var ironValueViewModel: ResourceValueViewModel

    @Published
    var niterValueViewModel: ResourceValueViewModel

    @Published
    var coalValueViewModel: ResourceValueViewModel

    @Published
    var oilValueViewModel: ResourceValueViewModel

    @Published
    var aluminiumValueViewModel: ResourceValueViewModel

    @Published
    var uraniumValueViewModel: ResourceValueViewModel

    @Published
    var turnLabelText: String

    weak var delegate: TopBarViewModelDelegate?

    init() {

        self.scienceYieldValueViewModel = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyDelta)
        self.cultureYieldValueViewModel = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyDelta)
        self.faithYieldValueViewModel = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .valueAndDelta)
        self.goldYieldValueViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .valueAndDelta)
        self.tourismYieldValueViewModel = YieldValueViewModel(yieldType: .tourism, initial: 0.0, type: .onlyValue)

        self.tradeRoutesLabelText = "0/0"

        self.horsesValueViewModel = ResourceValueViewModel(resourceType: .horses, initial: 1)
        self.ironValueViewModel = ResourceValueViewModel(resourceType: .iron, initial: 1)
        self.niterValueViewModel = ResourceValueViewModel(resourceType: .niter, initial: 1)
        self.coalValueViewModel = ResourceValueViewModel(resourceType: .coal, initial: 1)
        self.oilValueViewModel = ResourceValueViewModel(resourceType: .oil, initial: 1)
        self.aluminiumValueViewModel = ResourceValueViewModel(resourceType: .aluminium, initial: 1)
        self.uraniumValueViewModel = ResourceValueViewModel(resourceType: .uranium, initial: 1)

        self.turnLabelText = "-"

        self.scienceYieldValueViewModel.delta = 0.0
        self.cultureYieldValueViewModel.delta = 0.0
        self.faithYieldValueViewModel.value = 0.0
        self.faithYieldValueViewModel.delta = 0.0
        self.goldYieldValueViewModel.value = 0.0
        self.goldYieldValueViewModel.delta = 0.0
        self.tourismYieldValueViewModel.value = 0.0
    }

    func update() {

        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }

        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }

        self.scienceYieldValueViewModel.delta = humanPlayer.science(in: gameModel)
        self.cultureYieldValueViewModel.delta = humanPlayer.culture(in: gameModel)
        self.faithYieldValueViewModel.value = humanPlayer.religion?.faith() ?? 0.0
        self.faithYieldValueViewModel.delta = humanPlayer.faith(in: gameModel)
        self.goldYieldValueViewModel.value = humanPlayer.treasury?.value() ?? 0.0
        self.goldYieldValueViewModel.delta = humanPlayer.treasury?.calculateGrossGold(in: gameModel) ?? 0.0
        self.tourismYieldValueViewModel.value = humanPlayer.currentTourism(in: gameModel)

        let numberOfTradeRoutes = humanPlayer.numberOfTradeRoutes()
        let tradingCapacity = humanPlayer.tradingCapacity(in: gameModel)
        self.tradeRoutesLabelText = "\(numberOfTradeRoutes)/\(tradingCapacity)"

        self.horsesValueViewModel.value = humanPlayer.numAvailable(resource: .horses)
        self.ironValueViewModel.value = humanPlayer.numAvailable(resource: .iron)
        self.niterValueViewModel.value = humanPlayer.numAvailable(resource: .niter)
        self.coalValueViewModel.value = humanPlayer.numAvailable(resource: .coal)
        self.oilValueViewModel.value = humanPlayer.numAvailable(resource: .oil)
        self.aluminiumValueViewModel.value = humanPlayer.numAvailable(resource: .aluminium)
        self.uraniumValueViewModel.value = humanPlayer.numAvailable(resource: .uranium)

        self.turnLabelText = gameModel.turnYear()
    }

    func religionClicked() {

        self.delegate?.religionClicked()
    }

    func treasuryClicked() {

        self.delegate?.treasuryClicked()
    }
}
