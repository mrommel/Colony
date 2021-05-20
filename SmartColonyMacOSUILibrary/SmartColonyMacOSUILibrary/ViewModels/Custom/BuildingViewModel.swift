//
//  BuildingViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary

protocol BuildingViewModelDelegate: AnyObject {
    
    func clicked(on buildingType: BuildingType, at index: Int)
}

class BuildingViewModel: QueueViewModel, ObservableObject {
    
    let buildingType: BuildingType
    let turns: Int
    let index: Int
    
    weak var delegate: BuildingViewModelDelegate?
    
    init(buildingType: BuildingType, turns: Int, at index: Int = -1) {
        
        self.buildingType = buildingType
        self.turns = turns
        self.index = index
        
        super.init(queueType: .building)
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
    
    func clicked() {
        
        self.delegate?.clicked(on: self.buildingType, at: self.index)
    }
}

/*extension BuildingViewModel: Hashable {
    
    static func == (lhs: BuildingViewModel, rhs: BuildingViewModel) -> Bool {
        
        return lhs.buildingType == rhs.buildingType
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(self.buildingType)
    }
}*/
