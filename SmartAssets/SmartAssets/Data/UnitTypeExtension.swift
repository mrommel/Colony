//
//  UnitTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.04.21.
//

import Cocoa
import SmartAILibrary

extension UnitType {

    var spriteName: String {

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
            return ObjectTextureAtlas(template: "warrior-idle-", range: 0..<10)

        case .barbarianArcher:
            return ObjectTextureAtlas(template: "archer-idle-", range: 0..<10)

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

    var walkDownAtlas: ObjectTextureAtlas? {
        
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

    var walkUpAtlas: ObjectTextureAtlas? {
        
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

    var walkRightAtlas: ObjectTextureAtlas? {
        
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

    var walkLeftAtlas: ObjectTextureAtlas? {
        
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
