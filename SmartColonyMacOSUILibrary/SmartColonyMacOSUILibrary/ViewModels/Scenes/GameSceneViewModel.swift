//
//  GameSceneViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import Cocoa
import SmartAILibrary
import SmartAssets

public class GameSceneViewModel: ObservableObject {
    
    enum GameSceneCombatMode {
        
        case none
        case melee
        case ranged
    }
    
    @Published
    var game: GameModel?
    
    @Published
    var selectedUnit: AbstractUnit? = nil
    
    @Published
    var sceneCombatMode: GameSceneCombatMode = .none
    
    @Published
    var turnButtonNotificationType: NotificationType = .unitNeedsOrders
    
    @Published
    var showCommands: Bool = false
    
    public init() {
        
        self.game = nil
    }
    
    public func doTurn() {
        
        print("do turn: \(self.turnButtonNotificationType)")
        
        if self.turnButtonNotificationType == .turn {
            // self.delegate?.handleTurnButtonClicked()
            return
        } else if self.turnButtonNotificationType == .unitNeedsOrders {
            // self.delegate?.handleFocusOnUnit()
            return
        } else if self.turnButtonNotificationType == .techNeeded {
            // self.delegate?.handleTechNeeded()
            return
        } else if self.turnButtonNotificationType == .civicNeeded {
            // self.delegate?.handleCivicNeeded()
            return
        } else if self.turnButtonNotificationType == .productionNeeded {
            // self.delegate?.handleProductionNeeded(at: self.turnButtonNotificationLocation)
            return
        } else if self.turnButtonNotificationType == .policiesNeeded {
            // self.delegate?.handlePoliciesNeeded()
            return
        } else if self.turnButtonNotificationType == .unitPromotion {
            // self.delegate?.handleUnitPromotion(at: self.turnButtonNotificationLocation)
            return
        } else {
            print("--- unhandled notification type: \(self.turnButtonNotificationType)")
        }
    }
    
    public func buttonImage() -> NSImage {
        
        if let selectedUnit = self.selectedUnit {
            return selectedUnit.type.iconTexture()
        } else {
            return NSImage(named: "button_generic")!
        }
    }
    
    public func typeImage() -> NSImage {
        
        if let selectedUnit = self.selectedUnit {
            
            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }
            
            let image = ImageCache.shared.image(for: selectedUnit.type.typeTexture())
            
            return image.tint(with: civilization.accent)
            
        } else {
            return ImageCache.shared.image(for: "unit-type-default")
        }
    }
    
    public func typeBackgroundImage() -> NSImage {

        if let selectedUnit = self.selectedUnit {
            
            guard let civilization = selectedUnit.player?.leader.civilization() else {
                fatalError("cant get civ")
            }

            return NSImage(color: civilization.main, size: NSSize(width: 16, height: 16))
            
        } else {
            return NSImage(color: .black, size: NSSize(width: 16, height: 16))
        }
    }
    
    public func unitName() -> String {
        
        if let selectedUnit = self.selectedUnit {
            return selectedUnit.name()
        } else {
            return ""
        }
    }
    
    func selectedUnitChanged(commands: [Command], in gameModel: GameModel?) {
        
        self.turnButtonNotificationType = .unitNeedsOrders
        
        // init
        
        if let selectedUnit = self.selectedUnit {
            
            // make current unit visible
            print("has unit")
            
            /*
             
             // type
             guard let civilization = selectedUnit.player?.leader.civilization() else {
             fatalError("cant get civ")
             }
             
             self.unitTypeBackgroundNode?.color = civilization.backgroundColor()
             self.unitTypeBackgroundNode?.colorBlendFactor = 1.0
             self.unitTypeIconNode?.texture = SKTexture(imageNamed: selectedUnit.type.typeTexture())
             self.unitTypeIconNode?.color = civilization.iconColor()
             self.unitTypeIconNode?.colorBlendFactor = 1.0
             
             if self.unitName == nil {
             self.unitName = SKLabelNode()
             self.unitName?.position = CGPoint(x: 110, y: 82)
             self.unitName?.zPosition = 0.5
             self.unitName?.fontSize = 16
             self.unitName?.horizontalAlignmentMode = .left
             self.unitCommandsCanvasNode?.addChild(self.unitName!)
             }
             
             self.unitName?.text = selectedUnit.name()
             if self.unitName?.parent == nil {
             self.unitCommandsCanvasNode?.addChild(self.unitName!)
             }
             
             if self.unitMoves == nil {
             self.unitMoves = SKLabelNode()
             self.unitMoves?.position = CGPoint(x: 110, y: 65)
             self.unitMoves?.zPosition = 0.5
             self.unitMoves?.fontSize = 16
             self.unitMoves?.horizontalAlignmentMode = .left
             self.unitCommandsCanvasNode?.addChild(self.unitMoves!)
             }
             
             self.unitMoves?.text = "\(selectedUnit.moves()) / \(selectedUnit.maxMoves(in: gameModel)) Moves"
             if self.unitMoves?.parent == nil {
             self.unitCommandsCanvasNode?.addChild(self.unitMoves!)
             }
             
             if self.unitHealth == nil {
             self.unitHealth = SKLabelNode()
             self.unitHealth?.position = CGPoint(x: 110, y: 48)
             self.unitHealth?.zPosition = 0.5
             self.unitHealth?.fontSize = 14
             self.unitHealth?.horizontalAlignmentMode = .left
             self.unitCommandsCanvasNode?.addChild(self.unitHealth!)
             }
             
             self.unitHealth?.text = "\(selectedUnit.healthPoints()) ⚕"
             if self.unitHealth?.parent == nil {
             self.unitCommandsCanvasNode?.addChild(self.unitHealth!)
             }
             
             if self.unitCharges == nil && selectedUnit.type.buildCharges() > 0 {
             self.unitCharges = SKLabelNode()
             self.unitCharges?.position = CGPoint(x: 110, y: 31)
             self.unitCharges?.zPosition = 0.5
             self.unitCharges?.fontSize = 14
             self.unitCharges?.horizontalAlignmentMode = .left
             self.unitCommandsCanvasNode?.addChild(self.unitCharges!)
             }
             
             self.unitCharges?.text = "\(selectedUnit.buildCharges()) ♾"
             if self.unitCharges != nil && self.unitCharges?.parent == nil {
             self.unitCommandsCanvasNode?.addChild(self.unitCharges!)
             }
             
             // commands
             
             for commandIconNode in self.commandIconNodes {
             commandIconNode?.removeFromParent()
             }
             
             self.commandIconNodes = []
             
             // show commands
             for (index, command) in commands.enumerated() {
             
             if command.type == .cancelAttack {
             continue
             }
             
             let commandNode = TouchableSpriteNode(imageNamed: command.type.commandTexture(), size: CGSize(width: 32, height: 32))
             commandNode.zPosition = 0.5
             commandNode.position = CGPoint(x: 40 + index * 34, y: 108)
             commandNode.anchorPoint = CGPoint.lowerLeft
             commandNode.isUserInteractionEnabled = true
             commandNode.identifier = command.type.identifier()
             commandNode.delegate = self
             self.unitCommandsCanvasNode?.addChild(commandNode)
             
             commandIconNodes.append(commandNode)
             }
             
             self.commands = commands
             
             let moveAction = SKAction.move(to: self.position + BottomLeftBar.unitCommandsVisiblePosition, duration:(TimeInterval(0.3)))
             self.unitCommandsCanvasNode?.run(moveAction, withKey: "showUnitCommands", completion: {
             self.unitCommandsVisible = true
             })*/
            
            self.showCommands = true
        } else {
            print("no unit")
            /*
             
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
             
             self.unitName?.removeFromParent()
             self.unitCharges?.removeFromParent()
             self.unitHealth?.removeFromParent()
             self.unitMoves?.removeFromParent()
             */
            self.showCommands = false
        }
    }
}
