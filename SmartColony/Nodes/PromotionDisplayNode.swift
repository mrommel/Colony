//
//  PromotionDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

enum PromotionState {

    case gained
    case possible
    case disabled

    func iconTexture() -> String {

        switch self {

        case .gained: return "promotion_state_gained"
        case .possible: return "promotion_state_possible"
        case .disabled: return "promotion_state_disabled"
        }
    }
}

protocol PromotionDisplayNodeDelegate: class {

    func clicked(on promotionType: UnitPromotionType)
}

class PromotionDisplayNode: SKNode {

    // variables
    let promotionType: UnitPromotionType
    let state: PromotionState
    var moved: Bool = false

    // nodes
    var backgroundNode: NineGridTextureSprite?
    var iconNode: SKSpriteNode?
    var labelNode: SKLabelNode?
    var effectNode: SKLabelNode?

    // delegate
    weak var delegate: PromotionDisplayNodeDelegate?

    // MARK: constructors

    init(promotionType: UnitPromotionType, state: PromotionState) {

        self.promotionType = promotionType
        self.state = state

        super.init()

        self.isUserInteractionEnabled = true

        let size = CGSize(width: 212, height: 106)

        // background
        let textureName = state.iconTexture()
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.addChild(self.backgroundNode!)

        // icon
        let iconTexture = SKTexture(imageNamed: promotionType.iconTexture())
        self.iconNode = SKSpriteNode(texture: iconTexture, size: CGSize(width: 32, height: 32))
        self.iconNode?.position = CGPoint(x: 16, y: -16)
        self.iconNode?.zPosition = self.zPosition + 1
        self.iconNode?.anchorPoint = CGPoint.upperLeft
        self.addChild(self.iconNode!)

        // name
        self.labelNode = SKLabelNode(text: promotionType.name())
        self.labelNode?.position = CGPoint(x: 60, y: -16)
        self.labelNode?.zPosition = self.zPosition + 1
        self.labelNode?.fontSize = 18
        self.labelNode?.fontName = Globals.Fonts.customFontFamilyname
        self.labelNode?.fontColor = .white
        self.labelNode?.numberOfLines = 1
        self.labelNode?.horizontalAlignmentMode = .left
        self.labelNode?.verticalAlignmentMode = .top
        self.labelNode?.fitToWidth(maxWidth: size.width - 26)
        self.addChild(self.labelNode!)

        // effects
        self.effectNode = SKLabelNode(text: promotionType.effect().replaceIcons())
        self.effectNode?.position = CGPoint(x: 16, y: -50)
        self.effectNode?.zPosition = self.zPosition + 1
        self.effectNode?.fontSize = 14
        self.effectNode?.fontName = Globals.Fonts.customFontFamilyname
        self.effectNode?.fontColor = .white
        self.effectNode?.numberOfLines = 2
        self.effectNode?.horizontalAlignmentMode = .left
        self.effectNode?.verticalAlignmentMode = .top
        self.effectNode?.preferredMaxLayoutWidth = size.width - 32
        self.addChild(self.effectNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        let touch = touches.first!

        let touchLocation = touch.location(in: self)
        let previousLocation = touch.previousLocation(in: self)
        let deltaY = (touchLocation.y) - (previousLocation.y)

        if abs(deltaY) > 0.1 {
            self.moved = true
        }
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

                    if self.state == .possible {

                        if self.backgroundNode!.contains(location) {
                            print("clicked on: \(self.promotionType)")
                            self.delegate?.clicked(on: self.promotionType)
                        }
                    }
                }
            } else {
                if self.state == .possible {

                    if self.backgroundNode!.contains(location) {
                        print("clicked on: \(self.promotionType)")
                        self.delegate?.clicked(on: self.promotionType)
                    }
                }
            }
        }
    }
}
