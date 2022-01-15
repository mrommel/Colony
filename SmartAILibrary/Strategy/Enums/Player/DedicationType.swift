//
//  DedicationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum DedicationType: Int, Codable, Equatable {

    case none

    // normal, golden
    case monumentality // #, #
    case penBrushAndVoice // #, #
    case freeInquiry // #, #
    case exodusOfTheEvangelists // #, #
    case hicSuntDracones // #, #
    case reformTheCoinage // #, #
    case heartbeatOfSteam // #, #
    case toArms // #, #
    case wishYouWereHere // #, #
    case bodyguardOfLies // #, #
    case skyAndStars // #, #
    case automatonWarfare // #, #

    public static var all: [DedicationType] = [

        .monumentality,
        .penBrushAndVoice,
        .freeInquiry,
        .exodusOfTheEvangelists,
        .hicSuntDracones,
        .reformTheCoinage,
        .heartbeatOfSteam,
        .toArms,
        .wishYouWereHere,
        .bodyguardOfLies,
        .skyAndStars,
        .automatonWarfare
    ]

    // MARK: public methods

    public func name() -> String {

        return self.data().name
    }

    public func normalEffect() -> String {

        return self.data().normalEffect
    }

    public func goldenEffect() -> String {

        return self.data().goldenEffect
    }

    public func eras() -> [EraType] {

        return self.data().eras
    }

    // MARK: private methods

    private struct DedicationTypeData {

        let name: String
        let normalEffect: String
        let goldenEffect: String
        let eras: [EraType]
    }

    private func data() -> DedicationTypeData {

        switch self {

        case .none:
            return DedicationTypeData(
                name: "",
                normalEffect: "",
                goldenEffect: "",
                eras: []
            )

        case .monumentality:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_MONUMENTALITY_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_MONUMENTALITY_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_MONUMENTALITY_GOLDEN_EFFECT",
                eras: [.classical, .medieval, .renaissance]
            )

        case .penBrushAndVoice:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_PEN_BRUSH_VOICE_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_PEN_BRUSH_VOICE_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_PEN_BRUSH_VOICE_GOLDEN_EFFECT",
                eras: [.classical, .medieval]
            )

        case .freeInquiry:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_FREE_INQUIRY_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_FREE_INQUIRY_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_FREE_INQUIRY_GOLDEN_EFFECT",
                eras: [.classical, .medieval]
            )

        case .exodusOfTheEvangelists:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_EXODUS_EVANGELISTS_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_EXODUS_EVANGELISTS_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_EXODUS_EVANGELISTS_GOLDEN_EFFECT",
                eras: [.classical, .medieval, .renaissance]
            )

        case .hicSuntDracones:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_DRACONES_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_DRACONES_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_DRACONES_GOLDEN_EFFECT",
                eras: [.renaissance, .industrial, .modern]
            )

        case .reformTheCoinage:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_REFORM_COINAGE_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_REFORM_COINAGE_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_REFORM_COINAGE_GOLDEN_EFFECT",
                eras: [.renaissance, .industrial, .modern]
            )

        case .heartbeatOfSteam:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_HEARTBEAT_STEAM_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_HEARTBEAT_STEAM_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_HEARTBEAT_STEAM_GOLDEN_EFFECT",
                eras: [.industrial, .modern]
            )

        case .toArms:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_ARMS_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_ARMS_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_ARMS_GOLDEN_EFFECT",
                eras: [.industrial, .modern, .atomic, .information]
            )

        case .wishYouWereHere:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_WISH_HERE_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_WISH_HERE_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_WISH_HERE_GOLDEN_EFFECT",
                eras: [.atomic, .information]
            )

        case .bodyguardOfLies:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_BODYGUARD_LIES_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_BODYGUARD_LIES_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_BODYGUARD_LIES_GOLDEN_EFFECT",
                eras: [.atomic, .information]
            )

        case .skyAndStars:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_SKY_STARS_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_SKY_STARS_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_SKY_STARS_GOLDEN_EFFECT",
                eras: [.atomic, .information]
            )

        case .automatonWarfare:
            return DedicationTypeData(
                name: "TXT_KEY_DEDICATION_AUTOMATON_WARFARE_TITLE",
                normalEffect: "TXT_KEY_DEDICATION_AUTOMATON_NORMAL_EFFECT",
                goldenEffect: "TXT_KEY_DEDICATION_AUTOMATON_GOLDEN_EFFECT",
                eras: [.information]
            )
        }
    }
}
