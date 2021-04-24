//
//  UnitLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SmartAILibrary
import SwiftUI

class UnitItem: ObservableObject, Identifiable, Equatable {
    
    var id = UUID()
    
    @Published
    var name: String
    
    @Published
    var type: UnitType
    
    @Published
    var location: CGPoint
    
    init(name: String, type: UnitType, location: CGPoint) {
        self.name = name
        self.type = type
        self.location = location
    }
    
    static func == (lhs: UnitItem, rhs: UnitItem) -> Bool {
        return lhs.id == rhs.id
    }
}

class UnitLayerViewModel: BaseLayerViewModel {
    
    @Published
    var units: [UnitItem] = []
    
    override func update(from game: GameModel?, showCompleteMap: Bool) {
        
        guard let game = game else {
            return
        }
        
        if self.size == .zero {
            self.updateSizeAndShift(from: game)
        }
        
        for player in game.players {
            
            for unitRef in game.units(of: player) {
                
                /*guard let unit = unitRef else {
                 continue
                 }
                 
                 //let screenPoint = (HexPoint.toScreen(hex: unit.location) * self.factor) + self.shift
                 //let tileRect = CGRect(x: screenPoint.x, y: screenPoint.y, width: 48 * self.factor, height: 48 * self.factor)
                 */
                
                self.show(unit: unitRef, in: game)
            }
        }
        
    }
    
    func show(unit: AbstractUnit?, in game: GameModel?) {
        
        guard let human = game?.humanPlayer() else {
            return
        }
        
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        if let tile = game?.tile(at: unit.location) {
            
            if !tile.isVisible(to: human) {
                
                return
            }
        }
        
        var screenPoint = (HexPoint.toScreen(hex: unit.location) * self.factor) + self.shift
        
        screenPoint.y = size.height - screenPoint.y - 144
        
        // debug
        print("add \(unit.name()) at \(unit.location)")
        if unit.type != .builder {
            return
        }
        
        self.units.append(UnitItem(name: unit.name(), type: unit.type, location: screenPoint))
    }
}
