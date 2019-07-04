//
//  MenuScene.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit


protocol MenuDelegate {
    
    func start(level url: URL?)
    func startGeneration()
}

class MenuScene: SKScene {
    
    // MARK: Variables
    var menuDelegate: MenuDelegate?
    
    var safeAreaNode: SafeAreaNode
    var backgroundNode: SKSpriteNode?
    
    override init(size: CGSize) {
        
        self.safeAreaNode = SafeAreaNode()
        
        super.init(size: size)
        
        self.addChild(self.safeAreaNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let viewSize = (self.view?.bounds.size)!
        
        self.backgroundNode = SKSpriteNode(imageNamed: "background")
        self.backgroundNode?.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        self.backgroundNode?.zPosition = 0
        self.backgroundNode?.size = viewSize
        
        if let backgroundNode = self.backgroundNode {
            self.addChild(backgroundNode)
        }
        
        let levelManager = LevelManager()
        for level in levelManager.levels {
            
            let levelButton = LevelButtonNode(titled: "\(level.number)", difficulty: level.difficulty, buttonAction: {
                
                self.menuDelegate?.start(level: level.resource)
            })
            levelButton.position = CGPoint(x: self.frame.width * level.position.x, y: self.frame.height * level.position.y)
            levelButton.zPosition = 1
            self.safeAreaNode.addChild(levelButton)
            
            // FIXME: add level score here
            
        }
        
        let generateButton = LevelButtonNode(titled: "G", difficulty: .easy, buttonAction: {
            
            self.menuDelegate?.startGeneration()
        })
        generateButton.position = CGPoint(x: self.frame.width * 0.9, y: self.frame.height * 0.8)
        generateButton.zPosition = 1
        self.safeAreaNode.addChild(generateButton)
        
        let settingsButton = SettingsButtonNode(buttonAction: {
            print("settings")
        })
        settingsButton.position = CGPoint(x: self.frame.width * 0.88, y: self.frame.height * 0.1)
        settingsButton.zPosition = 1
        self.safeAreaNode.addChild(settingsButton)
    }
    
    func updateLayout() {
        
        self.safeAreaNode.updateLayout()
        
        self.backgroundNode?.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }
}
