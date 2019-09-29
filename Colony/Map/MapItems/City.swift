//
//  City.swift
//  Colony
//
//  Created by Michael Rommel on 14.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class City: MapItem {
    
    // MARK: constants
    
    static let kName = "name"
    static let kCivilization = "civilization"
    static let kPopulation = "population"
    
    // MARK: properties
    
    var name: String
    var civilization: Civilization
    var population: Float
    
    // MARK: constructors
    
    init(named name: String, at position: HexPoint, civilization: Civilization) {
        
        self.name = name
        self.civilization = civilization
        self.population = 1.0
        
        super.init(at: position, type: .city)
    }
    
    init(at position: HexPoint) {
        
        self.name = ""
        self.civilization = .english
        self.population = 1.0
        
        super.init(at: position, type: .city)
    }
    
    required init(from decoder: Decoder) throws {

        self.name = ""
        self.civilization = .english
        self.population = 1.0
        
        try super.init(from: decoder)
    }
    
    // MARK: methods
    
    func createGameObject() -> GameObject? {

        let gameObject = CityObject(for: self)
        self.gameObject = gameObject
        return gameObject
    }
    
    func copy(from item: MapItem) {
        
        self.dict[City.kName] = item.dict[City.kName]
        self.dict[City.kCivilization] = item.dict[City.kCivilization]
        self.dict[City.kPopulation] = item.dict[City.kPopulation]
    }

    override func saveToDict() {
        
        self.dict[City.kName] = self.name
        self.dict[City.kCivilization] = self.civilization
        self.dict[City.kPopulation] = self.population
    }
    
    override func loadFromDict() {
        
        self.name = self.dict[City.kName] as! String
        self.civilization = Civilization(rawValue: self.dict[City.kCivilization] as! String) ?? .english
        
        if let doubleValue = self.dict[City.kPopulation] as? Double {
            self.population = Float(doubleValue)
        } else if let intValue = self.dict[City.kPopulation] as? Int {
            self.population = Float(intValue)
        }
        
    }
}
