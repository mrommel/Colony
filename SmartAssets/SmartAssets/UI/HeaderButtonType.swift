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
    case log

    case ranking
    case tradeRoutes

    public func iconTexture(for state: Bool) -> String {

        switch self {

        case .science:
            return state ? "header-button-science-active" : "header-button-science-disabled"
        case .culture:
            return state ? "header-button-culture-active" : "header-button-culture-disabled"
        case .government:
            return state ? "header-button-government-active" : "header-button-government-disabled"
        case .log:
            return state ? "header-button-log-active" : "header-button-log-disabled"
        case .ranking:
            return state ? "header-button-log-active" : "header-button-log-disabled"
        case .tradeRoutes:
            return state ? "header-button-tradeRoutes-active" : "header-button-tradeRoutes-disabled"
        }
    }
}
