//
//  BottomCombatBar.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

enum CombatType {
    
    case melee
    case ranged
}

protocol BottomCombatBarDelegate: class {
    
    func doCombat(of attacker: AbstractUnit?, against defender: AbstractUnit?)
    func cancelCombat()
}

class BottomCombatBar: SizedNode {

    // properties
    
    var attacker: AbstractUnit?
    var defender: AbstractUnit?
    
    // nodes
    
    var combatCanvasNode: SKSpriteNode?
    var combatAttackNode: SKSpriteNode?
    var combatCancelNode: SKSpriteNode?
    var combatCanvasVisible: Bool = false
    
    var attackerHealthNode: CircularProgressBarNode?
    var defenderHealthNode: CircularProgressBarNode?
    
    // delegate
    
    weak var delegate: BottomCombatBarDelegate?
    
    // MARK: constructors

    override init(sized size: CGSize) {

        super.init(sized: size)

        self.anchorPoint = .lowerLeft
        self.zPosition = Globals.ZLevels.combatElements

        let combatViewTexture = SKTexture(imageNamed: "combat_view")
        self.combatCanvasNode = SKSpriteNode(texture: combatViewTexture, size: size)
        self.combatCanvasNode?.zPosition = Globals.ZLevels.combatElements
        self.combatCanvasNode?.anchorPoint = .lowerLeft
        // dont add to view yet
        
        let combatAttackTexture = SKTexture(imageNamed: "combat_option_melee")
        self.combatAttackNode = SKSpriteNode(texture: combatAttackTexture, size: CGSize(width: 43, height: 37))
        self.combatAttackNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        self.combatAttackNode?.anchorPoint = .lowerLeft
        
        let combatCancelTexture = SKTexture(imageNamed: "combat_option_cancel")
        self.combatCancelNode = SKSpriteNode(texture: combatCancelTexture, size: CGSize(width: 43, height: 37))
        self.combatCancelNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        self.combatCancelNode?.anchorPoint = .lowerLeft
        
        self.attackerHealthNode = CircularProgressBarNode(type: .attackerHealth, size: CGSize(width: 60, height: 60))
        self.attackerHealthNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        
        self.defenderHealthNode = CircularProgressBarNode(type: .defenderHealth, size: CGSize(width: 60, height: 60))
        self.defenderHealthNode?.zPosition = Globals.ZLevels.combatElements + 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {

        self.combatCanvasNode?.position = self.position
        self.combatAttackNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 43, y: self.position.y + 90)
        self.combatCancelNode?.position = CGPoint(x: self.position.x + self.size.halfWidth, y: self.position.y + 90)
        
        self.attackerHealthNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 29, y: self.position.y + 47)
        self.defenderHealthNode?.position = CGPoint(x: self.position.x + self.size.halfWidth + 29, y: self.position.y + 47)
    }
    
    func showCombatView() {
        
        if self.combatCanvasVisible {
            return
        }
        
        // now add the nodes
        self.addChild(self.combatCancelNode!)
        self.addChild(self.combatCanvasNode!)
        
        self.addChild(self.attackerHealthNode!)
        self.addChild(self.defenderHealthNode!)

        self.combatCanvasVisible = true
    }

    func combatPrediction(of attacker: AbstractUnit?, against defender: AbstractUnit?, mode: CombatType) {

        if !self.combatCanvasVisible {
            print("show not happen")
            return
        }
        
        self.attacker = attacker
        self.defender = defender

        // mode => different texture
        let combatAttackTexture = SKTexture(imageNamed: mode == .melee ? "combat_option_melee" : "combat_option_ranged")
        self.combatAttackNode?.texture = combatAttackTexture
        
        if self.combatAttackNode?.parent == nil {
            self.addChild(self.combatAttackNode!)
        }
        
        if let attacker = self.attacker {
            let imageIndex = min(25, max(0, attacker.healthPoints() / 4 )) // the assets are from 0 to 25
            self.attackerHealthNode?.value = imageIndex
        }
        
        if let defender = self.defender {
            let imageIndex = min(25, max(0, defender.healthPoints() / 4 )) // the assets are from 0 to 25
            self.defenderHealthNode?.value = imageIndex
        }
    }

    func hideCombatView() {

        if !self.combatCanvasVisible {
            return
        }

        self.combatAttackNode?.removeFromParent()
        self.combatCancelNode?.removeFromParent()
        self.combatCanvasNode?.removeFromParent()
        
        self.attackerHealthNode?.removeFromParent()
        self.defenderHealthNode?.removeFromParent()

        self.combatCanvasVisible = false
    }
    
    func handleTouches(_ touches: Set<UITouch>, with event: UIEvent?) -> Bool {
    
        if !self.combatCanvasVisible {
            return false
        }
        
        let touch = touches.first!
    
        let location = touch.location(in: self)
        
        if combatCancelNode!.frame.contains(location) {
            self.delegate?.cancelCombat()
            return true
        }
        
        if combatAttackNode!.frame.contains(location) {
            self.delegate?.doCombat(of: self.attacker, against: self.defender)
            return true
        }
        
        return false
    }
}
