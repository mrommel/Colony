//
//  GameObjectAtlas.swift
//  SmartColony
//
//  Created by Michael Rommel on 06.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class GameObjectAtlas {
    
    let textures: [SKTexture]
    let speed: Double
    
    init(textures: [SKTexture], speed: Double = -1.0) {
        
        self.textures = textures
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
    
    init(atlasName: String, textures: [String], speed: Double = -1.0) {
        
        let textureAtlas = SKTextureAtlas(named: atlasName)
        let frames = textures.map { textureAtlas.textureNamed($0) }

        self.textures = frames
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
    
    init(atlasName: String, template: String, range: Range<Int>, speed: Double = -1.0) {
        
        let textureAtlas = SKTextureAtlas(named: atlasName)
        
        let textureNames = range.map { index in
            template + "\(index)"
        }
        
        let frames = textureNames.map { textureAtlas.textureNamed($0) }

        self.textures = frames
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
}
