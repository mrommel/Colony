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
        let sixthBonus: String

        init(name: String,
             color: TypeColor,
             firstEnvoyBonus: String,
             thirdEnvoyBonus: String,
             sixthBonus: String) {

            self.name = name
            self.color = color
            self.firstEnvoyBonus = firstEnvoyBonus
            self.thirdEnvoyBonus = thirdEnvoyBonus
            self.sixthBonus = sixthBonus
        }
    }

    private func data() -> CityStateCategoryData {

        switch self {

        case .cultural:
            return CityStateCategoryData(
                name: "cultural",
                color: .magenta,
                firstEnvoyBonus: "+2 [Culture] Culture in the [Capital] Capital.",
                thirdEnvoyBonus: "+2 [Culture] Culture in every Amphitheater building.",
                sixthBonus: "+2 [Culture] Culture in every Art Museum and Archaeological Museum building."
            )

        case .industrial:
            return CityStateCategoryData(
                name: "Industrial",
                color: .orange,
                firstEnvoyBonus: "+2 [Production] Production in the [Capital] Capital when producing wonders, buildings, and districts.",
                thirdEnvoyBonus: "+2 [Production] Production in every city with a Workshop building when producing wonders, buildings, and districts.",
                sixthBonus: "+2 [Production] Production in every city with a Factory building when producing wonders, buildings, and districts."
            )

        case .militaristic:
            return CityStateCategoryData(
                name: "Militaristic",
                color: .yellow,
                firstEnvoyBonus: "+2 [Production] Production in the [Capital] Capital when producing units.",
                thirdEnvoyBonus: "+2 [Production] Production in every Barracks or Stable building when producing units.",
                sixthBonus: "+2 [Production] Production in every Armory building when producing units."
            )

        case .religious:
            return CityStateCategoryData(
                name: "Religious",
                color: .white,
                firstEnvoyBonus: "+2 [Faith] Faith in the [Capital] Capital.",
                thirdEnvoyBonus: "+2 [Faith] Faith in every Shrine building.",
                sixthBonus: "+2 [Faith] Faith in every Temple building."
            )

        case .scientific:
            return CityStateCategoryData(
                name: "Ccientific",
                color: .blue,
                firstEnvoyBonus: "+2 [Science] Science in the [Capital] Capital.",
                thirdEnvoyBonus: "+2 [Science] Science in every Library building.",
                sixthBonus: "+2 [Science] Science in every University building."
            )

        case .trade:
            return CityStateCategoryData(
                name: "Trade",
                color: .red,
                firstEnvoyBonus: "+4 [Gold] Gold in the [Capital] Capital",
                thirdEnvoyBonus: "+4 [Gold] Gold in every Commercial Hub district",
                sixthBonus: "Additional +4 [Gold] Gold in every Commercial Hub district"
            )
        }
    }
}

public enum CityStateType {

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
                name: "Bologna",
                categroy: .scientific,
                suzarinBonus: "Your districts with a building provide +1 [GreatPerson] Great Person point of their type ([GreatWriter] Great Writer, [GreatArtist] Great Artist, and [GreatMusician] Great Musician for Theater Square districts with a building)."
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
