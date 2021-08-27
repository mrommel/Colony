//
//  HorizontalLineNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

class HorizontalLineNode: SKSpriteNode {

    init(size: CGSize) {

        let texture = SKTexture(imageNamed: "horizontal_line")
        super.init(texture: texture, color: SKColor.black, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
