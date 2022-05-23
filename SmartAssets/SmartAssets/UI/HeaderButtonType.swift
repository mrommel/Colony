//
//  HeaderButtonType.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.09.21.
//

import Foundation

public enum HeaderButtonType: CaseIterable {

    case science
    case culture
    case government
    case religion
    case greatPeople
    case moments
    case governors

    case ranking
    case cityStates
    case tradeRoutes
    case eraProgress

    public func name() -> String {

        switch self {

        case .science: return "TXT_KEY_HEADER_SCIENCE"
        case .culture: return "TXT_KEY_HEADER_CULTURE"
        case .government: return "TXT_KEY_HEADER_GOVERNMENT"
        case .religion: return "TXT_KEY_HEADER_RELIGION"
        case .greatPeople: return "TXT_KEY_HEADER_GREAT_PEOPLE"
        case .moments: return "TXT_KEY_HEADER_MOMENTS"
        case .governors: return "TXT_KEY_HEADER_GOVERNORS"

        case .ranking: return "TXT_KEY_HEADER_RANKING"
        case .cityStates: return "TXT_KEY_HEADER_CITY_STATES"
        case .tradeRoutes: return "TXT_KEY_HEADER_TRADE_ROUTES"
        case .eraProgress: return "TXT_KEY_HEADER_ERA_PROGRESS"
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .science: return "header-button-science"
        case .culture: return "header-button-culture"
        case .government: return "header-button-government"
        case .religion: return "header-button-religion"
        case .greatPeople: return "header-button-greatPeople"
        case .moments: return "header-button-moments"
        case .governors: return "header-button-governors"

        case .ranking: return "header-button-ranking"
        case .cityStates: return "header-button-cityStates"
        case .tradeRoutes: return "header-button-tradeRoutes"
        case .eraProgress: return "header-button-eraProgress"
        }
    }
}
