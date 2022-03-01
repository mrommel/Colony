//
//  CityStateTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 28.02.22.
//

import SmartAILibrary

extension CityStateType {

    public func iconTexture() -> String {

        switch self.category() {

        case .cultural: return "cityStateCategory-cultural"
        case .industrial: return "cityStateCategory-industrial"
        case .militaristic: return "cityStateCategory-militaristic"
        case .religious: return "cityStateCategory-religious"
        case .scientific: return "cityStateCategory-scientific"
        case .trade: return "cityStateCategory-trade"
        }
    }

    public func bonusTexture(active: Bool = true) -> String {

        switch self.category() {

        case .cultural: return active ? "suzerain-cultural" : "suzerain-cultural-disabled"
        case .industrial: return active ? "suzerain-industrial" : "suzerain-industrial-disabled"
        case .militaristic: return active ? "suzerain-militaristic" : "suzerain-militaristic-disabled"
        case .religious: return active ? "suzerain-religious" : "suzerain-religious-disabled"
        case .scientific: return active ? "suzerain-scientific" : "suzerain-scientific-disabled"
        case .trade: return active ? "suzerain-trade" : "suzerain-trade-disabled"
        }
    }

    public func suzerainTexture(active: Bool = true) -> String {

        if active {
            return "suzerain-inactive"
        }

        switch self.category() {

        case .cultural: return "suzerain-cultural"
        case .industrial: return "suzerain-industrial"
        case .militaristic: return "suzerain-militaristic"
        case .religious: return "suzerain-religious"
        case .scientific: return "suzerain-scientific"
        case .trade: return "suzerain-trade"
        }
    }
}
