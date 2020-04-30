//
//  CivilizationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CivilizationType {
    
    case barbarian
    
    case greek
    case roman
    case english
    case aztecs
    case persian
    case french
    
    func cityNames() -> [String] {
        
        switch self {
            
        case .barbarian: return []
            //case .french:
            // taken from here: https://civilization.fandom.com/wiki/French_cities_(Civ6)
        //    return ["Paris", "Orleans", "Lyon", "Troyes", "Tours", "Marseille", "Chartres", "Avignon", "Rouen", "Grenoble"]
        case .english:
            // taken from here: https://civilization.fandom.com/wiki/English_cities_(Civ6)
            return ["London", "York", "Nottingham", "Hastings", "Canterbury", "Coventry", "Warwick", "Newcastle", "Oxford", "Liverpool"]
        //case .spanish:
            // taken from here: https://civilization.fandom.com/wiki/Spanish_cities_(Civ6)
            //return ["Madrid", "Barcelona", "Seville", "Cordoba", "Toledo", "Santiago", "Salamanca", "Murcia", "Valencia", "Zaragoza"]
        case .greek:
            // taken from here: https://civilization.fandom.com/wiki/Greek_cities_(Civ6)
            return ["Athens", "Sparta", "Corinth", "Argos", "Knossos", "Mycenae", "Pharsalos", "Ephesus", "Halicarnassus", "Rhodes", "Eretria", "Pergamon", "Miletos"]
            
        case .roman:
            // taken from here: https://civilization.fandom.com/wiki/Roman_cities_(Civ6)
            return ["Rome", "Ostia", "Antium", "Cumae", "Aquileia", "Ravenna", "Puteoli", "Arretium", "Mediolanum", "Lugdunum", "Arpinum", "Setia"]
            
        case .aztecs:
            // taken from here: https://civilization.fandom.com/wiki/Aztec_cities_(Civ6)
            return ["Tenochtitlan", "Texcoco", "Atzcapotzalco", "Teotihuacán", "Tlacopán", "Xochicalco", "Malinalco", "Teayo", "Cempoala", "Chalco", "Ixtapaluca", "Tenayuca", "Huexotla", "Chapultepec", "Tepexpan", "Zitlaltepec", "Xalapa", "Tamuín", "Teloloapan"]
            
        case .persian:
            // taken from here: https://civilization.fandom.com/wiki/Persian_cities_(Civ6)
            return ["Pasargadae", "Susa", "Hagmatana", "Tarsus", "Bakhtri", "Sparda", "Gordian", "Tushpa", "Ray", "Zranka"]
            
        case .french:
            // https://civilization.fandom.com/wiki/French_cities_(Civ6)
            return ["Paris", "Alba-La-Romaine", "Amboise", "Amiens", "Avignon", "Briançon", "Blois", "Bordeaux", "Boulogne", "Calais", "Carcassonne", "Chartres", "Dieppe", "Dijon", "Grenoble", "La Rochelle", "Limoges", "Lyon", "Marseille"]
            
        }
    }
    
    func name() -> String {
        
        switch self {
            
        case .barbarian: return "Barbarians"
            
        case .greek: return "Greeks"
        case .roman: return "Romans"
        case .english: return "English"
        case .aztecs: return "Aztecs"
        case .persian: return "Persians"
        case .french: return "French"
        }
    }
    
    func isPlural() -> Bool {
        
        return true
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
        }
    }
}
