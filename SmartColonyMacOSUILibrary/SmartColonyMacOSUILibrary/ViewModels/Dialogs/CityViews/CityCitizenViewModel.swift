//
//  CityCitizenViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.05.21.
//

import SwiftUI
import SmartAILibrary

class CityCitizenViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var hexagonGridViewModel: HexagonGridViewModel
    
    private var city: AbstractCity? = nil
    
    init(city: AbstractCity? = nil) {
        
        self.hexagonGridViewModel = HexagonGridViewModel()
        self.hexagonGridViewModel.delegate = self
        
        if city != nil {
            self.update(for: city)
        }
    }
    
    func update(for city: AbstractCity?) {
        
        self.city = city
        
        // populate values
        if let city = city {
            
            guard let gameModel = self.gameEnvironment.game.value else {
                return
            }
            
            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human player")
            }
            
            guard humanPlayer.leader == city.player?.leader else {
                fatalError("human player not city owner")
            }
            
            self.hexagonGridViewModel.update(for: city, with: gameModel)
        }
    }
}

extension CityCitizenViewModel: HexagonGridViewModelDelegate {
    
    func purchaseTile(at point: HexPoint) {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            return
        }
        
        guard let humanPlayer = gameModel.humanPlayer() else {
            return
        }
        
        guard let treasury = humanPlayer.treasury else {
            return
        }
        
        guard let city = self.city else {
            return
        }
        
        let cost: Double = Double(city.buyPlotCost(at: point, in: gameModel))
        
        if treasury.value() > cost {
            print("purchase: \(cost) at \(point)")
            city.doBuyPlot(at: point, in: gameModel)
        } else {
            print("try to buy plot, but treasury does not contain enough money")
        }
        
        self.hexagonGridViewModel.update(for: self.city, with: gameModel)
    }
    
    func forceWorking(on point: HexPoint) {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game model")
        }
        
        print("force working on \(point)")
        
        self.city?.cityCitizens?.forceWorkingPlot(at: point, force: true, in: gameModel)
        
        self.hexagonGridViewModel.update(for: self.city, with: gameModel)
    }
    
    func stopWorking(on point: HexPoint) {
        
        guard let gameModel = self.gameEnvironment.game.value else {
            fatalError("cant get game model")
        }
        
        print("stop working on \(point)")
        
        self.city?.cityCitizens?.forceWorkingPlot(at: point, force: false, in: gameModel)
        
        self.hexagonGridViewModel.update(for: self.city, with: gameModel)
    }
}
