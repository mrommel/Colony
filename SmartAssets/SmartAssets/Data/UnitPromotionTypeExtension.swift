//
//  UnitPromotionTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 31.08.21.
//

import SmartAILibrary

extension UnitPromotionType {

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
        case .battleCry: return "promotion-default"
        case .tortoise: return "promotion-default"
        case .commando: return "promotion-default"
        case .amphibious: return "promotion-default"
        case .zweihander: return "promotion-default"
        case .urbanWarfare: return "promotion-default"
        case .eliteGuard: return "promotion-default"

            // ranged
        case .volley: return "promotion-default"
        case .garrison: return "promotion-default"
        case .arrowStorm: return "promotion-default"
        case .incendiaries: return "promotion-default"
        case .suppression: return "promotion-default"
        case .emplacement: return "promotion-default"
        case .expertMarksman: return "promotion-default"

            // antiCavalry
        case .echelon: return "promotion-default"
        case .thrust: return "promotion-default"
        case .square: return "promotion-default"
        case .schiltron: return "promotion-default"
        case .redeploy: return "promotion-default"
        case .chokePoints: return "promotion-default"
        case .holdTheLine: return "promotion-default"

            // lightCavalry
        case .caparison: return "promotion-default"
        case .coursers: return "promotion-default"
        case .depredation: return "promotion-default"
        case .doubleEnvelopment: return "promotion-default"
        case .spikingTheGuns: return "promotion-default"
        case .pursuit: return "promotion-default"
        case .escortMobility: return "promotion-default"

            // heavyCavalry
            // siege

            // navalMelee
        case .helmsman: return "promotion-helmsman"
        case .embolon: return "promotion-embolon"
        case .rutter: return "promotion-rutter"
        case .reinforcedHull: return "promotion-reinforcedHull"
        case .convoy: return "promotion-convoy"
        case .auxiliaryShips: return "promotion-auxiliaryShips"
        case .creepingAttack: return "promotion-creepingAttack"

            // navalRanged
            // navalRaider
            // navalCarrier

            // airFighter
            // airBomber

            // support
        }
    }
}
