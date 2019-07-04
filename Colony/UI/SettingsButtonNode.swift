//
//  SettingsButtonNode.swift
//  Colony
//
//  Created by Michael Rommel on 03.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class SettingsButtonNode: SpriteButtonNode {
    
    init(sized size: CGSize = CGSize(width: 72, height: 72), buttonAction: @escaping () -> Void) {
        
        super.init(titled: "",
                   defaultButtonImage: "settings",
                   activeButtonImage: "settings",
                   size: size,
                   buttonAction: buttonAction)
    }
    
    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
