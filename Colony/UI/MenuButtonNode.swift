//
//  MenuButton.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MenuButtonNode: SpriteButtonNode {

    init(titled title: String, sized size: CGSize = CGSize(width: 200, height: 42), buttonAction: @escaping () -> Void) {
        
        super.init(titled: title,
                   defaultButtonImage: "grid9_button_active",
                   activeButtonImage: "grid9_button_highlighted",
                   size: size,
                   buttonAction: buttonAction)
    }
    
    init(imageNamed imageName: String, title: String, sized size: CGSize = CGSize(width: 200, height: 42), buttonAction: @escaping () -> Void) {
        
        super.init(imageNamed: imageName,
                   title: title,
                   defaultButtonImage: "grid9_button_active",
                   activeButtonImage: "grid9_button_highlighted",
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
