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
    
    // delegate
    
    weak var delegate: BottomCombatBarDelegate?
    
    // MARK: constructors

    override init(sized size: CGSize) {

        super.init(sized: size)

        self.anchorPoint = .lowerLeft
        self.zPosition = Globals.ZLevels.sceneElements + 5

        let combatViewTexture = SKTexture(imageNamed: "combat_view")
        self.combatCanvasNode = SKSpriteNode(texture: combatViewTexture, size: size)
        self.combatCanvasNode?.zPosition = Globals.ZLevels.bottomElements + 5
        self.combatCanvasNode?.anchorPoint = .lowerLeft
        // dont add to view yet
        
        let combatAttackTexture = SKTexture(imageNamed: "combat_option_melee")
        self.combatAttackNode = SKSpriteNode(texture: combatAttackTexture, size: CGSize(width: 43, height: 37))
        self.combatAttackNode?.zPosition = Globals.ZLevels.bottomElements + 6
        self.combatAttackNode?.anchorPoint = .lowerLeft
        
        let combatCancelTexture = SKTexture(imageNamed: "combat_option_cancel")
        self.combatCancelNode = SKSpriteNode(texture: combatCancelTexture, size: CGSize(width: 43, height: 37))
        self.combatCancelNode?.zPosition = Globals.ZLevels.bottomElements + 6
        self.combatCancelNode?.anchorPoint = .lowerLeft
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {

        self.combatCanvasNode?.position = self.position
        self.combatAttackNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 43, y: self.position.y + 80)
        self.combatCancelNode?.position = CGPoint(x: self.position.x + self.size.halfWidth, y: self.position.y + 80)
    }

    func combatPrediction(of attacker: AbstractUnit?, against defender: AbstractUnit?, mode: CombatType) {

        if self.combatCanvasVisible {
            return
        }
        
        self.attacker = attacker
        self.defender = defender

        // mode => different texture
        let combatAttackTexture = SKTexture(imageNamed: mode == .melee ? "combat_option_melee" : "combat_option_ranged")
        self.combatAttackNode?.texture = combatAttackTexture
        self.addChild(self.combatAttackNode!)
        self.addChild(self.combatCancelNode!)
        self.addChild(self.combatCanvasNode!)

        self.combatCanvasVisible = true
    }

    func hideCombatPrediction() {

        if !self.combatCanvasVisible {
            return
        }

        self.combatAttackNode?.removeFromParent()
        self.combatCancelNode?.removeFromParent()
        self.combatCanvasNode?.removeFromParent()

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
