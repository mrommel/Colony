//
//  MenuButton.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MenuButtonNode: SpriteButtonNode {

    init(titled title: String, buttonAction: @escaping () -> Void) {
        
        super.init(titled: title,
                   defaultButtonImage: "button_normal",
                   activeButtonImage: "button_selected",
                   buttonAction: buttonAction)
    }

    /**
     Required so XCode doesn't throw warnings
     */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
