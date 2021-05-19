//
//  TechViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.05.21.
//

import SwiftUI
import SmartAILibrary

enum TechTypeState {
    
    case researched
    case selected
    case possible
    case disabled
    
    func backgroundTexture() -> String {
        
        switch self {
        
        case .researched:
            return "techInfo-researched"
        case .selected:
            return "techInfo-researching"
        case .possible:
            return "techInfo-active"
        case .disabled:
            return "techInfo-disabled"
        }
    }
}

protocol TechViewModelDelegate: AnyObject {
    
    func selected(tech: TechType)
}

class TechViewModel: ObservableObject, Identifiable {
    
    let id: UUID = UUID()
    
    var techType: TechType
    
    @Published
    var state: TechTypeState
    
    let boosted: Bool
    let turns: Int
    
    weak var delegate: TechViewModelDelegate?
    
    init(techType: TechType, state: TechTypeState, boosted: Bool, turns: Int) {
        
        self.techType = techType
        self.state = state
        self.boosted = boosted
        self.turns = turns
    }
    
    func title() -> String {
        
        return self.techType.name()
    }
    
    func icon() -> NSImage {
        
        return ImageCache.shared.image(for: self.techType.iconTexture())
    }
    
    func background() -> NSImage {
        
        return ImageCache.shared.image(for: self.state.backgroundTexture()).resize(withSize: NSSize(width: 42, height: 42))!
    }
    
    func achievements() -> [NSImage] {
        
        var iconTextureNames: [String] = []
        
        let achievements = self.techType.achievements()
        
        for buildingType in achievements.buildingTypes {
            iconTextureNames.append(buildingType.iconTexture())
        }

        for unitType in achievements.unitTypes {
            iconTextureNames.append(unitType.typeTexture())
        }

        for wonderType in achievements.wonderTypes {
            iconTextureNames.append(wonderType.iconTexture())
        }

        for buildType in achievements.buildTypes {
            iconTextureNames.append(buildType.iconTexture())
        }
        
        for districtType in achievements.districtTypes {
            iconTextureNames.append(districtType.iconTexture())
        }
        
        return iconTextureNames.map { ImageCache.shared.image(for: $0) }
    }
    
    func turnsText() -> String {
        
        if self.turns == -1 {
            return ""
        }
        
        return "Turns \(self.turns)"
    }
    
    func boostText() -> String {
        
        if self.techType.eurekaSummary() == "" {
            return ""
        }
        
        if self.boosted {
            return "Boosted: " + self.techType.eurekaSummary()
        } else {
            return "To boost: " + self.techType.eurekaSummary()
        }
    }
    
    func selectTech() {
        
        self.delegate?.selected(tech: self.techType)
    }
}
