//
//  UnitPromotionTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 31.08.21.
//

import SmartAILibrary

extension UnitPromotionType {

    // swiftlint:disable cyclomatic_complexity
    public func iconTexture() -> String {

        switch self {

        case .embarkation: return "promotion-default"
        case .healthBoostRecon: return "promotion-default"
        case .healthBoostMelee: return "promotion-default"

            // recon
        case .ranger: return "promotion-ranger"
        case .alpine: return "promotion-alpine"
        case .sentry: return "promotion-sentry"
        case .guerrilla: return "promotion-guerrilla"
        case .spyglass: return "promotion-spyglass"
        case .ambush: return "promotion-ambush"
        case .camouflage: return "promotion-camouflage"

            // melee
        case .battlecry: return "promotion-battlecry"
        case .tortoise: return "promotion-tortoise"
        case .commando: return "promotion-commando"
        case .amphibious: return "promotion-amphibious"
        case .zweihander: return "promotion-zweihander"
        case .urbanWarfare: return "promotion-urbanWarfare"
        case .eliteGuard: return "promotion-eliteGuard"

            // ranged
        case .volley: return "promotion-volley"
        case .garrison: return "promotion-garrison"
        case .arrowStorm: return "promotion-arrowStorm"
        case .incendiaries: return "promotion-incendiaries"
        case .suppression: return "promotion-suppression"
        case .emplacement: return "promotion-emplacement"
        case .expertMarksman: return "promotion-expertMarksman"

            // antiCavalry
        case .echelon: return "promotion-echelon"
        case .thrust: return "promotion-thrust"
        case .square: return "promotion-square"
        case .schiltron: return "promotion-schiltron"
        case .redeploy: return "promotion-redeploy"
        case .chokePoints: return "promotion-chokePoints"
        case .holdTheLine: return "promotion-holdTheLine"

            // lightCavalry
        case .caparison: return "promotion-caparison"
        case .coursers: return "promotion-coursers"
        case .depredation: return "promotion-depredation"
        case .doubleEnvelopment: return "promotion-doubleEnvelopment"
        case .spikingTheGuns: return "promotion-spikingTheGuns"
        case .pursuit: return "promotion-pursuit"
        case .escortMobility: return "promotion-escortMobility"

            // heavyCavalry
        case .charge: return "promotion-charge"
        case .barding: return "promotion-barding"
        case .marauding: return "promotion-marauding"
        case .rout: return "promotion-rout"
        case .armorPiercing: return "promotion-armorPiercing"
        case .reactiveArmor: return "promotion-reactiveArmor"
        case .breakthrough: return "promotion-breakthrough"

            // siege
        case .grapeShot: return "promotion-grapeShot"
        case .crewWeapons: return "promotion-crewWeapons"
        case .shrapnel: return "promotion-shrapnel"
        case .shells: return "promotion-shells"
        case .advancedRangefinding: return "promotion-advancedRangefinding"
        case .expertCrew: return "promotion-expertCrew"
        case .forwardObservers: return "promotion-forwardObservers"

            // navalMelee
        case .helmsman: return "promotion-helmsman"
        case .embolon: return "promotion-embolon"
        case .rutter: return "promotion-rutter"
        case .reinforcedHull: return "promotion-reinforcedHull"
        case .convoy: return "promotion-convoy"
        case .auxiliaryShips: return "promotion-auxiliaryShips"
        case .creepingAttack: return "promotion-creepingAttack"

            // navalRanged
        case .lineOfBattle: return "promotion-lineOfBattle"
        case .bombardment: return "promotion-bombardment"
        case .preparatoryFire: return "promotion-preparatoryFire"
        case .rollingBarrage: return "promotion-rollingBarrage"
        case .supplyFleet: return "promotion-supplyFleet"
        case .proximityFuses: return "promotion-proximityFuses"
        case .coincidenceRangefinding: return "promotion-coincidenceRangefinding"

            // navalRaider
            // navalCarrier

            // airFighter
            // airBomber

            // support
        }
    }
}
