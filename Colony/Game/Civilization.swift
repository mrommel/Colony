
//
//  Civilization.swift
//  Colony
//
//  Created by Michael Rommel on 23.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

enum Civilization: String, Codable {
    
    // real players
    case english
    case french
    case spanish
    case greek
    
    // generic
    case pirates
    case trader
    
    case none
    
    static let all: [Civilization] = [.english, .french, .spanish, .greek]
    
    var name: String {
        
        switch self {
        case .english:
            return "English"
        case .french:
            return "French"
        case .spanish:
            return "Spanish"
        case .greek:
            return "Greek"
            
        case .pirates:
            return "Pirates"
        case .trader:
            return "Trader"
            
        case .none:
            return "None"
        }
    }
    
    var color: UIColor {
        
        switch self {
        case .french:
            return .blue
        case .english:
            return .red
        case .spanish:
            return .yellow
        case .greek:
            return .green
            
        case .pirates:
            return .black
        case .trader:
            return .gray
            
        case .none:
            fatalError("can't get color of none")
        }
    }
    
    var overviewColor: UIColor {
        
        switch self {
        case .french:
            return .blue
        case .english:
            return .red
        case .spanish:
            return .yellow
        case .greek:
            return .green
            
        case .pirates:
            return .black
        case .trader:
            return .gray
            
        case .none:
            fatalError("can't get color of none")
        }
    }
    
    var cityNames: [String] {
        switch self {
        /*case .cityStates:
            // taken from here: https://civilization-v-customisation.fandom.com/wiki/List_of_City-States
            return ["Almaty", "Antwerp", "Belgrade", "Bogota", "Bratislava", "Brussels", "Colombo", "Florence", "Geneva", "Genoa", "Jerusalem", "Lhasa", "Manila", "Melbourne", "Monaco", "Prague", "Riga", "Samarkand", "Sydney", "Tyre", "Vilnius", "Wittenberg", "Zurich"]*/
        
        case .french:
            // taken from here: https://civilization.fandom.com/wiki/French_cities_(Civ5)
            return ["Paris", "Orleans", "Lyon", "Troyes", "Tours", "Marseille", "Chartres", "Avignon", "Rouen", "Grenoble"]
        case .english:
            // taken from here: https://civilization.fandom.com/wiki/English_cities_(Civ5)
            return ["London", "York", "Nottingham", "Hastings", "Canterbury", "Coventry", "Warwick", "Newcastle", "Oxford", "Liverpool"]
        case .spanish:
            // taken from here: https://civilization.fandom.com/wiki/Spanish_cities_(Civ5)
            return ["Madrid", "Barcelona", "Seville", "Cordoba", "Toledo", "Santiago", "Salamanca", "Murcia", "Valencia", "Zaragoza"]
        case .greek:
            // taken from here: https://civilization.fandom.com/wiki/Greek_cities_(Civ5)
            return ["Athens", "Sparta", "Corinth", "Argos", "Knossos", "Mycenae", "Pharsalos", "Ephesus", "Halicarnassus", "Rhodes", "Eretria", "Pergamon", "Miletos"]
            
        default:
            fatalError("city name for unknown civ: \(self)")
        }
    }
    
    var leader: Leader {
        
        return Leaders.leader(for: self)
    }
}
