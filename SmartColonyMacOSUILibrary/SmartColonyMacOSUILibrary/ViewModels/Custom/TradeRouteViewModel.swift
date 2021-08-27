//
//  TradeRouteViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI
import SmartAILibrary

class TradeRouteViewModel: ObservableObject, Identifiable {

    let id: UUID = UUID()

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var title: String

    @Published
    var foodYieldViewModel: YieldValueViewModel

    @Published
    var productionYieldViewModel: YieldValueViewModel

    @Published
    var goldYieldViewModel: YieldValueViewModel

    @Published
    var remainingTurns: String

    init(title: String, yields: Yields, remainingTurns: Int) {

        self.title = title
        self.foodYieldViewModel = YieldValueViewModel(
            yieldType: .food,
            initial: 0.0,
            type: .onlyValue,
            withBackground: false
        )
        self.productionYieldViewModel = YieldValueViewModel(
            yieldType: .production,
            initial: 0.0,
            type: .onlyValue,
            withBackground: false
        )
        self.goldYieldViewModel = YieldValueViewModel(
            yieldType: .gold,
            initial: 0.0,
            type: .onlyValue,
            withBackground: false
        )
        self.remainingTurns = "0"

        /*guard let gameModel = self.gameEnvironment.game.value else {
            // fatalError("cant get game")
            return
        }

        guard let tradeRouteData = unit?.tradeRouteData() else {
            fatalError("unit has no trade route data")
        }

        guard let startCity = tradeRouteData.startCity(in: gameModel) else {
            fatalError("cant get start city")
        }

        guard let endCity = tradeRouteData.endCity(in: gameModel) else {
            fatalError("cant get end city")
        }*/

        self.foodYieldViewModel.value = yields.food
        self.productionYieldViewModel.value = yields.production
        self.goldYieldViewModel.value = yields.gold

        if remainingTurns <= 0 {
            self.remainingTurns = "expired"
        } else {
            self.remainingTurns = "\(remainingTurns)"
        }
    }
}

extension TradeRouteViewModel: Hashable {

    static func == (lhs: TradeRouteViewModel, rhs: TradeRouteViewModel) -> Bool {

        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.id)
    }
}
