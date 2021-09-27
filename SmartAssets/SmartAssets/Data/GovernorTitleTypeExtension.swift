//
//  GovernorTitleTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 27.09.21.
//

import SmartAILibrary

extension GovernorTitleType {

    public func iconTexture() -> String {

        switch self {

        case .landAcquisition: return "promotion-default"
        case .harbormaster: return "promotion-default"
        case .forestryManagement: return "promotion-default"
        case .taxCollector: return "promotion-default"
        case .contractor: return "promotion-default"
        case .renewableSubsidizer: return "promotion-default"

        case .redoubt: return "promotion-default"
        case .garrisonCommander: return "promotion-default"
        case .defenseLogistics: return "promotion-default"
        case .embrasure: return "promotion-default"
        case .airDefenseInitiative: return "promotion-default"
        case .armsRaceProponent: return "promotion-default"

        case .messenger: return "promotion-default"
        case .emissary: return "promotion-default"
        case .affluence: return "promotion-default"
        case .localInformants: return "promotion-default"
        case .foreignInvestor: return "promotion-default"
        case .puppeteer: return "promotion-default"

        case .groundbreaker: return "promotion-default"
        case .surplusLogistics: return "promotion-default"
        case .provision: return "promotion-default"
        case .industrialist: return "promotion-default"
        case .blackMarketeer: return "promotion-default"
        case .verticalIntegration: return "promotion-default"

        case .bishop: return "promotion-default"
        case .grandInquisitor: return "promotion-default"
        case .layingOnOfHands: return "promotion-default"
        case .citadelOfGod: return "promotion-default"
        case .patronSaint: return "promotion-default"
        case .divineArchitect: return "promotion-default"

        case .guildmaster: return "promotion-default"
        case .zoningCommissioner: return "promotion-default"
        case .aquaculture: return "promotion-default"
        case .reinforcedMaterials: return "promotion-default"
        case .waterWorks: return "promotion-default"
        case .parksAndRecreation: return "promotion-default"

        case .librarian: return "promotion-default"
        case .connoisseur: return "promotion-default"
        case .researcher: return "promotion-default"
        case .grants: return "promotion-default"
        case .spaceInitiative: return "promotion-default"
        case .curator: return "promotion-default"
        }
    }
}
