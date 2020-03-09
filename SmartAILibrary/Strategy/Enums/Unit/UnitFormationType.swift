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
}

enum UnitFormationType {

    case none
    
    case smallCityAttackForce
    case basicCityAttackForce
    case fastPillagers
    case settlerEscort
    case navalSquadron

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
        }
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
            if unit.task == .explore || unit.task == .exploreSea {
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
