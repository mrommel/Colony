//
//  BlurrableNode.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import SpriteKit

class BlurrableNode: SKEffectNode {
    
    let blurFilter: CIFilter? = CIFilter(name: "CIGaussianBlur")
    
    private static let blurRadius: CGFloat = 5
    private static let blurAnimationLength: CGFloat = 0.5
    
    override init() {
        super.init()
        
        self.shouldEnableEffects = false // no - effects

        self.blurFilter?.setDefaults()
        self.blurFilter?.setValue(BlurrableNode.blurRadius, forKey: kCIInputRadiusKey)
        
        self.filter = blurFilter
        self.shouldRasterize = true // no caching
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func blurWith(completion: @escaping () -> Void) {
        
        if BlurrableNode.blurAnimationLength == 0.0 {
            self.shouldEnableEffects = true
            completion()
        } else {
            self.run(SKAction.customAction(withDuration: TimeInterval(BlurrableNode.blurAnimationLength), actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
                let radius = (elapsedTime / BlurrableNode.blurAnimationLength) * BlurrableNode.blurRadius
                self.blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
                self.shouldEnableEffects = true
                self.blendMode = .alpha
            }), completion: {
                completion()
            })
        }
    }
    
    func sharpWith(completion: @escaping () -> Void) {
        
        if BlurrableNode.blurAnimationLength == 0.0 {
            self.shouldEnableEffects = false
            completion()
        } else {
            self.run(SKAction.customAction(withDuration: TimeInterval(BlurrableNode.blurAnimationLength), actionBlock: { (node: SKNode, elapsedTime: CGFloat) in
                let radius = BlurrableNode.blurRadius - (elapsedTime / BlurrableNode.blurAnimationLength) * BlurrableNode.blurRadius
                self.blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
            }), completion: {
                self.shouldEnableEffects = false
                completion()
            })
        }
    }
}
