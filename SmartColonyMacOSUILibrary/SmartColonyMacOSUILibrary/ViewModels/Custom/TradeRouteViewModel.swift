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

    init(tradeRoute: TradeRoute) {

        self.title = "start to end"
        self.foodYieldViewModel = YieldValueViewModel(yieldType: .food, initial: 0.0, type: .onlyValue, withBackground: false)
        self.productionYieldViewModel = YieldValueViewModel(yieldType: .production, initial: 0.0, type: .onlyValue, withBackground: false)
        self.goldYieldViewModel = YieldValueViewModel(yieldType: .gold, initial: 0.0, type: .onlyValue, withBackground: false)
        
        guard let gameModel = self.gameEnvironment.game.value else {
            // fatalError("cant get game")
            return
        }
        
        guard let startCity = tradeRoute.startCity(in: gameModel) else {
            fatalError("cant get start city")
        }
        
        guard let endCity = tradeRoute.endCity(in: gameModel) else {
            fatalError("cant get end city")
        }
        
        let yields = tradeRoute.yields(in: gameModel)
        
        self.title = "\(startCity.name) to \(endCity.name)"
        self.foodYieldViewModel.value = yields.food
        self.productionYieldViewModel.value = yields.production
        self.goldYieldViewModel.value = yields.gold
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
