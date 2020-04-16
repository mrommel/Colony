//
//  BottomLeftBar.swift
//  SmartColony
//
//  Created by Michael Rommel on 30.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol BottomLeftBarDelegate: class {
    
    func handleTurnButtonClicked()
    func handle(notification: Notifications.Notification?)
    func handle(command: Command)
}

class BottomLeftBar: SizedNode {
    
    private static let globeActionKey = "globeAnimation"
    private static let unitCommandsVisiblePosition: CGPoint = CGPoint(x: 0, y: 0)
    private static let unitCommandsInvisiblePosition: CGPoint = CGPoint(x: -40, y: 0)
    
    var backgroundCanvasNode: SKSpriteNode?
    var unitCanvasNode: SKSpriteNode?
    var unitImageNode: SKSpriteNode?
    var glassCanvasNode: SKSpriteNode?
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders
    
    var unitCommandsCanvasNode: SKSpriteNode?
    var unitCommandsVisible: Bool = false
    
    var commands: [Command] = []
    var commandIconNodes: [TouchableSpriteNode?] = []
    
    var notifications: [Notifications.Notification] = []
    var notificationTopNode: SKSpriteNode?
    var notificationBagdeNodes: [SKSpriteNode?] = []
    var notificationIconNodes: [TouchableSpriteNode?] = []
    var notificationBottomNode: SKSpriteNode?
    
    weak var delegate: BottomLeftBarDelegate?

    override init(sized size: CGSize) {

        super.init(sized: size)
        
        self.anchorPoint = .lowerLeft
        self.zPosition = Globals.ZLevels.sceneElements

        let blackCircleTexture = SKTexture(imageNamed: "black_circle")
        self.backgroundCanvasNode = SKSpriteNode(texture: blackCircleTexture, color: .black, size: CGSize(width: 90, height: 90))
        self.backgroundCanvasNode?.zPosition = self.zPosition + 0.2
        self.backgroundCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.backgroundCanvasNode!)
        
        let unitCanvasTexture = SKTexture(imageNamed: "unit_canvas")
        self.unitCanvasNode = SKSpriteNode(texture: unitCanvasTexture, color: .black, size: CGSize(width: 111, height: 112))
        self.unitCanvasNode?.zPosition = self.zPosition + 0.3
        self.unitCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.unitCanvasNode!)
        
        let selectedUnitTexture = SKTexture(imageNamed: "button_generic")
        self.unitImageNode = SKSpriteNode(texture: selectedUnitTexture, color: .black, size: CGSize(width: 90, height: 90))
        self.unitImageNode?.zPosition = self.zPosition + 0.4
        self.unitImageNode?.anchorPoint = .lowerLeft
        self.unitImageNode?.isUserInteractionEnabled = true
        self.addChild(self.unitImageNode!)
        
        let glassTexture = SKTexture(imageNamed: "glass")
        self.glassCanvasNode = SKSpriteNode(texture: glassTexture, size: CGSize(width: 90, height: 90))
        self.glassCanvasNode?.zPosition = self.zPosition + 0.5
        self.glassCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.glassCanvasNode!)
        
        let commandsTexture = SKTexture(imageNamed: "unit_commands_body")
        self.unitCommandsCanvasNode = SKSpriteNode(texture: commandsTexture, size: CGSize(width: 200, height: 112))
        self.unitCommandsCanvasNode?.position = self.position + BottomLeftBar.unitCommandsInvisiblePosition
        self.unitCommandsCanvasNode?.zPosition = self.zPosition + 0.0
        self.unitCommandsCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.unitCommandsCanvasNode!)
        
        // notifications
        let notificationBottomTexture = SKTexture(imageNamed: "notification_bottom")
        self.notificationBottomNode = SKSpriteNode(texture: notificationBottomTexture, size: CGSize(width: 61, height: 95))
        self.notificationBottomNode?.zPosition = self.zPosition + 0.1
        self.notificationBottomNode?.anchorPoint = .lowerLeft
        self.addChild(notificationBottomNode!)
        
        // self.notifications.append(Notifications.Notification(type: .generic, message: "test", summary: "test", at: HexPoint(x: 1, y: 1)))
        // self.notifications.append(Notifications.Notification(type: .tech, message: "test", summary: "test", at: HexPoint(x: 1, y: 1)))
        self.rebuildNotificationBadges()
        
        let notificationTopTexture = SKTexture(imageNamed: "notification_top")
        self.notificationTopNode = SKSpriteNode(texture: notificationTopTexture, size: CGSize(width: 61, height: 38))
        self.notificationTopNode?.zPosition = self.zPosition + 0.1
        self.notificationTopNode?.anchorPoint = .lowerLeft
        self.addChild(notificationTopNode!)
        
        self.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        
        self.backgroundCanvasNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.unitCanvasNode?.position = self.position + CGPoint(x: 0, y: 0)
        self.unitImageNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.glassCanvasNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.unitCommandsCanvasNode?.position = self.position + (self.unitCommandsVisible ? BottomLeftBar.unitCommandsVisiblePosition : BottomLeftBar.unitCommandsInvisiblePosition)
        
        self.notificationBottomNode?.position = self.position + CGPoint(x: 0, y: 25)
        for (index, notificationBagdeNode) in self.notificationBagdeNodes.enumerated() {
            notificationBagdeNode?.position = self.position + CGPoint(x: 0, y: 25 + 95 + (index * 65))
        }
        for (index, notificationIconNode) in self.notificationIconNodes.enumerated() {
            notificationIconNode?.position = self.position + CGPoint(x: 14, y: 25 + 106 + (index * 65))
        }
        self.notificationTopNode?.position = self.position + CGPoint(x: 0, y: 25 + 95 + (self.notificationBagdeNodes.count * 65))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch = touches.first!
    
        guard let unitImageNode = self.unitImageNode else {
            return
        }
    
        let location = touch.location(in: self)

        if unitImageNode.frame.contains(location) {
            //print("==> main button")
            if self.turnButtonNotificationType == .turn {
                self.delegate?.handleTurnButtonClicked()
            } else {
                // self.delegate?.handle(notification: <#T##Notifications.Notification?#>)
            }
        }
        
        for (index, notificationIconNode) in self.notificationIconNodes.enumerated() {
            
            if notificationIconNode!.frame.contains(location) {
                let notification = self.notifications[index]
                self.delegate?.handle(notification: notification)
                return
            }
        }
        
        let commandLocation = touch.location(in: self.unitCommandsCanvasNode!)
        
        for (index, commandIconNode) in self.commandIconNodes.enumerated() {
            
            if commandIconNode!.frame.contains(commandLocation) {
                let command = self.commands[index]
                self.delegate?.handle(command: command)
                return
            }
        }
    }
    
    func rebuildNotificationBadges() {
        
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
    
    func showTurnButton() {
        
        self.unitImageNode?.texture = SKTexture(imageNamed: "button_turn")
        self.turnButtonNotificationType = .turn
    }
    
    func showBlockingButton(for blockingNotification: Notifications.Notification) {
        
        self.unitImageNode?.texture = SKTexture(imageNamed: blockingNotification.type.iconTexture())
        self.turnButtonNotificationType = blockingNotification.type
        
        // todo remove from notifictionslist
    }
    
    func showSpinningGlobe() {
        
        let globeAtlas = GameObjectAtlas(atlasName: "globe", template: "globe", range: 0..<91)
        
        // start animation
        let textureAtlasGlobe = SKTextureAtlas(named: globeAtlas.atlasName)
        let globeFrames: [SKTexture] = globeAtlas.textures.map { textureAtlasGlobe.textureNamed($0) }
        let globeRotation = SKAction.repeatForever(SKAction.animate(with: globeFrames, timePerFrame: 0.2))
        
        self.unitImageNode?.run(globeRotation, withKey: BottomLeftBar.globeActionKey)
    }
    
    func hideSpinningGlobe() {
        
        self.unitImageNode?.removeAction(forKey: BottomLeftBar.globeActionKey)
    }
   
    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command]) {

        self.turnButtonNotificationType = .unitNeedsOrders
        
        if let selectedUnit = unit {
            
            // move possible shown notifications
            
            // make current unit visible
            let selectedUnitTextureString = selectedUnit.type.spriteName
            let selectedUnitTexture = SKTexture(imageNamed: selectedUnitTextureString)
        
            self.unitImageNode?.texture = selectedUnitTexture
            
            for commandIconNode in self.commandIconNodes {
                commandIconNode?.removeFromParent()
            }
            
            self.commandIconNodes = []
            
            // show commands
            for (index, command) in commands.enumerated() {

                let commandNode = TouchableSpriteNode(imageNamed: command.type.iconTexture(), size: CGSize(width: 32, height: 32))
                commandNode.zPosition = self.zPosition + 0.2
                commandNode.position = CGPoint(x: 120, y: 112 - 44 - index * 34)
                commandNode.anchorPoint = CGPoint.lowerLeft
                self.unitCommandsCanvasNode?.addChild(commandNode)
                
                commandIconNodes.append(commandNode)
            }
            
            self.commands = commands
            
            let moveAction = SKAction.move(to: self.position + BottomLeftBar.unitCommandsVisiblePosition, duration:(TimeInterval(0.3)))
            self.unitCommandsCanvasNode?.run(moveAction, withKey: "showUnitCommands", completion: {
                self.unitCommandsVisible = true
            })
        } else {
            let selectedUnitTexture = SKTexture(imageNamed: "button_generic")
            self.unitImageNode?.texture = selectedUnitTexture
            
            // hide commands
            let moveAction = SKAction.move(to: self.position + BottomLeftBar.unitCommandsInvisiblePosition, duration:(TimeInterval(0.3)))
            self.unitCommandsCanvasNode?.run(moveAction, withKey: "hideUnitCommands", completion: {
                self.unitCommandsVisible = false
                
                for commandIconNode in self.commandIconNodes {
                    commandIconNode?.removeFromParent()
                }
                
                self.commandIconNodes = []
                self.commands = []
            })
        }
    }
}
