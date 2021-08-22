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

    // ///////////////////////////

    public static var all: [CivilizationType] = [
        .greek, .roman, .english, .aztecs, .persian, .french, .egyptian, .german, .russian
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
            return CivilizationTypeData(name: "Barbarians",
                                        plural: true,
                                        ability: .none,
                                        cityNames: [])
        case .greek:
            // https://civilization.fandom.com/wiki/Greek_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Greek_cities_(Civ6)
            return CivilizationTypeData(name: "Greeks",
                                        plural: true,
                                        ability: .platosRepublic,
                                        cityNames: ["Athens", "Sparta", "Corinth", "Argos", "Knossos", "Mycenae", "Pharsalos", "Ephesus", "Halicarnassus", "Rhodes", "Eretria", "Pergamon", "Miletos"])
        case .roman:
            // https://civilization.fandom.com/wiki/Roman_(Civ6)
            // cities taken from here: https://civilization.fandom.com/wiki/Roman_cities_(Civ6)
            return CivilizationTypeData(name: "Romans",
                                        plural: true,
                                        ability: .allRoadsLeadToRome,
                                        cityNames: ["Rome", "Ostia", "Antium", "Cumae", "Aquileia", "Ravenna", "Puteoli", "Arretium", "Mediolanum", "Lugdunum", "Arpinum", "Setia"])
        case .english:
            // cities taken from here: https://civilization.fandom.com/wiki/English_cities_(Civ6)
            return CivilizationTypeData(name: "English",
                                        plural: true,
                                        ability: .workshopOfTheWorld,
                                        cityNames: ["London", "York", "Nottingham", "Hastings", "Canterbury", "Coventry", "Warwick", "Newcastle", "Oxford", "Liverpool"])
        case .aztecs:
            // cities taken from here: https://civilization.fandom.com/wiki/Aztec_cities_(Civ6)
            return CivilizationTypeData(name: "Aztecs",
                                        plural: true,
                                        ability: .legendOfTheFiveSuns,
                                        cityNames: ["Tenochtitlan", "Texcoco", "Atzcapotzalco", "Teotihuacán", "Tlacopán", "Xochicalco", "Malinalco", "Teayo", "Cempoala", "Chalco", "Ixtapaluca", "Tenayuca", "Huexotla", "Chapultepec", "Tepexpan", "Zitlaltepec", "Xalapa", "Tamuín", "Teloloapan"])
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
            return CivilizationTypeData(name: "German",
                                        plural: true,
                                        ability: .freeImperialCities,
                                        cityNames: ["Aachen", "Cologne", "Frankfurt", "Magdeburg", "Mainz", "Heidelberg", "Trier", "Berlin", "Ulm", "Hamburg", "Munich", "Dortmund", "Nuremberg", "Bremen", "Augsburg", "Münster", "Regensburg", "Erfurt", "Lübeck", "Freiburg", "Würzburg", "Hannover", "Rostock"])
        case .russian:
            // cities taken from here: https://civilization.fandom.com/wiki/Russian_cities_(Civ6)
            return CivilizationTypeData(name: "Russian",
                                        plural: true,
                                        ability: .motherRussia,
                                        cityNames: ["St. Petersburg", "Moscow", "Novgorod", "Kazan", "Astrakhan", "Yaroslavl", "Smolensk", "Voronezh", "Tula", "Solikamsk", "Tver", "Nizhniy Novgorod", "Arkhangelsk", "Vologda", "Olonets", "Saratov", "Tambov", "Pskov", "Krasnoyarsk"])
        }
    }
}
