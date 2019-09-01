//
//  MenuScene.swift
//  Colony
//
//  Created by Michael Rommel on 30.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol MenuDelegate: class {

    func startTutorials()
    func startQuests()
    func startWith(map: HexagonTileMap?)
    func startOptions()
    func startStore()
    
    func startPedia()
}

class MenuScene: BaseScene {

    // nodes
    var backgroundNode: SKSpriteNode?
    var colonyTitleLabel: SKSpriteNode?

    var tutorialButton: MenuButtonNode?
    var questsButton: MenuButtonNode?
    var freePlayButton: MenuButtonNode?
    var optionsButton: MenuButtonNode?
    var storeButton: MenuButtonNode?
    var pediaButton: MenuButtonNode?

    var copyrightLabel: SKLabelNode?

    // delegate
    weak var menuDelegate: MenuDelegate?

    override init(size: CGSize) {
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)

        let viewSize = (self.view?.bounds.size)!

        // background
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        self.addChild(self.backgroundNode!)

        // colony label
        let colonytexture = SKTexture(imageNamed: "ColonyText")
        self.colonyTitleLabel = SKSpriteNode(texture: colonytexture, color: .black, size: CGSize(width: 228, height: 87))
        self.colonyTitleLabel?.zPosition = 1
        self.addChild(self.colonyTitleLabel!)

        // tutorial
        self.tutorialButton = MenuButtonNode(titled: "Tutorials",
            buttonAction: {
                self.menuDelegate?.startTutorials()
            })
        self.tutorialButton?.zPosition = 2
        self.addChild(self.tutorialButton!)

        // quests
        self.questsButton = MenuButtonNode(imageNamed: "quests", title: "Quests",
            buttonAction: {
                self.menuDelegate?.startQuests()
            })
        self.questsButton?.zPosition = 2
        self.addChild(self.questsButton!)

        // quests
        self.freePlayButton = MenuButtonNode(titled: "Free Play",
            buttonAction: {
                self.requestMapType()
            })
        self.freePlayButton?.zPosition = 2
        self.addChild(self.freePlayButton!)

        // options
        self.optionsButton = MenuButtonNode(imageNamed: "settings", title: "Options",
            buttonAction: {
                self.menuDelegate?.startOptions()
            })
        self.optionsButton?.zPosition = 2
        self.addChild(self.optionsButton!)

        // shop
        self.storeButton = MenuButtonNode(imageNamed: "cart", title: "Store",
            buttonAction: {
                self.menuDelegate?.startStore()
            })
        self.storeButton?.zPosition = 2
        self.addChild(self.storeButton!)
        
        // pedia
        self.pediaButton = MenuButtonNode(titled: "Pedia",
                                          buttonAction: {
                                            self.menuDelegate?.startPedia()
        })
        self.pediaButton?.zPosition = 2
        self.addChild(self.pediaButton!)

        // copyright
        self.copyrightLabel = SKLabelNode(text: "Copyright 2019 MiRo & MaRo")
        self.copyrightLabel?.zPosition = 1
        self.copyrightLabel?.fontSize = 12
        self.addChild(self.copyrightLabel!)

        self.updateLayout()
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.aspectFillTo(size: viewSize)

        self.colonyTitleLabel?.position = CGPoint(x: 0, y: self.frame.halfHeight - 80)

        // buttons
        self.tutorialButton?.position = CGPoint(x: 0, y: 100)
        self.questsButton?.position = CGPoint(x: 0, y: 50)
        self.freePlayButton?.position = CGPoint(x: 0, y: 0)
        self.optionsButton?.position = CGPoint(x: 0, y: -50)
        self.storeButton?.position = CGPoint(x: 0, y: -100)
        self.pediaButton?.position = CGPoint(x: 0, y: -170)

        // copyright
        self.copyrightLabel?.position = CGPoint(x: 0, y: -self.frame.halfHeight + 18)
    }
}
