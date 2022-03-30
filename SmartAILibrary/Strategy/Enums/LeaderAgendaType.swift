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
    case both
    case lateGame
}

// https://civilization.fandom.com/wiki/List_of_agendas_in_Civ6?so=search
// swiftlint:disable type_body_length
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
    case civilized
    case darwinist // Alexander, Gandhi, Gilgamesh, John Curtin and Teddy Roosevelt will never have this agenda.
    // No more than 3 leaders per game may have this agenda.
    case devout // Hojo Tokimune, Jadwiga and Mvemba a Nzinga will never have this agenda.
    case explorer // João III will never have this agenda.
    case intolerant // Mvemba a Nzinga and Philip II will never have this agenda. Requires religion.
    case pillager
    case turtler // Alexander will never have this agenda.

    // both
    case exploitative // Kupe, Teddy Roosevelt and Wilfrid Laurier will never have this agenda. Mutually exclusive with Environmentalist agenda.
    case greatPersonAdvocate // 20% chance for Kristina to have this agenda. Pedro II will never have this agenda.
    case heavyIndustry // Kupe will never have this agenda.
    case moneyGrubber
    case naturalist
    case paranoid // Alexander, Ambiorix, Cleopatra, Genghis Khan, Harald Hardrada, Hojo Tokimune,
    // Lady Six Sky and Shaka will never have this agenda. Mutually exclusive with Great White Fleet agenda.
    case populous // 20% chance for Gandhi to have this agenda. Eleanor of Aquitaine will never have this agenda.
    case standingArmy // Cleopatra, Hojo Tokimune, and Ambiorix will never have this agenda.
    case sycophant // 10% chance for Gorgo, Peter, and Philip II to have this agenda. Mutually exclusive with Sympathizer agenda.
    case sympathizer // 10% chance for Genghis Khan, Jadwiga, Jayavarman VII, and Lautaro to have this agenda.
    // Mutually exclusive with Sycophant agenda.
    case wonderObsessed // Qin Shi Huang will never have this agenda.

    // late game hidden agendas
    case airpower
    case environmentalist
    case cityStateAlly // Frederick Barbarossa and Pericles will never have this agenda.
    case cultured
    case demagogue
    case destinationCiv
    case ideologue
    case technophile // Peter and Seondeok will never have this agenda.

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

        // early
        .cityStateProtector,
        .cityStateProtector,
        .civilized,
        .darwinist,
        .devout,
        .explorer,
        .intolerant,
        .pillager,
        .turtler,

        // both
        .exploitative,
        .greatPersonAdvocate,
        .heavyIndustry,
        .moneyGrubber,
        .naturalist,
        .paranoid,
        .populous,
        .standingArmy,
        .sycophant,
        .sympathizer,
        .wonderObsessed,

        // late game hidden agendas
        .airpower,
        .environmentalist,
        .cityStateAlly,
        .cultured,
        .demagogue,
        .destinationCiv,
        .ideologue,
        .technophile
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

    public func exclude() -> [LeaderAgendaType] {

        return self.data().exclude
    }

    // MARK: private methods

    private struct LeaderAgendaTypeData {

        let name: String
        let effects: String
        let category: LeaderAgendaCategory
        let exclude: [LeaderAgendaType]
    }

    private func data() -> LeaderAgendaTypeData {

        switch self {

        case .none:
            return LeaderAgendaTypeData(name: "", effects: "", category: .leader, exclude: [])

            // leaders

        case .ironCrown: // Frederick Barbarossa
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_IRON_CROWN_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_IRON_CROWN_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .opportunist: // cyrus
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_OPPORTUNIST_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_OPPORTUNIST_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .optimusPrinceps: // trajan
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_OPTIMUS_PRINCEPS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_OPTIMUS_PRINCEPS_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .queenOfTheNile:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_QUEEN_OF_THE_NILE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_QUEEN_OF_THE_NILE_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .shortLifeOfGlory:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SHORT_LIFE_OF_GLORY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SHORT_LIFE_OF_GLORY_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .sunNeverSets:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SUN_NEVER_SETS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SUN_NEVER_SETS_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .tlatoani:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_TLATOANI_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_TLATOANI_EFFECTS", // #
                category: .leader,
                exclude: []
            )

        case .westernizer:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_WESTERNIZER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_WESTERNIZER_EFFECTS", // #
                category: .leader,
                exclude: []
            )

            // hidden - early

        case .cityStateProtector:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_CITY_STATE_PROTECTOR_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_CITY_STATE_PROTECTOR_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .civilized:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_CIVILIZED_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_CIVILIZED_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .darwinist: // No more than 3 leaders per game may have this agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_DARWINIST_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_DARWINIST_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .devout:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_DEVOUT_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_DEVOUT_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .explorer:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_EXPLORER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_EXPLORER_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .intolerant:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_INTOLERANT_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_INTOLERANT_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .pillager:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_PILLAGER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_PILLAGER_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

        case .turtler:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_TURTLER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_TURTLER_EFFECTS", // #
                category: .earlyGame,
                exclude: []
            )

            // hidden - both

        case .exploitative: // Mutually exclusive with Environmentalist agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_EXPLOITATIVE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_EXPLOITATIVE_EFFECTS",
                category: .both,
                exclude: [.environmentalist]
            )

        case .greatPersonAdvocate: // 20% chance for Kristina to have this agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_GREAT_PERSON_ADVOCATE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_GREAT_PERSON_ADVOCATE_EFFECTS",
                category: .both,
                exclude: []
            )

        case .heavyIndustry:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_HEAVY_INDUSTRY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_HEAVY_INDUSTRY_EFFECTS",
                category: .both,
                exclude: []
            )

        case .moneyGrubber:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_MONEY_GRUBBER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_MONEY_GRUBBER_EFFECTS",
                category: .both,
                exclude: []
            )

        case .naturalist:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_NATURALIST_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_NATURALIST_EFFECTS",
                category: .both,
                exclude: []
            )

        case .paranoid: // Mutually exclusive with Great White Fleet agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_PARANOID_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_PARANOID_EFFECTS",
                category: .both,
                exclude: []
            )

        case .populous: // 20% chance for Gandhi to have this agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_POPULOUS_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_POPULOUS_EFFECTS",
                category: .both,
                exclude: []
            )

        case .standingArmy:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_STANDING_ARMY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_STANDING_ARMY_EFFECTS",
                category: .both,
                exclude: []
            )

        case .sycophant: // Mutually exclusive with Sympathizer agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SYCOPHANT_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SYCOPHANT_EFFECTS",
                category: .both,
                exclude: [.sympathizer]
            )

        case .sympathizer: // Mutually exclusive with Sycophant agenda.
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_SYMPATHIZER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_SYMPATHIZER_EFFECTS",
                category: .both,
                exclude: [.sycophant]
            )

        case .wonderObsessed:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_WONDER_OBSESSED_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_WONDER_OBSESSED_EFFECTS",
                category: .both,
                exclude: []
            )

            // hidden - late

        case .airpower:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_AIRPOWER_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_AIRPOWER_EFFECTS",
                category: .lateGame,
                exclude: []
            )

        case .cityStateAlly:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_CITY_STATE_ALLY_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_CITY_STATE_ALLY_EFFECTS",
                category: .lateGame,
                exclude: []
            )

        case .cultured:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_CULTURED_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_CULTURED_EFFECTS",
                category: .lateGame,
                exclude: []
            )

        case .demagogue:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_DEMAGOGUE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_DEMAGOGUE_EFFECTS",
                category: .lateGame,
                exclude: []
            )

        case .destinationCiv:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_DESTINATION_CIV_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_DESTINATION_CIV_EFFECTS",
                category: .lateGame,
                exclude: []
            )

        case .environmentalist:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_ENVIRONMENTALIST_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_ENVIRONMENTALIST_EFFECTS",
                category: .lateGame,
                exclude: [.exploitative]
            )

        case .ideologue:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_IDEALOGUE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_IDEALOGUE_EFFECTS",
                category: .lateGame,
                exclude: []
            )

        case .technophile:
            return LeaderAgendaTypeData(
                name: "TXT_KEY_LEADER_AGENDA_TECHNOPHILE_NAME",
                effects: "TXT_KEY_LEADER_AGENDA_TECHNOPHILE_EFFECTS",
                category: .lateGame,
                exclude: []
            )
        }
    }
}
