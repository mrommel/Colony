//
//  OptionsScene.swift
//  Colony
//
//  Created by Michael Rommel on 05.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol OptionsDelegate: class {

    func quitOptions()
    func resetData()
}

class OptionsScene: BaseScene {

    // nodes
    var backgroundNode: SKSpriteNode?
    var headerLabelNode: SKLabelNode?
    var headerIconNode: SKSpriteNode?
    var backButton: MenuButtonNode?
    var resetButton: MenuButtonNode?

    // delegate
    weak var optionsDelegate: OptionsDelegate?

    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        self.addChild(self.backgroundNode!)

        // header
        self.headerLabelNode = SKLabelNode(text: "Options")
        self.headerLabelNode?.zPosition = 1
        self.addChild(self.headerLabelNode!)
        
        let headerIconTexture = SKTexture(imageNamed: "settings")
        self.headerIconNode = SKSpriteNode(texture: headerIconTexture, color: .black, size: CGSize(width: 42, height: 42))
        self.headerIconNode?.zPosition = 1
        self.addChild(self.headerIconNode!)
        
        // debug
        self.resetButton = MenuButtonNode(titled: "Reset",
            buttonAction: {
                self.optionsDelegate?.resetData()
            })
        self.resetButton?.zPosition = 53
        self.addChild(self.resetButton!)

        self.backButton = MenuButtonNode(titled: "Back",
            sized: CGSize(width: 150, height: 42),
            buttonAction: {
                self.optionsDelegate?.quitOptions()
            })
        self.backButton?.zPosition = 53
        self.addChild(self.backButton!)

        self.updateLayout()
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        //self.backgroundNode?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)
        self.backgroundNode?.aspectFillTo(size: viewSize)
        
        self.headerLabelNode?.position = CGPoint(x: 0, y: viewSize.halfHeight - 72)
        self.headerIconNode?.position = CGPoint(x: -self.headerLabelNode!.frame.size.halfWidth - 24, y: viewSize.halfHeight - 62)

        self.resetButton?.position = CGPoint(x: 0, y: 100)

        self.backButton?.position = CGPoint(x: -100, y: -backgroundTileHeight / 2.0 + 80)
    }
}
