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

    case none

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
    case navalBombardment // MUFORMATION_NAVAL_BOMBARDMENT
    case navalCityAttack // MUFORMATION_PURE_NAVAL_CITY_ATTACK
    case antiBarbarianTeam // MUFORMATION_ANTI_BARBARIAN_TEAM
    case biggerCityAttackForce // MUFORMATION_BIGGER_CITY_ATTACK_FORCE
    case colonizationParty // MUFORMATION_COLONIZATION_PARTY
    case quickColonySettler // MUFORMATION_QUICK_COLONY_SETTLER
    case closeCityDefense // MUFORMATION_CLOSE_CITY_DEFENSE
    case rapidResponseForce // MUFORMATION_RAPID_RESPONSE_FORCE
    case earlyRush // MUFORMATION_EARLY_RUSH

    // https://civilization.fandom.com/wiki/Module:Data/Civ5/BNW/MultiUnitFormation_Values
    // https://github.com/LoneGazebo/Community-Patch-DLL/blob/3783d7f1f870984ebdbfaa486eca181335151322/Community%20Patch/Core%20Files/Core%20Values/New_CIV5MultiUnitFormations.xml
    func slots() -> [UnitFormationSlot] {

        switch self {

        case .none: return []

        case .smallCityAttackForce: return [
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .defense, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .defense, position: .bombard, required: false)
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
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false)
            ]
        case .navalEscort: return [
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: false)
            ]
        case .navalBombardment: return [
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .ranged, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .ranged, position: .bombard, required: false)
                // FIXME admiral
            ]
        case .navalCityAttack: return [
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard /*assauld*/, secondaryUnitTask: .reserveSea, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard /*assauld*/, secondaryUnitTask: .reserveSea, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard /*assauld*/, secondaryUnitTask: .reserveSea, position: .bombard, required: false),
                // UnitFormationSlot(primaryUnitTask: .carrierSea, secondaryUnitTask: .reserveSea, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .attackSea, secondaryUnitTask: .reserveSea, position: .frontline, required: true)
                // FIXME admiral
            ]
        case .antiBarbarianTeam: return [
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: false)
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
                UnitFormationSlot(primaryUnitTask: .citySpecial, secondaryUnitTask: .citySpecial, position: .civilianSupport, required: false)
            ]

        case .colonizationParty: return [
                UnitFormationSlot(primaryUnitTask: .settle, secondaryUnitTask: .settle, position: .civilianSupport, required: true),
                UnitFormationSlot(primaryUnitTask: .defense, secondaryUnitTask: .counter, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: true),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: false),
                UnitFormationSlot(primaryUnitTask: .escortSea, secondaryUnitTask: .reserveSea, position: .navalEscort, required: false)
            ]

        case .quickColonySettler: return [
                UnitFormationSlot(primaryUnitTask: .settle, secondaryUnitTask: .settle, position: .civilianSupport, required: true)
            ]

        case .closeCityDefense: return [
                UnitFormationSlot(primaryUnitTask: .counter, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .ranged, secondaryUnitTask: .defense, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .counter, secondaryUnitTask: .defense, position: .frontline, required: false),
                UnitFormationSlot(primaryUnitTask: .ranged, secondaryUnitTask: .defense, position: .bombard, required: false)
            ]

        case .rapidResponseForce: return [
                UnitFormationSlot(primaryUnitTask: .counter, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .ranged, secondaryUnitTask: .defense, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .fastAttack, secondaryUnitTask: .defense, position: .frontline, required: false)
            ]

        case .earlyRush: return [
                UnitFormationSlot(primaryUnitTask: .attack, secondaryUnitTask: .fastAttack, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .counter, secondaryUnitTask: .defense, position: .frontline, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .cityBombard, secondaryUnitTask: .ranged, position: .bombard, required: true),
                UnitFormationSlot(primaryUnitTask: .ranged, secondaryUnitTask: .cityBombard, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .ranged, secondaryUnitTask: .cityBombard, position: .bombard, required: false),
                UnitFormationSlot(primaryUnitTask: .general, secondaryUnitTask: .general, position: .civilianSupport, required: false),
                UnitFormationSlot(primaryUnitTask: .citySpecial, secondaryUnitTask: .citySpecial, position: .civilianSupport, required: false)
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
            if unit.task() == .explore || unit.task() == .exploreSea {
                continue
            }

            // can't use unit in an army
            if unit.army() != nil {
                continue
            }

            for var slot in slots {
                if unit.task() == slot.primaryUnitTask || unit.task() == slot.secondaryUnitTask {
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
