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
    func handleFocusOnUnit()
    func handleTechNeeded()
    func handleCivicNeeded()
    func handleProductionNeeded(at location: HexPoint)
    func handlePoliciesNeeded()
    func handleUnitPromotion(at location: HexPoint)
    
    func handle(command: Command)
}

class BottomLeftBar: SizedNode {
    
    private static let globeActionKey = "globeAnimation"
    private static let unitCommandsVisiblePosition: CGPoint = CGPoint(x: 0, y: 0)
    private static let unitCommandsInvisiblePosition: CGPoint = CGPoint(x: -40, y: 0)
    
    var backgroundCanvasNode: SKSpriteNode?
    var unitCanvasNode: SKSpriteNode?
    var unitImageNode: SKSpriteNode?
    var unitTypeBackgroundNode: SKSpriteNode?
    var unitTypeIconNode: SKSpriteNode?
    var glassCanvasNode: SKSpriteNode?
    
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders
    var turnButtonNotificationLocation: HexPoint = HexPoint.zero
    
    var unitCommandsCanvasNode: SKSpriteNode?
    var unitCommandsVisible: Bool = false
    
    var commands: [Command] = []
    var commandIconNodes: [TouchableSpriteNode?] = []
    
    weak var delegate: BottomLeftBarDelegate?

    override init(sized size: CGSize) {

        super.init(sized: size)
        
        self.anchorPoint = .lowerLeft
        self.zPosition = Globals.ZLevels.bottomElements

        let blackCircleTexture = SKTexture(imageNamed: "black_circle")
        self.backgroundCanvasNode = SKSpriteNode(texture: blackCircleTexture, color: .black, size: CGSize(width: 90, height: 90))
        self.backgroundCanvasNode?.zPosition = Globals.ZLevels.bottomElements + 0.2
        self.backgroundCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.backgroundCanvasNode!)
        
        let unitCanvasTexture = SKTexture(imageNamed: "unit_canvas")
        self.unitCanvasNode = SKSpriteNode(texture: unitCanvasTexture, color: .black, size: CGSize(width: 111, height: 112))
        self.unitCanvasNode?.zPosition = Globals.ZLevels.bottomElements + 0.3
        self.unitCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.unitCanvasNode!)
        
        let unitTypeBackgroundTexture = SKTexture(imageNamed: "unit_type_background")
        self.unitTypeBackgroundNode = SKSpriteNode(texture: unitTypeBackgroundTexture, color: .black, size: CGSize(width: 16, height: 16))
        self.unitTypeBackgroundNode?.zPosition = Globals.ZLevels.bottomElements + 0.6
        self.unitTypeBackgroundNode?.anchorPoint = .lowerLeft
        self.addChild(self.unitTypeBackgroundNode!)
        
        let unitTypeIconTexture = SKTexture(imageNamed: "unit_type_default")
        self.unitTypeIconNode = SKSpriteNode(texture: unitTypeIconTexture, color: .black, size: CGSize(width: 16, height: 16))
        self.unitTypeIconNode?.zPosition = Globals.ZLevels.bottomElements + 0.6
        self.unitTypeIconNode?.anchorPoint = .lowerLeft
        self.addChild(self.unitTypeIconNode!)
        
        let selectedUnitTexture = SKTexture(imageNamed: "button_generic")
        self.unitImageNode = SKSpriteNode(texture: selectedUnitTexture, color: .black, size: CGSize(width: 90, height: 90))
        self.unitImageNode?.zPosition = Globals.ZLevels.bottomElements + 0.4
        self.unitImageNode?.anchorPoint = .lowerLeft
        self.unitImageNode?.isUserInteractionEnabled = true
        self.addChild(self.unitImageNode!)
        
        let glassTexture = SKTexture(imageNamed: "glass")
        self.glassCanvasNode = SKSpriteNode(texture: glassTexture, size: CGSize(width: 90, height: 90))
        self.glassCanvasNode?.zPosition = Globals.ZLevels.bottomElements + 0.5
        self.glassCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.glassCanvasNode!)
        
        let commandsTexture = SKTexture(imageNamed: "unit_commands_body")
        self.unitCommandsCanvasNode = SKSpriteNode(texture: commandsTexture, size: CGSize(width: 200, height: 112))
        self.unitCommandsCanvasNode?.position = self.position + BottomLeftBar.unitCommandsInvisiblePosition
        self.unitCommandsCanvasNode?.zPosition = Globals.ZLevels.bottomElements + 0.0
        self.unitCommandsCanvasNode?.anchorPoint = .lowerLeft
        self.addChild(self.unitCommandsCanvasNode!)
        
        self.updateLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        
        self.backgroundCanvasNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.unitCanvasNode?.position = self.position + CGPoint(x: 0, y: 0)
        self.unitImageNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.unitTypeBackgroundNode?.position = self.position + CGPoint(x: 5, y: 5)
        self.unitTypeIconNode?.position = self.position + CGPoint(x: 5, y: 5)
        self.glassCanvasNode?.position = self.position + CGPoint(x: 3, y: 3)
        self.unitCommandsCanvasNode?.position = self.position + (self.unitCommandsVisible ? BottomLeftBar.unitCommandsVisiblePosition : BottomLeftBar.unitCommandsInvisiblePosition)
    }
    
    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
    
        let touch = touches.first!
    
        guard let unitImageNode = self.unitImageNode else {
            return false
        }
    
        let location = touch.location(in: self)

        if unitImageNode.frame.contains(location) {
            
            if self.turnButtonNotificationType == .turn {
                self.delegate?.handleTurnButtonClicked()
                return true
            } else if self.turnButtonNotificationType == .unitNeedsOrders {
                self.delegate?.handleFocusOnUnit()
                return true
            } else if self.turnButtonNotificationType == .techNeeded {
                self.delegate?.handleTechNeeded()
                return true
            } else if self.turnButtonNotificationType == .civicNeeded {
                self.delegate?.handleCivicNeeded()
                return true
            } else if self.turnButtonNotificationType == .productionNeeded {
                self.delegate?.handleProductionNeeded(at: self.turnButtonNotificationLocation)
                return true
            } else if self.turnButtonNotificationType == .policiesNeeded {
                self.delegate?.handlePoliciesNeeded()
                return true
            } else if self.turnButtonNotificationType == .unitPromotion {
                self.delegate?.handleUnitPromotion(at: self.turnButtonNotificationLocation)
                return true
            } else {
                print("--- unhandle notification type: \(self.turnButtonNotificationType)")
            }
        }
        
        let commandLocation = touch.location(in: self.unitCommandsCanvasNode!)
        
        for (index, commandIconNode) in self.commandIconNodes.enumerated() {
            
            if commandIconNode!.frame.contains(commandLocation) {
                let command = self.commands[index]
                self.delegate?.handle(command: command)
                return true
            }
        }
        
        return false
    }
    
    func showTurnButton() {
        
        self.unitImageNode?.texture = SKTexture(imageNamed: "button_turn")
        self.turnButtonNotificationType = .turn
    }
    
    func showBlockingButton(for blockingNotification: NotificationItem) {
        
        self.unitImageNode?.texture = SKTexture(imageNamed: blockingNotification.type.iconTexture())
        self.turnButtonNotificationType = blockingNotification.type
        self.turnButtonNotificationLocation = blockingNotification.location
    }
    
    func showSpinningGlobe() {
        
        let globeAtlas = GameObjectAtlas(atlasName: "globe", template: "globe", range: 0..<91)
        
        // start animation
        // let textureAtlasGlobe = SKTextureAtlas(named: globeAtlas.atlasName)
        let globeFrames: [SKTexture] = globeAtlas.textures // globeAtlas.textures.map { textureAtlasGlobe.textureNamed($0) }
        let globeRotation = SKAction.repeatForever(SKAction.animate(with: globeFrames, timePerFrame: 0.07))
        
        self.unitImageNode?.run(globeRotation, withKey: BottomLeftBar.globeActionKey)
    }
    
    func hideSpinningGlobe() {
        
        self.unitImageNode?.removeAction(forKey: BottomLeftBar.globeActionKey)
    }
   
    func selectedUnitChanged(to unit: AbstractUnit?, commands: [Command]) {

        self.turnButtonNotificationType = .unitNeedsOrders
        
        if let selectedUnit = unit {

            // make current unit visible
            
            self.unitImageNode?.texture = selectedUnit.type.iconTexture()
            
            // type
            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }
            
            self.unitTypeBackgroundNode?.color = civilization.backgroundColor()
            self.unitTypeBackgroundNode?.colorBlendFactor = 1.0
            self.unitTypeIconNode?.texture = SKTexture(imageNamed: selectedUnit.type.typeTexture())
            self.unitTypeIconNode?.color = civilization.iconColor()
            self.unitTypeIconNode?.colorBlendFactor = 1.0
            
            // commands
            
            for commandIconNode in self.commandIconNodes {
                commandIconNode?.removeFromParent()
            }
            
            self.commandIconNodes = []
            
            // show commands
            for (index, command) in commands.enumerated() {

                let commandNode = TouchableSpriteNode(imageNamed: command.type.iconTexture(), size: CGSize(width: 32, height: 32))
                commandNode.zPosition = 0.5
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
            
            // type
            self.unitTypeBackgroundNode?.color = SKColor.gray
            self.unitTypeBackgroundNode?.colorBlendFactor = 1.0
            
            let unitTypeIconTexture = SKTexture(imageNamed: "unit_type_default")
            self.unitTypeIconNode?.texture = unitTypeIconTexture
            self.unitTypeIconNode?.color = SKColor.white
            self.unitTypeIconNode?.colorBlendFactor = 1.0
            
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
