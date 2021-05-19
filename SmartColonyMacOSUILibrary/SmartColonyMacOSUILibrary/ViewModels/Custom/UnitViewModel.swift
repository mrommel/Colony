//
//  UnitViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

class UnitViewModel: ObservableObject {
    
    let unitType: UnitType
    let turns: Int
    
    init(unitType: UnitType, turns: Int) {
        
        self.unitType = unitType
        self.turns = turns
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.unitType.typeTexture())
    }
    
    func title() -> String {
        
        return self.unitType.name()
    }
    
    func turnsText() -> String {
        
        return "\(self.turns) Turns"
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: "grid9-button-active")
    }
}

extension UnitViewModel: Hashable {
    
    static func == (lhs: UnitViewModel, rhs: UnitViewModel) -> Bool {
        
        return lhs.unitType == rhs.unitType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.unitType)
    }
}
