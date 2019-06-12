//
//  MessageBoxNode.swift
//  Colony
//
//  Created by Michael Rommel on 01.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

enum MessageBoxActionType {
    case left
    case right
    case center
}

class MessageBoxAction {

    let title: String
    let type: MessageBoxActionType
    let handler: () -> Void

    init(title: String, type: MessageBoxActionType, handler: @escaping () -> Void) {

        self.title = title
        self.type = type
        self.handler = handler
    }
}

class MessageBoxNode: NineGridTextureSprite {

    var titleLabel: SKLabelNode
    var imageLabel: SKSpriteNode? = nil
    var messageLabel: SKLabelNode

    init(titled title: String, message: String) {

        self.titleLabel = SKLabelNode(text: title)
        self.titleLabel.fontColor = UIColor.white
        self.titleLabel.position = CGPoint(x: 0, y: 40)
        self.titleLabel.fontSize = 18
        self.titleLabel.fontName = "Helvetica-Bold"
        self.titleLabel.verticalAlignmentMode = .center
        self.titleLabel.name = "titleLabel"

        self.messageLabel = SKLabelNode(text: message)
        self.messageLabel.fontColor = UIColor.white
        self.messageLabel.position = CGPoint(x: 0, y: 5)
        self.messageLabel.fontSize = 14
        self.messageLabel.fontName = "Helvetica-Bold"
        self.messageLabel.verticalAlignmentMode = .center
        self.messageLabel.name = "messageLabel"

        super.init(imageNamed: "grid9_dialog", size: CGSize(width: 250, height: 170))

        self.isUserInteractionEnabled = true

        self.titleLabel.zPosition = self.zPosition + 1
        self.addChild(self.titleLabel)

        self.messageLabel.zPosition = self.zPosition + 1
        self.addChild(self.messageLabel)
    }
    
    init(imageNamed imageName: String, title: String, message: String) {
        
        self.titleLabel = SKLabelNode(text: title)
        self.titleLabel.fontColor = UIColor.white
        self.titleLabel.position = CGPoint(x: 0, y: 40)
        self.titleLabel.fontSize = 18
        self.titleLabel.fontName = "Helvetica-Bold"
        self.titleLabel.verticalAlignmentMode = .center
        self.titleLabel.name = "titleLabel"
        
        let imageSize = CGSize(width: 200, height: 120)
        let imageTexture = SKTexture(imageNamed: imageName)
        self.imageLabel = SKSpriteNode(texture: imageTexture, size: imageSize)
        self.imageLabel?.position = CGPoint(x: 0, y: 5)
        
        self.messageLabel = SKLabelNode(text: message)
        self.messageLabel.fontColor = UIColor.white
        self.messageLabel.position = CGPoint(x: 0, y: 5)
        self.messageLabel.fontSize = 14
        self.messageLabel.fontName = "Helvetica-Bold"
        self.messageLabel.verticalAlignmentMode = .center
        self.messageLabel.name = "messageLabel"
        
        super.init(imageNamed: "grid9_dialog", size: CGSize(width: 300, height: 370))
        
        self.isUserInteractionEnabled = true
        
        self.titleLabel.zPosition = self.zPosition + 1
        self.addChild(self.titleLabel)
        
        self.imageLabel?.zPosition = self.zPosition + 1
        self.addChild(self.imageLabel!)
        
        self.messageLabel.zPosition = self.zPosition + 1
        self.addChild(self.messageLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func dismiss() {
        self.removeAllChildren()
        self.removeFromParent()
    }

    func addAction(_ action: MessageBoxAction) {

        switch action.type {

        case .left:
            let leftButton = MessageBoxButtonNode(titled: action.title, buttonAction: action.handler)
            leftButton.position = CGPoint(x: -60, y: -40)
            leftButton.zPosition = self.zPosition + 1
            self.addChild(leftButton)
            break

        case .right:
            let rightButton = MessageBoxButtonNode(titled: action.title, buttonAction: action.handler)
            rightButton.position = CGPoint(x: 60, y: -40)
            rightButton.zPosition = self.zPosition + 1
            self.addChild(rightButton)
            break

        case .center:
            let centerButton = MessageBoxButtonNode(titled: action.title, buttonAction: action.handler)
            centerButton.position = CGPoint(x: 0, y: -40)
            centerButton.zPosition = self.zPosition + 1
            self.addChild(centerButton)
            break
        }
    }
}
