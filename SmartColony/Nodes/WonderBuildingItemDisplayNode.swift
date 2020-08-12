//
//  WonderBuildingItemDisplayNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 07.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

protocol WonderBuildingItemDisplayNodeDelegate: class {
 
    func clicked(on wonderType: WonderType)
}

class WonderBuildingItemDisplayNode: BaseBuildingItemDisplayNode {
    
    // vairables
    let wonderType: WonderType
    
    // callback
    weak var delegate: WonderBuildingItemDisplayNodeDelegate?
    
    // MARK: constructors
    
    init(wonderType: WonderType, size: CGSize) {
        
        self.wonderType = wonderType
        
        super.init(textureName: "grid9_button_active",
                   iconTexture: SKTexture(imageNamed: wonderType.iconTexture()),
                   name: wonderType.name(),
                   nameColor: .white,
                   cost: Double(wonderType.productionCost()),
                   showCosts: true,
                   size: size)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propagate back to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // propagate back to scrollview
        if let scrollView = self.parent?.parent as? ScrollNode {
            scrollView.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            
            // propagate back to scrollview
            if let scrollView = self.parent?.parent as? ScrollNode {
                
                if !scrollView.backgroundNode!.contains(location) {
                    return
                }
                
                if self.backgroundNode!.contains(location) {
                    self.delegate?.clicked(on: self.wonderType)
                }
            }
        }
    }
}
