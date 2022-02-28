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

public enum CityStateType: String {

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

    // MARK private methods

    private class CityStateTypeData {

        let name: String
        let categroy: CityStateCategory
        let suzarinBonus: String

        init(name: String,
             categroy: CityStateCategory,
             suzarinBonus: String) {

            self.name = name
            self.categroy = categroy
            self.suzarinBonus = suzarinBonus
        }
    }

    private func data() -> CityStateTypeData {

        switch self {

        case .akkad:
            // https://civilization.fandom.com/wiki/Akkad_(Civ6)
            return CityStateTypeData(
                name: "Akkad",
                categroy: .militaristic,
                suzarinBonus: "Melee and anti-cavalry units' attacks do full damage to the city's walls."
            )

        case .amsterdam:
            // https://civilization.fandom.com/wiki/Amsterdam_(Civ6)
            return CityStateTypeData(
                name: "Amsterdam",
                categroy: .trade,
                suzarinBonus: "Your [TradeRoute] Trade Routes to foreign cities earn +1 [Gold] Gold for each luxury resource."
            )

        case .anshan:
            // https://civilization.fandom.com/wiki/Anshan_(Civ6)
            return CityStateTypeData(
                name: "Anshan",
                categroy: .scientific,
                suzarinBonus: "+2 [Science] Science from each [GreatWork] of Writing Great Work of Writing. +1 [Science] Science from each [Relic] Relic and [Artifact] Artifact."
            )

        case .antananarivo:
            // https://civilization.fandom.com/wiki/Antananarivo_(Civ6)
            return CityStateTypeData(
                name: "Antananarivo",
                categroy: .cultural,
                suzarinBonus: "Your Civilization gains +2% [Culture] Culture for each [GreatPerson] Great Person it has ever earned (up to 30%)."
            )

        case .antioch:
            // https://civilization.fandom.com/wiki/Antioch_(Civ6)
            return CityStateTypeData(
                name: "Antioch",
                categroy: .trade,
                suzarinBonus: "Your [TradeRoute] Trade Routes to foreign cities earn +1 [Gold] Gold for each Luxury resource at the destination."
            )

        case .armagh:
            // https://civilization.fandom.com/wiki/Armagh_(Civ6)
            return CityStateTypeData(
                name: "Armagh",
                categroy: .religious,
                suzarinBonus: "Your Builders can build Monastery improvements."
            )

        case .auckland:
            // https://civilization.fandom.com/wiki/Auckland_(Civ6)
            return CityStateTypeData(
                name: "Auckland",
                categroy: .industrial,
                suzarinBonus: "Shallow water tiles worked by [Citizen] Citizens provide +1 [Production] Production. Additional +1 when you reach the Industrial Era"
            )

        case .ayutthaya:
            // https://civilization.fandom.com/wiki/Ayutthaya_(Civ6)
            return CityStateTypeData(
                name: "Ayutthaya",
                categroy: .cultural,
                suzarinBonus: "Gain [Culture] Culture equal to 10% of the construction cost when finishing buildings."
            )

        case .babylon:
            // https://civilization.fandom.com/wiki/Babylon_(Civ6)
            return CityStateTypeData(
                name: "Babylon",
                categroy: .scientific,
                suzarinBonus: "+2 [Science] Science from each [GreatWork] of Writing Great Work of Writing. +1 [Science] Science from each [Relic] Relic and [Artifact] Artifact."
            )

        case .bandarBrunei:
            // https://civilization.fandom.com/wiki/Bandar_Brunei_(Civ6)
            return CityStateTypeData(
                name: "Bandar Brunei",
                categroy: .trade,
                suzarinBonus: "Your [TradingPost] Trading Posts in foreign cities provide +1 [Gold] Gold to your [TradeRoute] Trade Routes passing through or going to the city."
            )

        case .bologna:
            // https://civilization.fandom.com/wiki/Bologna_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BOLOGNA_NAME",
                categroy: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_BOLOGNA_SUZARIN_BONUS"
            )

        case .brussels:
            // https://civilization.fandom.com/wiki/Brussels_(Civ6)
            return CityStateTypeData(
                name: "Brussels",
                categroy: .industrial,
                suzarinBonus: "Your cities get +15% [Production] Production towards wonders."
            )

        case .buenosAires:
            // https://civilization.fandom.com/wiki/Buenos_Aires_(Civ6)
            return CityStateTypeData(
                name: "Buenos Aires",
                categroy: .industrial,
                suzarinBonus: "Your Bonus resources behave like Luxury resources, providing 1 [Amenity] Amenity per type."
            )

        case .caguana:
            // https://civilization.fandom.com/wiki/Caguana_(Civ6)
            return CityStateTypeData(
                name: "Caguana",
                categroy: .cultural,
                suzarinBonus: "Builders can construct the Batey improvement, which provides [Culture] Culture and [Tourism] Tourism."
            )

            /*
             return CityStateTypeData(
             name: <#T##String#>,
             categroy: <#T##CityStateCategory#>,
             suzarinBonus: <#T##String#>
             )
             */
        }
    }
}
