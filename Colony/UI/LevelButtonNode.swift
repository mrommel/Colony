//
//  LevelButtonNode.swift
//  Colony
//
//  Created by Michael Rommel on 14.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class LevelButtonNode: SpriteButtonNode {
    
    init(titled title: String, difficulty: LevelDifficulty, buttonAction: @escaping () -> Void) {
        
        super.init(titled: title,
                   defaultButtonImage: difficulty.buttonName,
                   activeButtonImage: difficulty.buttonName,
                   size: CGSize(width: 50, height: 50),
                   isNineGrid: false,
                   buttonAction: buttonAction)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
