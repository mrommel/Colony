//
//  UnitFormation.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

struct UnitFormationSlot {

    let primaryUnitTask: UnitTaskType
    let secondaryUnitTask: UnitTaskType
    let position: UnitFormationPosition
    let required: Bool

    var filled: Bool = false
}

enum UnitFormationPosition {

    case bombard
    case frontline
    case civilianSupport
    case navalEscort
}

enum UnitFormationType: Int, Codable {

    case none
    
    case smallCityAttackForce
    case basicCityAttackForce // MUFORMATION_BASIC_CITY_ATTACK_FORCE
    case fastPillagers // MUFORMATION_FAST_PILLAGERS
    case settlerEscort // MUFORMATION_SETTLER_ESCORT
    case navalSquadron // MUFORMATION_NAVAL_SQUADRON
    case navalInvasion // MUFORMATION_NAVAL_INVASION
    case navalEscort // MUFORMATION_NAVAL_ESCORT
    case antiBarbarianTeam // MUFORMATION_ANTI_BARBARIAN_TEAM
    case biggerCityAttackForce // MUFORMATION_BIGGER_CITY_ATTACK_FORCE

    func slots() -> [UnitFormationSlot] {

        switch self {
            
        case .none: return []

        case .smallCityAttackForce: return [
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .defense, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .bombard, required: false),
            ]

        case .basicCityAttackForce: return [
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: false),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: false)
            ]
        case .fastPillagers: return [
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true)
            ]
        case .settlerEscort: return [
                UnitFormationSlot(primaryUnitTask: .settle, secondaryUnitTask: .settle, position: .civilianSupport, required: true),
                UnitFormationSlot(primaryUnitTask: .defense, secondaryUnitTask: .counter, position: .frontline, required: true)
            ]
        case .navalSquadron: return [
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false)
            ]
        case .navalInvasion: return [
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .defense, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .defense, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: true),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: true),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: false),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: false),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false),
            ]
        case .navalEscort: return [
            UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
            UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
            UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
            UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
            UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
            UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
            UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
            ]
        case .antiBarbarianTeam: return [
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false),
            ]
            
        case .biggerCityAttackForce: return [
            UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .fastAttack, position: .frontline, required: true),
            UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
            UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
            UnitFormationSlot(primaryUnitTask: .defense, secondaryUnitTask: .counter, position: .frontline, required: true),
            UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
            UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
            UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
            UnitFormationSlot(primaryUnitTask: .ranged, secondaryUnitTask: .cityBombard, position: .bombard, required: true),
            UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .counter, position: .frontline, required: false),
            UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .counter, position: .frontline, required: false),
            UnitFormationSlot(primaryUnitTask: .general, secondaryUnitTask: .general, position: .civilianSupport, required: false),
            UnitFormationSlot(primaryUnitTask: .citySpecial, secondaryUnitTask: .citySpecial, position: .civilianSupport, required: false),
            ]
        }
    }
    
    func isRequiresNavalUnitConsistency() -> Bool {
        
        return self == .navalEscort
    }
}

class UnitFormationHelper {

    static func numberOfFillableSlots(of units: [AbstractUnit?], for formation: UnitFormationType) -> (Int, Int, Int) {

        var numberSlotsRequired: Int = 0
        var numberLandReservesUsed: Int = 0
        var willBeFilled: Int = 0

        let slots = formation.slots()

        for unitRef in units {

            guard let unit = unitRef else {
                fatalError("cant get unit")
            }

            // Don't count scouts
            if unit.has(task: .explore) || unit.has(task: .exploreSea) {
                continue
            }

            // can't use unit in an army
            if unit.army() != nil {
                continue
            }

            for var slot in slots {
                if unit.has(task: slot.primaryUnitTask) || unit.has(task: slot.secondaryUnitTask) {
                    slot.filled = true

                    willBeFilled += 1

                    if unit.domain() == .land {
                        numberLandReservesUsed += 1
                    }
                }
            }
        }

        // Now go back through remaining slots and see how many were required, we'll need that many more units
        for slot in slots {
            if slot.required && !slot.filled {
                numberSlotsRequired += 1
            }
        }

        return (numberSlotsRequired, numberLandReservesUsed, willBeFilled)
    }
}
