//
//  GovernmentType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class PolicyCardSlots {

    let military: Int // red
    let economic: Int // yellow
    let diplomatic: Int // green
    let wildcard: Int // lila

    init(military: Int, economic: Int, diplomatic: Int, wildcard: Int) {

        self.military = military
        self.economic = economic
        self.diplomatic = diplomatic
        self.wildcard = wildcard
    }

    func types() -> [PolicyCardSlotType] {

        var list: [PolicyCardSlotType] = []

        for _ in 0..<self.military {
            list.append(.military)
        }

        for _ in 0..<self.economic {
            list.append(.economic)
        }

        for _ in 0..<self.diplomatic {
            list.append(.diplomatic)
        }

        for _ in 0..<self.wildcard {
            list.append(.wildcard)
        }

        return list
    }
}

public enum GovernmentType: Int, Codable {

    // ancient
    case chiefdom

    // classical
    case autocracy
    case classicalRepublic
    case oligarchy

    // medieval
    case merchantRepublic
    case monarchy

    // renaissance
    case theocracy

    // modern
    case fascism
    case communism
    case democracy

    static var all: [GovernmentType] {
        return [

            // ancient
            .chiefdom,

            // classical
            .autocracy, .classicalRepublic, .oligarchy,

            // medieval
            .merchantRepublic, .monarchy,

            // renaissance
            .theocracy,

            // modern
            .fascism, .communism, .democracy
        ]
    }

    // MARK: methods

    public func name() -> String {

        return self.data().name
    }
    
    public func era() -> EraType {

        return self.data().era
    }

    public func required() -> CivicType {

        return self.data().required
    }

    public func policyCardSlots() -> PolicyCardSlots {

        return self.data().policyCardSlots
    }

    public func bonusSummary() -> String {

        return self.data().bonusSummary
    }
    
    public func legacySummary() -> String {
        
        return self.data().legacyBonusSummary
    }

    func flavorValue(for flavor: FlavorType) -> Int {

        if let flavorOfTech = self.flavours().first(where: { $0.type == flavor }) {
            return flavorOfTech.value
        }

        return 0
    }

    func flavours() -> [Flavor] {

        return self.data().flavors
    }

    // MARK: private methods

    struct GovernmentData {

        let name: String
        let bonusSummary: String
        let legacyBonusSummary: String
        let era: EraType
        let required: CivicType
        let policyCardSlots: PolicyCardSlots
        let flavors: [Flavor]
        let influcencePointsPerTurn: Int
    }

    private func data() -> GovernmentData {

        switch self {

            // ancient
        case .chiefdom:
            return GovernmentData(name: "Chiefdom",
                                  bonusSummary: "No Bonus.",
                                  legacyBonusSummary: "No Bonus",
                                  era: .ancient,
                                  required: .codeOfLaws,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 1, diplomatic: 0, wildcard: 0),
                                  flavors: [],
                                  influcencePointsPerTurn: 1)

            // classical
        case .autocracy:
            return GovernmentData(name: "Autocracy",
                                  bonusSummary: "+1 to all yields for each government building and Palace in a city. +10% Production toward Wonders.",
                                  legacyBonusSummary: "1% Production toward Wonders for every 20 turns",
                                  era: .classical,
                                  required: .politicalPhilosophy,
                                  policyCardSlots: PolicyCardSlots(military: 2, economic: 1, diplomatic: 0, wildcard: 0),
                                  flavors: [Flavor(type: .growth, value: 2), Flavor(type: .production, value: 3)],
                                  influcencePointsPerTurn: 3)
        case .classicalRepublic:
            return GovernmentData(name: "ClassicalRepublic",
                                  bonusSummary: "All cities with a district receive +1 [ICON_Amenities] Amenity.",
                                  legacyBonusSummary: "",
                                  era: .classical,
                                  required: .politicalPhilosophy,
                                  policyCardSlots: PolicyCardSlots(military: 0, economic: 2, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .happiness, value: 4)],
                                  influcencePointsPerTurn: 3)
        case .oligarchy:
            return GovernmentData(name: "Oligarchy",
                                  bonusSummary: "All Land Melee units gain +4 [ICON_Strength] Combat Strength.",
                                  legacyBonusSummary: "",
                                  era: .classical,
                                  required: .politicalPhilosophy,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 1, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .offense, value: 4)],
                                  influcencePointsPerTurn: 3)

            // medieval
        case .merchantRepublic:
            return GovernmentData(name: "MerchantRepublic",
                                  bonusSummary: "+2 [ICON_TradeRoute] Trade Routes.",
                                  legacyBonusSummary: "",
                                  era: .medieval,
                                  required: .exploration,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 2, diplomatic: 1, wildcard: 2),
                                  flavors: [Flavor(type: .gold, value: 4)],
                                  influcencePointsPerTurn: 5)
        case .monarchy:
            return GovernmentData(name: "Monarchy",
                                  bonusSummary: "+2 [ICON_Housing] Housing in any city with Medieval Walls.",
                                  legacyBonusSummary: "",
                                  era: .medieval,
                                  required: .divineRight,
                                  policyCardSlots: PolicyCardSlots(military: 3, economic: 1, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .growth, value: 3)],
                                  influcencePointsPerTurn: 5)

            // renaissance
        case .theocracy:
            return GovernmentData(name: "Theocracy",
                                  bonusSummary: "Can buy land combat units with Faith. All units +5 [ICON_Religion] Religious Strength in theological combat.",
                                  legacyBonusSummary: "",
                                  era: .renaissance,
                                  required: .reformedChurch,
                                  policyCardSlots: PolicyCardSlots(military: 2, economic: 2, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .religion, value: 4)],
                                  influcencePointsPerTurn: 5)

            // modern
        case .fascism:
            return GovernmentData(name: "Fascism",
                                  bonusSummary: "All combat units gain +4 [ICON_Strength] Combat Strength.",
                                  legacyBonusSummary: "",
                                  era: .modern,
                                  required: .totalitarianism,
                                  policyCardSlots: PolicyCardSlots(military: 4, economic: 1, diplomatic: 1, wildcard: 2),
                                  flavors: [Flavor(type: .offense, value: 5)],
                                  influcencePointsPerTurn: 7)
        case .communism:
            return GovernmentData(name: "Communism",
                                  bonusSummary: "Land units gain +4 [ICON_Strength] Defense Strength.",
                                  legacyBonusSummary: "",
                                  era: .modern,
                                  required: .classStruggle,
                                  policyCardSlots: PolicyCardSlots(military: 3, economic: 3, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .defense, value: 4), Flavor(type: .cityDefense, value: 2)],
                                  influcencePointsPerTurn: 7)
        case .democracy:
            return GovernmentData(name: "Democracy",
                                  bonusSummary: "Patronage of Great People costs 50% less Gold.",
                                  legacyBonusSummary: "",
                                  era: .modern,
                                  required: .suffrage,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 3, diplomatic: 2, wildcard: 2),
                                  flavors: [Flavor(type: .gold, value: 2), Flavor(type: .greatPeople, value: 4)],
                                  influcencePointsPerTurn: 7)
        }
    }
}
