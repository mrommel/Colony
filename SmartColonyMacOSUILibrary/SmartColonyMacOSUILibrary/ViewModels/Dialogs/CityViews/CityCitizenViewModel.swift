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
        
        if city != nil {
            self.update(for: city)
        }
    }
    
    func update(for city: AbstractCity?) {
        
        self.city = city
        
        // populate values
        if let city = city {
            
            guard let game = self.gameEnvironment.game.value else {
                return
            }
            
            guard let humanPlayer = game.humanPlayer() else {
                fatalError("cant get human player")
            }
            
            guard humanPlayer.leader == city.player?.leader else {
                fatalError("human player not city owner")
            }
            
            self.hexagonGridViewModel.update(for: city, with: game)
        }
    }
}
