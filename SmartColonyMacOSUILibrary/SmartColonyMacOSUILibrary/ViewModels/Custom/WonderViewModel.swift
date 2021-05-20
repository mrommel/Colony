//
//  WonderViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

protocol WonderViewModelDelegate: AnyObject {
    
    func clicked(on wonderType: WonderType, at index: Int)
}

class WonderViewModel: QueueViewModel, ObservableObject {
    
    let wonderType: WonderType
    let turns: Int
    let index: Int
    
    weak var delegate: WonderViewModelDelegate?
    
    init(wonderType: WonderType, turns: Int, at index: Int = -1) {
        
        self.wonderType = wonderType
        self.turns = turns
        self.index = index
        
        super.init(queueType: .wonder)
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
    
    func clicked() {
        
        self.delegate?.clicked(on: self.wonderType, at: self.index)
    }
}

/*extension WonderViewModel: Hashable {
    
    static func == (lhs: WonderViewModel, rhs: WonderViewModel) -> Bool {
        
        return lhs.wonderType == rhs.wonderType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.wonderType)
    }
}*/
