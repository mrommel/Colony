//
//  PediaScene.swift
//  Colony
//
//  Created by Michael Rommel on 01.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol PediaDelegate {

    func show(terrain: Terrain)
    
    func quitPedia()
}

class PediaScene: BaseScene {

    // nodes
    var backgroundNode: SKSpriteNode?
    var headerLabelNode: SKLabelNode?
    var headerIconNode: SKSpriteNode?
    var backButton: MenuButtonNode?

    // delegate
    var pediaDelegate: PediaDelegate?

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
        self.cameraNode.addChild(self.backgroundNode!)

        self.headerLabelNode = SKLabelNode(text: "Pedia")
        self.headerLabelNode?.zPosition = 1
        //self.headerLabelNode?.position = CGPoint(x: 0, y: 250)
        self.rootNode.addChild(self.headerLabelNode!)
        
        let headerIconTexture = SKTexture(imageNamed: "pedia")
        self.headerIconNode = SKSpriteNode(texture: headerIconTexture, color: .black, size: CGSize(width: 42, height: 42))
        self.headerIconNode?.zPosition = 1
        self.rootNode.addChild(self.headerIconNode!)

        let terrainLabel = SKLabelNode(text: "Terrains")
        terrainLabel.fontSize = 20
        terrainLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        terrainLabel.zPosition = 1
        terrainLabel.position = CGPoint(x: 0, y: 230)
        self.rootNode.addChild(terrainLabel)
        
        var y = 230 - 50
        
        self.addPedia(for: .plain, at: y)
        y -= 50
        self.addPedia(for: .grass, at: y)
        y -= 50
        self.addPedia(for: .ocean, at: y)
        y -= 50
        
        let featuresLabel = SKLabelNode(text: "Features")
        featuresLabel.fontSize = 20
        featuresLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        featuresLabel.zPosition = 1
        featuresLabel.position = CGPoint(x: 0, y: -50)
        self.rootNode.addChild(featuresLabel)
        
        y = -50 - 50
        
        let unitsLabel = SKLabelNode(text: "Units")
        unitsLabel.fontSize = 20
        unitsLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        unitsLabel.zPosition = 1
        unitsLabel.position = CGPoint(x: 0, y: -320)
        self.rootNode.addChild(unitsLabel)
        
        y = -320 - 50
        
        self.addPedia(for: .axeman, at: y)
        y -= 50
        self.addPedia(for: .archer, at: y)
        y -= 50
        self.addPedia(for: .ship, at: y)
        y -= 50

        self.backButton = MenuButtonNode(titled: "Back",
            sized: CGSize(width: 150, height: 42),
            buttonAction: {
                self.pediaDelegate?.quitPedia()
            })
        self.backButton?.zPosition = 53
        self.cameraNode.addChild(self.backButton!)
        
        self.updateLayout()
    }
    
    func addPedia(for terrain: Terrain, at y: Int) {
        
        let terrainTexture = SKTexture(imageNamed: terrain.textureNameHex.first!)
        let terrainIcon = SKSpriteNode(texture: terrainTexture, size: CGSize(width: 42, height: 42))
        terrainIcon.zPosition = 1
        terrainIcon.position = CGPoint(x: -150, y: y + 15)
        self.rootNode.addChild(terrainIcon)
        
        let terrainLabel = ClickableLabelNode(text: terrain.title, buttonAction: {
            self.pediaDelegate?.show(terrain: terrain)
        })
        terrainLabel.fontSize = 20
        terrainLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        terrainLabel.zPosition = 1
        terrainLabel.position = CGPoint(x: -100, y: y)
        self.rootNode.addChild(terrainLabel)
    }
    
    func addPedia(for unitType: GameObjectType, at y: Int) {
        
        let unitLabel = SKLabelNode(text: unitType.title)
        unitLabel.fontSize = 20
        unitLabel.fontName = Formatters.Fonts.systemFontBoldFamilyname
        unitLabel.zPosition = 1
        unitLabel.position = CGPoint(x: -100, y: y)
        self.rootNode.addChild(unitLabel)
    }
    
    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // let viewSize = (self.view?.bounds.size)!
        
        for touch in touches {
            let location = touch.location(in: self.backgroundNode!)
            let previousLocation = touch.previousLocation(in: self.backgroundNode!)
            
            let deltaY = (location.y) - (previousLocation.y)
            let height = (self.backgroundNode?.frame.height)! * 2 // << == change here
            
            self.cameraNode.position.x = 0.0
            self.cameraNode.position.y -= deltaY * 0.7
            
            if self.cameraNode.position.y < -height {
                self.cameraNode.position.y = -height
            }
            
            if self.cameraNode.position.y > 0 {
                self.cameraNode.position.y = 0
            }
        }
    }

    override func updateLayout() {

        super.updateLayout()

        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375

        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.aspectFillTo(size: viewSize)
        
        self.headerLabelNode?.position = CGPoint(x: 0, y: viewSize.halfHeight - 72)
        self.headerIconNode?.position = CGPoint(x: -self.headerLabelNode!.frame.size.halfWidth - 24, y: viewSize.halfHeight - 62)

        self.backButton?.position = CGPoint(x: -100, y: -backgroundTileHeight / 2.0 + 80)
    }
}
