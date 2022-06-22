//
//  GovernorTitleType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Governor_(Civ6)
// swiftlint:disable type_body_length
// swiftlint:disable inclusive_language
public enum GovernorTitleType: Int, Codable {

    // reyna
    case landAcquisition
    case harbormaster
    case forestryManagement
    case taxCollector
    case contractor
    case renewableSubsidizer

    // victor
    case redoubt
    case garrisonCommander
    case defenseLogistics
    case embrasure
    case airDefenseInitiative
    case armsRaceProponent

    // amani
    case messenger
    case emissary
    case affluence
    case localInformants
    case foreignInvestor
    case puppeteer

    // magnus
    case groundbreaker
    case surplusLogistics
    case provision
    case industrialist
    case blackMarketeer
    case verticalIntegration

    // moksha
    case bishop
    case grandInquisitor
    case layingOnOfHands
    case citadelOfGod
    case patronSaint
    case divineArchitect

    // Liang
    case guildmaster
    case zoningCommissioner
    case aquaculture
    case reinforcedMaterials
    case waterWorks
    case parksAndRecreation

    // Pingala
    case librarian
    case connoisseur
    case researcher
    case grants
    case spaceInitiative
    case curator

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> [String] {

        return self.data().effects
    }

    public func tier() -> Int {

        return self.data().tier
    }

    public func requiredOr() -> [GovernorTitleType] {

        return self.data().requiredOr
    }

    func flavor(for flavorType: FlavorType) -> Int {

        if let modifier = self.data().flavors.first(where: { $0.type == flavorType }) {
            return modifier.value
        }

        return DistrictType.defaultFlavorValue
    }

    // MARK: private methods

    private struct GovernorTitleTypeData {

        let name: String
        let effects: [String]
        let tier: Int
        let requiredOr: [GovernorTitleType]
        let flavors: [Flavor]
    }

    // swiftlint:disable function_body_length
    // swiftlint:disable line_length
    private func data() -> GovernorTitleTypeData {

        switch self {

        // Reyna
        case .landAcquisition:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_LAND_ACQUISITION_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_ACQUISITION_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_ACQUISITION_EFFECT2"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .harbormaster:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_HARBORMASTER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_HARBORMASTER_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .gold, value: 6), Flavor(type: .tileImprovement, value: 4)]
            )
        case .forestryManagement:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_FORESTRY_MANAGEMENT_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_FORESTRY_MANAGEMENT_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_FORESTRY_MANAGEMENT_EFFECT2"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .gold, value: 6), Flavor(type: .amenities, value: 4)]
            )
        case .taxCollector:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_TAX_COLLECTOR_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_TAX_COLLECTOR_EFFECT1"
                ],
                tier: 2,
                requiredOr: [.harbormaster, .forestryManagement],
                flavors: [Flavor(type: .gold, value: 6)]
            )
        case .contractor:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_CONTRACTOR_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_CONTRACTOR_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.taxCollector],
                flavors: [Flavor(type: .growth, value: 6)]
            )
        case .renewableSubsidizer:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_RENEWABLE_SUBSIDIZER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_REYNA_RENEWABLE_SUBSIDIZER_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.taxCollector],
                flavors: [Flavor(type: .energy, value: 6), Flavor(type: .tileImprovement, value: 4)]
            )

            // ----------------------------------
            // Victor

        case .redoubt:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_REDOUBT_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_REDOUBT_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_REDOUBT_EFFECT2"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .garrisonCommander:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_GARRISON_COMMANDER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_GARRISON_COMMANDER_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_GARRISON_COMMANDER_EFFECT2"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .defense, value: 6), Flavor(type: .cityDefense, value: 4)]
            )
        case .defenseLogistics:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_DEFENSE_LOGISTICS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_DEFENSE_LOGISTICS_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_DEFENSE_LOGISTICS_EFFECT2"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .cityDefense, value: 6)]
            )
        case .embrasure:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_EMBRASURE_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_EMBRASURE_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_EMBRASURE_EFFECT2"
                ],
                tier: 2,
                requiredOr: [.garrisonCommander, .defenseLogistics],
                flavors: [Flavor(type: .offense, value: 6), Flavor(type: .cityDefense, value: 8)]
            )
        case .airDefenseInitiative:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_AIR_DEFENSE_INITIATIVE_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_AIR_DEFENSE_INITIATIVE_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.embrasure],
                flavors: [Flavor(type: .defense, value: 4), Flavor(type: .cityDefense, value: 6)]
            )
        case .armsRaceProponent:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_ARMS_RACE_PROPONENT_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_VICTOR_ARMS_RACE_PROPONENT_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.embrasure],
                flavors: [Flavor(type: .defense, value: 6), Flavor(type: .cityDefense, value: 4)]
            )

            // Amani
        case .messenger:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_MESSENGER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_MESSENGER_EFFECT1"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .emissary:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_EMISSARY_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_EMISSARY_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .diplomacy, value: 6)]
            )
        case .affluence:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_AFFLUENCE_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_AFFLUENCE_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .amenities, value: 6)]
            )
        case .localInformants:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_LOCAL_INFORMANTS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_LOCAL_INFORMANTS_EFFECT1"
                ],
                tier: 2,
                requiredOr: [.emissary],
                flavors: [Flavor(type: .diplomacy, value: 6), Flavor(type: .cityDefense, value: 4)]
            )
        case .foreignInvestor:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_FOREIGN_INVESTOR_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_FOREIGN_INVESTOR_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_FOREIGN_INVESTOR_EFFECT2"
                ],
                tier: 2,
                requiredOr: [.affluence],
                flavors: [Flavor(type: .tileImprovement, value: 6), Flavor(type: .defense, value: 4), Flavor(type: .offense, value: 5)]
            )
        case .puppeteer:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_PUPPETEER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_AMANI_PUPPETEER_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.localInformants, .foreignInvestor],
                flavors: [Flavor(type: .diplomacy, value: 6)]
            )

            // ----------------------------------
            // Magnus
        case .groundbreaker:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_GROUNDBREAKER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_GROUNDBREAKER_EFFECT1"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .surplusLogistics:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_SURPLUS_LOGISTICS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_SURPLUS_LOGISTICS_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_SURPLUS_LOGISTICS_EFFECT2"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .growth, value: 6), Flavor(type: .diplomacy, value: 3)]
            )
        case .provision:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_PROVISION_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_PROVISION_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .growth, value: 8)]
            )
        case .industrialist:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_INDUSTRIALIST_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_INDUSTRIALIST_EFFECT1"
                ],
                tier: 2,
                requiredOr: [.surplusLogistics],
                flavors: [Flavor(type: .energy, value: 6)]
            )
        case .blackMarketeer:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_BLACK_MARKETEER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_BLACK_MARKETEER_EFFECT1"
                ],
                tier: 2,
                requiredOr: [.provision],
                flavors: [Flavor(type: .production, value: 4)]
            )
        case .verticalIntegration:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_VERTICAL_INTEGRATION_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MAGNUS_VERTICAL_INTEGRATION_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.industrialist, .blackMarketeer],
                flavors: [Flavor(type: .production, value: 6)]
            )

            // moksha
        case .bishop:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_BISHOP_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_BISHOP_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_BISHOP_EFFECT2"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .grandInquisitor:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_GRAD_INQUISITOR_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_GRAD_INQUISITOR_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .religion, value: 6)]
            )
        case .layingOnOfHands:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_LAYING_ON_OF_HANDS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_LAYING_ON_OF_HANDS_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .religion, value: 4), Flavor(type: .defense, value: 4)]
            )
        case .citadelOfGod:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_CITADEL_OF_GOD_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_CITADEL_OF_GOD_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_CITADEL_OF_GOD_EFFECT2"
                ],
                tier: 2,
                requiredOr: [.grandInquisitor, .layingOnOfHands],
                flavors: [Flavor(type: .religion, value: 5)]
            )
        case .patronSaint:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_PATRON_SAINT_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_PATRON_SAINT_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.citadelOfGod],
                flavors: [Flavor(type: .religion, value: 5)]
            )
        case .divineArchitect:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_DIVINE_ARCHITECT_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_MOKSHA_DIVINE_ARCHITECT_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.citadelOfGod],
                flavors: [Flavor(type: .religion, value: 5)]
            )

            // ----------------------------------
            // Liang
        case .guildmaster:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_GUILDMASTER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_GUILDMASTER_EFFECT1"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .zoningCommissioner:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_ZONING_COMMISSIONER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_ZONING_COMMISSIONER_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .production, value: 4), Flavor(type: .growth, value: 3)]
            )
        case .aquaculture:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_AQUACULTURE_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_AQUACULTURE_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_AQUACULTURE_EFFECT2",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_AQUACULTURE_EFFECT3"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .production, value: 6), Flavor(type: .growth, value: 4)]
            )
        case .reinforcedMaterials:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_REINFORCED_MATERIALS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_REINFORCED_MATERIALS_EFFECT1"
                ],
                tier: 2,
                requiredOr: [.zoningCommissioner],
                flavors: [Flavor(type: .growth, value: 4)]
            )
        case .waterWorks:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_WATER_WORKS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_WATER_WORKS_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_WATER_WORKS_EFFECT2"
                ],
                tier: 2,
                requiredOr: [.aquaculture],
                flavors: [Flavor(type: .growth, value: 6)]
            )
        case .parksAndRecreation:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_PARKS_AND_RECREATION_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_PARKS_AND_RECREATION_EFFECT1",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_PARKS_AND_RECREATION_EFFECT2",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_PARKS_AND_RECREATION_EFFECT3",
                    "TXT_KEY_GOVERNMENT_GOVERNOR_LIANG_PARKS_AND_RECREATION_EFFECT4"
                ],
                tier: 3,
                requiredOr: [.reinforcedMaterials, .waterWorks],
                flavors: [
                    Flavor(type: .culture, value: 6),
                    Flavor(type: .amenities, value: 4)
                ]
            )

            // ----------------------------------
            // Pingala

        case .librarian:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_LIBRARIAN_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_LIBRARIAN_EFFECT1"
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .connoisseur:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_CONNOISSEUR_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_CONNOISSEUR_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .culture, value: 8)]
            )
        case .researcher:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_RESEARCHER_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_RESEARCHER_EFFECT1"
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .science, value: 8)]
            )
        case .grants:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_GRANTS_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_GRANTS_EFFECT1"
                ],
                tier: 2,
                requiredOr: [.connoisseur, .researcher],
                flavors: [Flavor(type: .greatPeople, value: 8)]
            )
        case .spaceInitiative:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_SPACE_INITIATIVE_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_SPACE_INITIATIVE_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.grants],
                flavors: [Flavor(type: .science, value: 6)]
            )
        case .curator:
            return GovernorTitleTypeData(
                name: "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_CURATOR_TITLE",
                effects: [
                    "TXT_KEY_GOVERNMENT_GOVERNOR_PINGALA_CURATOR_EFFECT1"
                ],
                tier: 3,
                requiredOr: [.grants],
                flavors: [Flavor(type: .tourism, value: 8)]
            )
        }
    }
}
