//
//  City.swift
//  Colony
//
//  Created by Michael Rommel on 14.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// actually Viallge
class City: MapItem {
    
    // MARK: constants
    
    static let kName = "name"
    static let kCivilization = "civilization"
    static let kPopulation = "population"
    
    // MARK: properties
    
    var name: String
    var civilization: Civilization
    var population: Int
    
    // MARK: constructors
    
    init(named name: String, at position: HexPoint, civilization: Civilization) {
        
        self.name = name
        self.civilization = civilization
        self.population = 1000
        
        super.init(at: position, type: .city)
    }
    
    init(at position: HexPoint) {
        
        self.name = ""
        self.civilization = .english
        self.population = 1000
        
        super.init(at: position, type: .city)
    }
    
    required init(from decoder: Decoder) throws {

        self.name = ""
        self.civilization = .english
        self.population = 1000
        
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
            self.population = Int(doubleValue)
        } else if let intValue = self.dict[City.kPopulation] as? Int {
            self.population = Int(intValue)
        }
    }
    
    override func update(in game: Game?) {
        
        print("update \(self.name) - \(self.population)")
        
        
        
        // https://en.wikipedia.org/wiki/Demographic_transition
        // https://en.wikipedia.org/wiki/File:Demographic-TransitionOWID.png
        // https://ourworldindata.org/uploads/2019/06/Mortality-rates-of-children-over-last-two-millennia.png
        //let food = game?.foodProduction(at: self.position, for: self.civilization)
        //let foodSecurity = // 0..1 // 1==good +transportation, +crop rotation, +selective breeding, +seed drilling
        //let foodSupply = food * (1.0 - foodSecurity) * 0.2 * random(0..1)
        //let health = // 0..1 // +sewage, +doctors, -waterSecurity, -urbanisation, +hygiene, -marsh
        
        let birthRate = (44.0 + Double.random(minimum: -5.0, maximum: 5.0)) / 1000.0
        let deathRate = (40.0 + Double.random(minimum: -5.0, maximum: 5.0)) / 1000.0
        
        let births: Double = Double(self.population) * birthRate + Double.random(minimum: -20.0, maximum: 20.0)
        let immigrats: Double = 0
        let deaths: Double = Double(self.population) * deathRate + Double.random(minimum: -20.0, maximum: 20.0)
        let emigrats: Double = 0
        
        // Change in Population Size = (Births + Immigration) - (Deaths + Emigration)
        let delta: Double = (births + immigrats) - (deaths + emigrats)
        
        // update population
        self.population = self.population + Int(delta)
        
        // check
        if self.population <= 0 {
            // FIXME: all our people have left this place - kill the city
            self.population = 0
        }
    }
}
