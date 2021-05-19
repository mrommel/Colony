//
//  WonderViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

class WonderViewModel: ObservableObject {
    
    let wonderType: WonderType
    let turns: Int
    
    init(wonderType: WonderType, turns: Int) {
        
        self.wonderType = wonderType
        self.turns = turns
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.wonderType.iconTexture())
    }
    
    func title() -> String {
        
        return self.wonderType.name()
    }
    
    func turnsText() -> String {
        
        return "\(self.turns) Turns"
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: "grid9-button-active")
    }
}

extension WonderViewModel: Hashable {
    
    static func == (lhs: WonderViewModel, rhs: WonderViewModel) -> Bool {
        
        return lhs.wonderType == rhs.wonderType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.wonderType)
    }
}
