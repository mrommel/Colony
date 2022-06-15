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
        case .ranger: return "promotion-default"
        case .alpine: return "promotion-default"
        case .sentry: return "promotion-default"
        case .guerrilla: return "promotion-default"
        case .spyglass: return "promotion-default"
        case .ambush: return "promotion-default"
        case .camouflage: return "promotion-default"

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

        }
    }
}
