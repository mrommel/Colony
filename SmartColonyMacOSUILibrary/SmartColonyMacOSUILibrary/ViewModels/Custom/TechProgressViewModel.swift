//
//  TechProgressViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 17.05.21.
//

import SwiftUI
import SmartAILibrary

class TechProgressViewModel: ObservableObject {
    
    let tech: TechType
    
    @Published
    var progress: Int
    
    @Published
    var boosted: Bool
    
    init(tech: TechType, progress: Int, boosted: Bool) {
        
        self.tech = tech
        self.progress = progress
        self.boosted = boosted
    }
    
    func title() -> String {
        
        return self.tech.name()
    }
    
    func iconImage() -> NSImage {
        
        return ImageCache.shared.image(for: self.tech.iconTexture())
    }
    
    func progressImage() -> NSImage {
        
        let progress_val = self.progress <= 100 ? self.progress : 100
        
        let textureName = "science_progress_\(progress_val)"
        return ImageCache.shared.image(for: textureName)
    }
    
    func achievements() -> [NSImage] {
        
        var iconTextureNames: [String] = []
        
        let achievements = self.tech.achievements()
        
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
    
    func boostText() -> String {
        
        if self.tech.eurekaSummary() == "" {
            return ""
        }
        
        if self.boosted {
            return "Boosted: " + self.tech.eurekaSummary()
        } else {
            return "To boost: " + self.tech.eurekaSummary()
        }
    }
}
