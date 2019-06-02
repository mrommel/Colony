//
//  MenuScene.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit


protocol MenuDelegate {
    
    func startGame()
    func startOptions()
    func startCredits()
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
        
        let background = SKSpriteNode(imageNamed: "menu")
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.zPosition = 0
        background.size = (self.view?.bounds.size)!
        self.addChild(background)
        
        let monsterButton = MenuButtonNode(titled: "Seeungeheuer", buttonAction: {
            
            self.menuDelegate?.startGame()
        })
        monsterButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        monsterButton.zPosition = 1
        self.addChild(monsterButton)
        
        let optionButton = MenuButtonNode(titled: "Optionen", buttonAction: {
            
            //self.menuDelegate.gotoGame()
        })
        optionButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 80)
        optionButton.zPosition = 1
        self.addChild(optionButton)
    }
}
