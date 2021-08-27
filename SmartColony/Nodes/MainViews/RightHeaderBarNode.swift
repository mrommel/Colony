//
//  RightHeaderBarNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 24.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol RightHeaderBarNodeDelegate: class {

    // func toogleScienceButton()
}

class RightHeaderBarNode: SKNode {

    // nodes
    var buttonBackground0: SKSpriteNode?

    var leftBackground: SKSpriteNode?

    weak var delegate: RightHeaderBarNodeDelegate?

    override init() {

        super.init()

        self.isUserInteractionEnabled = true

        let headerBarButtonTexture = SKTexture(imageNamed: "header_bar_button")

        self.buttonBackground0 = SKSpriteNode(texture: headerBarButtonTexture, color: .black, size: CGSize(width: 56, height: 47))
        self.buttonBackground0?.position = CGPoint(x: -56, y: 0)
        self.buttonBackground0?.zPosition = self.zPosition
        self.buttonBackground0?.anchorPoint = CGPoint.upperLeft
        self.addChild(buttonBackground0!)

        let headerBarEndTexture = SKTexture(imageNamed: "header_bar_right_end")
        self.leftBackground = SKSpriteNode(texture: headerBarEndTexture, color: .black, size: CGSize(width: 35, height: 47))
        self.leftBackground?.position = CGPoint(x: -35 - 56, y: 0)
        self.leftBackground?.zPosition = self.zPosition
        self.leftBackground?.anchorPoint = CGPoint.upperLeft
        self.addChild(leftBackground!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
