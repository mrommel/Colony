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
    let showYields: Bool
    
    weak var delegate: BuildingViewModelDelegate?
    
    init(buildingType: BuildingType, turns: Int, showYields: Bool = false, at index: Int = -1) {
        
        self.buildingType = buildingType
        self.turns = turns
        self.showYields = showYields
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
        
        if self.showYields {
            return ""
        }
        
        return "\(self.turns)"
    }
    
    func turnsIcon() -> NSImage {
        
        return ImageCache.shared.image(for: "turns")
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: "grid9-button-active")
    }
    
    func yieldValueViewModels() -> [YieldValueViewModel] {
        
        if !self.showYields {
            return []
        }
        
        let buildingYield = self.buildingType.yields()
        var models: [YieldValueViewModel] = []
        
        for yieldType in YieldType.all {
            
            let yieldValue = buildingYield.value(of: yieldType)
            if yieldValue > 0.0 {
                models.append(YieldValueViewModel(yieldType: yieldType, initial: yieldValue, type: .onlyValue, withBackground: false))
            }
        }
        
        return models
    }
    
    func clicked() {
        
        self.delegate?.clicked(on: self.buildingType, at: self.index)
    }
}
