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
                color: .red,
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
                color: .yellow,
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
    case cahokia
    case cardiff
    case carthage
    case chinguetti
    case fez
    case geneva
    case granada
    case hattusa
    case hongKong
    case hunza
    case jakarta
    case jerusalem
    case johannesburg
    case kabul
    case kandy
    case kumasi
    case laVenta
    // Lahore
    // Lisbon
    // Mexico City
    // Mitla
    // Mogadishu
    // Mohenjo-Daro
    // Muscat
    // Nalanda
    // Nan Madol
    // Nazca
    // Ngazargamu
    // Palenque
    // Preslav
    // Rapa Nui
    case samarkand
    case seoul
    case singapore
    case stockholm
    case taruga
    case toronto
    case valletta
    case vaticanCity
    case venice
    case vilnius
    case wolin
    case yerevan
    case zanzibar

    public static var all: [CityStateType] = [
        .akkad, .amsterdam, .anshan, .antananarivo, .antioch, .armagh, .auckland, .ayutthaya, .babylon,
        .bandarBrunei, .bologna, .brussels, .buenosAires, .caguana, .cahokia, .cardiff, .carthage,
        .chinguetti, .fez, .geneva, .granada, .hattusa, .hongKong, .hunza, .jakarta, .jerusalem,
        .johannesburg, .kabul, .kandy, .kumasi, .laVenta,
        // ...
        .samarkand, .seoul, .singapore, .stockholm, .taruga, .toronto, .valletta, .vaticanCity, .venice,
        .vilnius, .wolin, .yerevan, .zanzibar
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

    // MARK: private methods

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
                suzarinBonus: "TXT_KEY_CITY_STATE_AKKAD_SUZARIN"
            )

        case .amsterdam:
            // https://civilization.fandom.com/wiki/Amsterdam_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AMSTERDAM_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_AMSTERDAM_SUZARIN"
            )

        case .anshan:
            // https://civilization.fandom.com/wiki/Anshan_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ANSHAN_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_ANSHAN_SUZARIN"
            )

        case .antananarivo:
            // https://civilization.fandom.com/wiki/Antananarivo_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ANTANANARIVO_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_ANTANANARIVO_SUZARIN"
            )

        case .antioch:
            // https://civilization.fandom.com/wiki/Antioch_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ANITOCH_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_ANITOCH_SUZARIN"
            )

        case .armagh:
            // https://civilization.fandom.com/wiki/Armagh_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_ARMAGH_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_ARMAGH_SUZARIN"
            )

        case .auckland:
            // https://civilization.fandom.com/wiki/Auckland_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AUCKLAND_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_AUCKLAND_SUZARIN"
            )

        case .ayutthaya:
            // https://civilization.fandom.com/wiki/Ayutthaya_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_AYUTTHAYA_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_AYUTTHAYA_SUZARIN"
            )

        case .babylon:
            // https://civilization.fandom.com/wiki/Babylon_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BABYLON_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_BABYLON_SUZARIN"
            )

        case .bandarBrunei:
            // https://civilization.fandom.com/wiki/Bandar_Brunei_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BANDAR_BRUNEI_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_BANDAR_BRUNEI_SUZARIN"
            )

        case .bologna:
            // https://civilization.fandom.com/wiki/Bologna_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BOLOGNA_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_BOLOGNA_SUZARIN"
            )

        case .brussels:
            // https://civilization.fandom.com/wiki/Brussels_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BRUSSELS_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_BRUSSELS_SUZARIN"
            )

        case .buenosAires:
            // https://civilization.fandom.com/wiki/Buenos_Aires_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_BUENOS_AIRES_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_BUENOS_AIRES_SUZARIN"
            )

        case .caguana:
            // https://civilization.fandom.com/wiki/Caguana_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_CAGUANA_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_CAGUANA_SUZARIN"
            )

        case .cahokia:
            // https://civilization.fandom.com/wiki/Cahokia_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_CAHOKIA_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_CAHOKIA_SUZARIN"
            )

        case .cardiff:
            // https://civilization.fandom.com/wiki/Cardiff_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_CARDIFF_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_CARDIFF_SUZARIN"
            )

        case .carthage:
            // https://civilization.fandom.com/wiki/Carthage_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_CARTHAGE_NAME",
                category: .militaristic,
                suzarinBonus: "TXT_KEY_CITY_STATE_CARTHAGE_SUZARIN"
            )

        case .chinguetti:
            // https://civilization.fandom.com/wiki/Chinguetti_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_CHINGUETTI_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_CHINGUETTI_SUZARIN"
            )

        case .fez:
            // https://civilization.fandom.com/wiki/Fez_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_FEZ_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_FEZ_SUZARIN"
            )

        case .geneva:
            // https://civilization.fandom.com/wiki/Geneva_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_GENEVA_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_GENEVA_SUZARIN"
            )

        case .granada:
            // https://civilization.fandom.com/wiki/Granada_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_GRANADA_NAME",
                category: .militaristic,
                suzarinBonus: "TXT_KEY_CITY_STATE_GRANADA_SUZARIN"
            )

        case .hattusa:
            // https://civilization.fandom.com/wiki/Hattusa_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_HATTUSA_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_HATTUSA_SUZARIN"
            )

        case .hongKong:
            // https://civilization.fandom.com/wiki/Hong_Kong_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_HONG_KONG_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_HONG_KONG_SUZARIN"
            )

        case .hunza:
            // https://civilization.fandom.com/wiki/Hunza_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_HUNZA_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_HUNZA_SUZARIN"
            )

        case .jakarta:
            // https://civilization.fandom.com/wiki/Jakarta_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_JARKARTA_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_JARKARTA_SUZARIN"
        )

        case .jerusalem:
            // https://civilization.fandom.com/wiki/Jerusalem_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_JERUSALEM_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_JERUSALEM_SUZARIN"
            )

        case .johannesburg:
            // https://civilization.fandom.com/wiki/Johannesburg_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_JOHANNESBURG_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_JOHANNESBURG_SUZARIN"
            )

        case .kabul:
            // https://civilization.fandom.com/wiki/Kabul_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_KABUL_NAME",
                category: .militaristic,
                suzarinBonus: "TXT_KEY_CITY_STATE_KABUL_SUZARIN"
            )

        case .kandy:
            // https://civilization.fandom.com/wiki/Kandy_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_KANDY_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_KANDY_SUZARIN"
            )

        case .kumasi:
            // https://civilization.fandom.com/wiki/Kumasi_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_KUMASI_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_KUMASI_SUZARIN"
            )

        case .laVenta:
            // https://civilization.fandom.com/wiki/La_Venta_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_LA_VENTA_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_LA_VENTA_SUZARIN"
            )

            // -------------------------

            /*
             return CityStateTypeData(
             name: <#T##String#>,
             category: <#T##CityStateCategory#>,
             suzarinBonus: <#T##String#>
             )
             */

            // -------------------------

        case .samarkand:
            // https://civilization.fandom.com/wiki/Samarkand_(Civ6)
            return CityStateTypeData(
            name: "TXT_KEY_CITY_STATE_SAMARKAND_NAME",
            category: .trade,
            suzarinBonus: "TXT_KEY_CITY_STATE_SAMARKAND_SUZARIN"
            )

        case .seoul:
            // https://civilization.fandom.com/wiki/Seoul_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_SEOUL_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_SEOUL_SUZARIN"
            )

        case .singapore:
            // https://civilization.fandom.com/wiki/Singapore_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_SINGAPORE_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_SINGAPORE_SUZARIN"
            )

        case .stockholm:
            // https://civilization.fandom.com/wiki/Stockholm_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_STOCKHOLM_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_STOCKHOLM_SUZARIN"
            )

        case .taruga:
            // https://civilization.fandom.com/wiki/Taruga_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_TARUGA_NAME",
                category: .scientific,
                suzarinBonus: "TXT_KEY_CITY_STATE_TARUGA_SUZARIN"
            )

        case .toronto:
            // https://civilization.fandom.com/wiki/Toronto_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_TORONTA_NAME",
                category: .industrial,
                suzarinBonus: "TXT_KEY_CITY_STATE_TORONTA_SUZARIN"
            )

        case .valletta:
            // https://civilization.fandom.com/wiki/Valletta_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_VALLETTA_NAME",
                category: .militaristic,
                suzarinBonus: "TXT_KEY_CITY_STATE_VALLETTA_SUZARIN"
            )

        case .vaticanCity:
            // https://civilization.fandom.com/wiki/Vatican_City_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_VATICAN_CITY_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_VATICAN_CITY_SUZARIN"
            )

        case .venice:
            // https://civilization.fandom.com/wiki/Venice_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_VENICE_NAME",
                category: .trade,
                suzarinBonus: "TXT_KEY_CITY_STATE_VENICE_SUZARIN"
            )

        case .vilnius:
            // https://civilization.fandom.com/wiki/Vilnius_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_VILNIUS_NAME",
                category: .cultural,
                suzarinBonus: "TXT_KEY_CITY_STATE_VILNIUS_SUZARIN"
            )

        case .wolin:
            // https://civilization.fandom.com/wiki/Wolin_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_WOLIN_NAME",
                category: .militaristic,
                suzarinBonus: "TXT_KEY_CITY_STATE_WOLIN_SUZARIN"
            )

        case .yerevan:
            // https://civilization.fandom.com/wiki/Yerevan_(Civ6)
            return CityStateTypeData(
                name: "TXT_KEY_CITY_STATE_YEREVAN_NAME",
                category: .religious,
                suzarinBonus: "TXT_KEY_CITY_STATE_YEREVAN_SUZARIN"
            )

        case .zanzibar:
            // https://civilization.fandom.com/wiki/Zanzibar_(Civ6)
            return CityStateTypeData(
            name: "TXT_KEY_CITY_STATE_ZANZIBAR_NAME",
            category: .trade,
            suzarinBonus: "TXT_KEY_CITY_STATE_ZANZIBAR_SUZARIN"
            )
        }
    }
}
