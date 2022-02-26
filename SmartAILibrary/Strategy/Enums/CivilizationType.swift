//
//  CivilizationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable type_body_length
public enum CivilizationType: String, Codable {

    case barbarian
    case free

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
        case .free: return 0

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

    private struct CivilizationTypeData {

        let name: String
        let plural: Bool
        let ability: CivilizationAbility
        let cityNames: [String]
    }

    // swiftlint:disable function_body_length
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

        case .free:
            return CivilizationTypeData(
                name: "Free Cities",
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
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_PERSIANS",
                plural: true,
                ability: .satrapies,
                cityNames: [
                    "TXT_KEY_CITY_NAME_PASARGADAE",
                    "TXT_KEY_CITY_NAME_SUSA",
                    "TXT_KEY_CITY_NAME_HAGMATANA",
                    "TXT_KEY_CITY_NAME_TARSUS",
                    "TXT_KEY_CITY_NAME_BAKHTRI",
                    "TXT_KEY_CITY_NAME_SPARDA",
                    "TXT_KEY_CITY_NAME_GORDIAN",
                    "TXT_KEY_CITY_NAME_TUSHPA",
                    "TXT_KEY_CITY_NAME_RAY",
                    "TXT_KEY_CITY_NAME_ZRANKA",
                    "TXT_KEY_CITY_NAME_SHAHR_I_QUMIS",
                    "TXT_KEY_CITY_NAME_PARSA",
                    "TXT_KEY_CITY_NAME_HALICARNASSUS",
                    "TXT_KEY_CITY_NAME_ISPAHAN",
                    "TXT_KEY_CITY_NAME_TYAIY_DRAYAHYA",
                    "TXT_KEY_CITY_NAME_MAZAKA",
                    "TXT_KEY_CITY_NAME_HARAIVA",
                    "TXT_KEY_CITY_NAME_ANASHAN",
                    "TXT_KEY_CITY_NAME_PUSHKALAVATI",
                    "TXT_KEY_CITY_NAME_PURA",
                    "TXT_KEY_CITY_NAME_TAXILA",
                    "TXT_KEY_CITY_NAME_BUKHARA",
                    "TXT_KEY_CITY_NAME_GANZAK",
                    "TXT_KEY_CITY_NAME_MARAKANDA",
                    "TXT_KEY_CITY_NAME_THAPSACUS",
                    "TXT_KEY_CITY_NAME_ISTAKHR",
                    "TXT_KEY_CITY_NAME_ARTASHAT",
                    "TXT_KEY_CITY_NAME_IZKI",
                    "TXT_KEY_CITY_NAME_BORAZJAN",
                    "TXT_KEY_CITY_NAME_CYRA",
                    "TXT_KEY_CITY_NAME_TOPRAK_QALA"
                ]
            )
        case .french:
            // https://civilization.fandom.com/wiki/French_(Civ6)
            // cities taken from here:  https://civilization.fandom.com/wiki/French_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_FRENCH",
                plural: true,
                ability: .grandTour,
                cityNames: [
                    "TXT_KEY_CITY_NAME_PARIS",
                    "TXT_KEY_CITY_NAME_LYON",
                    "TXT_KEY_CITY_NAME_ROUEN",
                    "TXT_KEY_CITY_NAME_BORDEAUX",
                    "TXT_KEY_CITY_NAME_MARSEILLE",
                    "TXT_KEY_CITY_NAME_TOULOUSE",
                    "TXT_KEY_CITY_NAME_LA_ROCHELLE",
                    "TXT_KEY_CITY_NAME_AMBOISE",
                    "TXT_KEY_CITY_NAME_NANTES",
                    "TXT_KEY_CITY_NAME_RENNES",
                    "TXT_KEY_CITY_NAME_CALAIS",
                    "TXT_KEY_CITY_NAME_RHEIMS",
                    "TXT_KEY_CITY_NAME_AVIGNON",
                    "TXT_KEY_CITY_NAME_BOULOGNE",
                    "TXT_KEY_CITY_NAME_DIJON",
                    "TXT_KEY_CITY_NAME_MONTPELLIER",
                    "TXT_KEY_CITY_NAME_LIMOGES",
                    "TXT_KEY_CITY_NAME_CHARTRES",
                    "TXT_KEY_CITY_NAME_BLOIS",
                    "TXT_KEY_CITY_NAME_TOURS",
                    "TXT_KEY_CITY_NAME_VERDUN",
                    "TXT_KEY_CITY_NAME_GRENOBLE",
                    "TXT_KEY_CITY_NAME_JARNAC",
                    "TXT_KEY_CITY_NAME_AMIENS",
                    "TXT_KEY_CITY_NAME_TROYES",
                    "TXT_KEY_CITY_NAME_DIEPPE",
                    "TXT_KEY_CITY_NAME_TOUL",
                    "TXT_KEY_CITY_NAME_BRIANCON",
                    "TXT_KEY_CITY_NAME_METZ",
                    "TXT_KEY_CITY_NAME_MONTELIMAR",
                    "TXT_KEY_CITY_NAME_CARCASSONNE",
                    "TXT_KEY_CITY_NAME_GAP",
                    "TXT_KEY_CITY_NAME_ALBA_LA_ROMAINE"
                ]
            )

        case .egyptian:
            // https://civilization.fandom.com/wiki/Egyptian_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Egyptian_cities_(Civ6)
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_EGYPTIAN",
                plural: true,
                ability: .iteru,
                cityNames: [
                    "TXT_KEY_CITY_NAME_RA_KEDET",
                    "TXT_KEY_CITY_NAME_THEBES",
                    "TXT_KEY_CITY_NAME_MEMPHIS",
                    "TXT_KEY_CITY_NAME_AKHETATEN",
                    "TXT_KEY_CITY_NAME_SHEDET",
                    "TXT_KEY_CITY_NAME_IWNW",
                    "TXT_KEY_CITY_NAME_SWENETT",
                    "TXT_KEY_CITY_NAME_NEKHEN",
                    "TXT_KEY_CITY_NAME_SAIS",
                    "TXT_KEY_CITY_NAME_ABYDOS",
                    "TXT_KEY_CITY_NAME_APU",
                    "TXT_KEY_CITY_NAME_EDFU",
                    "TXT_KEY_CITY_NAME_MENDES",
                    "TXT_KEY_CITY_NAME_SENA",
                    "TXT_KEY_CITY_NAME_CYRENE",
                    "TXT_KEY_CITY_NAME_BUTO",
                    "TXT_KEY_CITY_NAME_GIZA",
                    "TXT_KEY_CITY_NAME_KHMUN",
                    "TXT_KEY_CITY_NAME_ASYUT",
                    "TXT_KEY_CITY_NAME_PITHOM",
                    "TXT_KEY_CITY_NAME_BUSIRIS",
                    "TXT_KEY_CITY_NAME_PIEMRO",
                    "TXT_KEY_CITY_NAME_ORYX",
                    "TXT_KEY_CITY_NAME_HUT_HERYIB",
                    "TXT_KEY_CITY_NAME_TANIS",
                    "TXT_KEY_CITY_NAME_PER_BAST",
                    "TXT_KEY_CITY_NAME_THIS",
                    "TXT_KEY_CITY_NAME_ARSINOE",
                    "TXT_KEY_CITY_NAME_TJEBNUTJER",
                    "TXT_KEY_CITY_NAME_AKHMIM",
                    "TXT_KEY_CITY_NAME_KARNAK"
                ]
            )

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
            return CivilizationTypeData(
                name: "TXT_KEY_CIVILIZATION_RUSSIAN",
                plural: true,
                ability: .motherRussia,
                cityNames: [
                    "TXT_KEY_CITY_NAME_ST_PETERSBURG",
                    "TXT_KEY_CITY_NAME_MOSCOW",
                    "TXT_KEY_CITY_NAME_NOVGOROD",
                    "TXT_KEY_CITY_NAME_KAZAN",
                    "TXT_KEY_CITY_NAME_ASTRAKHAN",
                    "TXT_KEY_CITY_NAME_YAROSLAVL",
                    "TXT_KEY_CITY_NAME_SMOLENSK",
                    "TXT_KEY_CITY_NAME_VORONEZH",
                    "TXT_KEY_CITY_NAME_TULA",
                    "TXT_KEY_CITY_NAME_SOLIKAMSK",
                    "TXT_KEY_CITY_NAME_TVER",
                    "TXT_KEY_CITY_NAME_NIZHNIY_NOVGOROD",
                    "TXT_KEY_CITY_NAME_ARKHANGELSK",
                    "TXT_KEY_CITY_NAME_VOLOGDA",
                    "TXT_KEY_CITY_NAME_OLONETS",
                    "TXT_KEY_CITY_NAME_SARATOV",
                    "TXT_KEY_CITY_NAME_TAMBOV",
                    "TXT_KEY_CITY_NAME_PSKOV",
                    "TXT_KEY_CITY_NAME_KRASNOYARSK",
                    "TXT_KEY_CITY_NAME_IRKUTSK",
                    "TXT_KEY_CITY_NAME_YEKATERINBURG",
                    "TXT_KEY_CITY_NAME_ROSTOV",
                    "TXT_KEY_CITY_NAME_BRYANSK",
                    "TXT_KEY_CITY_NAME_YAKUTSK",
                    "TXT_KEY_CITY_NAME_STARAYA_RUSSA",
                    "TXT_KEY_CITY_NAME_PERM",
                    "TXT_KEY_CITY_NAME_PETROZAVODSK",
                    "TXT_KEY_CITY_NAME_OKHOTSK",
                    "TXT_KEY_CITY_NAME_KOSTROMA",
                    "TXT_KEY_CITY_NAME_NIZHNEKOLYMSK",
                    "TXT_KEY_CITY_NAME_SERGIYEV_POSAD",
                    "TXT_KEY_CITY_NAME_OMSK"
                ]
            )

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
