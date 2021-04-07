//
//  ObjectTextureAtlas.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.04.21.
//

import Cocoa

public class ObjectTextureAtlas {
    
    public let textures: [NSImage]
    public let speed: Double
    
    init(textures: [NSImage], speed: Double = -1.0) {
        
        self.textures = textures
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
    
    init(textures: [String], speed: Double = -1.0) {
        
        let bundle = Bundle.init(for: Textures.self)
        
        self.textures = textures.map { bundle.image(forResource: $0)! }
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
    
    init(template: String, range: Range<Int>, speed: Double = -1.0) {

        let bundle = Bundle.init(for: Textures.self)
        
        let textureNames = range.map { index in
            template + "\(index)"
        }

        self.textures = textureNames.map { bundle.image(forResource: $0)! }
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
}
