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
    
    override init(size: CGSize) {
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let viewSize = (self.view?.bounds.size)!
        
        let background = SKSpriteNode(imageNamed: "menu")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = 0
        background.size = viewSize
        self.addChild(background)
        
        let levelManager = LevelManager()
        for level in levelManager.levels {
            
            let levelButton = LevelButtonNode(titled: "\(level.number)", difficulty: level.difficulty, buttonAction: {
                
                self.menuDelegate?.start(level: level.resource)
            })
            levelButton.position = CGPoint(x: self.frame.width * level.position.x, y: self.frame.height * level.position.y)
            levelButton.zPosition = 1
            self.addChild(levelButton)
        }
        
        let generateButton = LevelButtonNode(titled: "G", difficulty: .easy, buttonAction: {
            
            self.menuDelegate?.startGeneration()
        })
        generateButton.position = CGPoint(x: self.frame.width * 0.9, y: self.frame.height * 0.8)
        generateButton.zPosition = 1
        self.addChild(generateButton)
    }
}
