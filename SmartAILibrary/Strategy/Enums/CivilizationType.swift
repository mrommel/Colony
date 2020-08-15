//
//  CivilizationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivilizationAbility {

    case none

    case platosRepublic // greek
    case allRoadsLeadToRome // roman
    case workshopOfTheWorld // english
    case legendOfTheFiveSuns // aztecs
    case satrapies // persian
    case grandTour // french
    case iteru // egyptian
    case freeImperialCities // german
    case motherRussia // russian
    

    public func name() -> String {

        return self.data().name
    }

    private struct CivilizationAbilityData {

        let name: String
        let effects: [String]
    }

    private func data() -> CivilizationAbilityData {

        switch self {

        case .none:
            return CivilizationAbilityData(name: "None",
                                           effects: ["None"])
        case .platosRepublic:
            return CivilizationAbilityData(name: "Plato's Republic",
                                           effects: ["Gain an additional Wildcard policy slot in all Governments."])
        case .allRoadsLeadToRome:
            return CivilizationAbilityData(name: "All Roads Lead to Rome",
                                           effects: [
                                            "Founded or conquered cities start with a Trading Post", // FIXME: conquered
                                            "If within TradeRoute6 Trade Route range of the Capital6 Capital, a road to it.",
                                            "TradeRoute6 Trade Routes generate +1 additional Civ6Gold Gold from Roman Trading Posts they pass through."])
        case .workshopOfTheWorld:
            return CivilizationAbilityData(name: "Workshop of the World",
                                           effects: ["Iron and Coal Mines accumulate +2 resources per turn.", // FIXME
                                                     "+100% Civ6Production Production towards Military Engineers.", // FIXME
                                                     "Military Engineers receive +2 charges.", // FIXME
                                                     "Buildings that provide additional yields when powered receive +4 of their respective yields.", // FIXME
                                                     "+20% Civ6Production Production towards Industrial Zone buildings.", // FIXME
                                                     "Harbor buildings grant +10 Strategic Resource stockpiles."]) // FIXME
        case .legendOfTheFiveSuns:
            return CivilizationAbilityData(name: "Legend of the Five Suns",
                                           effects: ["Can spend Builder charges to complete 20% of a district's Civ6Production Production cost."])  // FIXME
        case .satrapies:
            return CivilizationAbilityData(name: "Satrapies",
                                           effects: ["Gains +1 TradeRoute6 Trade Route capacity with Political Philosophy.",
                                                     "Domestic TradeRoute6 Trade Routes provide +2 Civ6Gold Gold and +1 Civ6Culture Culture.",
                                                     "Roads built inside Persian territory are one level more advanced than usual."]) // FIXME
        case .grandTour:
            return CivilizationAbilityData(name: "Grand Tour",
                                           effects: ["+20% Civ6Production Production towards Medieval, Renaissance, and Industrial Wonders.",
                                                     "Double Tourism6 Tourism from all Wonders."]) // FIXME
        case .iteru:
            return CivilizationAbilityData(name: "Iteru",
                                           effects: ["+15% Civ6Production Production towards District (Civ6) Districts and wonders built next to a river.",
                                                     "Districts, improvements and units are immune to damage from floods."]) // FIXME
        case .freeImperialCities:
            return CivilizationAbilityData(name: "Free Imperial Cities",
                                           effects: ["Each city can build one more district than the population limit would normally allow."]) // FIXME
        case .motherRussia:
            return CivilizationAbilityData(name: "Mother Russia",
                                           effects: ["Founded cities start with eight additional tiles.",
                                                     "Tundra tiles provide +1 Civ6Faith Faith and +1 Civ6Production Production, in addition to their usual yields.",
                                                     "Districts, improvements and units are immune to damage from Blizzards.", // FIXME
                                                     "+100% damage from Blizzards inside Russian territory to civilizations at war with Russia."]) // FIXME
        }
    }
}

public enum CivilizationType {

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
