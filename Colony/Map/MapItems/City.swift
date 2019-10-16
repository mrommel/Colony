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

    static let kDefaultName = "default"
    static let kName = "name"
    static let kCivilization = "civilization"
    static let kPopulation = "population"

    // MARK: properties

    var name: String
    var civilization: Civilization
    var population: Int

    var sumEmigrats: Int = 0
    var sumImmigrats: Int = 0

    // MARK: constructors

    init(named name: String, at position: HexPoint, civilization: Civilization) {

        self.name = name
        self.civilization = civilization
        self.population = 1000

        super.init(at: position, type: .city)
    }

    init(at position: HexPoint) {

        self.name = City.kDefaultName
        self.civilization = .english
        self.population = 1000

        super.init(at: position, type: .city)
    }

    required init(from decoder: Decoder) throws {

        self.name = City.kDefaultName
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
        
        self.updateCitySprite()
    }

    override func saveToDict() {

        self.dict[City.kName] = self.name
        self.dict[City.kCivilization] = self.civilization
        self.dict[City.kPopulation] = self.population
    }

    override func loadFromDict() {

        self.name = self.dict[City.kName] as! String
        self.civilization = Civilization(rawValue: self.dict[City.kCivilization] as! String) ?? .english

        self.population = 0
        if let doubleValue = self.dict[City.kPopulation] as? Double {
            self.population = Int(doubleValue)
        } else if let intValue = self.dict[City.kPopulation] as? Int {
            self.population = Int(intValue)
        }
        
        self.updateCitySprite()
    }

    override func update(in game: Game?) {

        // print("update \(self.name) - \(self.population) - \(self.gameObject?.spriteName ?? "-")")

        // get some random local events


        // https://en.wikipedia.org/wiki/Demographic_transition
        // https://en.wikipedia.org/wiki/File:Demographic-TransitionOWID.png
        // https://ourworldindata.org/uploads/2019/06/Mortality-rates-of-children-over-last-two-millennia.png
        //let food = game?.foodProduction(at: self.position, for: self.civilization)
        //let foodSecurity = // 0..1 // 1==good +transportation, +crop rotation, +selective breeding, +seed drilling
        //let foodSupply = food * (1.0 - foodSecurity) * 0.2 * random(0..1)
        //let health = // 0..1 // +sewage, +doctors, -waterSecurity, -urbanisation, +hygiene, -marsh

        let birthRate = (46.0 + Double.random(minimum: -5.0, maximum: 5.0)) / 1000.0
        let deathRate = (40.0 + Double.random(minimum: -5.0, maximum: 5.0)) / 1000.0
        let emigrationRate = (5.0 + Double.random(minimum: -2.0, maximum: 2.0)) / 1000.0 // ca. 0.5%

        let births: Double = max(Double(self.population) * birthRate + Double.random(minimum: -20.0, maximum: 20.0), 0.0)
        let immigrats: Double = Double(self.sumImmigrats)
        let deaths: Double = max(Double(self.population) * deathRate + Double.random(minimum: -20.0, maximum: 20.0), 0.0)
        let emigrats: Double = max(Double(self.population) * emigrationRate + Double.random(minimum: -10.0, maximum: 10.0), 0.0) // clamped

        // Change in Population Size = (Births + Immigration) - (Deaths + Emigration)
        let delta: Double = (births + immigrats) - (deaths + emigrats)

        // update population
        self.sumEmigrats = self.sumEmigrats + Int(emigrats)
        self.sumImmigrats = 0
        self.population = self.population + Int(delta)
        self.updateCitySprite()

        // check
        if self.population <= 0 {
            self.population = 0
            self.handleAbandonment(in: game)
        }

        self.checkCityName(in: game)

        // send emigrants
        if self.sumEmigrats > 100 {
            self.handleEmigation(of: self.sumEmigrats, in: game)
        }
    }

    // MARK: private methods

    private func checkCityName(in game: Game?) {

        if self.name == City.kDefaultName {
            let uuid = UUID()
            self.name = "\(City.kDefaultName)-\(uuid.uuidString)"
        }

        if self.name.starts(with: City.kDefaultName) && self.population >= 10000 {

            guard let player = game?.player(for: self.civilization) else {
                fatalError("can't get player")
            }

            let civilization = player.leader.civilization
            var unusedCityNames = civilization.cityNames

            // get all cities of player
            guard let cities = game?.getCitiesOf(civilization: civilization) else {
                fatalError("can't get cities")
            }

            for city in cities {
                if let cityName = city?.name {
                    unusedCityNames.remove(object: cityName)
                }
            }
            
            if let firstCityName = unusedCityNames.first {
                self.name = firstCityName
            } else {
                fatalError("no city name left")
            }
        }
    }

    // all our people have left this place - kill the city
    private func handleAbandonment(in game: Game?) {
        
        game?.abandon(city: self)
    }

    private func handleEmigation(of emigration: Int, in game: Game?) {

        self.sumEmigrats = 0

        guard let player = game?.player(for: self.civilization) else {
            fatalError("can't get player")
        }

        if let emigrationLocation = player.spawn?.location {

            if let city = game?.getCity(at: emigrationLocation) {
                city.sumImmigrats = city.sumImmigrats + emigration
            } else {
                // found new city
                let newCity = City(named: City.kDefaultName, at: emigrationLocation, civilization: self.civilization)
                newCity.population = emigration
                game?.found(city: newCity)
            }
        } else {
            // find random spot nearby
            guard let neighbors = game?.neighborsOnLand(of: self.position) else {
                fatalError("can't get neighbors")
            }

            if neighbors.isEmpty {
                // FIXME: hm - maybe send them overseas
                fatalError("there are no neighbors - WTF")
            } else {
                let newCityLocation = neighbors.randomItem()
                
                if let city = game?.getCity(at: newCityLocation) {
                    city.sumImmigrats = city.sumImmigrats + emigration
                } else {
                    // found new city
                    let newCity = City(named: City.kDefaultName, at: newCityLocation, civilization: self.civilization)
                    newCity.population = emigration
                    game?.found(city: newCity)
                }
            }
        }
    }
    
    private func updateCitySprite() {
        
        if self.population < 1000 {
            self.gameObject?.showTexture(named: "hex_city_1")
        }
        
        if 1000 <= self.population && self.population < 2000 {
            self.gameObject?.showTexture(named: "hex_city_2")
        }
        
        if 2000 <= self.population {
            self.gameObject?.showTexture(named: "hex_city_3")
        }
    }
}
