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
    var attackerIconNode: SKSpriteNode?
    var attackerNameNode: SKLabelNode?
    var attackerBaseStrengthNode: SKLabelNode?
    var attackerStrengthBonusNodes: [SKLabelNode?] = []

    var defenderHealthNode: CircularProgressBarNode?
    var defenderIconNode: SKSpriteNode?
    var defenderNameNode: SKLabelNode?
    var defenderBaseStrengthNode: SKLabelNode?
    var defenderStrengthBonusNodes: [SKLabelNode?] = []

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

        // attacker
        self.attackerHealthNode = CircularProgressBarNode(type: .attackerHealth, size: CGSize(width: 60, height: 60))
        self.attackerHealthNode?.zPosition = Globals.ZLevels.combatElements + 1.0

        let attackerTypeTexture = SKTexture(imageNamed: "unit_type_default")
        self.attackerIconNode = SKSpriteNode(texture: attackerTypeTexture, color: .black, size: CGSize(width: 40, height: 40))
        self.attackerIconNode?.zPosition = Globals.ZLevels.combatElements + 1.0

        self.attackerNameNode = SKLabelNode()
        self.attackerNameNode?.horizontalAlignmentMode = .right
        self.attackerNameNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        self.attackerNameNode?.fontSize = 16.0
        self.attackerNameNode?.fontColor = .white

        self.attackerBaseStrengthNode = SKLabelNode()
        self.attackerBaseStrengthNode?.horizontalAlignmentMode = .right
        self.attackerBaseStrengthNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        self.attackerBaseStrengthNode?.fontSize = 14.0
        self.attackerBaseStrengthNode?.fontColor = .white

        // defender
        self.defenderHealthNode = CircularProgressBarNode(type: .defenderHealth, size: CGSize(width: 60, height: 60))
        self.defenderHealthNode?.zPosition = Globals.ZLevels.combatElements + 1.0

        let defenderTypeTexture = SKTexture(imageNamed: "unit_type_default")
        self.defenderIconNode = SKSpriteNode(texture: defenderTypeTexture, color: .black, size: CGSize(width: 40, height: 40))
        self.defenderIconNode?.zPosition = Globals.ZLevels.combatElements + 1.0

        self.defenderNameNode = SKLabelNode()
        self.defenderNameNode?.horizontalAlignmentMode = .left
        self.defenderNameNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        self.defenderNameNode?.fontSize = 16.0
        self.defenderNameNode?.fontColor = .white

        self.defenderBaseStrengthNode = SKLabelNode()
        self.defenderBaseStrengthNode?.horizontalAlignmentMode = .left
        self.defenderBaseStrengthNode?.zPosition = Globals.ZLevels.combatElements + 1.0
        self.defenderBaseStrengthNode?.fontSize = 14.0
        self.defenderBaseStrengthNode?.fontColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateLayout() {

        self.combatCanvasNode?.position = self.position
        self.combatAttackNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 43, y: self.position.y + 90)
        self.combatCancelNode?.position = CGPoint(x: self.position.x + self.size.halfWidth, y: self.position.y + 90)

        // attacker
        self.attackerHealthNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 29, y: self.position.y + 47)
        self.attackerIconNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 29, y: self.position.y + 47)
        self.attackerNameNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 80, y: self.position.y + 87)
        self.attackerBaseStrengthNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 80, y: self.position.y + 65)

        var attackerY: CGFloat = 50.0
        for attackerStrengthBonusNode in self.attackerStrengthBonusNodes {
            attackerStrengthBonusNode?.position = CGPoint(x: self.position.x + self.size.halfWidth - 80, y: self.position.y + attackerY)
            attackerY -= 15.0
        }

        // defender
        self.defenderHealthNode?.position = CGPoint(x: self.position.x + self.size.halfWidth + 29, y: self.position.y + 47)
        self.defenderIconNode?.position = CGPoint(x: self.position.x + self.size.halfWidth + 29, y: self.position.y + 47)
        self.defenderNameNode?.position = CGPoint(x: self.position.x + self.size.halfWidth + 80, y: self.position.y + 87)
        self.defenderBaseStrengthNode?.position = CGPoint(x: self.position.x + self.size.halfWidth + 80, y: self.position.y + 65)

        var defenderY: CGFloat = 50.0
        for defenderStrengthBonusNode in self.defenderStrengthBonusNodes {
            defenderStrengthBonusNode?.position = CGPoint(x: self.position.x + self.size.halfWidth + 80, y: self.position.y + defenderY)
            defenderY -= 15.0
        }
    }

    func showCombatView() {

        if self.combatCanvasVisible {
            return
        }

        // now add the nodes
        self.addChild(self.combatCancelNode!)
        self.addChild(self.combatCanvasNode!)

        // attacker
        self.addChild(self.attackerHealthNode!)
        self.addChild(self.attackerIconNode!)
        self.addChild(self.attackerNameNode!)
        self.addChild(self.attackerBaseStrengthNode!)

        // defender
        self.addChild(self.defenderHealthNode!)
        self.addChild(self.defenderIconNode!)
        self.addChild(self.defenderNameNode!)
        self.addChild(self.defenderBaseStrengthNode!)

        self.combatCanvasVisible = true
    }

    func combatPrediction(of attacker: AbstractUnit?, against defender: AbstractUnit?, mode: CombatType, in gameModel: GameModel?) {

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
            self.attackerIconNode?.texture = attacker.type.iconTexture()
            self.attackerNameNode?.text = attacker.name()
            self.attackerBaseStrengthNode?.text = "\(attacker.baseCombatStrength(ignoreEmbarked: true))"

            for modifier in attacker.attackStrengthModifier(against: self.defender, or: nil, on: nil, in: gameModel) {
                // print("- \(modifier.modifierTitle)")

                let modifierNode = SKLabelNode(text: "\(modifier.modifierValue) \(modifier.modifierTitle)")
                modifierNode.horizontalAlignmentMode = .right
                modifierNode.zPosition = Globals.ZLevels.combatElements + 1.0
                modifierNode.fontSize = 10.0
                modifierNode.fontColor = .white

                self.addChild(modifierNode)

                self.attackerStrengthBonusNodes.append(modifierNode)
            }
        }

        if let defender = self.defender {
            let imageIndex = min(25, max(0, defender.healthPoints() / 4 )) // the assets are from 0 to 25
            self.defenderHealthNode?.value = imageIndex
            self.defenderIconNode?.texture = defender.type.iconTexture()
            self.defenderNameNode?.text = defender.name()
            self.defenderBaseStrengthNode?.text = "\(defender.baseCombatStrength(ignoreEmbarked: true))"

            for modifier in defender.attackStrengthModifier(against: self.attacker, or: nil, on: nil, in: gameModel) {
                // print("+ \(modifier.modifierTitle)")

                let modifierNode = SKLabelNode(text: "\(modifier.modifierValue) \(modifier.modifierTitle)")
                modifierNode.horizontalAlignmentMode = .left
                modifierNode.zPosition = Globals.ZLevels.combatElements + 1.0
                modifierNode.fontSize = 10.0
                modifierNode.fontColor = .white

                self.addChild(modifierNode)

                self.defenderStrengthBonusNodes.append(modifierNode)
            }
        }

        self.updateLayout()
    }

    func hideCombatView() {

        if !self.combatCanvasVisible {
            return
        }

        self.combatAttackNode?.removeFromParent()
        self.combatCancelNode?.removeFromParent()
        self.combatCanvasNode?.removeFromParent()

        // attacker
        self.attackerHealthNode?.removeFromParent()
        self.attackerIconNode?.removeFromParent()
        self.attackerNameNode?.removeFromParent()
        self.attackerBaseStrengthNode?.removeFromParent()

        for attackerStrengthBonusNode in self.attackerStrengthBonusNodes {
            attackerStrengthBonusNode?.removeFromParent()
        }

        self.attackerStrengthBonusNodes.removeAll()

        // defender
        self.defenderHealthNode?.removeFromParent()
        self.defenderIconNode?.removeFromParent()
        self.defenderNameNode?.removeFromParent()
        self.defenderBaseStrengthNode?.removeFromParent()

        for defenderStrengthBonusNode in self.defenderStrengthBonusNodes {
            defenderStrengthBonusNode?.removeFromParent()
        }

        self.defenderStrengthBonusNodes.removeAll()

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
