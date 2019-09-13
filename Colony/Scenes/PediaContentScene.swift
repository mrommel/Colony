//
//  PediaContentScene.swift
//  Colony
//
//  Created by Michael Rommel on 02.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol PediaContentDelegate {
    
    func quitPediaContent()
}

class PediaContentScene: BaseScene {
    
    // nodes
    var backgroundNode: SKSpriteNode?
    var headerLabelNode: SKLabelNode?
    var headerIconNode: SKSpriteNode?
    var backButton: MenuButtonNode?
    
    // delegate
    var pediaContentDelegate: PediaContentDelegate?
    
    // view model
    var viewModel: PediaContentSceneViewModel?
    
    override init(size: CGSize) {
        
        super.init(size: size, layerOrdering: .nodeLayerOnTop)
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
        self.rootNode.addChild(self.headerLabelNode!)
        
        let headerIconTexture = SKTexture(imageNamed: "pedia")
        self.headerIconNode = SKSpriteNode(texture: headerIconTexture, color: .black, size: CGSize(width: 42, height: 42))
        self.headerIconNode?.zPosition = 1
        self.rootNode.addChild(self.headerIconNode!)
        
        // add content here
        if let terrain = viewModel?.terrain {
            
            let contentIconTexture = SKTexture(imageNamed: terrain.textureNameHex.first!)
            let contentIconNode = SKSpriteNode(texture: contentIconTexture, color: .black, size: CGSize(width: 120, height: 120))
            contentIconNode.zPosition = 1
            contentIconNode.position = CGPoint(x: 0, y: 180)
            self.rootNode.addChild(contentIconNode)
            
            let contentTitleLabelNode = SKLabelNode(text: terrain.title)
            contentTitleLabelNode.zPosition = 1
            contentTitleLabelNode.position = CGPoint(x: 0, y: 40)
            self.rootNode.addChild(contentTitleLabelNode)
            
            let contentTextLabelNode = SKLabelNode(text: terrain.summary)
            contentTextLabelNode.zPosition = 1
            contentTextLabelNode.position = CGPoint(x: 0, y: -10)
            self.rootNode.addChild(contentTextLabelNode)
        }
        
        self.backButton = MenuButtonNode(titled: "Back",
                                         sized: CGSize(width: 150, height: 42),
                                         buttonAction: {
                                            self.pediaContentDelegate?.quitPediaContent()
        })
        self.backButton?.zPosition = 53
        self.cameraNode.addChild(self.backButton!)
        
        self.updateLayout()
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
