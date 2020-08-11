//
//  GovernmentNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 24.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

enum GovernmentState {
    
    case selected
    case active
    case disabled
    
    func backgroundTexture() -> String {
        
        switch self {
            
        case .selected: return "government_box_selected"
        case .active: return "government_box_active"
        case .disabled: return "government_box_disabled"
        }
    }
}

protocol GovernmentNodeDelegate: class {
    
    func clicked(on governmentType: GovernmentType)
}

class GovernmentNode: SKNode {

    // variables
    let governmentType: GovernmentType
    var state: GovernmentState
    var moved: Bool = false
    
    // nodes
    var backgroundNode: SKSpriteNode?
    var bannerNode: SKSpriteNode?
    var titleLabel: SKLabelNode?
    var bonus1Label: SKLabelNode?
    var bonus2Label: SKLabelNode?
    
    // delegate
    weak var delegate: GovernmentNodeDelegate?

    // MARK: constructors

    init(governmentType: GovernmentType, with state: GovernmentState) {

        self.governmentType = governmentType
        self.state = state
        
        super.init()

        let size = CGSize(width: 299, height: 200)
        
        let backgroundTexture = SKTexture(imageNamed: state.backgroundTexture())
        self.backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: size)
        self.backgroundNode?.position = CGPoint(x: size.halfWidth, y: -size.halfHeight)
        self.backgroundNode?.zPosition = self.zPosition + 1
        self.addChild(self.backgroundNode!)
        
        // /////////////////////
        // banner
        let bannerTexture: SKTexture
        
        if let bannerImage = UIImage(named: governmentType.bannerTexture()), let croppedBannerImage = bannerImage.cropped(boundingBox: CGRect(x: 0, y: 0, width: 300, height: 100)) {
            bannerTexture = SKTexture(image: croppedBannerImage)
        } else {
            bannerTexture = SKTexture(imageNamed: "government_ambient_default")
        }
        self.bannerNode = SKSpriteNode(texture: bannerTexture, color: .black, size: CGSize(width: 296, height: 100))
        self.bannerNode?.position = CGPoint(x: size.halfWidth, y: -80)
        self.bannerNode?.zPosition = self.zPosition
        self.addChild(self.bannerNode!)

        // /////////////////////
        // title
        self.titleLabel = SKLabelNode(text: governmentType.name())
        self.titleLabel?.zPosition = self.zPosition + 10
        self.titleLabel?.fontColor = state == .selected ?  UIColor.black : UIColor.white
        self.titleLabel?.fontSize = 14
        self.titleLabel?.horizontalAlignmentMode = .center
        self.titleLabel?.position = CGPoint(x: size.halfWidth, y: -26)
        self.addChild(self.titleLabel!)
        
        // /////////////////////
        // bonus1
        self.bonus1Label = SKLabelNode(text: governmentType.bonus1Summary().replaceIcons())
        self.bonus1Label?.zPosition = self.zPosition + 10
        self.bonus1Label?.fontColor = state == .selected ?  UIColor.black : UIColor.white
        self.bonus1Label?.fontSize = 10
        self.bonus1Label?.numberOfLines = 0
        self.bonus1Label?.verticalAlignmentMode = .center
        self.bonus1Label?.horizontalAlignmentMode = .center
        self.bonus1Label?.preferredMaxLayoutWidth = 250
        self.bonus1Label?.position = CGPoint(x: size.halfWidth, y: -135)
        self.addChild(self.bonus1Label!)
        
        // /////////////////////
        // bonus2
        self.bonus2Label = SKLabelNode(text: governmentType.bonus2Summary().replaceIcons())
        self.bonus2Label?.zPosition = self.zPosition + 10
        self.bonus2Label?.fontColor = state == .selected ?  UIColor.black : UIColor.white
        self.bonus2Label?.fontSize = 10
        self.bonus2Label?.numberOfLines = 0
        self.bonus2Label?.verticalAlignmentMode = .center
        self.bonus2Label?.horizontalAlignmentMode = .center
        self.bonus2Label?.preferredMaxLayoutWidth = 250
        self.bonus2Label?.position = CGPoint(x: size.halfWidth, y: -170)
        self.addChild(self.bonus2Label!)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        
        let backgroundTexture = SKTexture(imageNamed: self.state.backgroundTexture())
        self.backgroundNode?.texture = backgroundTexture
        
        self.titleLabel?.fontColor = self.state == .selected ?  UIColor.black : UIColor.white
        self.bonus1Label?.fontColor = self.state == .selected ?  UIColor.black : UIColor.white
        self.bonus2Label?.fontColor = self.state == .selected ?  UIColor.black : UIColor.white
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
                
                    //print("clicked at: \(scrollNodeLocation)")
                    /*if !scrollNode.backgroundNode!.contains(location) {
                        return
                    }*/
                    
                    if self.state == .disabled {
                        return
                    }
                    
                    if self.backgroundNode!.contains(location) {
                        print("clicked on: \(self.governmentType)")
                        self.delegate?.clicked(on: self.governmentType)
                    }
                } 
            }
        }
    }
}
