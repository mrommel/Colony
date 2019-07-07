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

class OptionsScene: SKScene {
    
    var backgroundNode: SKSpriteNode?
    var backButton: MenuButtonNode?
    
    weak var optionsDelegate: OptionsDelegate?
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let viewSize = (self.view?.bounds.size)!
        
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.position = CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        
        if let backgroundNode = self.backgroundNode {
            self.addChild(backgroundNode)
        }
        
        let resetButton = MenuButtonNode(titled: "Reset",
                                         buttonAction: {
                                            self.optionsDelegate?.resetData()
        })
        resetButton.position = CGPoint(x: viewSize.width / 2, y: viewSize.height * 0.7)
        resetButton.zPosition = 53
        self.addChild(resetButton)
        
        self.backButton = MenuButtonNode(titled: "Back",
                                         buttonAction: {
            self.optionsDelegate?.quitOptions()
        })
        self.backButton?.position = CGPoint(x: viewSize.width / 2, y: 100)
        self.backButton?.zPosition = 53
        
        if let backButton = self.backButton {
            self.addChild(backButton)
        }
    }
}
