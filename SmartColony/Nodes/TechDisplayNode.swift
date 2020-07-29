//
//  TechDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class TechDisplayNode: BaseDisplayNode {
    
    let techType: TechType
    
    init(techType: TechType, size: CGSize) {
        
        self.techType = techType
        
        var iconNames: [String] = []
        
        let achievements = techType.achievements()
        
        for buildingType in achievements.buildingTypes {
            iconNames.append(buildingType.iconTexture())
        }

        for unitType in achievements.unitTypes {
            iconNames.append(unitType.iconTexture())
        }

        for wonderType in achievements.wonderTypes {
            iconNames.append(wonderType.iconTexture())
        }

        for buildType in achievements.buildTypes {
            iconNames.append(buildType.iconTexture())
        }
        
        super.init(texture: self.techType.iconTexture(), name: self.techType.name(), iconNames: iconNames, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
