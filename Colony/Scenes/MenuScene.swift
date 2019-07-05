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
    func startOptions()
}

class MenuScene: SKScene {
    
    // MARK: Variables
    var menuDelegate: MenuDelegate?
    
    var safeAreaNode: SafeAreaNode
    var backgroundNode2: SKSpriteNode?
    var backgroundNode1: SKSpriteNode?
    var backgroundNode0: SKSpriteNode?
    var cameraNode: SKCameraNode!
    
    let gameUsecase: GameUsecase?
    
    override init(size: CGSize) {
        
        self.safeAreaNode = SafeAreaNode()
        self.gameUsecase = GameUsecase()
        
        super.init(size: size)
        
        self.addChild(self.safeAreaNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        // camera
        self.cameraNode = SKCameraNode() //initialize and assign an instance of SKCameraNode to the cam variable.
        self.camera = self.cameraNode //set the scene's camera to reference cam
        self.addChild(self.cameraNode) //make the cam a childElement of the scene itself.
        
        let viewSize = (self.view?.bounds.size)!
        
        self.backgroundNode0 = SKSpriteNode(imageNamed: "menu_background0")
        self.backgroundNode0?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode0?.zPosition = 0
        self.backgroundNode0?.size = viewSize
        
        if let backgroundNode0 = self.backgroundNode0 {
            self.addChild(backgroundNode0)
        }
        
        self.backgroundNode1 = SKSpriteNode(imageNamed: "menu_background1")
        self.backgroundNode1?.position = CGPoint(x: 0.0, y: (self.backgroundNode0?.frame.height)!)
        self.backgroundNode1?.zPosition = 0
        self.backgroundNode1?.size = viewSize
        
        if let backgroundNode1 = self.backgroundNode1 {
            self.addChild(backgroundNode1)
        }
        
        self.backgroundNode2 = SKSpriteNode(imageNamed: "menu_background2")
        self.backgroundNode2?.position = CGPoint(x: 0.0, y: (self.backgroundNode0?.frame.height)! * 2)
        self.backgroundNode2?.zPosition = 0
        self.backgroundNode2?.size = viewSize
        
        if let backgroundNode2 = self.backgroundNode2 {
            self.addChild(backgroundNode2)
        }
        
        let levelManager = LevelManager()
        for level in levelManager.levels {
            
            let levelButton = LevelButtonNode(titled: "\(level.number)", difficulty: level.difficulty, buttonAction: {
                
                self.menuDelegate?.start(level: level.resource)
            })
            levelButton.position = CGPoint(x: self.frame.width * level.position.x - self.frame.halfWidth, y: self.frame.height * level.position.y - self.frame.halfHeight)
            levelButton.zPosition = 1
            self.addChild(levelButton)
            
            // FIXME: add level score here
            var levelScoreValue = LevelScore.none
            if let levelScore = self.gameUsecase?.levelScore(for: Int32(level.number)) {
                levelScoreValue = levelScore
            }
            
            let starTexture = SKTexture(imageNamed: levelScoreValue.buttonName)
            let starSprite = SKSpriteNode(texture: starTexture, color: .black, size: CGSize(width: 20, height: 20))
            starSprite.position = CGPoint(x: self.frame.width * level.position.x - self.frame.halfWidth + 20, y: self.frame.height * level.position.y - self.frame.halfHeight + 20)
            starSprite.zPosition = 2
            self.addChild(starSprite)
        }
        
        let generateButton = LevelButtonNode(titled: "G", difficulty: .easy, buttonAction: {
            
            self.menuDelegate?.startGeneration()
        })
        generateButton.position = CGPoint(x: self.frame.width * 0.9 - self.frame.halfWidth, y: self.frame.height * 0.8 - self.frame.halfHeight)
        generateButton.zPosition = 1
        self.addChild(generateButton)
        
        // settings
        let settingsButton = SettingsButtonNode(buttonAction: {
            self.menuDelegate?.startOptions()
        })
        settingsButton.position = CGPoint(x: self.frame.width * 0.88 - self.frame.halfWidth, y: self.frame.height * 0.1 - self.frame.halfHeight)
        settingsButton.zPosition = 1
        self.cameraNode.addChild(settingsButton)
        
        // copyright
        let copyrightLabel = SKLabelNode(text: "Copyright 2019 MiRo & MaRo")
        copyrightLabel.position = CGPoint(x: 0, y: self.frame.height * 0.1 - self.frame.halfHeight)
        copyrightLabel.zPosition = 1
        copyrightLabel.fontSize = 12
        self.cameraNode.addChild(copyrightLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    // moving the map around
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self.backgroundNode0!)
            let previousLocation = touch.previousLocation(in: self.backgroundNode0!)
            
            let deltaY = (location.y) - (previousLocation.y)
            
            self.cameraNode.position.x = 0.0
            self.cameraNode.position.y -= deltaY * 0.7
            
            if self.cameraNode.position.y < 0 {
                self.cameraNode.position.y = 0
            }
            
            if self.cameraNode.position.y > (self.backgroundNode0?.frame.height)! * 2 {
                self.cameraNode.position.y = (self.backgroundNode0?.frame.height)! * 2
            }
            //print("camera pos moved: \(self.cameraNode.position)")
        }
    }
    
    func updateLayout() {
        
        self.safeAreaNode.updateLayout()
        
        self.backgroundNode0?.position = CGPoint(x: 0.0, y: 0.0)
    }
}
