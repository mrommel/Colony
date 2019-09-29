//
//  ShadowLabelNode.swift
//  Colony
//
//  Created by Michael Rommel on 03.09.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class ShadowLabelNode: SKLabelNode {

    var offset: CGPoint = CGPoint(x: 2, y: 2)
    var shadowColor: UIColor = UIColor.white
    var blurRadius: CGFloat = 3

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init () {
        super.init()
    }
    
    convenience init(text: String?) {
        self.init(fontNamed: Formatters.Fonts.customFontFamilyname)
        
        self.text = text
    }

    // Inital setup for the shadow node (in Objective-C this is the instanceType method)
    override init(fontNamed: String?) {
        
        super.init(fontNamed: fontNamed)

        for keyPath in ["text", "fontName", "fontSize", "verticalAlignmentMode", "horizontalAlignmentMode", "fontColor"] {
            self.addObserver(self, forKeyPath: keyPath, options: NSKeyValueObservingOptions.new, context: nil)
        }

        self.updateShadow()
    }

    func updateShadow() {
        
        var effectNode: SKEffectNode? = self.childNode(withName: "ShadowEffectNodeKey") as? SKEffectNode

        if (effectNode == nil) {
            effectNode = SKEffectNode();
            effectNode!.name = "ShadowEffectNodeKey"
            effectNode!.shouldEnableEffects = true
            effectNode!.zPosition = -1
        }

        let filter: CIFilter? = CIFilter (name: "CIGaussianBlur")
        filter?.setDefaults();
        filter?.setValue(blurRadius, forKey: "inputRadius")
        effectNode?.filter = filter
        effectNode?.removeAllChildren()

        // Duplicate and offset the label
        let labelNode: SKLabelNode? = SKLabelNode (fontNamed: self.fontName)
        labelNode?.text = self.text
        labelNode?.fontSize = self.fontSize
        labelNode?.verticalAlignmentMode = self.verticalAlignmentMode
        labelNode?.horizontalAlignmentMode = self.horizontalAlignmentMode
        labelNode?.fontColor = shadowColor // Shadow not parent color
        labelNode?.position = offset // Offset from parent

        effectNode!.addChild(labelNode!)
        self.insertChild(effectNode!, at: 0)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        self.updateShadow()
    }
    
    

    /*func setOffset(offset: CGPoint) {
        self.updateShadow()
    }

    func setBlurRadius(blurRadius: CGFloat) {
        self.updateShadow()
    }

    func setShadowColor(shadowColor: UIColor) {
        self.updateShadow();
    }*/

    func nodeTexture() -> SKTexture {
        return self.scene!.view!.texture(from: self)!
    }

    // Removes all of the observers for the shadow node and the label itself.
    override func removeFromParent() {

        for keyPath in ["text", "fontName", "fontSize", "verticalAlignmentMode", "horizontalAlignmentMode", "fontColor"] {
            self.removeObserver(self, forKeyPath: keyPath);
            self.removeFromParent();
        }
    }
}
