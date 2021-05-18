//
//  NineGridTextureSprite.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit

public class NineGridTextureSprite: SKSpriteNode {
    
    public init(imageNamed imageName: String, size: CGSize, isNineGrid: Bool = true) {
        let texture = SKTexture.init(imageNamed: imageName)
        super.init(texture: texture, color: NSColor.black, size: size)
        
        if isNineGrid {
            setupNineGrid()
        }
    }
    
    public init(texture: SKTexture?, color: NSColor, size: CGSize, isNineGrid: Bool = true) {
        super.init(texture: texture, color: color, size: size)
        
        if isNineGrid {
            setupNineGrid()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNineGrid() {
        
        guard self.texture != nil else {
            return
        }

        self.centerRect = CGRect.init(x: 0.3333, y: 0.3333, width: 0.3333, height: 0.3333)
    }
    
}
