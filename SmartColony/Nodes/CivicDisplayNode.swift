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
        
        super.init(texture: self.civicType.iconTexture(), name: self.civicType.name(), cost: civicType.cost(), size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
