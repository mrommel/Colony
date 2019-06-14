//
//  LevelButtonNode.swift
//  Colony
//
//  Created by Michael Rommel on 14.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class LevelButtonNode: SpriteButtonNode {
    
    init(titled title: String, buttonAction: @escaping () -> Void) {
        
        super.init(titled: title,
                   defaultButtonImage: "level",
                   activeButtonImage: "level",
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
