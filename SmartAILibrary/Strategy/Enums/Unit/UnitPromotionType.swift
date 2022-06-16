//
//  UnitPromotionType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 18.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Promotions_(Civ6)
// https://github.com/LoneGazebo/Community-Patch-DLL/blob/b33ee4a04e91d27356af0bcc421de1b7899ac073/(2)%20Vox%20Populi/Balance%20Changes/Units/PromotionChanges.xml
// swiftlint:disable type_body_length
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
    case volley // +5 Ranged Strength Ranged Strength vs. land units.
    case garrison // +10 Strength Combat Strength when occupying a district or Fort.
    case arrowStorm // +7 Ranged Strength Ranged Strength vs. land and naval units.
    case incendiaries // +7 Ranged Strength Ranged Strength vs. district defenses.
    case suppression // Exercise zone of control.
    case emplacement // +10 Strength Combat Strength when defending vs. city attacks.
    case expertMarksman // +1 additional attack per turn if unit has not moved.

    // antiCavalry
    case echelon
    case thrust
    case square
    case schiltron
    case redeploy
    case chokePoints
    case holdTheLine

    // lightCavalry
    case caparison
    case coursers
    case depredation
    case doubleEnvelopment
    case spikingTheGuns
    case pursuit
    case escortMobility

    // heavyCavalry
    // siege

    // navalMelee
    case helmsman
    case embolon
    case rutter
    case reinforcedHull
    case convoy
    case auxiliaryShips
    case creepingAttack

    // navalRanged
    // navalRaider
    // navalCarrier

    // airFighter
    // airBomber

    // support

    public static var all: [UnitPromotionType] {
        return [

            // recon
            .ranger, .alpine, .sentry, .guerrilla, .spyglass, .ambush, .camouflage,

            // melee
            .battleCry, .tortoise, .commando, .amphibious, .zweihander, .urbanWarfare, .eliteGuard,

            // ranged
            .volley, .garrison, .arrowStorm, .incendiaries, .suppression, .emplacement, .expertMarksman,

            // antiCavalry
            .echelon, .thrust, .square, .schiltron, .redeploy, .chokePoints, .holdTheLine,

            // lightCavalry
            .caparison, .coursers, .depredation, .doubleEnvelopment, .spikingTheGuns, .pursuit, .escortMobility,

            // navalMelee
            .helmsman, .embolon, .rutter, .reinforcedHull, .convoy, .auxiliaryShips, .creepingAttack
        ]
    }

    public static let defaultFlavorValue = 5

    // MARK: internal classes

    private struct PromotionData {

        let name: String
        let effect: String
        let tier: Int
        let unitClass: UnitClassType
        let required: [UnitPromotionType]
        let consumable: Bool
        let enemyRoute: Bool
        let ignoreZoneOfControl: Bool
        let flavours: [Flavor]

        init(name: String,
             effect: String,
             tier: Int,
             unitClass: UnitClassType,
             required: [UnitPromotionType],
             consumable: Bool,
             enemyRoute: Bool = false,
             ignoreZoneOfControl: Bool = false,
             flavours: [Flavor]) {

            self.name = name
            self.effect = effect
            self.tier = tier
            self.unitClass = unitClass
            self.required = required
            self.consumable = consumable
            self.enemyRoute = enemyRoute
            self.ignoreZoneOfControl = ignoreZoneOfControl
            self.flavours = flavours
        }
    }

    // MARK: methods

    public func name() -> String {

        return self.data().name
    }

    public func effect() -> String {

        return self.data().effect
    }

    public func tier() -> Int {

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

    func isEnemyRoute() -> Bool {

        return self.data().enemyRoute
    }

    func ignoreZoneOfControl() -> Bool {

        return self.data().ignoreZoneOfControl
    }

    // MARK: private methods

    private func data() -> PromotionData {

        switch self {

        case .embarkation:
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_EMBARKATION_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_EMBARKATION_EFFECT",
                tier: 0,
                unitClass: .melee,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .navalGrowth, value: 2)
                ]
            )

            // ---------------------
            // general
            
        case .healthBoostRecon:
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_HEALTH_BOOST_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_HEALTH_BOOST_EFFECT",
                tier: 0,
                unitClass: .recon,
                required: [],
                consumable: true,
                flavours: [
                    Flavor(type: .amenities, value: 2)
                ]
            )
        case .healthBoostMelee:
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_HEALTH_BOOST_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_HEALTH_BOOST_EFFECT",
                tier: 0,
                unitClass: .melee,
                required: [],
                consumable: true,
                flavours: [
                    Flavor(type: .amenities, value: 2)
                ]
            )

            // ---------------------
            // recon

        case .ranger:
            // https://civilization.fandom.com/wiki/Ranger_(promotion)_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_RANGER_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_RANGER_EFFECT",
                tier: 1,
                unitClass: .recon,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .recon, value: 2),
                    Flavor(type: .mobile, value: 2)
                ]
            )
        case .alpine:
            // https://civilization.fandom.com/wiki/Alpine_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_ALPINE_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_ALPINE_EFFECT",
                tier: 1,
                unitClass: .recon,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .recon, value: 1),
                    Flavor(type: .mobile, value: 2)
                ]
            )
        case .sentry:
            // https://civilization.fandom.com/wiki/Sentry_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_SENTRY_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_SENTRY_EFFECT",
                tier: 2,
                unitClass: .recon,
                required: [.ranger, .alpine],
                consumable: false,
                flavours: [
                    Flavor(type: .recon, value: 2)
                ]
            )
        case .guerrilla:
            // https://civilization.fandom.com/wiki/Guerrilla_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_GUERRILLA_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_GUERRILLA_EFFECT",
                tier: 2,
                unitClass: .recon,
                required: [.ranger, .alpine],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 2),
                    Flavor(type: .mobile, value: 2)
                ]
            )
        case .spyglass:
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_SPYGLASS_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_SPYGLASS_EFFECT",
                tier: 3,
                unitClass: .recon,
                required: [.sentry],
                consumable: false,
                flavours: [
                    Flavor(type: .recon, value: 2),
                    Flavor(type: .mobile, value: 1)
                ]
            )
        case .ambush:
            // https://civilization.fandom.com/wiki/Ambush_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_AMBUSH_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_AMBUSH_EFFECT",
                tier: 3,
                unitClass: .recon,
                required: [.guerrilla],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 2)
                ]
            )
        case .camouflage:
            // https://civilization.fandom.com/wiki/Camouflage_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_CAMOUFLAGE_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_CAMOUFLAGE_EFFECT",
                tier: 4,
                unitClass: .recon,
                required: [.spyglass, .ambush],
                consumable: false,
                flavours: [
                    Flavor(type: .recon, value: 2)
                ]
            )

            // ---------------------
            // melee

        case .battleCry:
            // https://civilization.fandom.com/wiki/Battlecry_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_BATTLECRY_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_BATTLECRY_EFFECT",
                tier: 1,
                unitClass: .melee,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 2),
                    Flavor(type: .ranged, value: 1)
                ]
            )
        case .tortoise:
            // https://civilization.fandom.com/wiki/Tortoise_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_TORTOISE_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_TORTOISE_EFFECT",
                tier: 1,
                unitClass: .melee,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .ranged, value: 1)
                ]
            )
        case .commando:
            // https://civilization.fandom.com/wiki/Commando_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_COMMANDO_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_COMMANDO_EFFECT",
                tier: 2,
                unitClass: .melee,
                required: [.battleCry, .amphibious],
                consumable: false,
                flavours: [
                    Flavor(type: .mobile, value: 3)
                ]
            )
        case .amphibious:
            // https://civilization.fandom.com/wiki/Amphibious_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_AMPHIBIOUS_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_AMPHIBIOUS_EFFECT",
                tier: 2,
                unitClass: .melee,
                required: [.tortoise, .commando],
                consumable: false,
                flavours: [
                    Flavor(type: .mobile, value: 2),
                    Flavor(type: .naval, value: 2)
                ]
            )
        case .zweihander:
            // https://civilization.fandom.com/wiki/Zweihander_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_ZWEIHANDER_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_ZWEIHANDER_EFFECT",
                tier: 3,
                unitClass: .melee,
                required: [.tortoise, .amphibious],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )
        case .urbanWarfare:
            // https://civilization.fandom.com/wiki/Urban_Warfare_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_URBAN_WARFARE_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_URBAN_WARFARE_EFFECT",
                tier: 3,
                unitClass: .melee,
                required: [.commando, .amphibious],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 2),
                    Flavor(type: .cityDefense, value: 2)
                ]
            )
        case .eliteGuard:
            // https://civilization.fandom.com/wiki/Elite_Guard_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_ELITE_GUARD_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_ELITE_GUARD_EFFECT",
                tier: 4,
                unitClass: .melee,
                required: [.zweihander, .urbanWarfare],
                consumable: false,
                flavours: [
                    Flavor(type: .mobile, value: 3),
                    Flavor(type: .offense, value: 2)
                ]

            )

            // ---------------------
            // ranged

        case .volley:
            // https://civilization.fandom.com/wiki/Volley_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_VOLLEY_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_VOLLEY_EFFECT",
                tier: 1,
                unitClass: .ranged,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .garrison:
            // https://civilization.fandom.com/wiki/Garrison_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_GARRISON_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_GARRISON_EFFECT",
                tier: 1,
                unitClass: .ranged,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .cityDefense, value: 4)
                ]
            )

        case .arrowStorm:
            // https://civilization.fandom.com/wiki/Arrow_Storm_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_ARROW_STORM_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_ARROW_STORM_EFFECT",
                tier: 2,
                unitClass: .ranged,
                required: [.volley],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3),
                    Flavor(type: .naval, value: 2)
                ]
            )

        case .incendiaries:
            // https://civilization.fandom.com/wiki/Incendiaries_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_INCENDIARIES_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_INCENDIARIES_EFFECT",
                tier: 2,
                unitClass: .ranged,
                required: [.garrison],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 4)
                ]
            )

        case .suppression:
            // https://civilization.fandom.com/wiki/Suppression_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_SUPPRESSION_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_SUPPRESSION_EFFECT",
                tier: 3,
                unitClass: .ranged,
                required: [.arrowStorm, .incendiaries],
                consumable: false,
                flavours: [
                    Flavor(type: .defense, value: 3)
                ]
            )

        case .emplacement:
            // https://civilization.fandom.com/wiki/Emplacement_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_EMPLACEMENT_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_EMPLACEMENT_EFFECT",
                tier: 3,
                unitClass: .ranged,
                required: [.arrowStorm, .incendiaries],
                consumable: false,
                flavours: [
                    Flavor(type: .cityDefense, value: 3),
                    Flavor(type: .defense, value: 2)
                ]
            )

        case .expertMarksman:
            // https://civilization.fandom.com/wiki/Expert_Marksman_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_EXPERT_MARKSMAN_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_EXPERT_MARKSMAN_EFFECT",
                tier: 4,
                unitClass: .ranged,
                required: [.suppression, .emplacement],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

            // ---------------------
            // antiCavalry

        case .echelon:
            // https://civilization.fandom.com/wiki/Echelon_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_ECHELON_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_ECHELON_EFFECT",
                tier: 1,
                unitClass: .antiCavalry,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .thrust:
            // https://civilization.fandom.com/wiki/Thrust_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_THRUST_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_THRUST_EFFECT",
                tier: 1,
                unitClass: .antiCavalry,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 4)
                ]
            )

        case .square:
            // https://civilization.fandom.com/wiki/Square_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_SQUARE_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_SQUARE_EFFECT",
                tier: 2,
                unitClass: .antiCavalry,
                required: [.echelon],
                consumable: false,
                flavours: [
                    Flavor(type: .defense, value: 3),
                    Flavor(type: .militaryTraining, value: 1)
                ]
            )

        case .schiltron:
            // https://civilization.fandom.com/wiki/Schiltron_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_SCHILTRON_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_SCHILTRON_EFFECT",
                tier: 2,
                unitClass: .antiCavalry,
                required: [.thrust],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 4)
                ]
            )

        case .redeploy:
            // Redeploy
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_REDEPLOY_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_REDEPLOY_EFFECT",
                tier: 3,
                unitClass: .antiCavalry,
                required: [.square, .schiltron],
                consumable: false,
                flavours: [
                    Flavor(type: .mobile, value: 3)
                ]
            )

        case .chokePoints:
            // https://civilization.fandom.com/wiki/Choke_Points_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_CHOKE_POINTS_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_CHOKE_POINTS_EFFECT",
                tier: 3,
                unitClass: .antiCavalry,
                required: [.square, .schiltron],
                consumable: false,
                flavours: [
                    Flavor(type: .defense, value: 4)
                ]
            )

        case .holdTheLine:
            // https://civilization.fandom.com/wiki/Hold_the_Line_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_HOLD_THE_LINE_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_HOLD_THE_LINE_EFFECT",
                tier: 4,
                unitClass: .antiCavalry,
                required: [.redeploy, .chokePoints],
                consumable: false,
                flavours: [
                    Flavor(type: .militaryTraining, value: 2),
                    Flavor(type: .defense, value: 3)
                ]
            )

            // ---------------------
            // lightCavalry

        case .caparison:
            // https://civilization.fandom.com/wiki/Caparison_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_CAPARISON_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_CAPARISON_EFFECT",
                tier: 1,
                unitClass: .lightCavalry,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 4)
                ]
            )

        case .coursers:
            // https://civilization.fandom.com/wiki/Coursers_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_COURSERS_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_COURSERS_EFFECT",
                tier: 1,
                unitClass: .lightCavalry,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 2)
                ]
            )

        case .depredation:
            // https://civilization.fandom.com/wiki/Depredation_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_DEPREDATION_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_DEPREDATION_EFFECT",
                tier: 2,
                unitClass: .lightCavalry,
                required: [.caparison],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .doubleEnvelopment:
            // https://civilization.fandom.com/wiki/Double_Envelopment_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_DOUBLE_ENVELOPMENT_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_DOUBLE_ENVELOPMENT_EFFECT",
                tier: 2,
                unitClass: .lightCavalry,
                required: [.coursers],
                consumable: false,
                flavours: [
                    Flavor(type: .militaryTraining, value: 3),
                    Flavor(type: .offense, value: 2)
                ]
            )

        case .spikingTheGuns:
            // https://civilization.fandom.com/wiki/Spiking_the_Guns_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_SPIKING_THE_GUNS_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_SPIKING_THE_GUNS_EFFECT",
                tier: 3,
                unitClass: .lightCavalry,
                required: [.depredation, .doubleEnvelopment],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 2),
                    Flavor(type: .defense, value: 2)
                ]
            )

        case .pursuit:
            // https://civilization.fandom.com/wiki/Pursuit_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_PURSUIT_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_PURSUIT_EFFECT",
                tier: 3,
                unitClass: .lightCavalry,
                required: [.depredation, .doubleEnvelopment],
                consumable: false,
                flavours: [
                    Flavor(type: .mobile, value: 3)
                ]
            )

        case .escortMobility:
            // https://civilization.fandom.com/wiki/Escort_Mobility_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_ESCORT_MOBILITY_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_ESCORT_MOBILITY_EFFECT",
                tier: 4,
                unitClass: .lightCavalry,
                required: [.spikingTheGuns, .pursuit],
                consumable: false,
                flavours: [
                    Flavor(type: .mobile, value: 3)
                ]
            )

            // ---------------------
            // navalMelee

        case .helmsman:
            // https://civilization.fandom.com/wiki/Helmsman_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_HELMSMAN_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_HELMSMAN_EFFECT",
                tier: 1,
                unitClass: .navalMelee,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .expansion, value: 2),
                    Flavor(type: .mobile, value: 3)
                ]
            )

        case .embolon:
            // https://civilization.fandom.com/wiki/Embolon_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_EMBOLON_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_EMBOLON_EFFECT",
                tier: 1,
                unitClass: .navalMelee,
                required: [],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .rutter:
            // https://civilization.fandom.com/wiki/Rutter_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_RUTTER_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_RUTTER_EFFECT",
                tier: 2,
                unitClass: .navalMelee,
                required: [.helmsman],
                consumable: false,
                flavours: [
                    Flavor(type: .expansion, value: 2)
                ]
            )

        case .reinforcedHull:
            // https://civilization.fandom.com/wiki/Reinforced_Hull_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_REINFORCED_HULL_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_REINFORCED_HULL_EFFECT",
                tier: 2,
                unitClass: .navalMelee,
                required: [.embolon],
                consumable: false,
                flavours: [
                    Flavor(type: .defense, value: 4)
                ]
            )

        case .convoy:
            // https://civilization.fandom.com/wiki/Convoy_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_CONVOY_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_CONVOY_EFFECT",
                tier: 3,
                unitClass: .navalMelee,
                required: [.rutter, .reinforcedHull],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        case .auxiliaryShips:
            // https://civilization.fandom.com/wiki/Auxiliary_Ships_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_AUXILIARY_SHIPS_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_AUXILIARY_SHIPS_EFFECT",
                tier: 3,
                unitClass: .navalMelee,
                required: [.rutter, .reinforcedHull],
                consumable: false,
                flavours: [
                    Flavor(type: .defense, value: 3)
                ]
            )

        case .creepingAttack:
            // https://civilization.fandom.com/wiki/Creeping_Attack_(Civ6)
            return PromotionData(
                name: "TXT_KEY_UNIT_PROMOTION_CREEPING_ATTACK_NAME",
                effect: "TXT_KEY_UNIT_PROMOTION_CREEPING_ATTACK_EFFECT",
                tier: 4,
                unitClass: .navalMelee,
                required: [.convoy, .auxiliaryShips],
                consumable: false,
                flavours: [
                    Flavor(type: .offense, value: 3)
                ]
            )

        }
    }

    func consume(by unit: AbstractUnit?) {

        if self == .healthBoostMelee || self == .healthBoostRecon {

            // unit?.healBy(percent: 50)
            return
        }

        fatalError("consume not handled")
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.flavors().first(where: { $0.type == flavorType }) {
            return UnitPromotionType.defaultFlavorValue + modifier.value
        }

        return UnitPromotionType.defaultFlavorValue
    }

    private func flavors() -> [Flavor] {

        return self.data().flavours
    }
}
