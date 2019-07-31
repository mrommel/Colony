//
//  IconButtonNode.swift
//  Colony
//
//  Created by Michael Rommel on 30.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class IconButtonNode: SpriteButtonNode {
    
    init(imageNamed imageName: String, sized size: CGSize = CGSize(width: 64, height: 64), buttonAction: @escaping () -> Void) {
        
        super.init(imageNamed: imageName,
                   title: "",
                   defaultButtonImage: "grid9_button_red_active",
                   activeButtonImage: "grid9_button_red_highlighted",
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
