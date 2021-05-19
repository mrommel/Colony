//
//  BuildingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

class BuildingViewModel: ObservableObject {
    
    let buildingType: BuildingType
    let turns: Int
    
    init(buildingType: BuildingType, turns: Int) {
        
        self.buildingType = buildingType
        self.turns = turns
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.buildingType.iconTexture())
    }
    
    func title() -> String {
        
        return self.buildingType.name()
    }
    
    func turnsText() -> String {
        
        return "\(self.turns) Turns"
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: "grid9-button-active")
    }
}

extension BuildingViewModel: Hashable {
    
    static func == (lhs: BuildingViewModel, rhs: BuildingViewModel) -> Bool {
        
        return lhs.buildingType == rhs.buildingType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.buildingType)
    }
}
