//
//  MenuScene.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit


protocol MenuDelegate {
    
    func start(level levelName: String)
    func startGeneration()
    
    /*func startOptions()
    func startCredits()*/
}

class MenuScene: SKScene {

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
            
            let levelButton = LevelButtonNode(titled: "\(level.number)", buttonAction: {
                
                self.menuDelegate?.start(level: level.levelName)
            })
            levelButton.position = CGPoint(x: self.frame.width * level.position.x, y: self.frame.height * level.position.y)
            levelButton.zPosition = 2
            self.addChild(levelButton)
        }
        
        let generateButton = LevelButtonNode(titled: "G", buttonAction: {
            
            self.menuDelegate?.startGeneration()
        })
        generateButton.position = CGPoint(x: self.frame.width * 0.9, y: self.frame.height * 0.9)
        generateButton.zPosition = 2
        self.addChild(generateButton)
        
        /*let level1Button = LevelButtonNode(titled: "1", buttonAction: {
            
            self.menuDelegate?.startGame()
        })
        level1Button.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        level1Button.zPosition = 2
        self.addChild(level1Button)*/
        
        /*let frame = NineGridTextureSprite(imageNamed: "grid9_frame", size: viewSize.reduce(dx: 40, dy: 80))
        frame.position = CGPoint(x: frame.size.width / 2 + 20, y: frame.size.height / 2 + 40)
        frame.zPosition = 1
        self.addChild(frame)*/
        
        /*let monsterButton = MenuButtonNode(titled: "Seeungeheuer", buttonAction: {
            
            self.menuDelegate?.startGame()
        })
        monsterButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        monsterButton.zPosition = 2
        self.addChild(monsterButton)
        
        let optionButton = MenuButtonNode(titled: "Optionen", buttonAction: {
            
            self.menuDelegate?.startOptions()
        })
        optionButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 80)
        optionButton.zPosition = 2
        self.addChild(optionButton)*/
    }
}
