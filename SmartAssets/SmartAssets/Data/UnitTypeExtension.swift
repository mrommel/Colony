//
//  UnitTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.04.21.
//

import Cocoa
import SmartAILibrary

extension UnitType {

    public func iconTexture() -> NSImage {

        if let texture = self.idleAtlas?.textures.first {
            return texture
        }

        return ImageCache.shared.image(for: "unit-type-default")
    }

    public func portraitTexture() -> String {

        switch self {

        case .none: return "unit-portrait-default"

            // barbarian
        case .barbarianWarrior: return "unit-portrait-warrior"
        case .barbarianArcher: return "unit-portrait-archer"

            // ancient
        case .settler: return "unit-portrait-settler"
        case .builder: return "unit-portrait-builder"
        case .trader: return "unit-portrait-trader"

        case .scout: return "unit-portrait-scout"
        case .warrior: return "unit-portrait-warrior"
        case .slinger: return "unit-portrait-default" // default
        case .archer: return "unit-portrait-archer"
        case .spearman: return "unit-portrait-default" // default
        case .heavyChariot: return "unit-portrait-default" // default
        case .galley: return "unit-portrait-galley"

            // classical
        case .quadrireme: return "unit-portrait-default"

            // industial
        case .medic: return "unit-portrait-default"

            // great people
        case .artist: return "unit-portrait-default"
        case .admiral: return "unit-portrait-default"
        case .engineer: return "unit-portrait-default"
        case .general: return "unit-portrait-default"
        case .merchant: return "unit-portrait-default"
        case .musician: return "unit-portrait-default"
        case .prophet: return "unit-portrait-default"
        case .scientist: return "unit-portrait-default"
        case .writer: return "unit-portrait-default"

        }
    }

    public func typeTemplateTexture() -> String {

        switch self {

        case .none: return "unit-type-template-warrior"

            // barbarian
        case .barbarianWarrior: return "unit-type-template-warrior"
        case .barbarianArcher: return "unit-type-template-archer"

            // ancient
        case .settler: return "unit-type-template-settler"
        case .builder: return "unit-type-template-builder"
        case .trader: return "unit-type-template-trader"

        case .scout: return "unit-type-template-scout"
        case .warrior: return "unit-type-template-warrior"
        case .slinger: return "unit-type-template-slinger"
        case .archer: return "unit-type-template-archer"
        case .spearman: return "unit-type-template-spearman"
        case .heavyChariot: return "unit-type-template-heavyChariot"
        case .galley: return "unit-type-template-galley"

            // classical
        case .quadrireme: return "unit-type-template-default"

            // industrial
        case .medic: return "unit-type-template-medic"

            // great people
        case .admiral: return "unit-type-template-default"
        case .artist: return "unit-type-template-default"
        case .engineer: return "unit-type-template-default"
        case .general: return "unit-type-template-default"
        case .merchant: return "unit-type-template-default"
        case .musician: return "unit-type-template-default"
        case .prophet: return "unit-type-template-default"
        case .scientist: return "unit-type-template-default"
        case .writer: return "unit-type-template-default"

        }
    }

    public func typeTexture() -> String {

        switch self {

        case .none: return "unit-type-warrior"

            // barbarian
        case .barbarianWarrior: return "unit-type-warrior"
        case .barbarianArcher: return "unit-type-archer"

            // ancient
        case .settler: return "unit-type-settler"
        case .builder: return "unit-type-builder"
        case .trader: return "unit-type-trader"

        case .scout: return "unit-type-scout"
        case .warrior: return "unit-type-warrior"
        case .slinger: return "unit-type-slinger"
        case .archer: return "unit-type-archer"
        case .spearman: return "unit-type-spearman"
        case .heavyChariot: return "unit-type-heavyChariot"
        case .galley: return "unit-type-galley"

            // classical
        case .quadrireme: return "unit-type-default"

            // industrial
        case .medic: return "unit-type-medic"

            // great people
        case .admiral: return "unit-type-default"
        case .artist: return "unit-type-default"
        case .engineer: return "unit-type-default"
        case .general: return "unit-type-default"
        case .merchant: return "unit-type-default"
        case .musician: return "unit-type-default"
        case .prophet: return "unit-type-default"
        case .scientist: return "unit-type-default"
        case .writer: return "unit-type-default"

        }
    }
}

extension UnitType {

    public var spriteName: String {

        switch self {

        case .none: return "warrior-idle-0"

            // barbarian
        case .barbarianWarrior: return "warrior-idle-0"
        case .barbarianArcher: return "archer-idle-0"

            // ancient
        case .settler: return "settler-idle-0"
        case .builder: return "builder-idle-0"
        case .trader: return "cart-right-0"

        case .scout: return "archer-idle-0"
        case .warrior: return "warrior-idle-0"
        case .slinger: return "archer-idle-0"
        case .archer: return "archer-idle-0"
        case .spearman: return "archer-idle-0"
        case .heavyChariot: return "archer-idle-0"
        case .galley: return "galley-idle-0"

            // classical
        case .quadrireme: return "quadrireme-idle-0"

            // industrial
        case .medic: return "archer-idle-0"

            // great people
        case .admiral: return "archer-idle-0"
        case .artist: return "archer-idle-0"
        case .engineer: return "archer-idle-0"
        case .general: return "archer-idle-0"
        case .merchant: return "archer-idle-0"
        case .musician: return "archer-idle-0"
        case .prophet: return "prophet-idle"
        case .scientist: return "archer-idle-0"
        case .writer: return "archer-idle-0"

        }
    }

    public var idleAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none:
            return nil

            // barbarian
        case .barbarianWarrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .barbarianArcher:
            let textureAtlas = TextureAtlasLoader.load(named: "archer", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

            // ancient
        case .settler:
            return ObjectTextureAtlas(template: "settler-idle-", range: 0..<15)

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .trader:
            return ObjectTextureAtlas(template: "cart-right-", range: 0..<2)

        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .slinger:
            return nil

        case .archer:
            let textureAtlas = TextureAtlasLoader.load(named: "archer", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .spearman:
            let textureAtlas = TextureAtlasLoader.load(named: "spearman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .heavyChariot:
            return ObjectTextureAtlas(template: "chariot-idle-", range: 0..<3)

        case .galley:
            return ObjectTextureAtlas(template: "galley-idle-", range: 0..<3)

            // classical
        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-idle-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet:
            let textureAtlas = TextureAtlasLoader.load(named: "prophet", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkDownAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // ancient
        case .settler:
            return nil

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .trader:
            return ObjectTextureAtlas(template: "cart-down-", range: 0..<14)

        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .slinger:
            return nil

        case .archer:
            let textureAtlas = TextureAtlasLoader.load(named: "archer", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .spearman:
            let textureAtlas = TextureAtlasLoader.load(named: "spearman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .heavyChariot:
            return ObjectTextureAtlas(template: "chariot-south-", range: 0..<3)

        case .galley:
            return ObjectTextureAtlas(template: "galley-south-", range: 0..<3)

            // classical
        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-south-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet:
            let textureAtlas = TextureAtlasLoader.load(named: "prophet", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkUpAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // ancient
        case .settler:
            return nil

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .trader:
            return ObjectTextureAtlas(template: "cart-up-", range: 0..<14)

        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .slinger:
            return nil

        case .archer:
            let textureAtlas = TextureAtlasLoader.load(named: "archer", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .spearman:
            let textureAtlas = TextureAtlasLoader.load(named: "spearman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .heavyChariot:
            return ObjectTextureAtlas(template: "chariot-north-", range: 0..<3)

        case .galley:
            return ObjectTextureAtlas(template: "galley-north-", range: 0..<3)

            // classical
        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-north-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet:
            let textureAtlas = TextureAtlasLoader.load(named: "prophet", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkRightAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // ancient
        case .settler:
            return nil

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .trader:
            return ObjectTextureAtlas(template: "cart-right-", range: 0..<14)

        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .slinger:
            return nil

        case .archer:
            let textureAtlas = TextureAtlasLoader.load(named: "archer", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .spearman:
            let textureAtlas = TextureAtlasLoader.load(named: "spearman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .heavyChariot:
            return ObjectTextureAtlas(template: "chariot-east-", range: 0..<3)

        case .galley:
            return ObjectTextureAtlas(template: "galley-east-", range: 0..<3)

            // classical
        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-east-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet:
            let textureAtlas = TextureAtlasLoader.load(named: "prophet", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkLeftAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // ancient
        case .settler: return nil

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .trader:
            return ObjectTextureAtlas(template: "cart-left-", range: 0..<14)

        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .slinger:
            return nil

        case .archer:
            let textureAtlas = TextureAtlasLoader.load(named: "archer", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .spearman:
            let textureAtlas = TextureAtlasLoader.load(named: "spearman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .heavyChariot:
            return ObjectTextureAtlas(template: "chariot-west-", range: 0..<3)

        case .galley:
            return ObjectTextureAtlas(template: "galley-west-", range: 0..<3)

        // classical
        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-west-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet:
            let textureAtlas = TextureAtlasLoader.load(named: "prophet", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .scientist: return nil
        case .writer: return nil
        }
    }
}
