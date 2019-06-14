//
//  ProgressBarNode.swift
//  Colony
//
//  Created by Michael Rommel on 02.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class ProgressBarNode: SKNode {

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
        self.progressBar.zPosition = 5
        self.addChild(self.progressBar)
        
        self.percentageLabel.position = CGPoint(x: self.position.x, y: self.position.y)
        self.percentageLabel.zPosition = 6
        self.percentageLabel.fontColor = UIColor.white
        self.percentageLabel.fontSize = 18
        self.percentageLabel.fontName = "Helvetica-Bold"
        self.percentageLabel.verticalAlignmentMode = .center
        self.percentageLabel.name = "percentageLabel"
        self.addChild(self.percentageLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(progress: CGFloat) {
        
        var value = progress
        if progress < 0 {
            value = 0
        }
        if progress > 1 {
            value = 1
        }
        
        self.progressBar.maskNode?.xScale = value
        let percentageValue: Int = Int(value * 100.0)
        self.percentageLabel.text = "\(percentageValue)%"
    }
}
