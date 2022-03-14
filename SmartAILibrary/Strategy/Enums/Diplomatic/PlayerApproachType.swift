//
//  PlayerApproachType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

/* civ6
 <Row StateType="DIPLO_STATE_ALLIED" Name="LOC_DIPLO_STATE_ALLIED_NAME" DiplomaticYieldBonus="50" RelationshipLevel="100"/>
 <Row StateType="DIPLO_STATE_DECLARED_FRIEND" Name="LOC_DIPLO_STATE_DECLARED_FRIEND_NAME" DiplomaticYieldBonus="25" RelationshipLevel="83"/>
 <Row StateType="DIPLO_STATE_FRIENDLY" Name="LOC_DIPLO_STATE_FRIENDLY_NAME" DiplomaticYieldBonus="25" RelationshipLevel="66"/>
 <Row StateType="DIPLO_STATE_NEUTRAL" Name="LOC_DIPLO_STATE_NEUTRAL_NAME" RelationshipLevel="50"/>
 <Row StateType="DIPLO_STATE_UNFRIENDLY" Name="LOC_DIPLO_STATE_UNFRIENDLY_NAME" DiplomaticYieldBonus="-25" RelationshipLevel="33"/>
 <Row StateType="DIPLO_STATE_DENOUNCED" Name="LOC_DIPLO_STATE_DENOUNCED_NAME" DiplomaticYieldBonus="-75" RelationshipLevel="16"/>
 <Row StateType="DIPLO_STATE_WAR" Name="LOC_DIPLO_STATE_WAR_NAME" DiplomaticYieldBonus="-100" RelationshipLevel="0"/>
 */
public enum PlayerApproachType: Int, Codable {

    case none

    case war
    case denounced
    case unfriendly
    case neutral
    case friendly
    case declaredFriend
    case allied

    public static var all: [PlayerApproachType] {
        return [
            .war, .denounced, .unfriendly, .neutral, .friendly, .declaredFriend, .allied
        ]
    }

    public func level() -> Int {

        switch self {

        case .none: return 50

        case .war: return 0
        case .denounced: return 16
        case .unfriendly: return 33
        case .neutral: return 50
        case .friendly: return 66
        case .declaredFriend: return 83
        case .allied: return 100
        }
    }

    public static func from(level: Int) -> PlayerApproachType {

        if level > 91 {
            return .allied
        } else if level > 74 {
            return .declaredFriend
        } else if level > 58 {
            return .friendly
        } else if level > 41 {
            return .neutral
        } else if level > 24 {
            return .unfriendly
        } else if level > 8 {
            return .denounced
        } else {
            return .war
        }
    }
}
