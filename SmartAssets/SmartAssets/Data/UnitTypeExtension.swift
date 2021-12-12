//
//  UnitTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.04.21.
//

import Cocoa
import SmartAILibrary

extension UnitType {

    public func toolTip() -> NSAttributedString {

        let toolTipText = NSMutableAttributedString()

        let title = NSAttributedString(
            string: self.name().localized(),
            attributes: Globals.Attributs.tooltipTitleAttributs
        )
        toolTipText.append(title)

        let effects = NSAttributedString(
            string: self.effects().reduce("\n\n", { $0 + $1.localized() + "\n" }),
            attributes: Globals.Attributs.tooltipContentAttributs
        )
        toolTipText.append(effects)

        return toolTipText
    }

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

            // civilian
        case .settler: return "unit-portrait-settler"
        case .builder: return "unit-portrait-builder"
        case .trader: return "unit-portrait-trader"

            // ancient
        case .scout: return "unit-portrait-scout"
        case .warrior: return "unit-portrait-warrior"
        case .slinger: return "unit-portrait-default" // default
        case .archer: return "unit-portrait-archer"
        case .spearman: return "unit-portrait-spearman"
        case .heavyChariot: return "unit-portrait-heavyChariot"
        case .galley: return "unit-portrait-galley"
        case .batteringRam: return "unit-portrait-batteringRam"

            // classical
        case .swordman: return "unit-portrait-swordman"
        case .horseman: return "unit-portrait-horseman"
        case .catapult: return "unit-portrait-catapult"
        case .quadrireme: return "unit-portrait-quadrireme"
        case .siegeTower: return "unit-portrait-siegeTower"

            // medieval
        case .skirmisher: return "unit-portrait-skirmisher"
        case .manAtArms: return "unit-portrait-manAtArms"
        case .crossbowman: return "unit-portrait-crossbowman"
        case .pikeman: return "unit-portrait-pikeman"
        case .knight: return "unit-portrait-knight"
        case .trebuchet: return "unit-portrait-trebuchet"

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

            // civilian
        case .settler: return "unit-type-template-settler"
        case .builder: return "unit-type-template-builder"
        case .trader: return "unit-type-template-trader"

            // ancient
        case .scout: return "unit-type-template-scout"
        case .warrior: return "unit-type-template-warrior"
        case .slinger: return "unit-type-template-slinger"
        case .archer: return "unit-type-template-archer"
        case .spearman: return "unit-type-template-spearman"
        case .heavyChariot: return "unit-type-template-heavyChariot"
        case .galley: return "unit-type-template-galley"
        case .batteringRam: return "unit-type-template-batteringRam"

            // classical
        case .swordman: return "unit-type-template-swordman"
        case .horseman: return "unit-type-template-horseman"
        case .catapult: return "unit-type-template-catapult"
        case .quadrireme: return "unit-type-template-quadrireme"
        case .siegeTower: return "unit-type-template-siegeTower"

            // medieval
        case .skirmisher: return "unit-type-template-skirmisher"
        case .manAtArms: return "unit-type-template-manAtArms"
        case .crossbowman: return "unit-type-template-crossbowman"
        case .pikeman: return "unit-type-template-pikeman"
        case .knight: return "unit-type-template-knight"
        case .trebuchet: return "unit-type-template-trebuchet"

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

            // civilian
        case .settler: return "unit-type-settler"
        case .builder: return "unit-type-builder"
        case .trader: return "unit-type-trader"

            // ancient
        case .scout: return "unit-type-scout"
        case .warrior: return "unit-type-warrior"
        case .slinger: return "unit-type-slinger"
        case .archer: return "unit-type-archer"
        case .spearman: return "unit-type-spearman"
        case .heavyChariot: return "unit-type-heavyChariot"
        case .galley: return "unit-type-galley"
        case .batteringRam: return "unit-type-batteringRam"

            // classical
        case .swordman: return "unit-type-swordman"
        case .horseman: return "unit-type-horseman"
        case .catapult: return "unit-type-catapult"
        case .quadrireme: return "unit-type-default"
        case .siegeTower: return "unit-type-siegeTower"

            // medieval
        case .skirmisher: return "unit-type-skirmisher"
        case .manAtArms: return "unit-type-manAtArms"
        case .crossbowman: return "unit-type-crossbowman"
        case .pikeman: return "unit-type-pikeman"
        case .knight: return "unit-type-knight"
        case .trebuchet: return "unit-type-trebuchet"

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

            // civilian
        case .settler: return "settler-idle-0"
        case .builder: return "builder-idle-0"
        case .trader: return "cart-idle-0"

            // ancient
        case .scout: return "archer-idle-0"
        case .warrior: return "warrior-idle-0"
        case .slinger: return "archer-idle-0"
        case .archer: return "archer-idle-0"
        case .spearman: return "archer-idle-0"
        case .heavyChariot: return "archer-idle-0"
        case .galley: return "galley-idle-0"
        case .batteringRam: return "batteringRam-idle-0"

            // classical
        case .swordman: return "swordman-idle-0"
        case .horseman: return "horseman-idle-0"
        case .catapult: return "catapult-idle-0"
        case .quadrireme: return "quadrireme-idle-0"
        case .siegeTower: return "siegeTower-idle-0"

            // medieval
        case .skirmisher: return "skirmisher-idle-0"
        case .manAtArms: return "manAtArms-idle-0" // #
        case .crossbowman: return "crossbowman-idle-0" // #
        case .pikeman: return "pikeman-idle-0" // #
        case .knight: return "knight-idle-0" // #
        case .trebuchet: return "trebuchet-idle-0"

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

            // civilian
        case .settler:
            return ObjectTextureAtlas(template: "settler-idle-", range: 0..<15)

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .trader:
            return ObjectTextureAtlas(template: "cart-idle-", range: 0..<15)

            // ancient
        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .slinger:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

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

        case .batteringRam:
            return ObjectTextureAtlas(template: "batteringRam-idle-", range: 0..<3)

            // classical
        case .swordman:
            let textureAtlas = TextureAtlasLoader.load(named: "long_swordman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .horseman:
            return ObjectTextureAtlas(template: "horseman-idle-", range: 0..<10)

        case .catapult:
            return ObjectTextureAtlas(template: "catapult-idle-", range: 0..<3)

        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-idle-", range: 0..<3)

        case .siegeTower:
            return ObjectTextureAtlas(template: "siegeTower-idle-", range: 0..<3)

            // medieval
        case .skirmisher:
            return ObjectTextureAtlas(template: "skirmisher-idle-", range: 0..<8)

        case .manAtArms:
            let textureAtlas = TextureAtlasLoader.load(named: "man_at_arms", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .crossbowman:
            let textureAtlas = TextureAtlasLoader.load(named: "crossbowman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .pikeman:
            let textureAtlas = TextureAtlasLoader.load(named: "pikeman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .knight:
            let textureAtlas = TextureAtlasLoader.load(named: "knight", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .trebuchet:
            return ObjectTextureAtlas(template: "trebuchet-idle-", range: 0..<3)

            // industrial
        case .medic:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

            // great people
        case .artist:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .admiral:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .engineer:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .general:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .merchant:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .musician:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .prophet:
            let textureAtlas = TextureAtlasLoader.load(named: "prophet", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "idle")

        case .scientist:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)

        case .writer:
            return ObjectTextureAtlas(template: "default-idle-", range: 0..<15)
        }
    }

    public var walkSouthAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // civilian
        case .settler:
            return ObjectTextureAtlas(template: "settler-south-", range: 0..<15)

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .trader:
            return ObjectTextureAtlas(template: "cart-down-", range: 0..<15)

            // ancient
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

        case .batteringRam:
            return ObjectTextureAtlas(template: "batteringRam-south-", range: 0..<3)

            // classical
        case .swordman:
            let textureAtlas = TextureAtlasLoader.load(named: "long_swordman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .horseman:
            return ObjectTextureAtlas(template: "horseman-south-", range: 0..<10)

        case .catapult:
            return ObjectTextureAtlas(template: "catapult-south-", range: 0..<3)

        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-south-", range: 0..<3)

        case .siegeTower:
            return ObjectTextureAtlas(template: "siegeTower-south-", range: 0..<3)

            // medieval
        case .skirmisher:
            return ObjectTextureAtlas(template: "skirmisher-south-", range: 0..<10)

        case .manAtArms:
            let textureAtlas = TextureAtlasLoader.load(named: "man_at_arms", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .crossbowman:
            let textureAtlas = TextureAtlasLoader.load(named: "crossbowman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .pikeman:
            let textureAtlas = TextureAtlasLoader.load(named: "pikeman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .knight:
            let textureAtlas = TextureAtlasLoader.load(named: "knight", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "south")

        case .trebuchet:
            return ObjectTextureAtlas(template: "trebuchet-south-", range: 0..<10)

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

    public var walkNorthAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // civilian
        case .settler:
            return ObjectTextureAtlas(template: "settler-north-", range: 0..<15)

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .trader:
            return ObjectTextureAtlas(template: "cart-up-", range: 0..<15)

            // ancient
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

        case .batteringRam:
            return ObjectTextureAtlas(template: "batteringRam-north-", range: 0..<3)

            // classical
        case .swordman:
            let textureAtlas = TextureAtlasLoader.load(named: "long_swordman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .horseman:
            return ObjectTextureAtlas(template: "horseman-north-", range: 0..<10)

        case .catapult:
            return ObjectTextureAtlas(template: "catapult-north-", range: 0..<3)

        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-north-", range: 0..<3)

        case .siegeTower:
            return ObjectTextureAtlas(template: "siegeTower-north-", range: 0..<3)

            // medieval
        case .skirmisher:
            return ObjectTextureAtlas(template: "skirmisher-north-", range: 0..<10)

        case .manAtArms:
            let textureAtlas = TextureAtlasLoader.load(named: "man_at_arms", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .crossbowman:
            let textureAtlas = TextureAtlasLoader.load(named: "crossbowman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .pikeman:
            let textureAtlas = TextureAtlasLoader.load(named: "pikeman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .knight:
            let textureAtlas = TextureAtlasLoader.load(named: "knight", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "north")

        case .trebuchet:
            return ObjectTextureAtlas(template: "trebuchet-north-", range: 0..<10)

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

    public var walkEastAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // civilian
        case .settler:
            return ObjectTextureAtlas(template: "settler-east-", range: 0..<15)

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .trader:
            return ObjectTextureAtlas(template: "cart-right-", range: 0..<15)

            // ancient
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

        case .batteringRam:
            return ObjectTextureAtlas(template: "batteringRam-east-", range: 0..<3)

            // classical
        case .swordman:
            let textureAtlas = TextureAtlasLoader.load(named: "long_swordman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .horseman:
            return ObjectTextureAtlas(template: "horseman-east-", range: 0..<10)

        case .catapult:
            return ObjectTextureAtlas(template: "catapult-east-", range: 0..<3)

        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-east-", range: 0..<3)

        case .siegeTower:
            return ObjectTextureAtlas(template: "siegeTower-east-", range: 0..<3)

            // medieval
        case .skirmisher:
            return ObjectTextureAtlas(template: "skirmisher-east-", range: 0..<10)

        case .manAtArms:
            let textureAtlas = TextureAtlasLoader.load(named: "man_at_arms", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .crossbowman:
            let textureAtlas = TextureAtlasLoader.load(named: "crossbowman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .pikeman:
            let textureAtlas = TextureAtlasLoader.load(named: "pikeman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .knight:
            let textureAtlas = TextureAtlasLoader.load(named: "knight", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west", mirror: true)

        case .trebuchet:
            return ObjectTextureAtlas(template: "trebuchet-east-", range: 0..<10)

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

    public var walkWestAtlas: ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        switch self {

        case .none: return nil

            // barbarian
        case .barbarianWarrior: return nil
        case .barbarianArcher: return nil

            // civilian
        case .settler:
            return ObjectTextureAtlas(template: "settler-west-", range: 0..<15)

        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .trader:
            return ObjectTextureAtlas(template: "cart-left-", range: 0..<15)

            // ancient
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

        case .batteringRam:
            return ObjectTextureAtlas(template: "batteringRam-west-", range: 0..<3)

        // classical
        case .swordman:
            let textureAtlas = TextureAtlasLoader.load(named: "long_swordman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .horseman:
            return ObjectTextureAtlas(template: "horseman-west-", range: 0..<10)

        case .catapult:
            return ObjectTextureAtlas(template: "catapult-west-", range: 0..<3)

        case .quadrireme:
            return ObjectTextureAtlas(template: "quadrireme-west-", range: 0..<3)

        case .siegeTower:
            return ObjectTextureAtlas(template: "siegeTower-west-", range: 0..<3)

            // medieval
        case .skirmisher:
            return ObjectTextureAtlas(template: "skirmisher-west-", range: 0..<10)

        case .manAtArms:
            let textureAtlas = TextureAtlasLoader.load(named: "man_at_arms", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .crossbowman:
            let textureAtlas = TextureAtlasLoader.load(named: "crossbowman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .pikeman:
            let textureAtlas = TextureAtlasLoader.load(named: "pikeman", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .knight:
            let textureAtlas = TextureAtlasLoader.load(named: "knight", in: bundle)
            return textureAtlas?.objectTextureAtlas(for: "walk", in: "west")

        case .trebuchet:
            return ObjectTextureAtlas(template: "trebuchet-west-", range: 0..<10)

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
