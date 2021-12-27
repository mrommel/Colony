//
//  HeaderButtonType.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.09.21.
//

import Foundation

public enum HeaderButtonType {

    case science
    case culture
    case government
    case religion
    case greatPeople
    case log
    case governors

    case ranking
    case tradeRoutes
    case eraProgress

    public func name() -> String {

        switch self {

        case .science:
            return "TXT_KEY_HEADER_SCIENCE"
        case .culture:
            return "TXT_KEY_HEADER_CULTURE"
        case .government:
            return "TXT_KEY_HEADER_GOVERNMENT"
        case .religion:
            return "TXT_KEY_HEADER_RELIGION"
        case .greatPeople:
            return "TXT_KEY_HEADER_GREAT_PEOPLE"
        case .log:
            return "TXT_KEY_HEADER_LOG"
        case .governors:
            return "TXT_KEY_HEADER_GOVERNORS"
        case .ranking:
            return "TXT_KEY_HEADER_RANKING"
        case .tradeRoutes:
            return "TXT_KEY_HEADER_TRADE_ROUTES"
        case .eraProgress:
            return "TXT_KEY_HEADER_ERA_PROGRESS"
        }
    }

    public func iconTexture(for state: Bool) -> String {

        switch self {

        case .science:
            return state ? "header-button-science-active" : "header-button-science-disabled"
        case .culture:
            return state ? "header-button-culture-active" : "header-button-culture-disabled"
        case .government:
            return state ? "header-button-government-active" : "header-button-government-disabled"
        case .religion:
            return state ? "header-button-religion-active" : "header-button-religion-disabled"
        case .greatPeople:
            return state ? "header-button-greatPeople-active" : "header-button-greatPeople-disabled"
        case .log:
            return state ? "header-button-log-active" : "header-button-log-disabled"
        case .governors:
            return state ? "header-button-governors-active" : "header-button-governors-disabled"
        case .ranking:
            return state ?  "header-button-ranking-active" : "header-button-ranking-disabled"
        case .tradeRoutes:
            return state ? "header-button-tradeRoutes-active" : "header-button-tradeRoutes-disabled"
        case .eraProgress:
            return state ? "header-button-eraProgress-active" : "header-button-eraProgress-disabled"
        }
    }
}
