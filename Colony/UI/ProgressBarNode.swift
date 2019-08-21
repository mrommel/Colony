//
//  ProgressBarNode.swift
//  Colony
//
//  Created by Michael Rommel on 02.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class ProgressBarNode: SKNode {

    private static let kProgressAnimationKey = "progressAnimationKey"
    
    var progressBar: SKCropNode
    let percentageLabel: SKLabelNode

    init(size: CGSize) {

        progressBar = SKCropNode()
        percentageLabel = SKLabelNode()
        
        super.init()
        
        let filledImage = NineGridTextureSprite(imageNamed: "grid9_progress", size: size)
        self.progressBar.addChild(filledImage)
        
        self.progressBar.maskNode = SKSpriteNode(color: UIColor.white,
            size: CGSize(width: size.width * 2, height: size.height * 2))

        self.progressBar.maskNode?.position = CGPoint(x: -size.width / 2, y: -size.height / 2)
        self.progressBar.zPosition = self.zPosition + 2
        self.progressBar.maskNode?.xScale = 0
        self.addChild(self.progressBar)
        
        self.percentageLabel.position = CGPoint(x: self.position.x, y: self.position.y)
        self.percentageLabel.zPosition = self.zPosition + 3
        self.percentageLabel.fontColor = UIColor.white
        self.percentageLabel.fontSize = 18
        self.percentageLabel.verticalAlignmentMode = .center
        self.percentageLabel.name = "percentageLabel"
        self.addChild(self.percentageLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(progress: CGFloat) {
        
        self.progressBar.maskNode?.removeAction(forKey: ProgressBarNode.kProgressAnimationKey)
        
        let value = max(0.0, min(1.0, progress))
        
        let scaleAction = SKAction.scaleX(to: value, duration: 0.3)
        self.progressBar.maskNode?.run(scaleAction, withKey: ProgressBarNode.kProgressAnimationKey)

        let percentageValue: Int = Int(value * 100.0)
        self.percentageLabel.text = "\(percentageValue)%"
    }
}
