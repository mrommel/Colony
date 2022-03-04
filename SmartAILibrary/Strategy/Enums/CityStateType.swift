//
//  CityStateType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

#if os(macOS)
import AppKit
public typealias TypeColor = NSColor
#else
import UIKit
public typealias TypeColor = UIColor
#endif

public enum CityStateCategory {

    case cultural
    case industrial
    case militaristic
    case religious
    case scientific
    case trade

    public func name() -> String {

        return self.data().name
    }

    public func color() -> TypeColor {

        return self.data().color
    }

    public func firstEnvoyBonus() -> String {

        return self.data().firstEnvoyBonus
    }

    public func thirdEnvoyBonus() -> String {

        return self.data().thirdEnvoyBonus
    }

    public func sixthEnvoyBonus() -> String {

        return self.data().sixthEnvoyBonus
    }

    private class CityStateCategoryData {

        let name: String
        let color: TypeColor
        let firstEnvoyBonus: String
        let thirdEnvoyBonus: String
        let sixthEnvoyBonus: String

        init(name: String,
             color: TypeColor,
             firstEnvoyBonus: String,
             thirdEnvoyBonus: String,
             sixthEnvoyBonus: String) {

            self.name = name
            self.color = color
            self.firstEnvoyBonus = firstEnvoyBonus
            self.thirdEnvoyBonus = thirdEnvoyBonus
            self.sixthEnvoyBonus = sixthEnvoyBonus
        }
    }

    private func data() -> CityStateCategoryData {

        switch self {

        case .cultural:
            return CityStateCategoryData(
                name: "TXT_KEY_CITY_STATE_CATEGORY_CULTURAL_NAME",
                color: .magenta,
                firstEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_CULTURAL_FIRST_ENVOY_BONUS",
                thirdEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_CULTURAL_THIRD_ENVOY_BONUS",
                sixthEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_CULTURAL_SIXTH_ENVOY_BONUS"
            )

        case .industrial:
            return CityStateCategoryData(
                name: "TXT_KEY_CITY_STATE_CATEGORY_INDUSTRIAL_NAME",
                color: .orange,
                firstEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_INDUSTRIAL_FIRST_ENVOY_BONUS",
                thirdEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_INDUSTRIAL_THIRD_ENVOY_BONUS",
                sixthEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_INDUSTRIAL_SIXTH_ENVOY_BONUS"
            )

        case .militaristic:
            return CityStateCategoryData(
                name: "TXT_KEY_CITY_STATE_CATEGORY_MILITARISTIC_NAME",
                color: .yellow,
                firstEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_MILITARISTIC_FIRST_ENVOY_BONUS",
                thirdEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_MILITARISTIC_THIRD_ENVOY_BONUS",
                sixthEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_MILITARISTIC_SIXTH_ENVOY_BONUS"
            )

        case .religious:
            return CityStateCategoryData(
                name: "TXT_KEY_CITY_STATE_CATEGORY_RELIGIOUS_NAME",
                color: .white,
                firstEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_RELIGIOUS_FIRST_ENVOY_BONUS",
                thirdEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_RELIGIOUS_THIRD_ENVOY_BONUS",
                sixthEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_RELIGIOUS_SIXTH_ENVOY_BONUS"
            )

        case .scientific:
            return CityStateCategoryData(
                name: "TXT_KEY_CITY_STATE_CATEGORY_SCIENTIFIC_NAME",
                color: .blue,
                firstEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_SCIENTIFIC_FIRST_ENVOY_BONUS",
                thirdEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_SCIENTIFIC_THIRD_ENVOY_BONUS",
                sixthEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_SCIENTIFIC_SIXTH_ENVOY_BONUS"
            )

        case .trade:
            return CityStateCategoryData(
                name: "TXT_KEY_CITY_STATE_CATEGORY_TRADE_NAME",
                color: .red,
                firstEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_TRADE_FIRST_ENVOY_BONUS",
                thirdEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_TRADE_THIRD_ENVOY_BONUS",
                sixthEnvoyBonus: "TXT_KEY_CITY_STATE_CATEGORY_TRADE_SIXTH_ENVOY_BONUS"
            )
        }
    }
}

public enum CityStateType: String, Codable {

    case akkad
    case amsterdam
    case anshan
    case antananarivo
    case antioch
    case armagh
    case auckland
    case ayutthaya
    case babylon
    case bandarBrunei
    case bologna
    case brussels
    case buenosAires
    case caguana
    // ..
    // Carthage
    // ..
    // Geneva
    // Granada
    // Hattusa
    // Hong Kong
    // Hunza
    // Jakarta
    // Jerusalem
    // Johannesburg
    // Kabul
    // ..
    // Valletta
    // Vatican City
    // Venice
    // Vilnius
    // Wolin
    // Yerevan
    // Zanzibar

    public static var all: [CityStateType] = [
        .akkad, .amsterdam, .anshan, .antananarivo, .antioch, .armagh, .auckland, .ayutthaya, .babylon,
        .bandarBrunei, .bologna, .brussels, .buenosAires, .caguana
    ]

    public func name() -> String {

        return self.data().name
    }

    public func color() -> TypeColor {

        return self.data().category.color()
    }

    public func category() -> CityStateCategory {

        return self.data().category
    }

    public func bonus(for level: EnvoyEffectLevel) -> String {

        switch level {

        case .first: return self.category().firstEnvoyBonus()
        case .third: return self.category().thirdEnvoyBonus()
        case .sixth: return self.category().sixthEnvoyBonus()
        case .suzerain: return self.data().suzarinBonus
        }
    }

    // MARK private methods

    private class CityStateTypeData {

        let name: String
        let category: CityStateCategory
        let suzarinBonus: String

        init(name: String,
             category: CityStateCategory,
             suzarinBonus: String) {

            self.name = name
            self.category = category
            self.suzarinBonus = suzarinBonus
        }
    }

    private func data() -> CityStateTypeData {

        switch self {

        case .akkad:
            // https://civilization.fandom.com/wiki/Akkad_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AKKAD_NAME",
                category: .militaristic,
                suzarinBonus: "TXT_KEY_CITY_STATE_AKKAD_SUZARIN_BONUS"
            )

        case .amsterdam:
            // https://civilization.fandom.com/wiki/Amsterdam_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AMSTERDAM_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_AMSTERDAM_SUZARIN_BONUS"
            )

        case .anshan:
            // https://civilization.fandom.com/wiki/Anshan_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ANSHAN_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_ANSHAN_SUZARIN_BONUS"
            )

        case .antananarivo:
            // https://civilization.fandom.com/wiki/Antananarivo_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ANTANANARIVO_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_ANTANANARIVO_SUZARIN_BONUS"
            )

        case .antioch:
            // https://civilization.fandom.com/wiki/Antioch_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ANITOCH_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_ANITOCH_SUZARIN_BONUS"
            )

        case .armagh:
            // https://civilization.fandom.com/wiki/Armagh_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ARMAGH_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_ARMAGH_SUZARIN_BONUS"
            )

        case .auckland:
            // https://civilization.fandom.com/wiki/Auckland_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AUCKLAND_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_AUCKLAND_SUZARIN_BONUS"
            )

        case .ayutthaya:
            // https://civilization.fandom.com/wiki/Ayutthaya_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AYUTTHAYA_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_AYUTTHAYA_SUZARIN_BONUS"
            )

        case .babylon:
            // https://civilization.fandom.com/wiki/Babylon_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BABYLON_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_BABYLON_SUZARIN_BONUS"
            )

        case .bandarBrunei:
            // https://civilization.fandom.com/wiki/Bandar_Brunei_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BANDAR_BRUNEI_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_BANDAR_BRUNEI_SUZARIN_BONUS"
            )

        case .bologna:
            // https://civilization.fandom.com/wiki/Bologna_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BOLOGNA_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_BOLOGNA_SUZARIN_BONUS"
            )

        case .brussels:
            // https://civilization.fandom.com/wiki/Brussels_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BRUSSELS_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_BRUSSELS_SUZARIN_BONUS"
            )

        case .buenosAires:
            // https://civilization.fandom.com/wiki/Buenos_Aires_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BUENOS_AIRES_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_BUENOS_AIRES_SUZARIN_BONUS"
            )

        case .caguana:
            // https://civilization.fandom.com/wiki/Caguana_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_CAGUANA_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_CAGUANA_SUZARIN_BONUS"
            )

            /*
             return CityStateTypeData(
             name: <#T##String#>,
             category: <#T##CityStateCategory#>,
             suzarinBonus: <#T##String#>
             )
             */
        }
    }
}
