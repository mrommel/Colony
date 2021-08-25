//
//  TradeRoutesDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 25.08.21.
//

import SwiftUI
import SmartAILibrary

enum TradeRoutesViewType {
    
    case myRoutes
    case foreign
    case available
}

class TradeRoutesDialogViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var viewType: TradeRoutesViewType = .myRoutes
    
    @Published
    var tradeRouteViewModels: [TradeRouteViewModel] = []
    
    weak var delegate: GameViewModelDelegate?
    
    init() {
        
    }
    
    func update() {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game")
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            fatalError("cant get human player")
        }
        
        guard let tradeRoutes = humanPlayer.tradeRoutes else {
            fatalError("cant get trade routes")
        }
        
        for index in 0..<tradeRoutes.numberOfTradeRoutes() {
            
            guard let tradeRoute = tradeRoutes.tradeRoute(at: index) else {
                continue
            }
            
            let tradeRouteViewModel = TradeRouteViewModel(tradeRoute: tradeRoute)
            tradeRouteViewModels.append(tradeRouteViewModel)
        }
    }
    
    func select(viewType: TradeRoutesViewType) {
        
        self.viewType = viewType
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
