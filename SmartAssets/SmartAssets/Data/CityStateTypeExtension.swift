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
