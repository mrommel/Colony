//
//  CivicProgressViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 18.05.21.
//

import SwiftUI
import SmartAILibrary

class CivicProgressViewModel: ObservableObject {
    
    let civic: CivicType
    
    @Published
    var progress: Int
    
    @Published
    var boosted: Bool
    
    init(civic: CivicType, progress: Int, boosted: Bool) {
        
        self.civic = civic
        self.progress = progress
        self.boosted = boosted
    }
    
    func title() -> String {
        
        return self.civic.name()
    }
    
    func iconImage() -> NSImage {
        
        return ImageCache.shared.image(for: self.civic.iconTexture())
    }
    
    func progressImage() -> NSImage {
        
        let progress_val = self.progress <= 100 ? self.progress : 100
        
        let textureName = "culture_progress_\(progress_val)"
        return ImageCache.shared.image(for: textureName)
    }
    
    func achievements() -> [NSImage] {
        
        var iconTextureNames: [String] = []
        
        let achievements = self.civic.achievements()
        
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
        
        for policyCardType in achievements.policyCards {
            iconTextureNames.append(policyCardType.iconTexture())
        }
        
        return iconTextureNames.map { ImageCache.shared.image(for: $0) }
    }
    
    func boostText() -> String {
        
        if self.civic.eurekaSummary() == "" {
            return ""
        }
        
        if self.boosted {
            return "Boosted: " + self.civic.eurekaSummary()
        } else {
            return "To boost: " + self.civic.eurekaSummary()
        }
    }
}
