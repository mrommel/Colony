//
//  CivicDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class CivicDisplayNode: BaseDisplayNode {
    
    let civicType: CivicType
    
    init(civicType: CivicType, size: CGSize) {
        
        self.civicType = civicType
        
        var iconTextures: [SKTexture] = []
        
        let achievements = civicType.achievements()
        
        for buildingType in achievements.buildingTypes {
            iconTextures.append(SKTexture(imageNamed: buildingType.iconTexture()))
        }

        for unitType in achievements.unitTypes {
            iconTextures.append(unitType.iconTexture())
        }

        for wonderType in achievements.wonderTypes {
            iconTextures.append(SKTexture(imageNamed: wonderType.iconTexture()))
        }

        for buildType in achievements.buildTypes {
            iconTextures.append(SKTexture(imageNamed: buildType.iconTexture()))
        }
        
        for policyCards in achievements.policyCards {
            iconTextures.append(SKTexture(imageNamed: policyCards.iconTexture()))
        }
        
        for governmentType in achievements.governments {
            iconTextures.append(SKTexture(imageNamed: governmentType.iconTexture()))
        }
        
        super.init(texture: self.civicType.iconTexture(), name: self.civicType.name(), iconTextures: iconTextures, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
