//
//  BoosterNode.swift
//  Colony
//
//  Created by Michael Rommel on 28.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol BoosterActivationDelegate: class {
    
    func activated(boosterType: BoosterType)
}

class BoosterNode: SKSpriteNode {
    
    var expanded: Bool = false
    let boosterType: BoosterType
    
    var activationButton: MenuButtonNode?
    weak var delegate: BoosterActivationDelegate?
    
    init(for boosterType: BoosterType, active: Bool) {
        
        self.boosterType = boosterType
        
        let texture = active ? SKTexture(imageNamed: "grid9_info_banner") : SKTexture(imageNamed: "grid9_info_banner_inactive")
        super.init(texture: texture, color: .black, size: CGSize(width: 180, height: 70))
        
        self.isUserInteractionEnabled = true
        
        // nine grid
        self.centerRect = CGRect.init(x: 0.3333, y: 0.3333, width: 0.3333, height: 0.3333)
        
        // icon
        let boosterTypeNode = BoosterTypeNode(for: boosterType)
        boosterTypeNode.zPosition = self.zPosition + 0.1
        boosterTypeNode.position = CGPoint(x: -60, y: 0)
        self.addChild(boosterTypeNode)
        
        // label
        let boosterTypeLabel = SKLabelNode(text: boosterType.title)
        boosterTypeLabel.zPosition = self.zPosition + 0.1
        boosterTypeLabel.position = CGPoint(x: 0, y: 10)
        boosterTypeLabel.fontSize = 16
        boosterTypeLabel.fontName = Formatters.Fonts.customFontFamilyname
        self.addChild(boosterTypeLabel)
        
        // activation button
        if active {
            self.activationButton = MenuButtonNode(titled: "Activate", sized: CGSize(width: 100, height: 36), buttonAction: {
                
                self.activate(boosterType: boosterType)
            })
            self.activationButton?.zPosition = self.zPosition + 0.1
            self.activationButton?.position = CGPoint(x: 20, y: -14)
            
            if let activationButton = self.activationButton {
                self.addChild(activationButton)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.toogle()
    }
    
    func toogle() {
        
        self.run(SKAction.move(by: CGVector(dx: expanded ? 120 : -120, dy: 0), duration: 0.5))
        self.expanded = !expanded
    }
    
    func enable() {
        self.texture = SKTexture(imageNamed: "grid9_info_banner")
        
        self.activationButton = MenuButtonNode(titled: "Activate", sized: CGSize(width: 100, height: 36), buttonAction: {
            
            self.activate(boosterType: self.boosterType)
        })
        self.activationButton?.zPosition = self.zPosition + 0.1
        self.activationButton?.position = CGPoint(x: 20, y: -14)
        
        if let activationButton = self.activationButton {
            self.addChild(activationButton)
        }
    }
    
    func disable() {
        self.texture = SKTexture(imageNamed: "grid9_info_banner_inactive")
        
        self.activationButton?.removeFromParent()
        self.activationButton = nil
    }
    
    func activate(boosterType: BoosterType) {
        
        print("activate booster: \(boosterType)")
        
        self.toogle()
        
        self.delegate?.activated(boosterType: boosterType)
    }
}
