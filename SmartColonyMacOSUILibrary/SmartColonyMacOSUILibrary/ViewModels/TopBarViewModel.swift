//
//  TopBarViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 23.06.21.
//

import SwiftUI

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
    var turnLabelText: String

    init() {

        self.scienceYieldValueViewModel = YieldValueViewModel(yieldType: .science, initial: 0.0, type: .onlyDelta)
        self.cultureYieldValueViewModel = YieldValueViewModel(yieldType: .culture, initial: 0.0, type: .onlyDelta)
        self.faithYieldValueViewModel = YieldValueViewModel(yieldType: .faith, initial: 0.0, type: .valueAndDelta)
        self.goldYieldValueViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .valueAndDelta)

        self.turnLabelText = "-"

        self.scienceYieldValueViewModel.delta = 0.0
        self.cultureYieldValueViewModel.delta = 0.0
        self.faithYieldValueViewModel.value = 0.0
        self.faithYieldValueViewModel.delta = 0.0
        self.goldYieldValueViewModel.value = 0.0
        self.goldYieldValueViewModel.delta = 0.0
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

        self.turnLabelText = gameModel.turnYear()
    }
}
