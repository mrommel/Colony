//
//  UnitViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

protocol UnitViewModelDelegate: AnyObject {
    
    func clicked(on unitType: UnitType, at index: Int)
}

class UnitViewModel: QueueViewModel, ObservableObject {
    
    let unitType: UnitType
    let turns: Int
    let index: Int
    
    weak var delegate: UnitViewModelDelegate?
    
    init(unitType: UnitType, turns: Int, at index: Int = -1) {
        
        self.unitType = unitType
        self.turns = turns
        self.index = index
        
        super.init(queueType: .unit)
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
    
    func clicked() {
        
        self.delegate?.clicked(on: self.unitType, at: self.index)
    }
}

/*extension UnitViewModel: Hashable {
    
    static func == (lhs: UnitViewModel, rhs: UnitViewModel) -> Bool {
        
        return lhs.unitType == rhs.unitType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.unitType)
    }
}*/
