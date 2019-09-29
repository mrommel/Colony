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
    func show(feature: Feature)
    func show(unitType: UnitType)
    
    func quitPedia()
}

class PediaScene: BaseScene {

    // nodes
    var backgroundNode: SKSpriteNode?
    var headerLabelNode: SKLabelNode?
    var headerIconNode: SKSpriteNode?
    
    var terrainHeadingLabel: SKLabelNode?
    var terrainItems: [PediaItemNode?] = []
    
    var featureHeadingLabel: SKLabelNode?
    var featureItems: [PediaItemNode?] = []
    
    var unitTypeHeadingLabel: SKLabelNode?
    var unitTypeItems: [PediaItemNode?] = []
    
    var backButton: MenuButtonNode?

    // delegate
    var pediaDelegate: PediaDelegate?
    
    // view model
    var viewModel: PediaSceneViewModel?

    override init(size: CGSize) {

        super.init(size: size, layerOrdering: .nodeLayerOnTop)
        
        self.viewModel = PediaSceneViewModel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        super.didMove(to: view)
        
        guard let viewModel = self.viewModel else {
            fatalError("view model not set")
        }

        let viewSize = (self.view?.bounds.size)!

        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        self.cameraNode.addChild(self.backgroundNode!)

        let headerIconTexture = SKTexture(imageNamed: "pedia")
        self.headerIconNode = SKSpriteNode(texture: headerIconTexture, color: .black, size: CGSize(width: 42, height: 42))
        self.headerIconNode?.zPosition = 1
        self.rootNode.addChild(self.headerIconNode!)
        
        self.headerLabelNode = SKLabelNode(text: "Pedia")
        self.headerLabelNode?.fontSize = 30
        self.headerLabelNode?.zPosition = 1
        self.rootNode.addChild(self.headerLabelNode!)

        self.terrainHeadingLabel = SKLabelNode(text: "Terrains")
        self.terrainHeadingLabel?.fontSize = 24
        self.terrainHeadingLabel?.fontName = Formatters.Fonts.customFontBoldFamilyname
        self.terrainHeadingLabel?.zPosition = 1
        self.rootNode.addChild(self.terrainHeadingLabel!)
        
        for terrain in viewModel.terrains {
            let pediaItem = PediaItemNode(terrain: terrain, action: {
                self.pediaDelegate?.show(terrain: terrain)
            })
            self.rootNode.addChild(pediaItem)
            
            self.terrainItems.append(pediaItem)
        }
        
        self.featureHeadingLabel = SKLabelNode(text: "Features")
        self.featureHeadingLabel?.fontSize = 24
        self.featureHeadingLabel?.fontName = Formatters.Fonts.customFontBoldFamilyname
        self.featureHeadingLabel?.zPosition = 1
        self.rootNode.addChild(self.featureHeadingLabel!)
        
        for feature in viewModel.features {
            let pediaItem = PediaItemNode(feature: feature, action: {
                self.pediaDelegate?.show(feature: feature)
            })
            self.rootNode.addChild(pediaItem)
            
            self.featureItems.append(pediaItem)
        }
        
        self.unitTypeHeadingLabel = SKLabelNode(text: "Units")
        self.unitTypeHeadingLabel?.fontSize = 24
        self.unitTypeHeadingLabel?.fontName = Formatters.Fonts.customFontBoldFamilyname
        self.unitTypeHeadingLabel?.zPosition = 1
        self.rootNode.addChild(self.unitTypeHeadingLabel!)
        
        for unitType in viewModel.unitTypes {
            let pediaItem = PediaItemNode(unitType: unitType, action: {
                self.pediaDelegate?.show(unitType: unitType)
            })
            self.rootNode.addChild(pediaItem)
            
            self.unitTypeItems.append(pediaItem)
        }

        self.backButton = MenuButtonNode(titled: "Back",
            sized: CGSize(width: 150, height: 42),
            buttonAction: {
                self.pediaDelegate?.quitPedia()
            })
        self.backButton?.zPosition = 53
        self.cameraNode.addChild(self.backButton!)
        
        self.updateLayout()
    }
    
    // moving the pedia content around
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
        
        var y = 260
        
        // terrain
        self.terrainHeadingLabel?.position = CGPoint(x: 0, y: y)
        y -= 50
        for terrainItem in self.terrainItems {
            terrainItem?.position = CGPoint(x: 0, y: y)
            y -= 50
        }
        y -= 20
        
        // feature
        self.featureHeadingLabel?.position = CGPoint(x: 0, y: y)
        y -= 50
        for featureItem in self.featureItems {
            featureItem?.position = CGPoint(x: 0, y: y)
            y -= 50
        }
        y -= 20
        
        // units
        self.unitTypeHeadingLabel?.position = CGPoint(x: 0, y: y)
        y -= 50
        for unitType in self.unitTypeItems {
            unitType?.position = CGPoint(x: 0, y: y)
            y -= 50
        }

        self.backButton?.position = CGPoint(x: -100, y: -backgroundTileHeight / 2.0 + 80)
        
        // debug
        //self.renderNodeHierarchyFor(node: self.cameraNode)
        //self.renderNodeHierarchyFor(node: self.rootNode)
    }
}
