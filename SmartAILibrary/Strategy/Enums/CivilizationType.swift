//
//  CivilizationType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 16.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CivilizationType {
    
    case barbarian
    
    case greek
    case roman
    case english
    
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
            // takenf from here: https://civilization.fandom.com/wiki/Roman_cities_(Civ6)
            return ["Rome", "Ostia", "Antium", "Cumae", "Aquileia", "Ravenna", "Puteoli", "Arretium", "Mediolanum", "Lugdunum", "Arpinum", "Setia"]
        }
    }
    
}
