//
//  BoosterStoreNode.swift
//  Colony
//
//  Created by Michael Rommel on 31.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

protocol BoosterStoreNodeDelegate: class {
    
    func handleNew(value: Int, for boosterType: BoosterType)
}

class BoosterStoreNode: NineGridTextureSprite {
    
    let boosterTypeNode: BoosterTypeNode!
    let boosterTypeTitleNode: SKLabelNode!
    let boosterTypeSummaryNode: TruncatedLabelNode!
    let amountNode: SKLabelNode!
    let plusButtonNode: MenuButtonNode!
    let minusButtonNode: MenuButtonNode!
    
    private var value: Int
    weak var delegate: BoosterStoreNodeDelegate?
    let boosterType: BoosterType
    
    init(for boosterType: BoosterType, amount: Int, viewWidth: CGFloat) {
        
        self.boosterType = boosterType
        self.value = amount
        
        self.boosterTypeNode = BoosterTypeNode(for: boosterType)
        self.boosterTypeTitleNode = SKLabelNode(text: boosterType.title)
        self.boosterTypeSummaryNode = TruncatedLabelNode(text: boosterType.summary)
        self.amountNode = SKLabelNode(text: "\(amount)")
        self.plusButtonNode = MenuButtonNode(titled: "+", sized: CGSize(width: 32, height: 32))
        self.minusButtonNode = MenuButtonNode(titled: "-", sized: CGSize(width: 32, height: 32))
        
        super.init(imageNamed: "grid9_info_banner", size: CGSize(width: viewWidth - 32, height: 84))
        
        self.anchorPoint = .middleLeft
        
        // icon
        self.boosterTypeNode.zPosition = self.zPosition + 1
        self.addChild(self.boosterTypeNode)
        
        // texts
        self.boosterTypeTitleNode.zPosition = self.zPosition + 1
        self.boosterTypeTitleNode.fontSize = 24
        self.boosterTypeTitleNode.horizontalAlignmentMode = .left
        self.addChild(self.boosterTypeTitleNode)
        
        self.boosterTypeSummaryNode.zPosition = self.zPosition + 1
        self.boosterTypeSummaryNode.fontSize = 16
        self.boosterTypeSummaryNode.numberOfLines = 1
        self.boosterTypeSummaryNode.lineBreakMode = .byTruncatingTail
        self.boosterTypeSummaryNode.horizontalAlignmentMode = .left
        self.addChild(self.boosterTypeSummaryNode)
        
        // plus / minus
        self.amountNode.zPosition = self.zPosition + 1
        self.amountNode.fontSize = 16
        self.addChild(self.amountNode)
        
        self.plusButtonNode.action = { self.plusAction() }
        self.plusButtonNode.zPosition = self.zPosition + 1
        self.addChild(self.plusButtonNode)
        
        self.minusButtonNode.action = { self.minusAction() }
        self.minusButtonNode.zPosition = self.zPosition + 1
        self.addChild(self.minusButtonNode)
        
        self.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func plusAction() -> Void {
        
        self.value += 1
        self.amountNode.text = "\(self.value)"
        self.delegate?.handleNew(value: self.value, for: self.boosterType)
    }
    
    func minusAction() -> Void {
        
        if self.value > 0 {
        
            self.value -= 1
            self.amountNode.text = "\(self.value)"
            self.delegate?.handleNew(value: self.value, for: self.boosterType)
        }
    }
    
    func updateLayout() {
        
        self.boosterTypeNode.position = CGPoint(x: 48, y: 0)
        self.boosterTypeTitleNode.position = CGPoint(x: 48 + 42, y: 6)
        self.boosterTypeSummaryNode.position = CGPoint(x: 48 + 42, y: -12)
        self.boosterTypeSummaryNode.maxWidth = self.size.width - 200
        self.boosterTypeSummaryNode.limitText()
        self.amountNode.position = CGPoint(x: self.size.width - 44, y: 6)
        self.plusButtonNode.position = CGPoint(x: self.size.width - 64, y: -16)
        self.minusButtonNode.position = CGPoint(x: self.size.width - 24, y: -16)
    }
}


