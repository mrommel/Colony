//
//  ApproachModifierType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum ApproachModifierType: Int, Codable {

    // normal
    case delegation // STANDARD_DIPLOMATIC_DELEGATION
    case embassy // STANDARD_DIPLOMACY_RESIDENT_EMBASSY
    case declaredFriend // STANDARD_DIPLOMATIC_DECLARED_FRIEND
    case denounced // STANDARD_DIPLOMATIC_DENOUNCED
    case firstImpression // STANDARD_DIPLOMACY_RANDOM ??
    case establishedTradeRoute // STANDARD_DIPLOMACY_TRADE_RELATIONS
    case nearBorder // STANDARD_DIPLOMATIC_NEAR_BORDER_WARNING

    // hidden agendas
    // https://github.com/Swiftwork/civ6-explorer/blob/dbe3ca6d5468828ef0b26ef28f69555de0bcb959/src/assets/game/BaseGame/Leaders.xml

    // MARK: public methods

    public func summary() -> String {

        return self.data().summary
    }

    public func initialValue() -> Int {

        return self.data().initialValue
    }

    public func reductionTurns() -> Int {

        return self.data().reductionTurns
    }

    public func reductionValue() -> Int {

        return self.data().reductionValue
    }

    // MARK: private methods

    private class ApproachModifierTypeData {

        let summary: String
        let initialValue: Int
        let reductionTurns: Int // how many turns is it active
        let reductionValue: Int // decay value to be substracted
        let hiddenAgenda: LeaderAgendaType? // for effect of hidden agenda

        init(summary: String, initialValue: Int, reductionTurns: Int, reductionValue: Int, hiddenAgenda: LeaderAgendaType?) {

            self.summary = summary
            self.initialValue = initialValue
            self.reductionTurns = reductionTurns
            self.reductionValue = reductionValue
            self.hiddenAgenda = hiddenAgenda
        }
    }

    private func data() -> ApproachModifierTypeData {

        switch self {

        case .delegation:
            return ApproachModifierTypeData(
                summary: "LOC_DIPLO_MODIFIER_DELEGATION",
                initialValue: 3,
                reductionTurns: -1,
                reductionValue: 0,
                hiddenAgenda: nil
            )

        case .embassy:
            return ApproachModifierTypeData(
                summary: "LOC_DIPLO_MODIFIER_RESIDENT_EMBASSY",
                initialValue: 5,
                reductionTurns: -1,
                reductionValue: 0,
                hiddenAgenda: nil
            )

        case .declaredFriend:
            return ApproachModifierTypeData(
                summary: "LOC_DIPLO_MODIFIER_DECLARED_FRIEND",
                initialValue: -9,
                reductionTurns: 10,
                reductionValue: -1,
                hiddenAgenda: nil
            )

        case .denounced:
            return ApproachModifierTypeData(
                summary: "LOC_DIPLO_MODIFIER_DENOUNCED",
                initialValue: -9,
                reductionTurns: 10,
                reductionValue: -1,
                hiddenAgenda: nil
            )

        case .firstImpression:
            return ApproachModifierTypeData(
                summary: "First impressions of you",
                initialValue: 0, // overriden
                reductionTurns: 10,
                reductionValue: -1, // overriden
                hiddenAgenda: nil
            )

        case .establishedTradeRoute:
            return ApproachModifierTypeData(
                summary: "Trade Route between our nations",
                initialValue: 2,
                reductionTurns: 1,
                reductionValue: -1,
                hiddenAgenda: nil
            )

        case .nearBorder:
            return ApproachModifierTypeData(
                summary: "LOC_DIPLO_MODIFIER_NEAR_BORDER_WARNING",
                initialValue: -2,
                reductionTurns: 20,
                reductionValue: -1,
                hiddenAgenda: nil
            )
        }
    }
}
