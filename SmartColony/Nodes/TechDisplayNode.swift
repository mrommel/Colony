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
        
        super.init(texture: self.techType.iconTexture(), name: self.techType.name(), cost: self.techType.cost(), size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
