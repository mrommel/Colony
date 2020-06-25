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

    func era() -> EraType {

        switch self {

            // ancient
        case .chiefdom: return .ancient

            // classical
        case .autocracy: return .classical
        case .classicalRepublic: return .classical
        case .oligarchy: return .classical

            // medieval
        case .merchantRepublic: return .medieval
        case .monarchy: return .medieval

            // renaissance
        case .theocracy: return .renaissance

            // modern
        case .fascism: return .modern
        case .communism: return .modern
        case .democracy: return .modern
        }
    }

    func required() -> CivicType {

        switch self {

            // ancient
        case .chiefdom: return .codeOfLaws

            // classical
        case .autocracy: return .politicalPhilosophy
        case .classicalRepublic: return .politicalPhilosophy
        case .oligarchy: return .politicalPhilosophy

            // medieval
        case .merchantRepublic: return .exploration
        case .monarchy: return .divineRight

            // renaissance
        case .theocracy: return .reformedChurch

            // modern
        case .fascism: return .totalitarianism
        case .communism: return .classStruggle
        case .democracy: return .suffrage
        }
    }

    func policyCardSlots() -> PolicyCardSlots {

        switch self {

            // ancient
        case .chiefdom: return PolicyCardSlots(military: 1, economic: 1, diplomatic: 0, wildcard: 0)

            // classical
        case .autocracy: return PolicyCardSlots(military: 2, economic: 1, diplomatic: 0, wildcard: 0)
        case .classicalRepublic: return PolicyCardSlots(military: 0, economic: 2, diplomatic: 1, wildcard: 1)
        case .oligarchy: return PolicyCardSlots(military: 1, economic: 1, diplomatic: 1, wildcard: 1)

            // medieval
        case .merchantRepublic: return PolicyCardSlots(military: 1, economic: 2, diplomatic: 1, wildcard: 2)
        case .monarchy: return PolicyCardSlots(military: 3, economic: 1, diplomatic: 1, wildcard: 1)

            // renaissance
        case .theocracy: return PolicyCardSlots(military: 2, economic: 2, diplomatic: 1, wildcard: 1)

        case .fascism: return PolicyCardSlots(military: 4, economic: 1, diplomatic: 1, wildcard: 2)
        case .communism: return PolicyCardSlots(military: 3, economic: 3, diplomatic: 1, wildcard: 1)
        case .democracy: return PolicyCardSlots(military: 1, economic: 3, diplomatic: 2, wildcard: 2)
        }
    }

    func bonusSummay() -> String {

        switch self {

            // ancient
        case .chiefdom: return "No Bonus."

            // classical
        case .autocracy: return "Capital receives +1 boost to all yields."
        case .classicalRepublic: return "All cities with a district receive +1 [ICON_Amenities] Amenity."
        case .oligarchy: return "All Land Melee units gain +4 [ICON_Strength] Combat Strength."

            // medieval
        case .merchantRepublic: return "+2 [ICON_TradeRoute] Trade Routes."
        case .monarchy: return "+2 [ICON_Housing] Housing in any city with Medieval Walls."

            // renaissance
        case .theocracy: return "Can buy land combat units with Faith. All units +5 [ICON_Religion] Religious Strength in theological combat."

            // modern
        case .fascism: return "All combat units gain +4 [ICON_Strength] Combat Strength."
        case .communism: return "Land units gain +4 [ICON_Strength] Defense Strength."
        case .democracy: return "Patronage of Great People costs 50% less Gold."
        }
    }
    
    func flavorValue(for flavor: FlavorType) -> Int {

        if let flavorOfTech = self.flavours().first(where: { $0.type == flavor }) {
            return flavorOfTech.value
        }

        return 0
    }

    func flavours() -> [Flavor] {

        switch self {

            // ancient
        case .chiefdom: return []

            // classical
        case .autocracy: return [Flavor(type: .growth, value: 2), Flavor(type: .production, value: 3)]
        case .classicalRepublic: return [Flavor(type: .happiness, value: 4)]
        case .oligarchy: return [Flavor(type: .offense, value: 4)]

            // medieval
        case .merchantRepublic: return [Flavor(type: .gold, value: 4)]
        case .monarchy: return [Flavor(type: .growth, value: 3)]

            // renaissance
        case .theocracy: return [Flavor(type: .religion, value: 4)]

            // modern
        case .fascism: return [Flavor(type: .offense, value: 5)]
        case .communism: return [Flavor(type: .defense, value: 4), Flavor(type: .cityDefense, value: 2)]
        case .democracy: return [Flavor(type: .gold, value: 2), Flavor(type: .greatPeople, value: 4)]
        }
    }
}
