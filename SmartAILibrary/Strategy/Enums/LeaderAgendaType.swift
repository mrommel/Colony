//
//  LeaderAgendaType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// https://civilization.fandom.com/wiki/List_of_agendas_in_Civ6?so=search
public enum LeaderAgendaType {

    case none

    // fixed leader agendas
    case ironCrown // Frederick Barbarossa
    case opportunist // cyrus
    case optimusPrinceps // trajan
    case queenOfTheNile // cleopatra
    case shortLifeOfGlory // alexander
    case sunNeverSets // victoria
    case tlatoani // montezuma
    case westernizer // peter

    // hidden agendas
    case cityStateAlly // Frederick Barbarossa and Pericles will never have this agenda.

    public static var leader: [LeaderAgendaType] = [

        .ironCrown,
        .opportunist,
        .optimusPrinceps,
        .queenOfTheNile,
        .shortLifeOfGlory,
        .sunNeverSets,
        .tlatoani,
        .westernizer
    ]

    public static var hidden: [LeaderAgendaType] = [

        .cityStateAlly
    ]

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> String {

        return self.data().effects
    }

    // MARK: private methods

    private struct LeaderAgendaTypeData {

        let name: String
        let effects: String
    }

    private func data() -> LeaderAgendaTypeData {

        switch self {

        case .none:
            return LeaderAgendaTypeData(name: "", effects: "")

            // leaders

        case .ironCrown: // Frederick Barbarossa
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_IRON_CROWN_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_IRON_CROWN_EFFECTS" // #
            )

        case .opportunist: // cyrus
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_OPPORTUNIST_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_OPPORTUNIST_EFFECTS" // #
            )

        case .optimusPrinceps: // trajan
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_OPTIMUS_PRINCEPS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_OPTIMUS_PRINCEPS_EFFECTS" // #
            )

        case .queenOfTheNile:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_QUEEN_OF_THE_NILE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_QUEEN_OF_THE_NILE_EFFECTS" // #
            )

        case .shortLifeOfGlory:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SHORT_LIFE_OF_GLORY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SHORT_LIFE_OF_GLORY_EFFECTS" // #
            )

        case .sunNeverSets:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SUN_NEVER_SETS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SUN_NEVER_SETS_EFFECTS" // #
            )

        case .tlatoani:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_TLATOANI_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_TLATOANI_EFFECTS" // #
            )

        case .westernizer:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_WESTERNIZER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_WESTERNIZER_EFFECTS" // #
            )

            // hidden

        case .cityStateAlly:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_CITY_STATE_ALLY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_CITY_STATE_ALLY_EFFECTS" // #
            )
        }
    }
}
