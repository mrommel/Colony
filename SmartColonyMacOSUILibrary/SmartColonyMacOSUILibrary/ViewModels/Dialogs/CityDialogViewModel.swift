//
//  CityDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

enum CityDetailViewType {
    
    case production
    case buildings
    case growth
    case citizen
    case religion
    
    static var all: [CityDetailViewType] = [
        .production, .buildings, .growth, .citizen, .religion
    ]
    
    func name() -> String {
        
        switch self {
        
        case .production:
            return "Production"
        case .buildings:
            return "Buildings"
        case .growth:
            return "Growth"
        case .citizen:
            return "Citizen"
        case .religion:
            return "Religion"
        }
    }
}

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
    
    @Published
    var cityDetailViewType: CityDetailViewType = CityDetailViewType.production
    
    @Published
    var productionViewModel: CityProductionViewModel
    
    @Published
    var buildingsViewModel: CityBuildingsViewModel
    
    @Published
    var citizenViewModel: CityCitizenViewModel
    
    @Published
    var growthViewModel: CityGrowthViewModel
    
    @Published
    var religionViewModel: CityReligionViewModel

    private var city: AbstractCity? = nil
    
    weak var delegate: GameViewModelDelegate?
    
    init(city: AbstractCity? = nil) {

        self.scienceYieldViewModel = YieldValueViewModel(yieldType: .science, value: 0.0)
        self.cultureYieldViewModel = YieldValueViewModel(yieldType: .culture, value: 0.0)
        self.foodYieldViewModel = YieldValueViewModel(yieldType: .food, value: 0.0)
        self.productionYieldViewModel = YieldValueViewModel(yieldType: .production, value: 0.0)
        self.goldYieldViewModel = YieldValueViewModel(yieldType: .gold, value: 0.0)
        self.faithYieldViewModel = YieldValueViewModel(yieldType: .faith, value: 0.0)
        
        self.productionViewModel = CityProductionViewModel(city: city)
        self.buildingsViewModel = CityBuildingsViewModel(city: city)
        self.growthViewModel = CityGrowthViewModel(city: city)
        self.citizenViewModel = CityCitizenViewModel(city: city)
        self.religionViewModel = CityReligionViewModel(city: city)
        
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
            
            self.productionViewModel.update(for: city)
            self.buildingsViewModel.update(for: city)
            self.growthViewModel.update(for: city)
            self.citizenViewModel.update(for: city)
            self.religionViewModel.update(for: city)
        }
    }
    
    func show(detail: CityDetailViewType) {
        
        self.cityDetailViewType = detail
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
