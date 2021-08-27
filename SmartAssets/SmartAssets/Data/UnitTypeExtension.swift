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

        return NSImage(named: "unit_type_default")!
    }

    public func typeTemplateTexture() -> String {

        switch self {

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

            // barbarian
        case .barbarianWarrior: return "warrior-idle-0"
        case .barbarianArcher: return "archer-idle-0"

            // ancient
        case .settler: return "settler-idle-0"
        case .builder: return "builder-idle-0"
        case .trader: return "cart_right-0"

        case .scout: return "archer-idle-0"
        case .warrior: return "warrior-idle-0"
        case .slinger: return "archer-idle-0"
        case .archer: return "archer-idle-0"
        case .spearman: return "archer-idle-0"
        case .heavyChariot: return "archer-idle-0"
        case .galley: return "galley_right-0"

            // industrial
        case .medic: return "archer-idle-0"

            // great people
        case .admiral: return "archer-idle-0"
        case .artist: return "archer-idle-0"
        case .engineer: return "archer-idle-0"
        case .general: return "archer-idle-0"
        case .merchant: return "archer-idle-0"
        case .musician: return "archer-idle-0"
        case .prophet: return "archer-idle-0"
        case .scientist: return "archer-idle-0"
        case .writer: return "archer-idle-0"

        }
    }

    public var idleAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

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

        case .heavyChariot: return nil

        case .galley:
            return ObjectTextureAtlas(template: "galley-idle-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkDownAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

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

        case .heavyChariot: return nil

        case .galley:
            return ObjectTextureAtlas(template: "galley-south-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkUpAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

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

        case .heavyChariot: return nil

        case .galley:
            return ObjectTextureAtlas(template: "galley-north-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkRightAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

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

        case .heavyChariot: return nil

        case .galley:
            return ObjectTextureAtlas(template: "galley-right-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    public var walkLeftAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

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

        case .heavyChariot: return nil

        case .galley:
            return ObjectTextureAtlas(template: "galley-left-", range: 0..<3)

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }
}
