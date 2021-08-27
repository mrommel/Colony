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
            initial: yields.food,
            type: .onlyValue,
            withBackground: false
        )
        self.productionYieldViewModel = YieldValueViewModel(
            yieldType: .production,
            initial: yields.production,
            type: .onlyValue,
            withBackground: false
        )
        self.goldYieldViewModel = YieldValueViewModel(
            yieldType: .gold,
            initial: yields.gold,
            type: .onlyValue,
            withBackground: false
        )

        if remainingTurns == Int.max {
            self.remainingTurns = ""
        } else if remainingTurns <= 0 {
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
