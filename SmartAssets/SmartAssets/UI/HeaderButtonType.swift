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

    public func name() -> String {

        switch self {

        case .science:
            return "Science"
        case .culture:
            return "Culture"
        case .government:
            return "Government"
        case .religion:
            return "Religion"
        case .greatPeople:
            return "Great People"
        case .log:
            return "Log"
        case .governors:
            return "Governors"
        case .ranking:
            return "Ranking"
        case .tradeRoutes:
            return "Trade Routes"
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
        }
    }
}
