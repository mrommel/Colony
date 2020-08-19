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
    
    init(techType: TechType, progress: Int, size: CGSize) {
        
        self.techType = techType
        
        var iconTextures: [SKTexture] = []
        
        let achievements = techType.achievements()
        
        for buildingType in achievements.buildingTypes {
            iconTextures.append(SKTexture(imageNamed: buildingType.iconTexture()))
        }

        for unitType in achievements.unitTypes {
            iconTextures.append(SKTexture(imageNamed: unitType.typeTexture()))
        }

        for wonderType in achievements.wonderTypes {
            iconTextures.append(SKTexture(imageNamed: wonderType.iconTexture()))
        }

        for buildType in achievements.buildTypes {
            iconTextures.append(SKTexture(imageNamed: buildType.iconTexture()))
        }
        
        for districtType in achievements.districtTypes {
            iconTextures.append(SKTexture(imageNamed: districtType.iconTexture()))
        }
        
        super.init(texture: self.techType.iconTexture(), type: .science, name: self.techType.name(), progress: progress, iconTextures: iconTextures, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
