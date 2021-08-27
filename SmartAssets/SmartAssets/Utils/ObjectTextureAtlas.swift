//
//  ObjectTextureAtlas.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.04.21.
//

import Cocoa
import SpriteKit

public class ObjectTextureAtlas {

    public let textures: [NSImage]
    public let speed: Double

    public init(textures: [NSImage], speed: Double = -1.0) {

        self.textures = textures
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }

    public init(textures: [String], speed: Double = -1.0) {

        let bundle = Bundle.init(for: Textures.self)

        self.textures = textures.map { bundle.image(forResource: $0)! }
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }

    public init(atlasName: String, textures textureNames: [String], speed: Double = -1.0) {

        let textureAtlas = SKTextureAtlas(named: atlasName)
        let frames = textureNames.map { textureAtlas.textureNamed($0).cgImage() }

        self.textures = frames.map { NSImage(cgImage: $0, size: CGSize(width: $0.width, height: $0.height)) }
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }

    public init(template: String, range: Range<Int>, speed: Double = -1.0) {

        let bundle = Bundle.init(for: Textures.self)

        let textureNames = range.map { index in
            template + "\(index)"
        }

        self.textures = textureNames.map { bundle.image(forResource: $0)! }
        self.speed = speed == -1.0 ? 2.0 / Double(self.textures.count) : speed
    }
}
