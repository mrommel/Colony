//
//  NotificationSkene.swift
//  Colony
//
//  Created by Michael Rommel on 31.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class NotificationSkene: SKScene {

    var messages: [NotificationNode] = []

    override init(size: CGSize) {

        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(message: String, for seconds: TimeInterval = 5.0) {

        let notificationNode = NotificationNode(message: message)
        notificationNode.zPosition = GameScene.Constants.ZLevels.messages // on top of everything
        notificationNode.position = self.nextNotificationPosition()
        notificationNode.alpha = 0

        self.addChild(notificationNode)

        self.messages.append(notificationNode)
        self.updateMessages()
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let display = SKAction.wait(forDuration: seconds)
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let flashAction = SKAction.sequence([fadeIn, display, fadeOut])
        
        notificationNode.run(flashAction, completion: {
            notificationNode.removeFromParent()
            self.messages.removeFirst()
            self.updateMessages()
        })
    }
    
    private func nextNotificationPosition() -> CGPoint {
        
        let posY = self.size.halfHeight - 50
        return CGPoint(x: 0, y: posY - 36.0 * CGFloat(self.messages.count))
    }
    
    private func updateMessages() {
        
        var posY = self.size.halfHeight - 50
        for message in self.messages {
            
            let moveAction = SKAction.move(to: CGPoint(x: 0, y: posY), duration: 0.5)
            message.run(moveAction)
            
            posY -= 36
        }
    }
}
