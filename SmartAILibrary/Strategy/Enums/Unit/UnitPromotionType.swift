//
//  UnitPromotionType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Promotions_(Civ6)
public enum UnitPromotionType: Int, Codable {

    case embarkation
    
    // fallback
    case healthBoostRecon // 50% boost
    case healthBoostMelee // 50% boost

    // recon
    case ranger // Faster Movement in Woods and Jungle terrain.
    case alpine // Faster Movement on Hill terrain.
    case sentry // Can see through Woods and Jungle.
    case guerrilla // Can move after attacking.
    case spyglass // +1 sight range.
    case ambush // +20 Combat Strength in all situations.
    case camouflage // Only adjacent enemy units can reveal this unit.

    // melee
    case battleCry // +7 Combat Strength vs. melee and ranged units.
    case tortoise // +10 Combat Strength when defending against ranged attacks.
    case commando // Can scale Cliff walls. +1 Movement.
    case amphibious // No Combat Strength and Movement penalty when attacking from Sea or over a River.
    case zweihander // +7 Combat Strength vs. anti-cavalry units.
    case urbanWarfare // +10 Combat Strength when fighting in a district.
    case eliteGuard // +1 additional attack per turn if Movement allows. Can move after attacking.

    // ranged


    static var all: [UnitPromotionType] {
        return [

            // recon
            .ranger, .alpine, .sentry, .guerrilla, .spyglass, .ambush, .camouflage,

            // melee
            .battleCry, .tortoise, .commando, .amphibious, .zweihander, .urbanWarfare, .eliteGuard
        ]
    }

    // MARK: internal classes

    private struct PromotionData {

        let name: String
        let effect: String
        let tier: Int
        let unitClass: UnitClassType
        let required: [UnitPromotionType]
        let consumable: Bool
    }

    // MARK: methods

    public func name() -> String {

        return self.data().name
    }
    
    public func effect() -> String {

        return self.data().effect
    }

    func tier() -> Int {

        return self.data().tier
    }

    func unitClass() -> UnitClassType {

        return self.data().unitClass
    }

    func required() -> [UnitPromotionType] {

        return self.data().required
    }
    
    func consumable() -> Bool {
        
        return self.data().consumable
    }


    // MARK: private methods

    private func data() -> PromotionData {

        switch self {

        case .embarkation:
            return PromotionData(name: "Embarkation", // FIXME
                                 effect: "---",
                                 tier: 0,
                                 unitClass: .melee, required: [],
                                 consumable: false)
            
            // general
        case .healthBoostRecon:
            return PromotionData(name: "Health Boost", // FIXME
                                 effect: "---",
                                 tier: 0,
                                 unitClass: .recon,
                                 required: [],
                                 consumable: true)
        case .healthBoostMelee:
            return PromotionData(name: "Health Boost", // FIXME
                                 effect: "---",
                                 tier: 0,
                                 unitClass: .melee,
                                 required: [],
                                 consumable: true)

            // recon
        case .ranger:
            // https://civilization.fandom.com/wiki/Ranger_(promotion)_(Civ6)
            return PromotionData(name: "Ranger",
                                 effect: "Faster Civ6Movement Movement in Woods and Jungle terrain.", // FIXME
                                 tier: 1,
                                 unitClass: .recon,
                                 required: [],
                                 consumable: false)
        case .alpine:
            // https://civilization.fandom.com/wiki/Alpine_(Civ6)
            return PromotionData(name: "Alpine",
                                 effect: "Faster Civ6Movement Movement on Hill terrain.", // FIXME
                                 tier: 1,
                                 unitClass: .recon,
                                 required: [],
                                 consumable: false)
        case .sentry:
            // https://civilization.fandom.com/wiki/Sentry_(Civ6)
            return PromotionData(name: "Sentry",
                                 effect: "Can see through Woods and Jungle.", // FIXME
                                 tier: 2,
                                 unitClass: .recon,
                                 required: [.ranger, .alpine],
                                 consumable: false)
        case .guerrilla:
            // https://civilization.fandom.com/wiki/Guerrilla_(Civ6)
            return PromotionData(name: "Guerrilla",
                                 effect: "Can move after attacking.", // FIXME
                                 tier: 2,
                                 unitClass: .recon,
                                 required: [.ranger, .alpine],
                                 consumable: false)
        case .spyglass:
            return PromotionData(name: "Spyglass",
                                 effect: "+1 sight range.",
                                 tier: 3,
                                 unitClass: .recon,
                                 required: [.sentry],
                                 consumable: false)
        case .ambush:
            // https://civilization.fandom.com/wiki/Ambush_(Civ6)
            return PromotionData(name: "Ambush",
                                 effect: "+20 Civ6StrengthIcon Combat Strength in all situations.", // FIXME
                                 tier: 3,
                                 unitClass: .recon,
                                 required: [.guerrilla],
                                 consumable: false)
        case .camouflage:
            // https://civilization.fandom.com/wiki/Camouflage_(Civ6)
            return PromotionData(name: "Camouflage",
                                 effect: "Only adjacent enemy units can reveal this unit.", // FIXME
                                 tier: 4,
                                 unitClass: .recon,
                                 required: [.spyglass, .ambush],
                                 consumable: false)

            // melee
        case .battleCry:
            // https://civilization.fandom.com/wiki/Battlecry_(Civ6)
            return PromotionData(name: "Battlecry",
                                 effect: "+7 Civ6StrengthIcon Combat Strength vs. melee and ranged units.",
                                 tier: 1,
                                 unitClass: .melee,
                                 required: [],
                                 consumable: false)
        case .tortoise:
            // https://civilization.fandom.com/wiki/Tortoise_(Civ6)
            return PromotionData(name: "Tortoise",
                                 effect: "+10 Civ6StrengthIcon Combat Strength when defending against ranged attacks.",
                                 tier: 1,
                                 unitClass: .melee,
                                 required: [],
                                 consumable: false)
        case .commando:
            // https://civilization.fandom.com/wiki/Commando_(Civ6)
            return PromotionData(name: "Commando",
                                 effect: "Can scale Cliff walls. +1 Civ6Movement Movement.", // FIXME
                                 tier: 2,
                                 unitClass: .melee,
                                 required: [.battleCry, .amphibious],
                                 consumable: false)
        case .amphibious:
            // https://civilization.fandom.com/wiki/Amphibious_(Civ6)
            return PromotionData(name: "Amphibious",
                                 effect: "No Civ6StrengthIcon Combat Strength and Civ6Movement Movement penalty when attacking from Sea or over a River.", // FIXME
                                 tier: 2,
                                 unitClass: .melee,
                                 required: [.tortoise, .commando],
                                 consumable: false)
        case .zweihander:
            // https://civilization.fandom.com/wiki/Zweihander_(Civ6)
            return PromotionData(name: "Zweihander",
                                 effect: "+7 Civ6StrengthIcon Combat Strength vs. anti-cavalry units.", // FIXME
                                 tier: 3,
                                 unitClass: .melee,
                                 required: [.tortoise, .amphibious],
                                 consumable: false)
        case .urbanWarfare:
            // https://civilization.fandom.com/wiki/Urban_Warfare_(Civ6)
            return PromotionData(name: "Urban warfare",
                                 effect: "+10 Civ6StrengthIcon Combat Strength when fighting in a city.", // FIXME
                                 tier: 3,
                                 unitClass: .melee,
                                 required: [.commando, .amphibious],
                                 consumable: false)
        case .eliteGuard:
            // https://civilization.fandom.com/wiki/Elite_Guard_(Civ6)
            return PromotionData(name: "Elite guard",
                                 effect: "+1 additional attack per turn if Civ6Movement Movement allows. Can move after attacking.", // FIXME
                                 tier: 4,
                                 unitClass: .melee,
                                 required: [.zweihander, .urbanWarfare],
                                 consumable: false)

        }
    }
    
    func consume(by unit: AbstractUnit?) {
        
        if self == .healthBoostMelee || self == .healthBoostRecon {
        
            //unit?.healBy(percent: 50)
            return
        }
        
        fatalError("consume not handled")
    }
    
    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return 0
    }

    private func flavors() -> [Flavor] {

        switch self {

        case .embarkation: return [Flavor(type: .navalGrowth, value: 2)]
            
            // general
        case .healthBoostRecon: return [Flavor(type: .happiness, value: 2)]
        case .healthBoostMelee: return [Flavor(type: .happiness, value: 2)]

            // recon
        case .ranger: return [Flavor(type: .recon, value: 2), Flavor(type: .mobile, value: 2)]
        case .alpine: return [Flavor(type: .recon, value: 1), Flavor(type: .mobile, value: 2)]
        case .sentry: return [Flavor(type: .recon, value: 2)]
        case .guerrilla: return [Flavor(type: .offense, value: 2), Flavor(type: .mobile, value: 2)]
        case .spyglass: return [Flavor(type: .recon, value: 2), Flavor(type: .mobile, value: 1)]
        case .ambush: return [Flavor(type: .offense, value: 2)]
        case .camouflage: return [Flavor(type: .recon, value: 2)]

            // melee
        case .battleCry: return [Flavor(type: .offense, value: 2), Flavor(type: .ranged, value: 1)]
        case .tortoise: return [Flavor(type: .offense, value: 3), Flavor(type: .ranged, value: 1)]
        case .commando: return [Flavor(type: .mobile, value: 3)]
        case .amphibious: return [Flavor(type: .mobile, value: 2), Flavor(type: .naval, value: 2)]
        case .zweihander: return [Flavor(type: .offense, value: 3)]
        case .urbanWarfare: return [Flavor(type: .offense, value: 2), Flavor(type: .cityDefense, value: 2)]
        case .eliteGuard: return [Flavor(type: .mobile, value: 3), Flavor(type: .offense, value: 2)]

        }
    }
}
