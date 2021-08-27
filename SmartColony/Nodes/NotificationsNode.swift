//
//  NotificationsNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol NotificationsDelegate: class {

    func handle(notification: NotificationItem?)
}

class NotificationsNode: SizedNode {

    // TODO: model?
    private var notifications: [NotificationItem] = []

    var notificationTopNode: SKSpriteNode?
    var notificationBagdeNodes: [SKSpriteNode?] = []
    var notificationIconNodes: [TouchableSpriteNode?] = []
    var notificationBottomNode: SKSpriteNode?

    weak var delegate: NotificationsDelegate?

    override init(sized size: CGSize) {

        super.init(sized: size)

        self.anchorPoint = .lowerLeft
        self.zPosition = Globals.ZLevels.sceneElements

        // notifications
        let notificationBottomTexture = SKTexture(imageNamed: "notification_bottom")
        self.notificationBottomNode = SKSpriteNode(texture: notificationBottomTexture, size: CGSize(width: 61, height: 95))
        self.notificationBottomNode?.zPosition = self.zPosition + 0.1
        self.notificationBottomNode?.anchorPoint = .lowerLeft
        self.addChild(notificationBottomNode!)

        self.rebuildNotificationBadges()

        let notificationTopTexture = SKTexture(imageNamed: "notification_top")
        self.notificationTopNode = SKSpriteNode(texture: notificationTopTexture, size: CGSize(width: 61, height: 38))
        self.notificationTopNode?.zPosition = self.zPosition + 0.1
        self.notificationTopNode?.anchorPoint = .lowerLeft
        self.addChild(notificationTopNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {

        self.notificationBottomNode?.position = self.position + CGPoint(x: 0, y: 35)
        for (index, notificationBagdeNode) in self.notificationBagdeNodes.enumerated() {
            notificationBagdeNode?.position = self.position + CGPoint(x: 0, y: 35 + 95 + (index * 65))
        }
        for (index, notificationIconNode) in self.notificationIconNodes.enumerated() {
            notificationIconNode?.position = self.position + CGPoint(x: 14, y: 35 + 106 + (index * 65))
        }
        self.notificationTopNode?.position = self.position + CGPoint(x: 0, y: 35 + 95 + (self.notificationBagdeNodes.count * 65))
    }

    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) -> Bool {

        let touch = touches.first!

        let location = touch.location(in: self)

        for (index, notificationIconNode) in self.notificationIconNodes.enumerated() {

            if notificationIconNode!.frame.contains(location) {
                let notification = self.notifications[index]
                self.delegate?.handle(notification: notification)
                return true
            }
        }

        return false
    }

    private func rebuildNotificationBadges() {

        // ensure that this runs on UI thread
        DispatchQueue.main.async {
            for notificationBagdeNode in self.notificationBagdeNodes {
                notificationBagdeNode?.removeFromParent()
            }

            for notificationIconNode in self.notificationIconNodes {
                notificationIconNode?.removeFromParent()
            }

            self.notificationBagdeNodes.removeAll()
            self.notificationIconNodes.removeAll()

            for notification in self.notifications {

                let notificationBadgeTexture = SKTexture(imageNamed: "notification_bagde")
                let notificationBadgeNode = SKSpriteNode(texture: notificationBadgeTexture, color: .black, size: CGSize(width: 61, height: 65))
                notificationBadgeNode.zPosition = self.zPosition + 0.1
                notificationBadgeNode.anchorPoint = .lowerLeft
                self.addChild(notificationBadgeNode)

                self.notificationBagdeNodes.append(notificationBadgeNode)

                let buttonIconTextureName = notification.type.iconTexture()
                let notificationIconNode = TouchableSpriteNode(imageNamed: buttonIconTextureName, size: CGSize(width: 40, height: 40))
                notificationIconNode.zPosition = self.zPosition + 0.2
                notificationIconNode.anchorPoint = .lowerLeft
                self.addChild(notificationIconNode)

                self.notificationIconNodes.append(notificationIconNode)
            }

            self.updateLayout()
        }
    }

    func add(notification: NotificationItem) {

        self.notifications.append(notification)
        self.rebuildNotificationBadges()
    }

    func remove(notification: NotificationItem) {

        self.notifications.removeAll(where: { $0.type == notification.type })
        self.rebuildNotificationBadges()
    }
}
