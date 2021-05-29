//
//  HexagonGridViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.05.21.
//

import SwiftUI
import SmartAILibrary

class HexagonGridViewModel: ObservableObject {
    
    @Published
    var hexagonViewModels: [HexagonViewModel] = []
    
    @Published
    var focused: CGSize = .zero

    init(gameModel: GameModel? = nil) {
        
        if gameModel != nil {
            self.update(for: nil, with: gameModel)
        }
    }
    
    func update(for city: AbstractCity?, with gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        if let city = city {
            
            let screenPoint = HexPoint.toScreen(hex: city.location)
            self.focused = CGSize(fromPoint: CGPoint(x: -screenPoint.x, y: screenPoint.y))
        }
        
        let mapSize = gameModel.mapSize()
        
        for y in 0..<mapSize.height() {
            for x in 0..<mapSize.width() {
                
                guard let tile = gameModel.tile(x: x, y: y) else {
                    continue
                }

                let hexagonViewModel = HexagonViewModel(tile: tile)
                hexagonViewModel.delegate = self
                self.hexagonViewModels.append(hexagonViewModel)
            }
        }
    }
}

extension HexagonGridViewModel: HexagonViewModelDelegate {
    
    func clicked(on point: HexPoint) {
        print("clicked on \(point)")
    }
}
