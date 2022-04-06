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
    public let timePerFrame: Double

    public init(textures: [NSImage], timePerFrame: Double = -1.0) {

        self.textures = textures
        self.timePerFrame = timePerFrame == -1.0 ? 2.0 / Double(self.textures.count) : timePerFrame
    }

    public init(textures: [String], timePerFrame: Double = -1.0) {

        let bundle = Bundle.init(for: Textures.self)

        self.textures = textures.map { bundle.image(forResource: $0)! }
        self.timePerFrame = timePerFrame == -1.0 ? 2.0 / Double(self.textures.count) : timePerFrame
    }

    public init(atlasName: String, textures textureNames: [String], timePerFrame: Double = -1.0) {

        let textureAtlas = SKTextureAtlas(named: atlasName)
        let frames = textureNames.map { textureAtlas.textureNamed($0).cgImage() }

        self.textures = frames.map { NSImage(cgImage: $0, size: CGSize(width: $0.width, height: $0.height)) }
        self.timePerFrame = timePerFrame == -1.0 ? 2.0 / Double(self.textures.count) : timePerFrame
    }

    public init(template: String, range: Range<Int>, timePerFrame: Double = -1.0) {

        let bundle = Bundle.init(for: Textures.self)

        let textureNames = range.map { index in
            template + "\(index)"
        }

        self.textures = textureNames.map { bundle.image(forResource: $0)! }
        self.timePerFrame = timePerFrame == -1.0 ? 2.0 / Double(self.textures.count) : timePerFrame
    }

    public func repeatFirst(amount: Int, timePerFrame: Double = -1.0) -> ObjectTextureAtlas {

        let firstTextureRepeated = Array(repeating: self.textures[0], count: amount)

        var newTimePerFrame: Double = timePerFrame

        if timePerFrame == -1.0 && self.timePerFrame != 2.0 / Double(self.textures.count) {
            newTimePerFrame = self.timePerFrame
        }

        return ObjectTextureAtlas(textures: firstTextureRepeated + self.textures, timePerFrame: newTimePerFrame)
    }
}
