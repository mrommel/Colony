//
//  HeaderBarNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol LeftHeaderBarNodeDelegate: class {
    
    func toogleScienceButton()
    func toggleCultureButton()
    func governmentButtonClicked()
}

class LeftHeaderBarNode: SKNode {
    
    // science nodes
    var scienceButtonBackground: SKSpriteNode?
    var scienceButton: TouchableSpriteNode?
    var scienceButtonActive: Bool = true
    
    // culture nodes
    var cultureButtonBackground: SKSpriteNode?
    var cultureButton: TouchableSpriteNode?
    var cultureButtonActive: Bool = true
    
    // log nodes
    var governmentButtonBackground: SKSpriteNode?
    var governmentButton: TouchableSpriteNode?
    
    // log nodes
    var logButtonBackground: SKSpriteNode?
    var logButton: TouchableSpriteNode?
    var logButtonActive: Bool = true
    
    // misc nodes
    var buttonBackground3: SKSpriteNode?
    
    var rightBackground: SKSpriteNode?
    
    weak var delegate: LeftHeaderBarNodeDelegate?
    
    override init() {
        
        super.init()
        
        self.isUserInteractionEnabled = true
        
        let headerBarButtonTexture = SKTexture(imageNamed: "header_bar_button")
        
        // science
        
        self.scienceButtonBackground = SKSpriteNode(texture: headerBarButtonTexture, color: .black, size: CGSize(width: 56, height: 47))
        self.scienceButtonBackground?.position = CGPoint(x: 0, y: 0)
        self.scienceButtonBackground?.zPosition = self.zPosition
        self.scienceButtonBackground?.anchorPoint = CGPoint.upperLeft
        self.addChild(scienceButtonBackground!)
        
        self.scienceButton = TouchableSpriteNode(imageNamed: "header_science_button_active", size: CGSize(width: 37, height: 37))
        self.scienceButton?.position = CGPoint(x: 10, y: -5)
        self.scienceButton?.zPosition = self.zPosition + 1.0
        self.scienceButton?.anchorPoint = CGPoint.upperLeft
        self.scienceButton?.isUserInteractionEnabled = true
        self.scienceButton?.touchHandler = {
            print("touched science button")
            self.delegate?.toogleScienceButton()
            
            self.scienceButtonActive = !self.scienceButtonActive
            let textureName = self.scienceButtonActive ? "header_science_button_active" : "header_science_button_disabled"
            self.scienceButton?.texture = SKTexture(imageNamed: textureName)
        }
        self.addChild(self.scienceButton!)
        
        // culture
        
        self.cultureButtonBackground = SKSpriteNode(texture: headerBarButtonTexture, color: .black, size: CGSize(width: 56, height: 47))
        self.cultureButtonBackground?.position = CGPoint(x: 56, y: 0)
        self.cultureButtonBackground?.zPosition = self.zPosition
        self.cultureButtonBackground?.anchorPoint = CGPoint.upperLeft
        self.addChild(cultureButtonBackground!)
        
        self.cultureButton = TouchableSpriteNode(imageNamed: "header_culture_button_active", size: CGSize(width: 37, height: 37))
        self.cultureButton?.position = CGPoint(x: 66, y: -5)
        self.cultureButton?.zPosition = self.zPosition + 1.0
        self.cultureButton?.anchorPoint = CGPoint.upperLeft
        self.cultureButton?.isUserInteractionEnabled = true
        self.cultureButton?.touchHandler = {
            print("touched cultureButton button")
            self.delegate?.toggleCultureButton()
            
            self.cultureButtonActive = !self.cultureButtonActive
            let textureName = self.cultureButtonActive ? "header_culture_button_active" : "header_culture_button_disabled"
            self.cultureButton?.texture = SKTexture(imageNamed: textureName)
        }
        self.addChild(self.cultureButton!)
        
        // government
        
        self.governmentButtonBackground = SKSpriteNode(texture: headerBarButtonTexture, color: .black, size: CGSize(width: 56, height: 47))
        self.governmentButtonBackground?.position = CGPoint(x: 56 + 56, y: 0)
        self.governmentButtonBackground?.zPosition = self.zPosition
        self.governmentButtonBackground?.anchorPoint = CGPoint.upperLeft
        self.addChild(governmentButtonBackground!)
        
        self.governmentButton = TouchableSpriteNode(imageNamed: "header_government_button_active", size: CGSize(width: 37, height: 37))
        self.governmentButton?.position = CGPoint(x: 66 + 56, y: -5)
        self.governmentButton?.zPosition = self.zPosition + 1.0
        self.governmentButton?.anchorPoint = CGPoint.upperLeft
        self.governmentButton?.isUserInteractionEnabled = true
        self.governmentButton?.touchHandler = {
            print("touched governmentButton button")
            self.delegate?.governmentButtonClicked()
        }
        self.addChild(self.governmentButton!)
        
        // log
        
        self.logButtonBackground = SKSpriteNode(texture: headerBarButtonTexture, color: .black, size: CGSize(width: 56, height: 47))
        self.logButtonBackground?.position = CGPoint(x: 112 + 56, y: 0)
        self.logButtonBackground?.zPosition = self.zPosition
        self.logButtonBackground?.anchorPoint = CGPoint.upperLeft
        self.addChild(logButtonBackground!)
        
        self.logButton = TouchableSpriteNode(imageNamed: "header_log_button_active", size: CGSize(width: 37, height: 37))
        self.logButton?.position = CGPoint(x: 66 + 56 + 56, y: -5)
        self.logButton?.zPosition = self.zPosition + 1.0
        self.logButton?.anchorPoint = CGPoint.upperLeft
        self.logButton?.isUserInteractionEnabled = true
        self.logButton?.touchHandler = {
            print("touched logButton button")
            /*self.delegate?.toggleLogButton()*/
            
            self.logButtonActive = !self.logButtonActive
            let textureName = self.logButtonActive ? "header_log_button_active" : "header_log_button_disabled"
            self.logButton?.texture = SKTexture(imageNamed: textureName)
        }
        self.addChild(self.logButton!)
        
        // end
        
        let headerBarEndTexture = SKTexture(imageNamed: "header_bar_left_end")
        self.rightBackground = SKSpriteNode(texture: headerBarEndTexture, color: .black, size: CGSize(width: 35, height: 47))
        self.rightBackground?.position = CGPoint(x: 112 + 56 + 56, y: 0)
        self.rightBackground?.zPosition = self.zPosition
        self.rightBackground?.anchorPoint = CGPoint.upperLeft
        self.addChild(rightBackground!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
