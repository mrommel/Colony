//
//  GovernorType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/Governor_(Civ6)
public enum GovernorType {

    case reyna
    case victor
    case amani
    case magnus
    case moksha
    case liang
    case pingala

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func title() -> String {

        return self.data().title
    }

    public func turnsToEstablish() -> Int {

        return self.data().turnsToEstablish
    }

    public func defaultTitle() -> GovernorTitleType {

        return self.data().defaultTitle
    }

    public func titles() -> [GovernorTitleType] {

        return self.data().titles
    }

    // MARK: private methods

    private struct GovernorTypeData {

        let name: String
        let title: String
        let turnsToEstablish: Int

        let defaultTitle: GovernorTitleType
        let titles: [GovernorTitleType]
    }

    private func data() -> GovernorTypeData {

        switch self {

        case .reyna:
            // https://civilization.fandom.com/wiki/Reyna_(Financier)_(Civ6)
            return GovernorTypeData(
                name: "Reyna",
                title: "The Financier",
                turnsToEstablish: 5,
                defaultTitle: .landAcquisition,
                titles: [
                    .harbormaster, .forestryManagement, // tier 1
                    .taxCollector, // tier 2
                    .contractor, .renewableSubsidizer // tier 3
                ]
            )

        case .victor:
            // https://civilization.fandom.com/wiki/Victor_(Castellan)_(Civ6)
            return GovernorTypeData(
                name: "Victor",
                title: "The Castellan",
                turnsToEstablish: 3,
                defaultTitle: .redoubt,
                titles: [
                    .garrisonCommander, .defenseLogistics, // tier 1
                    .embrasure, // tier 2
                    .airDefenseInitiative, .armsRaceProponent // tier 3
                ]
            )

        case .amani:
            // https://civilization.fandom.com/wiki/Amani_(Diplomat)_(Civ6)
            return GovernorTypeData(
                name: "Amani",
                title: "The Diplomat",
                turnsToEstablish: 5,
                defaultTitle: .messenger,
                titles: [
                    .emissary, .affluence, // tier 1
                    .localInformants, .foreignInvestor, // tier 2
                    .puppeteer // tier 3
                ]
            )

        case .magnus:
            // https://civilization.fandom.com/wiki/Magnus_(Steward)_(Civ6)
            return GovernorTypeData(
                name: "Magnus",
                title: "The Steward",
                turnsToEstablish: 5,
                defaultTitle: .groundbreaker,
                titles: [
                    .surplusLogistics, .provision, // tier 1
                    .industrialist, .blackMarketeer, // tier 2
                    .verticalIntegration // tier 3
                ]
            )

        case .moksha:
            // https://civilization.fandom.com/wiki/Moksha_(Cardinal)_(Civ6)
            return GovernorTypeData(
                name: "Moksha",
                title: "The Cardinal",
                turnsToEstablish: 5,
                defaultTitle: .bishop,
                titles: [
                    .grandInquisitor, .layingOnOfHands, // tier 1
                    .citadelOfGod, // tier 2
                    .patronSaint, .divineArchitect // tier 3
                ]
            )

        case .liang:
            // https://civilization.fandom.com/wiki/Liang_(Surveyor)_(Civ6)
            return GovernorTypeData(
                name: "Liang",
                title: "The Surveyor",
                turnsToEstablish: 5,
                defaultTitle: .guildmaster,
                titles: [
                    .zoningCommissioner, .aquaculture, // tier 1
                    .reinforcedMaterials, .waterWorks, // tier 2
                    .parksAndRecreation // tier 3
                ]
            )

        case .pingala:
            // https://civilization.fandom.com/wiki/Pingala_(Educator)_(Civ6)
            return GovernorTypeData(
                name: "Pingala",
                title: "The Educator",
                turnsToEstablish: 5,
                defaultTitle: .librarian,
                titles: [
                    .connoisseur, .researcher, // tier 1
                    .grants, // tier 2
                    .spaceInitiative, .curator // tier 3
                ]
            )
        }
    }
}
