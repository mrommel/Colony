//
//  SelectTradeCityDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.07.21.
//

import SwiftUI
import SmartAILibrary

class SelectTradeCityDialogViewModel: ObservableObject {
    
    typealias CityCompletionBlock = (AbstractCity?) -> Void
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    weak var delegate: GameViewModelDelegate?
    
    @Published
    var title: String
    
    @Published
    var question: String
    
    @Published
    var targetCityViewModels: [TradeCityViewModel] = []
    
    var completion: CityCompletionBlock? = nil
    var selectedCity: AbstractCity? = nil
    
    init() {
        
        self.title = "From"
        self.question = "Select a Trade Route Destination."
    }
    
#if DEBUG
    init(cities: [AbstractCity?]) {
            
        self.title = "From"
        self.question = "Select a Trade Route Destination."
        self.buildCityModels(for: cities)
    }
#endif
    
    func update(start startCity: AbstractCity?, of cities: [AbstractCity?], completion: @escaping CityCompletionBlock) {

        if let city = startCity {
            self.title = "\(city) to ..."
        }

        self.buildCityModels(for: cities)
    }

    private func buildCityModels(for cities: [AbstractCity?]) {
        
        var targetCityViewModels: [TradeCityViewModel] = []
        
        for cityRef in cities {
            
            guard let city = cityRef else {
                continue
            }
            
            let cityViewModel = TradeCityViewModel(city: city)
            cityViewModel.delegate = self
            targetCityViewModels.append(cityViewModel)
        }
        
        self.targetCityViewModels = targetCityViewModels
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
        self.completion?(self.selectedCity)
    }
}

extension SelectTradeCityDialogViewModel: TradeCityViewModelDelegate {

    func selected(city: AbstractCity?) {
        
        self.selectedCity = city
    }
}
