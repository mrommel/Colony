//
//  TurnDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 10.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class TurnDialog: Dialog {
    
    let globeAtlas: GameObjectAtlas
    
    init() {
        
        let uiParser = UIParser()
        guard let turnDialogConfiguration = uiParser.parse(from: "TurnDialog") else {
            fatalError("cant load turnDialogConfiguration configuration")
        }
        
        self.globeAtlas = GameObjectAtlas(atlasName: "globe", template: "globe", range: 0..<91)
        
        super.init(from: turnDialogConfiguration)
        
        // get image
        guard let globeNode = self.children.first(where: { $0.name == "dialog_image" }) else {
            fatalError("Can't find dialog_image")
        }

        guard let spriteNode = globeNode as? SKSpriteNode else {
            fatalError("globeNode does not identify a SKSpriteNode")
        }
        
        // start animation
        let textureAtlasGlobe = SKTextureAtlas(named: self.globeAtlas.atlasName)
        let globeFrames: [SKTexture] = self.globeAtlas.textures.map { textureAtlasGlobe.textureNamed($0) }
        let globeRotation = SKAction.repeatForever(SKAction.animate(with: globeFrames, timePerFrame: 0.2))
        
        spriteNode.run(globeRotation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
