//
//  GovernmentType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

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

    public static var all: [GovernmentType] {
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

    public func bonus1Summary() -> String {

        return self.data().bonus1Summary
    }

    public func bonus2Summary() -> String {

        return self.data().bonus2Summary
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
        let bonus1Summary: String
        let bonus2Summary: String
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
                                  bonus1Summary: "No Bonus.",
                                  bonus2Summary: "No Bonus",
                                  era: .ancient,
                                  required: .codeOfLaws,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 1, diplomatic: 0, wildcard: 0),
                                  flavors: [],
                                  influcencePointsPerTurn: 1)

            // classical
        case .autocracy:
            return GovernmentData(name: "Autocracy",
                                  bonus1Summary: "+1 to all yields for each government building and Palace in a city.",
                                  bonus2Summary: "+10% Production toward Wonders.",
                                  era: .classical,
                                  required: .politicalPhilosophy,
                                  policyCardSlots: PolicyCardSlots(military: 2, economic: 1, diplomatic: 0, wildcard: 0),
                                  flavors: [Flavor(type: .growth, value: 2), Flavor(type: .production, value: 3)],
                                  influcencePointsPerTurn: 3)
        case .classicalRepublic:
            return GovernmentData(name: "ClassicalRepublic",
                                  bonus1Summary: "All cities with a district receive +1 Housing6 Housing and +1 Amenities6 Amenity.",
                                  bonus2Summary: "+15% Great Person points.", // FIXME niy
                                  era: .classical,
                                  required: .politicalPhilosophy,
                                  policyCardSlots: PolicyCardSlots(military: 0, economic: 2, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .happiness, value: 4)],
                                  influcencePointsPerTurn: 3)
        case .oligarchy:
            return GovernmentData(name: "Oligarchy",
                                  bonus1Summary: "All land melee, anti-cavalry, and naval melee class units gain +4 Civ6StrengthIcon Combat Strength.",
                                  bonus2Summary: "+20% Unit Experience.",
                                  era: .classical,
                                  required: .politicalPhilosophy,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 1, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .offense, value: 4)],
                                  influcencePointsPerTurn: 3)

            // medieval
        case .merchantRepublic:
            return GovernmentData(name: "MerchantRepublic",
                                  bonus1Summary: "+10% Civ6Gold Gold in all cities with an established Governor.", // FIXME niy
                                  bonus2Summary: "+15% Production toward Districts.",
                                  era: .medieval,
                                  required: .exploration,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 2, diplomatic: 1, wildcard: 2),
                                  flavors: [Flavor(type: .gold, value: 4)],
                                  influcencePointsPerTurn: 5)
        case .monarchy:
            return GovernmentData(name: "Monarchy",
                                  bonus1Summary: "+1 Housing6 Housing per level of Walls.",
                                  bonus2Summary: "+50% Influence Points.", // FIXME niy
                                  era: .medieval,
                                  required: .divineRight,
                                  policyCardSlots: PolicyCardSlots(military: 3, economic: 1, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .growth, value: 3)],
                                  influcencePointsPerTurn: 5)

            // renaissance
        case .theocracy:
            return GovernmentData(name: "Theocracy",
                                  bonus1Summary: "+5 ReligiousStrength6 Religious Strength in Theological Combat. +0.5 Civ6Faith Faith per Citizen6 Citizen in cities with Governors.", // FIXME niy
                                  bonus2Summary: "15% Discount on Purchases with Civ6Faith Faith.", // FIXME niy
                                  era: .renaissance,
                                  required: .reformedChurch,
                                  policyCardSlots: PolicyCardSlots(military: 2, economic: 2, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .religion, value: 4)],
                                  influcencePointsPerTurn: 5)

            // modern
        case .fascism:
            return GovernmentData(name: "Fascism",
                                  bonus1Summary: "All units gain +5 Civ6StrengthIcon Combat Strength. War Weariness reduced by 15%.", // FIXME 2nd niy
                                  bonus2Summary: "+50% Civ6Production Production toward Units.",
                                  era: .modern,
                                  required: .totalitarianism,
                                  policyCardSlots: PolicyCardSlots(military: 4, economic: 1, diplomatic: 1, wildcard: 2),
                                  flavors: [Flavor(type: .offense, value: 5)],
                                  influcencePointsPerTurn: 7)
        case .communism:
            return GovernmentData(name: "Communism",
                                  bonus1Summary: "+0.6 Civ6Production Production per Citizen6 Citizen in cities with Governors.", // FIXME niy
                                  bonus2Summary: "+15% Civ6Production Production.",
                                  era: .modern,
                                  required: .classStruggle,
                                  policyCardSlots: PolicyCardSlots(military: 3, economic: 3, diplomatic: 1, wildcard: 1),
                                  flavors: [Flavor(type: .defense, value: 4), Flavor(type: .cityDefense, value: 2)],
                                  influcencePointsPerTurn: 7)
        case .democracy:
            return GovernmentData(name: "Democracy",
                                  bonus1Summary: "+1 Civ6Production Production and +1 Housing6 Housing per District.",
                                  bonus2Summary: "25% Discount on Purchases with Civ6Gold Gold.", // FIXME niy
                                  era: .modern,
                                  required: .suffrage,
                                  policyCardSlots: PolicyCardSlots(military: 1, economic: 3, diplomatic: 2, wildcard: 2),
                                  flavors: [Flavor(type: .gold, value: 2), Flavor(type: .greatPeople, value: 4)],
                                  influcencePointsPerTurn: 7)
        }
    }
}
