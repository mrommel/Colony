//
//  CivilizationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivilizationType: String, Codable {

    case barbarian

    case greek
    case roman
    case english
    case aztecs
    case persian
    case french
    case egyptian
    case german
    case russian

    case unmet // just for display

    // ///////////////////////////

    public static var all: [CivilizationType] = [

        .greek,
        .roman,
        .english,
        .aztecs,
        .persian,
        .french,
        .egyptian,
        .german,
        .russian
    ]

    // ///////////////////////////

    public func name() -> String {

        return self.data().name
    }

    func isPlural() -> Bool {

        return self.data().plural
    }

    public func ability() -> CivilizationAbility {

        return self.data().ability
    }

    func cityNames() -> [String] {

        return self.data().cityNames
    }

    // https://civilization.fandom.com/wiki/Starting_bias_(Civ5)
    func startingBias(for tile: AbstractTile?, in mapModel: MapModel?) -> Int {

        guard let mapModel = mapModel else {
            fatalError("cant get mapModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        switch self {

        case .barbarian: return 0

        case .greek: return 0 // no special bias
        case .roman: return 0 // no special bias
        case .english: return mapModel.isCoastal(at: tile.point) ? 2 : 0
        case .aztecs: return tile.feature() == .rainforest ? 2 : 0
        case .french: return 0 // no special bias
        case .persian: return 0 // no special bias
        case .egyptian: return tile.feature() == .forest || tile.feature() == .rainforest ? -2 : 0
        case .german: return 0 // no special bias
        case .russian: return tile.terrain() == .tundra ? 2 : 0

        case .unmet: return 0
        }
    }

    // MARK: private functions

    private struct CivilizationAbilityData {

        let name: String
        let effect: String
    }

    private struct CivilizationTypeData {

        let name: String
        let plural: Bool
        let ability: CivilizationAbility
        let cityNames: [String]
    }

    // swiftlint:disable line_length
    private func data() -> CivilizationTypeData {

        // french cities taken from here: https://civilization.fandom.com/wiki/French_cities_(Civ6)
        // return ["Paris", "Orleans", "Lyon", "Troyes", "Tours", "Marseille", "Chartres", "Avignon", "Rouen", "Grenoble"]
        // spanish cities taken from here: https://civilization.fandom.com/wiki/Spanish_cities_(Civ6)
        // return ["Madrid", "Barcelona", "Seville", "Cordoba", "Toledo", "Santiago", "Salamanca", "Murcia", "Valencia", "Zaragoza"]

        switch self {

        case .barbarian:
            return CivilizationTypeData(
                name: "Barbarians",
                plural: true,
                ability: .none,
                cityNames: []
            )

        case .greek:
            // https://civilization.fandom.com/wiki/Greek_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Greek_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_GREEK",
                plural: true,
                ability: .platosRepublic,
                cityNames: [
                    "TXT_KEY_CITY_NAME_ATHENS",
                    "TXT_KEY_CITY_NAME_SPARTA",
                    "TXT_KEY_CITY_NAME_CORINTH",
                    "TXT_KEY_CITY_NAME_EPHESUS",
                    "TXT_KEY_CITY_NAME_ARGOS",
                    "TXT_KEY_CITY_NAME_KNOSSOS",
                    "TXT_KEY_CITY_NAME_MYCENAE",
                    "TXT_KEY_CITY_NAME_PHARSALOS",
                    "TXT_KEY_CITY_NAME_RHODES",
                    "TXT_KEY_CITY_NAME_OLYMPIA",
                    "TXT_KEY_CITY_NAME_ERETRIA",
                    "TXT_KEY_CITY_NAME_PERGAMON",
                    "TXT_KEY_CITY_NAME_MILETOS",
                    "TXT_KEY_CITY_NAME_MEGARA",
                    "TXT_KEY_CITY_NAME_PHOCAEA",
                    "TXT_KEY_CITY_NAME_DELPHI",
                    "TXT_KEY_CITY_NAME_MARATHON",
                    "TXT_KEY_CITY_NAME_PATRAS"
                ]
            )
        case .roman:
            // https://civilization.fandom.com/wiki/Roman_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Roman_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_ROMAN",
                plural: true,
                ability: .allRoadsLeadToRome,
                cityNames: [
                    "TXT_KEY_CITY_NAME_ROME",
                    "TXT_KEY_CITY_NAME_OSTIA",
                    "TXT_KEY_CITY_NAME_ANTIUM",
                    "TXT_KEY_CITY_NAME_CUMAE",
                    "TXT_KEY_CITY_NAME_AQUILEIA",
                    "TXT_KEY_CITY_NAME_RAVENNA",
                    "TXT_KEY_CITY_NAME_PUTEOLI",
                    "TXT_KEY_CITY_NAME_ARRETIUM",
                    "TXT_KEY_CITY_NAME_MEDIOLANUM",
                    "TXT_KEY_CITY_NAME_LUGDUNUM",
                    "TXT_KEY_CITY_NAME_ARPINUM",
                    "TXT_KEY_CITY_NAME_SETIA",
                    "TXT_KEY_CITY_NAME_VELITRAE",
                    "TXT_KEY_CITY_NAME_DUROCORTORUM",
                    "TXT_KEY_CITY_NAME_BRUNDISIUM",
                    "TXT_KEY_CITY_NAME_CAESARAUGUSTA",
                    "TXT_KEY_CITY_NAME_PALMYRA",
                    "TXT_KEY_CITY_NAME_HISPALIS",
                    "TXT_KEY_CITY_NAME_CAESAREA",
                    "TXT_KEY_CITY_NAME_ARTAXATA",
                    "TXT_KEY_CITY_NAME_PAPHOS",
                    "TXT_KEY_CITY_NAME_SALONAE",
                    "TXT_KEY_CITY_NAME_EBURACUM",
                    "TXT_KEY_CITY_NAME_LAURIACUM",
                    "TXT_KEY_CITY_NAME_VERONA",
                    "TXT_KEY_CITY_NAME_COLONIA_AGRIPPINA",
                    "TXT_KEY_CITY_NAME_NARBO",
                    "TXT_KEY_CITY_NAME_TINGI",
                    "TXT_KEY_CITY_NAME_SARMIZEGETUSA",
                    "TXT_KEY_CITY_NAME_SIRMIUM"
                ]
            )
        case .english:
            // cities taken from here: https://civilization.fandom.com/wiki/English_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_ENGLISH",
                plural: true,
                ability: .workshopOfTheWorld,
                cityNames: [
                    "TXT_KEY_CITY_NAME_LONDON",
                    "TXT_KEY_CITY_NAME_LIVERPOOL",
                    "TXT_KEY_CITY_NAME_MANCHESTER",
                    "TXT_KEY_CITY_NAME_BIRMINGHAM",
                    "TXT_KEY_CITY_NAME_LEEDS",
                    "TXT_KEY_CITY_NAME_SHEFFIELD",
                    "TXT_KEY_CITY_NAME_BRISTOL",
                    "TXT_KEY_CITY_NAME_PLYMOUTH",
                    "TXT_KEY_CITY_NAME_NEWCASTLE_UPON_TYNE",
                    "TXT_KEY_CITY_NAME_BRADFORD",
                    "TXT_KEY_CITY_NAME_STOKE_UPON_TRENT",
                    "TXT_KEY_CITY_NAME_HULL",
                    "TXT_KEY_CITY_NAME_PORTSMOUTH",
                    "TXT_KEY_CITY_NAME_PRESTON",
                    "TXT_KEY_CITY_NAME_SUNDERLAND",
                    "TXT_KEY_CITY_NAME_BRIGHTON",
                    "TXT_KEY_CITY_NAME_NORWICH",
                    "TXT_KEY_CITY_NAME_YORK",
                    "TXT_KEY_CITY_NAME_NOTTINGHAM",
                    "TXT_KEY_CITY_NAME_LEICESTER",
                    "TXT_KEY_CITY_NAME_BLACKBURN",
                    "TXT_KEY_CITY_NAME_WOLVERHAMPTON",
                    "TXT_KEY_CITY_NAME_BATH",
                    "TXT_KEY_CITY_NAME_CONVENTRY",
                    "TXT_KEY_CITY_NAME_EXETER",
                    "TXT_KEY_CITY_NAME_LINCOLN",
                    "TXT_KEY_CITY_NAME_CANTERBURY",
                    "TXT_KEY_CITY_NAME_IPSWICH",
                    "TXT_KEY_CITY_NAME_DOVER",
                    "TXT_KEY_CITY_NAME_HASTINGS",
                    "TXT_KEY_CITY_NAME_OXFORD",
                    "TXT_KEY_CITY_NAME_SHREWSBURY",
                    "TXT_KEY_CITY_NAME_CAMBRIDGE",
                    "TXT_KEY_CITY_NAME_NEWCASTLE",
                    "TXT_KEY_CITY_NAME_WARWICK"
                ]
            )
        case .aztecs:
            // cities taken from here: https://civilization.fandom.com/wiki/Aztec_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_AZTECS",
                plural: true,
                ability: .legendOfTheFiveSuns,
                cityNames: [
                    "TXT_KEY_CITY_NAME_TENOCHTITLAN",
                    "TXT_KEY_CITY_NAME_TEXCOCO",
                    "TXT_KEY_CITY_NAME_ATZCAPOTZALCO",
                    "TXT_KEY_CITY_NAME_TEOTIHUACAN",
                    "TXT_KEY_CITY_NAME_TLACOPAN",
                    "TXT_KEY_CITY_NAME_XOCHICALCO",
                    "TXT_KEY_CITY_NAME_MALINALCO",
                    "TXT_KEY_CITY_NAME_TEAYO",
                    "TXT_KEY_CITY_NAME_CEMPOALA",
                    "TXT_KEY_CITY_NAME_CHALCO",
                    "TXT_KEY_CITY_NAME_IXTAPALUCA",
                    "TXT_KEY_CITY_NAME_TENAYUCA",
                    "TXT_KEY_CITY_NAME_HUEXOTLA",
                    "TXT_KEY_CITY_NAME_CHAPULTEPEC",
                    "TXT_KEY_CITY_NAME_TEPEXPAN",
                    "TXT_KEY_CITY_NAME_ZITLALTEPEC",
                    "TXT_KEY_CITY_NAME_XALAPA",
                    "TXT_KEY_CITY_NAME_TAMUIN",
                    "TXT_KEY_CITY_NAME_TELOLOAPAN"
                ]
            )
        case .persian:
            // https://civilization.fandom.com/wiki/Persian_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Persian_cities_(Civ6)
            return CivilizationTypeData(name: "Persians",
                                        plural: true,
                                        ability: .satrapies,
                                        cityNames: ["Pasargadae", "Susa", "Hagmatana", "Tarsus", "Bakhtri", "Sparda", "Gordian", "Tushpa", "Ray", "Zranka"])
        case .french:
            // https://civilization.fandom.com/wiki/French_(Civ6)
            // cities taken from here:  https://civilization.fandom.com/wiki/French_cities_(Civ6)
            return CivilizationTypeData(name: "French",
                                        plural: true,
                                        ability: .grandTour,
                                        cityNames: ["Paris", "Alba-La-Romaine", "Amboise", "Amiens", "Avignon", "Briançon", "Blois", "Bordeaux", "Boulogne", "Calais", "Carcassonne", "Chartres", "Dieppe", "Dijon", "Grenoble", "La Rochelle", "Limoges", "Lyon", "Marseille"])
        case .egyptian:
            // https://civilization.fandom.com/wiki/Egyptian_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Egyptian_cities_(Civ6)
            return CivilizationTypeData(name: "Egyptian",
                                        plural: true,
                                        ability: .iteru,
                                        cityNames: ["Râ-Kedet", "Thebes", "Memphis", "Akhetaten", "Shedet", "Swenett", "Nekhen", "Abydos", "Apu", "Edfu", "Mendes", "Cyrene", "Giza", "Oryx", "Arsinoe", "Karnak"])
        case .german:
            // https://civilization.fandom.com/wiki/German_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/German_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_GERMAN",
                plural: true,
                ability: .freeImperialCities,
                cityNames: [
                    "TXT_KEY_CITY_NAME_AACHEN",
                    "TXT_KEY_CITY_NAME_COLOGNE",
                    "TXT_KEY_CITY_NAME_FRANKFURT",
                    "TXT_KEY_CITY_NAME_MAGDEBURG",
                    "TXT_KEY_CITY_NAME_MAINZ",
                    "TXT_KEY_CITY_NAME_HEIDELBERG",
                    "TXT_KEY_CITY_NAME_TRIER",
                    "TXT_KEY_CITY_NAME_BERLIN",
                    "TXT_KEY_CITY_NAME_ULM",
                    "TXT_KEY_CITY_NAME_HAMBURG",
                    "TXT_KEY_CITY_NAME_DORTMUND",
                    "TXT_KEY_CITY_NAME_NUREMBERG",
                    "TXT_KEY_CITY_NAME_BREMEN",
                    "TXT_KEY_CITY_NAME_AUGSBURG",
                    "TXT_KEY_CITY_NAME_MUNSTER",
                    "TXT_KEY_CITY_NAME_REGENSBURG",
                    "TXT_KEY_CITY_NAME_ERFURT",
                    "TXT_KEY_CITY_NAME_LUBECK",
                    "TXT_KEY_CITY_NAME_FREIBURG",
                    "TXT_KEY_CITY_NAME_WURZBURG",
                    "TXT_KEY_CITY_NAME_HANOVER",
                    "TXT_KEY_CITY_NAME_ROSTOCK",
                    "TXT_KEY_CITY_NAME_MUNICH",
                    "TXT_KEY_CITY_NAME_SCHWERIN",
                    "TXT_KEY_CITY_NAME_LEIPZIG",
                    "TXT_KEY_CITY_NAME_BONN",
                    "TXT_KEY_CITY_NAME_ESSEN",
                    "TXT_KEY_CITY_NAME_STUTTGART",
                    "TXT_KEY_CITY_NAME_DRESDEN",
                    "TXT_KEY_CITY_NAME_DUSSELDORF",
                    "TXT_KEY_CITY_NAME_WORMS",
                    "TXT_KEY_CITY_NAME_POTSDAM"
                ]
            )
        case .russian:
            // cities taken from here: https://civilization.fandom.com/wiki/Russian_cities_(Civ6)
            return CivilizationTypeData(name: "Russian",
                                        plural: true,
                                        ability: .motherRussia,
                                        cityNames: ["St. Petersburg", "Moscow", "Novgorod", "Kazan", "Astrakhan", "Yaroslavl", "Smolensk", "Voronezh", "Tula", "Solikamsk", "Tver", "Nizhniy Novgorod", "Arkhangelsk", "Vologda", "Olonets", "Saratov", "Tambov", "Pskov", "Krasnoyarsk"])

        case .unmet:
            return CivilizationTypeData(
                name: "Unmet",
                plural: false,
                ability: .none,
                cityNames: []
            )
        }
    }
}
