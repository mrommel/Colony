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

        return 0
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
    // swiftlint:disable cyclomatic_complexity
    private func data() -> GovernorTitleTypeData {

        switch self {

        // Reyna
        case .landAcquisition:
            return GovernorTitleTypeData(
                name: "Land Acquisition",
                effects: [
                    "Acquire new tiles in the city faster.",
                    "+3 Gold  per turn from each foreign Trade Route passing through the city."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .harbormaster:
            return GovernorTitleTypeData(
                name: "Harbormaster",
                effects: [
                    "Double adjacency bonuses from Commercial Hubs and Harbors in the city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .gold, value: 6), Flavor(type: .tileImprovement, value: 4)]
            )
        case .forestryManagement:
            return GovernorTitleTypeData(
                name: "Forestry Management",
                effects: [
                    "This city receives +2 Gold for each unimproved feature.",
                    "Tiles adjacent to unimproved features receive +1 Appeal in this city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .gold, value: 6), Flavor(type: .happiness, value: 4)]
            )
        case .taxCollector:
            return GovernorTitleTypeData(
                name: "Tax Collector",
                effects: [
                    "+2 Gold per turn for each Citizen in the city."
                ],
                tier: 2,
                requiredOr: [.harbormaster, .forestryManagement],
                flavors: [Flavor(type: .gold, value: 6)]
            )
        case .contractor:
            return GovernorTitleTypeData(
                name: "Contractor",
                effects: [
                    "Allows city to purchase Districts with Gold."
                ],
                tier: 3,
                requiredOr: [.taxCollector],
                flavors: [Flavor(type: .growth, value: 6)]
            )
        case .renewableSubsidizer:
            return GovernorTitleTypeData(
                name: "Renewable Subsidizer",
                effects: [
                    "All Offshore Wind Farms, Solar Farms, Wind Farms, Geothermal Plants and Hydroelectric Dams in this city receive +2 Power and +2 Gold."
                ],
                tier: 3,
                requiredOr: [.taxCollector],
                flavors: [Flavor(type: .energy, value: 6), Flavor(type: .tileImprovement, value: 4)]
            )

            // Victor
        case .redoubt:
            return GovernorTitleTypeData(
                name: "Redoubt",
                effects: [
                    "Increase city garrison Combat Strength by 5.",
                    "Established in 3 turns."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .garrisonCommander:
            return GovernorTitleTypeData(
                name: "Garrison Commander",
                effects: [
                    "Units defending within the city's territory get +5 Combat Strength.",
                    "Your other cities within 9 tiles gain +4 Loyalty per turn towards your civilization."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .defense, value: 6), Flavor(type: .cityDefense, value: 4)]
            )
        case .defenseLogistics:
            return GovernorTitleTypeData(
                name: "Defense Logistics",
                effects: [
                    "City cannot be put under siege.",
                    "Accumulating Strategic resources gain an additional +1 per turn."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .offense, value: 5), Flavor(type: .cityDefense, value: 6)]
            )
        case .embrasure:
            return GovernorTitleTypeData(
                name: "Embrasure",
                effects: [
                    "City gains an additional Ranged Strike per turn.",
                    "Military units trained in this city start with a free promotion that do not already start with a free promotion."
                ],
                tier: 2,
                requiredOr: [.garrisonCommander, .defenseLogistics],
                flavors: [Flavor(type: .offense, value: 6), Flavor(type: .cityDefense, value: 8)]
            )
        case .airDefenseInitiative:
            return GovernorTitleTypeData(
                name: "Air Defense Initiative",
                effects: [
                    "+25 Combat Strength to anti-air support units within the city's territory when defending against aircraft and ICBMs."
                ],
                tier: 3,
                requiredOr: [.embrasure],
                flavors: [Flavor(type: .defense, value: 4), Flavor(type: .cityDefense, value: 6)]
            )
        case .armsRaceProponent:
            return GovernorTitleTypeData(
                name: "Arms Race Proponent",
                effects: [
                    "30% Production increase to all nuclear armament projects in the city."
                ],
                tier: 3,
                requiredOr: [.embrasure],
                flavors: [Flavor(type: .defense, value: 6), Flavor(type: .cityDefense, value: 4)]
            )

            // Amani
        case .messenger:
            return GovernorTitleTypeData(
                name: "Messenger",
                effects: [
                    "Can be assigned to a City-state, where she acts as 2 Envoys."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .emissary:
            return GovernorTitleTypeData(
                name: "Emissary",
                effects: [
                    "Other cities within 9 tiles and not owned by you gain +2 Loyalty per turn towards your civilization."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .diplomacy, value: 6)]
            )
        case .affluence:
            return GovernorTitleTypeData(
                name: "Affluence",
                effects: [
                    "While established in a city-state, provides a copy of its Luxury resources to you."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .happiness, value: 6)]
            )
        case .localInformants:
            return GovernorTitleTypeData(
                name: "Local Informants",
                effects: [
                    "Enemy Spies operate at 3 levels below normal in this city."
                ],
                tier: 2,
                requiredOr: [.emissary],
                flavors: [Flavor(type: .diplomacy, value: 6), Flavor(type: .cityDefense, value: 4)]
            )
        case .foreignInvestor:
            return GovernorTitleTypeData(
                name: "Foreign Investor",
                effects: [
                    "While established in a city-state, accumulate its Strategic resources.",
                    "When suzerain receive double the amount of accumulated strategic resources."
                ],
                tier: 2,
                requiredOr: [.affluence],
                flavors: [Flavor(type: .tileImprovement, value: 6), Flavor(type: .defense, value: 4), Flavor(type: .offense, value: 5)]
            )
        case .puppeteer:
            return GovernorTitleTypeData(
                name: "Puppeteer",
                effects: [
                    "While established in a city-state, doubles the number of Envoys you have there."
                ],
                tier: 3,
                requiredOr: [.localInformants, .foreignInvestor],
                flavors: [Flavor(type: .diplomacy, value: 6)]
            )

        // magnus
        case .groundbreaker:
            return GovernorTitleTypeData(
                name: "Groundbreaker",
                effects: [
                    "+50% yields from plot harvests and feature removals in the city."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .surplusLogistics:
            return GovernorTitleTypeData(
                name: "Surplus Logistics",
                effects: [
                    "+20% Food Growth in the city.",
                    "Your Trade Routes ending here provide +2 Food to their starting city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .growth, value: 6), Flavor(type: .diplomacy, value: 3)]
            )
        case .provision:
            return GovernorTitleTypeData(
                name: "Provision",
                effects: [
                    "Settlers trained in the city do not consume a Citizen Population."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .growth, value: 8)]
            )
        case .industrialist:
            return GovernorTitleTypeData(
                name: "Industrialist",
                effects: [
                    "Increase the Power provided by each resource of the Coal Power Plant, Oil Power Plant and Nuclear Power Plant by 1 and the Production by 2."
                ],
                tier: 2,
                requiredOr: [.surplusLogistics],
                flavors: [Flavor(type: .energy, value: 6)]
            )
        case .blackMarketeer:
            return GovernorTitleTypeData(
                name: "Black Marketeer",
                effects: [
                    "Strategic resources for units are discounted 80%."
                ],
                tier: 2,
                requiredOr: [.provision],
                flavors: [Flavor(type: .production, value: 4)]
            )
        case .verticalIntegration:
            return GovernorTitleTypeData(
                name: "Vertical Integration",
                effects: [
                    "This city receives Production from any number of Industrial Zones within 6 tiles, not just the first."
                ],
                tier: 3,
                requiredOr: [.industrialist, .blackMarketeer],
                flavors: [Flavor(type: .production, value: 6)]
            )

            // moksha
        case .bishop:
            return GovernorTitleTypeData(
                name: "Bishop",
                effects: [
                    "Religious pressure to adjacent cities is 100% stronger from this city.",
                    "+2 Faith per specialty district in this city."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .grandInquisitor:
            return GovernorTitleTypeData(
                name: "Grand Inquisitor",
                effects: [
                    "+10 Religious Strength in theological combat in tiles of this city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .religion, value: 6)]
            )
        case .layingOnOfHands:
            return GovernorTitleTypeData(
                name: "Laying On Of Hands",
                effects: [
                    "All Governor's units heal fully in one turn in tiles of this city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .religion, value: 4), Flavor(type: .defense, value: 4)]
            )
        case .citadelOfGod:
            return GovernorTitleTypeData(
                name: "Citadel of God",
                effects: [
                    "City ignores pressure and combat effects from Religions not founded by the Governor's player.",
                    "Gain Faith equal to 25% of the construction cost when finishing buildings."
                ],
                tier: 2,
                requiredOr: [.grandInquisitor, .layingOnOfHands],
                flavors: [Flavor(type: .religion, value: 5)]
            )
        case .patronSaint:
            return GovernorTitleTypeData(
                name: "Patron Saint",
                effects: [
                    "Apostles and Warrior Monks trained in the city receive 1 extra Promotion when receiving their first promotion."
                ],
                tier: 3,
                requiredOr: [.citadelOfGod],
                flavors: [Flavor(type: .religion, value: 5)]
            )
        case .divineArchitect:
            return GovernorTitleTypeData(
                name: "Divine Architect",
                effects: [
                    "Allows city to purchase Districts with Faith."
                ],
                tier: 3,
                requiredOr: [.citadelOfGod],
                flavors: [Flavor(type: .religion, value: 5)]
            )

            // liang
        case .guildmaster:
            return GovernorTitleTypeData(
                name: "Guildmaster",
                effects: [
                    "All Builders trained in city get +1 build charge."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .zoningCommissioner:
            return GovernorTitleTypeData(
                name: "Zoning Commissioner",
                effects: [
                    "+20% Production towards constructing Districts in the city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .production, value: 4), Flavor(type: .growth, value: 3)]
            )
        case .aquaculture:
            return GovernorTitleTypeData(
                name: "Aquaculture",
                effects: [
                    "The Fishery unique improvement can be built in the city on coastal plots.",
                    "Yields 1 Food, +1 Food for each adjacent sea resource.",
                    "Fisheries provide +1 Production if Liang is in the city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .production, value: 6), Flavor(type: .growth, value: 4)]
            )
        case .reinforcedMaterials:
            return GovernorTitleTypeData(
                name: "Reinforced Materials",
                effects: [
                    "This city's improvements, buildings and Districts cannot be damaged by Environmental Effects."
                ],
                tier: 2,
                requiredOr: [.zoningCommissioner],
                flavors: [Flavor(type: .growth, value: 4)]
            )
        case .waterWorks:
            return GovernorTitleTypeData(
                name: "Water Works",
                effects: [
                    "+2 Housing for every Neighborhood and Aqueduct district in this city.",
                    "+1 Amenity for every Canal and Dam district in this city."],
                tier: 2,
                requiredOr: [.aquaculture],
                flavors: [Flavor(type: .growth, value: 6)]
            )
        case .parksAndRecreation:
            return GovernorTitleTypeData(
                name: "Parks and Recreation",
                effects: [
                    "The City Park unique improvement can be built in the city.",
                    "Yields 2 Appeal and 1 Culture.",
                    "+1 Amenity if adjacent to water.",
                    "City Parks provide 3 Culture Culture if Liang is in the city."
                ],
                tier: 3,
                requiredOr: [.reinforcedMaterials, .waterWorks],
                flavors: [Flavor(type: .culture, value: 6), Flavor(type: .happiness, value: 4)]
            )

            // Pingala
        case .librarian:
            return GovernorTitleTypeData(
                name: "Librarian",
                effects: [
                    "15% increase in Science and Culture generated by the city."
                ],
                tier: 0,
                requiredOr: [],
                flavors: [] // not needed
            )
        case .connoisseur:
            return GovernorTitleTypeData(
                name: "Connoisseur",
                effects: [
                    "+1 Culture per turn for each Citizen in the city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .culture, value: 8)]
            )
        case .researcher:
            return GovernorTitleTypeData(
                name: "Researcher",
                effects: [
                    "+1 Science per turn for each Citizen in the city."
                ],
                tier: 1,
                requiredOr: [],
                flavors: [Flavor(type: .science, value: 8)]
            )
        case .grants:
            return GovernorTitleTypeData(
                name: "Grants",
                effects: [
                    "+100% Great People points generated per turn in the city."
                ],
                tier: 2,
                requiredOr: [.connoisseur, .researcher],
                flavors: [Flavor(type: .greatPeople, value: 8)]
            )
        case .spaceInitiative:
            return GovernorTitleTypeData(
                name: "Space Initiative",
                effects: [
                    "30% Production increase to all space-program projects in the city."
                ],
                tier: 3,
                requiredOr: [.grants],
                flavors: [Flavor(type: .science, value: 6)]
            )
        case .curator:
            return GovernorTitleTypeData(
                name: "Curator",
                effects: [
                    "+100% Tourism from Great Works of Art, Music, and Writing in the city."
                ],
                tier: 3,
                requiredOr: [.grants],
                flavors: [Flavor(type: .tourism, value: 8)]
            )
        }
    }
}
