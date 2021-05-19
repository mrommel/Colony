//
//  CityDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

class CityDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var cityName: String = "-"
    
    @Published
    var scienceYieldViewModel: YieldValueViewModel
    
    @Published
    var cultureYieldViewModel: YieldValueViewModel
    
    @Published
    var foodYieldViewModel: YieldValueViewModel
    
    @Published
    var productionYieldViewModel: YieldValueViewModel
    
    @Published
    var goldYieldViewModel: YieldValueViewModel
    
    @Published
    var faithYieldViewModel: YieldValueViewModel

    private var city: AbstractCity? = nil
    
    weak var delegate: GameViewModelDelegate?
    
    init(city: AbstractCity? = nil) {

        self.scienceYieldViewModel = YieldValueViewModel(yieldType: .science, value: 0.0)
        self.cultureYieldViewModel = YieldValueViewModel(yieldType: .culture, value: 0.0)
        self.foodYieldViewModel = YieldValueViewModel(yieldType: .food, value: 0.0)
        self.productionYieldViewModel = YieldValueViewModel(yieldType: .production, value: 0.0)
        self.goldYieldViewModel = YieldValueViewModel(yieldType: .gold, value: 0.0)
        self.faithYieldViewModel = YieldValueViewModel(yieldType: .faith, value: 0.0)
        
        if city != nil {
            self.update(for: city)
        }
    }
    
    func update(for city: AbstractCity?) {
        
        self.city = city
        
        // populate values
        if let city = city {
            
            self.cityName = city.name
            
            guard let game = self.gameEnvironment.game.value else {
                return
            }
            
            self.scienceYieldViewModel.value = city.sciencePerTurn(in: game)
            self.cultureYieldViewModel.value = city.culturePerTurn(in: game)
            self.foodYieldViewModel.value = city.foodPerTurn(in: game)
            self.productionYieldViewModel.value = city.productionPerTurn(in: game)
            self.goldYieldViewModel.value = city.goldPerTurn(in: game)
            self.faithYieldViewModel.value = city.faithPerTurn(in: game)
        }
        
        /*guard let game = self.gameEnvironment.game.value else {
            return
        }
        
        guard let humanPlayer = game.humanPlayer() else {
            fatalError("cant get human player")
        }
        
        // ???
         */
    }
    
    func showManageProductionDialog() {
        
        self.delegate?.closeDialog()
        self.delegate?.showCityChooseProductionDialog(for: self.city)
    }
    
    func showBuildingsDialog() {
        
    }
    
    func showGrowthDialog() {
        
    }
    
    func showManageCitizenDialog() {
            
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
