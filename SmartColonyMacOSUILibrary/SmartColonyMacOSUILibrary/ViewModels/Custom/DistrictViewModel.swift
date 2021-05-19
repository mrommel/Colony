//
//  DistrictViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.05.21.
//

import SwiftUI
import SmartAILibrary
import SmartAssets

protocol DistrictViewModelDelegate: AnyObject {
    
    func clicked(on districtType: DistrictType)
}

class DistrictViewModel: ObservableObject {
    
    let districtType: DistrictType
    let turns: Int
    
    var active: Bool
    
    weak var delegate: DistrictViewModelDelegate?
    
    init(districtType: DistrictType, turns: Int = -1, active: Bool) {
        
        self.districtType = districtType
        self.turns = active ? -1 : turns
        
        self.active = active
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.districtType.iconTexture())
    }
    
    func title() -> String {
        
        return self.districtType.name()
    }
    
    func turnsText() -> String {
        
        if self.active {
            return "􀆅"
        } else {
            return "\(self.turns) Turns"
        }
    }
    
    func fontColor() -> Color {
        
        if self.active {
            return .white
        } else {
            return Color(NSColor.UI.districtActive)
        }
    }
    
    func background() -> NSImage {
        
        if self.active {
            return ImageCache.shared.image(for: "grid9-button-district-active")
        } else {
            return ImageCache.shared.image(for: "grid9-button-district")
        }
    }
    
    func clicked() {
        
        self.delegate?.clicked(on: self.districtType)
    }
}
