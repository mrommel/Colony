//
//  BlurrableNode.swift
//  Colony
//
//  Created by Michael Rommel on 03.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class BlurrableNode: SKEffectNode {
    
    let blurFilter: CIFilter? = CIFilter(name: "CIGaussianBlur")
    
    override init() {
        super.init()
        
        //self.shouldEnableEffects = false

        self.blurFilter?.setDefaults()
        self.blurFilter?.setValue(0.0, forKey: kCIInputRadiusKey)
        
        self.filter = blurFilter
        self.shouldRasterize = true // no caching
        //self.shouldEnableEffects = true // yes - effects
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blurWith(completion: @escaping () -> Void) {
        
        //self.blurFilter?.setValue(8, forKey: BlurrableNode.kInputRadius)
        //self.shouldEnableEffects = true
        //self.blendMode = .alpha
        
        //self.shouldEnableEffects = true
        
        self.run(SKAction.customAction(withDuration: 1.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
            let radius = (elapsedTime / 1.0) * 10.0
            self.blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
            self.shouldEnableEffects = true
            self.blendMode = .alpha
        }), completion: {
            completion()
        })
    }
    
    func sharpWith(completion: @escaping () -> Void) {
        
        self.run(SKAction.customAction(withDuration: 1.0, actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
            let radius = 10 - (elapsedTime / 1.0) * 10.0
            self.blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        }), completion: {
            self.shouldEnableEffects = false
            completion()
        })
    }
}
