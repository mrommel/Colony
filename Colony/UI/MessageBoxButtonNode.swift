//
//  MessageBoxButtonNode.swift
//  Colony
//
//  Created by Michael Rommel on 02.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MessageBoxButtonNode: SpriteButtonNode {
    
    init(titled title: String, buttonAction: @escaping () -> Void) {
        
        super.init(titled: title,
                   defaultButtonImage: "grid9_button_active",
                   activeButtonImage: "grid9_button_highlighted",
                   size: CGSize(width: 100, height: 42),
                   buttonAction: buttonAction)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
