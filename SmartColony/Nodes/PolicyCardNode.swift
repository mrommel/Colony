//
//  PolicyCardNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class PolicyCardNode: SKNode {

    // nodes
    var backgroundNode: SKSpriteNode?
    var titleLabel: SKLabelNode?
    var bonusLabel: SKLabelNode?

    // MARK: constructors

    init(policyCard: PolicyCardType) {

        super.init()

        let size = CGSize(width: 100, height: 100)

        let texture = SKTexture(imageNamed: policyCard.iconTexture())
        self.backgroundNode = SKSpriteNode(texture: texture, color: .black, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // /////////////////////
        // title
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]

        let titleTextAttributed = NSAttributedString(string: policyCard.name(), attributes: titleTextAttributes)

        self.titleLabel = SKLabelNode(attributedText: titleTextAttributed)
        self.titleLabel?.fontSize = 12
        self.titleLabel?.fontColor = .black
        self.titleLabel?.zPosition = self.zPosition + 10
        self.titleLabel?.verticalAlignmentMode = .center
        self.titleLabel?.position = CGPoint(x: size.halfWidth, y: -15)
        self.addChild(self.titleLabel!)

        // /////////////////////
        // bonus
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let bonusTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: 10),
            .paragraphStyle: paragraphStyle
        ]

        let bonusTextAttributed = NSAttributedString(string: policyCard.bonus().replaceIcons(), attributes: bonusTextAttributes)
        
        self.bonusLabel = SKLabelNode(attributedText: bonusTextAttributed)
        self.bonusLabel?.zPosition = self.zPosition + 10
        self.bonusLabel?.verticalAlignmentMode = .top
        self.bonusLabel?.numberOfLines = 0
        self.bonusLabel?.preferredMaxLayoutWidth = 60
        self.bonusLabel?.position = CGPoint(x: size.halfWidth, y: -22)

        self.addChild(self.bonusLabel!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
