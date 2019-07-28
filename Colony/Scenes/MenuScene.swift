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
    func restart(game: Game?)
    func startGeneration()
    func startOptions()
}

class MenuScene: SKScene {
    
    // MARK: Variables
    var menuDelegate: MenuDelegate?
    
    var safeAreaNode: SafeAreaNode
    var colonyTitleLabel: SKSpriteNode?
    var backgroundNode2: SKSpriteNode?
    var backgroundNode1: SKSpriteNode?
    var backgroundNode0: SKSpriteNode?
    var copyrightLabel: SKLabelNode?
    var settingsButton: SettingsButtonNode?
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
        
        // colony label
        let colonytexture = SKTexture(imageNamed: "ColonyText")
        self.colonyTitleLabel = SKSpriteNode(texture: colonytexture, color: .black, size: CGSize(width: 228, height: 87))
        self.colonyTitleLabel?.zPosition = 1
        
        if let colonyTitleLabel = self.colonyTitleLabel {
            self.cameraNode.addChild(colonyTitleLabel)
        }
        
        let levelManager = LevelManager()
        for level in levelManager.levels {
            
            let levelButton = LevelButtonNode(titled: "\(level.number)", difficulty: level.difficulty, buttonAction: {
                
                self.menuDelegate?.start(level: level.resource)
            })
            levelButton.position = CGPoint(x: self.frame.width * level.position.x - self.frame.halfWidth, y: self.frame.height * level.position.y - self.frame.halfHeight)
            levelButton.zPosition = 1
            self.addChild(levelButton)
            
            // add level score here
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
        self.settingsButton = SettingsButtonNode(buttonAction: {
            self.menuDelegate?.startOptions()
        })
        self.settingsButton?.zPosition = 7
        
        if let settingsButton = self.settingsButton {
            self.cameraNode.addChild(settingsButton)
        }
        
        // copyright
        self.copyrightLabel = SKLabelNode(text: "Copyright 2019 MiRo & MaRo")
        self.copyrightLabel?.zPosition = 1
        self.copyrightLabel?.fontSize = 12
        
        if let copyrightLabel = self.copyrightLabel {
            self.cameraNode.addChild(copyrightLabel)
        }
        
        self.updateLayout()
        
        // ask if user wants to continue last game
        let gameUsecase = GameUsecase()
        
        // check if a backup exists ...
        if let game = gameUsecase.restoreGame() {

            // ... ask the user if he wants ...
            if let continueDialog = UI.continueDialog() {
                continueDialog.addOkayAction(handler: {
                    
                    // ... and try to start it
                    self.menuDelegate?.restart(game: game)
                    continueDialog.close()
                })
                
                self.cameraNode.addChild(continueDialog)
            }
        }
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
        
        let viewSize = (self.view?.bounds.size)!
        let backgroundTileHeight = 812 * viewSize.width / 375
        
        self.safeAreaNode.updateLayout()
        
        self.colonyTitleLabel?.position = CGPoint(x: 0, y: self.frame.halfHeight - 80)
        
        self.backgroundNode0?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode0?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)
        
        self.backgroundNode1?.position = CGPoint(x: 0.0, y: backgroundTileHeight)
        self.backgroundNode1?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)
        
        self.backgroundNode2?.position = CGPoint(x: 0.0, y: 2 * backgroundTileHeight)
        self.backgroundNode2?.size = CGSize(width: viewSize.width, height: backgroundTileHeight)
        
        self.settingsButton?.position = CGPoint(x: self.frame.width * 0.88 - self.frame.halfWidth, y: self.frame.height * 0.1 - self.frame.halfHeight)
        self.copyrightLabel?.position = CGPoint(x: 0, y: -self.frame.halfHeight + 18)
    }
}
