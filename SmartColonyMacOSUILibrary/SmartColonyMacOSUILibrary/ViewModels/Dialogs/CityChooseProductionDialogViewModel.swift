//
//  CityChooseProductionDialogViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

class CityChooseProductionDialogViewModel: ObservableObject {
    
    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment
    
    @Published
    var cityName: String = "-"
    
    private var city: AbstractCity? = nil
    
    weak var delegate: GameViewModelDelegate?
    
    init(city: AbstractCity? = nil) {

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
        }
    }
    
    func closeDialog() {
        
        self.delegate?.closeDialog()
    }
}
