//
//  PolicyCardNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 22.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

enum PolicyCardState {

    case selected
    case active
    case disabled
}

protocol PolicyCardNodeDelegate: class {
    
    func clicked(on policyCardType: PolicyCardType)
}

class PolicyCardNode: SKNode {

    // variables
    let policyCardType: PolicyCardType
    var state: PolicyCardState
    var moved: Bool = false
    
    // nodes
    var backgroundNode: SKSpriteNode?
    var titleLabel: SKLabelNode?
    var bonusLabel: SKLabelNode?
    
    // delegate
    weak var delegate: PolicyCardNodeDelegate?

    // MARK: constructors

    init(policyCardType: PolicyCardType, state: PolicyCardState) {

        self.policyCardType = policyCardType
        self.state = state
        
        super.init()

        let size = CGSize(width: 100, height: 100)

        let textureName = state == .disabled ? "policyCard_slot" : policyCardType.iconTexture()
        let texture = SKTexture(imageNamed: textureName)
        self.backgroundNode = SKSpriteNode(texture: texture, color: .black, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)
        
        // /////////////////////
        // title
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: 12)
        ]

        let titleTextAttributed = NSAttributedString(string: policyCardType.name(), attributes: titleTextAttributes)

        self.titleLabel = SKLabelNode(attributedText: titleTextAttributed)
        self.titleLabel?.fontSize = 12
        self.titleLabel?.fontColor = .black
        self.titleLabel?.zPosition = self.zPosition + 10
        self.titleLabel?.verticalAlignmentMode = .center
        self.titleLabel?.position = CGPoint(x: size.halfWidth, y: -15)
        self.addChild(self.titleLabel!)

        // /////////////////////
        // bonus
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let bonusTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .backgroundColor: UIColor.black.withAlphaComponent(0.7),
            .font: UIFont.boldSystemFont(ofSize: 10),
            .paragraphStyle: paragraphStyle
        ]

        let bonusTextAttributed = NSAttributedString(string: policyCardType.bonus().replaceIcons(), attributes: bonusTextAttributes)
        
        self.bonusLabel = SKLabelNode(attributedText: bonusTextAttributed)
        self.bonusLabel?.zPosition = self.zPosition + 10
        self.bonusLabel?.verticalAlignmentMode = .top
        self.bonusLabel?.numberOfLines = 0
        self.bonusLabel?.preferredMaxLayoutWidth = 60
        self.bonusLabel?.position = CGPoint(x: size.halfWidth, y: -22)

        self.addChild(self.bonusLabel!)
        
        self.isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        
        let textureName = state == .disabled ? "policyCard_slot" : policyCardType.iconTexture()
        let texture = SKTexture(imageNamed: textureName)
        self.backgroundNode?.texture = texture
        
        //self.titleLabel?.fontColor = self.state == .selected ?  UIColor.black : UIColor.white
        //self.bonus1Label?.fontColor = self.state == .selected ?  UIColor.black : UIColor.white
        //self.bonus2Label?.fontColor = self.state == .selected ?  UIColor.black : UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
        
        self.moved = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propergate to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
        
        self.moved = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.moved {
            return
        }
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)

            // propergate to scrollview
            if let scrollNode = self.parent?.parent as? ScrollNode {
                
                let scrollNodeLocation: CGPoint = touch.location(in: scrollNode)
                let scrollNodeFrame = CGRect(origin: CGPoint(x: -scrollNode.size.halfWidth, y: -scrollNode.size.halfHeight), size: scrollNode.size)
                
                if scrollNodeFrame.contains(scrollNodeLocation) {
                    
                    if self.state == .disabled {
                        return
                    }
                    
                    if self.backgroundNode!.contains(location) {
                        print("clicked on policy card: \(self.policyCardType)")
                        self.delegate?.clicked(on: self.policyCardType)
                    }
                }
            }
        }
    }
    
    func toggleState() {
        
        if self.state == .disabled {
            return
        }
        
        if self.state == .active {
            self.state = .selected
        } else if self.state == .selected {
            self.state = .active
        }
        
        
    }
}
