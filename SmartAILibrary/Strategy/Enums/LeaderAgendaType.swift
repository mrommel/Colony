//
//  LeaderAgendaType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 12.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum LeaderAgendaCategory {

    case leader
    case earlyGame
    case lateGame
}

// https://civilization.fandom.com/wiki/List_of_agendas_in_Civ6?so=search
public enum LeaderAgendaType: Int, Codable {

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

    // early game hidden agendas
    case cityStateProtector // Alexander, Cyrus and Frederick Barbarossa will never have this agenda.

    // late game hidden agendas

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

        .cityStateProtector
    ]

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func effects() -> String {

        return self.data().effects
    }

    public func category() -> LeaderAgendaCategory {

        return self.data().category
    }

    // MARK: private methods

    private struct LeaderAgendaTypeData {

        let name: String
        let effects: String
        let category: LeaderAgendaCategory
    }

    private func data() -> LeaderAgendaTypeData {

        switch self {

        case .none:
            return LeaderAgendaTypeData(name: "", effects: "", category: .leader)

            // leaders

        case .ironCrown: // Frederick Barbarossa
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_IRON_CROWN_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_IRON_CROWN_EFFECTS", // #
                category: .leader
            )

        case .opportunist: // cyrus
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_OPPORTUNIST_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_OPPORTUNIST_EFFECTS", // #
                category: .leader
            )

        case .optimusPrinceps: // trajan
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_OPTIMUS_PRINCEPS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_OPTIMUS_PRINCEPS_EFFECTS", // #
                category: .leader
            )

        case .queenOfTheNile:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_QUEEN_OF_THE_NILE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_QUEEN_OF_THE_NILE_EFFECTS", // #
                category: .leader
            )

        case .shortLifeOfGlory:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SHORT_LIFE_OF_GLORY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SHORT_LIFE_OF_GLORY_EFFECTS", // #
                category: .leader
            )

        case .sunNeverSets:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SUN_NEVER_SETS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SUN_NEVER_SETS_EFFECTS", // #
                category: .leader
            )

        case .tlatoani:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_TLATOANI_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_TLATOANI_EFFECTS", // #
                category: .leader
            )

        case .westernizer:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_WESTERNIZER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_WESTERNIZER_EFFECTS", // #
                category: .leader
            )

            // hidden

        case .cityStateProtector:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_CITY_STATE_PROTECTOR_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_CITY_STATE_PROTECTOR_EFFECTS", // #
                category: .earlyGame
            )
        }
    }
}
