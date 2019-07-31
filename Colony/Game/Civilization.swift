
//
//  Civilization.swift
//  Colony
//
//  Created by Michael Rommel on 23.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import UIKit

enum Civilization: String, Codable {
    // real player
    case english
    case french
    case spanish
    
    // city state
    case cityStates
    
    // generic
    case pirates
    case trader
    
    static let all: [Civilization] = [.english, .french, .spanish, .cityStates]
    
    var name: String {
        
        switch self {
        case .english:
            return "English"
        case .french:
            return "French"
        case .spanish:
            return "Spanish"
            
        case .cityStates:
            return "City States"
            
        case .pirates:
            return "Pirates"
        case .trader:
            return "Trader"
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
            
        case .cityStates:
            return .gray
            
        case .pirates:
            return .black
        case .trader:
            return .gray
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
            
        case .cityStates:
            return .white
            
        case .pirates:
            return .black
        case .trader:
            return .gray
        }
    }
    
    var cityNames: [String] {
        switch self {
        case .cityStates:
            // taken from here: https://civilization-v-customisation.fandom.com/wiki/List_of_City-States
            return ["Almaty", "Antwerp", "Belgrade", "Bogota", "Bratislava", "Brussels", "Colombo", "Florence", "Geneva", "Genoa", "Jerusalem", "Lhasa", "Manila", "Melbourne", "Monaco", "Prague", "Riga", "Samarkand", "Sydney", "Tyre", "Vilnius", "Wittenberg", "Zurich"]
        
        case .french:
            // taken from here: https://civilization.fandom.com/wiki/French_cities_(Civ5)
            return ["Paris", "Orleans", "Lyon", "Troyes", "Tours", "Marseille", "Chartres", "Avignon", "Rouen", "Grenoble"]
        case .english:
            // taken from here: https://civilization.fandom.com/wiki/English_cities_(Civ5)
            return ["London", "York", "Nottingham", "Hastings", "Canterbury", "Coventry", "Warwick", "Newcastle", "Oxford", "Liverpool"]
        case .spanish:
            // taken from here: https://civilization.fandom.com/wiki/Spanish_cities_(Civ5)
            return ["Madrid", "Barcelona", "Seville", "Cordoba", "Toledo", "Santiago", "Salamanca", "Murcia", "Valencia", "Zaragoza"]
            
        default:
            fatalError("city name for unknown civ: \(self)")
        }
    }
    
    var defaultUserName: String {
        
        switch self {
        case .french:
            return "Jaques"
        case .english:
            return "John"
        case .spanish:
            return "Juan"
            
        case .cityStates:
            return "Neutron"
            
        case .pirates:
            return "Jack Sparrow"
        case .trader:
            return "Travis"
        }
    }
}
