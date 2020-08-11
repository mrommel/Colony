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
        
        var iconNames: [String] = []
        
        let achievements = civicType.achievements()
        
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
        
        for policyCards in achievements.policyCards {
            iconNames.append(policyCards.iconTexture())
        }
        
        for governmentType in achievements.governments {
            iconNames.append(governmentType.iconTexture())
        }
        
        super.init(texture: self.civicType.iconTexture(), name: self.civicType.name(), iconNames: iconNames, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
