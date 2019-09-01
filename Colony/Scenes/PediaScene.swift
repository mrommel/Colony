//
//  PediaScene.swift
//  Colony
//
//  Created by Michael Rommel on 01.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol PediaDelegate {
    
    func quitPedia()
}

class PediaScene: BaseScene {
    
    // nodes
    var backgroundNode: SKSpriteNode?
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
        self.addChild(self.backgroundNode!)
        
        self.backButton = MenuButtonNode(titled: "Back",
                                         sized: CGSize(width: 150, height: 42),
                                         buttonAction: {
                                            self.pediaDelegate?.quitPedia()
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
        self.backgroundNode?.aspectFillTo(size: viewSize)
        
        self.backButton?.position = CGPoint(x: -100, y: -backgroundTileHeight / 2.0 + 80)
    }
}
