//
//  CityReligion.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.05.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class ReligiousWeightList: WeightedList<ReligionType> {
    
    override func fill() {
        
        self.add(weight: 0.0, for: .atheism)
        
        for religionType in ReligionType.all {
            self.add(weight: 0.0, for: religionType)
        }
    }
    
    func removeZeroEntries() {
        
        self.items.removeAll(where: { item in
            item.weight == 0.0
        })
    }
}

public protocol AbstractCityReligion {
    
    func turn(with gameModel: GameModel?)
    
    func pressurePerTurn(in gameModel: GameModel?) -> ReligiousWeightList
        
    func dominantReligion() -> ReligionType
    func citizen(following religion: ReligionType) -> Int
    func citizens() -> ReligiousWeightList
}

public class CityReligion: AbstractCityReligion, Codable {
    
    enum CodingKeys: String, CodingKey {
    
        case pressure
        case majorityReligion
    }
    
    var city: AbstractCity?
    let pressure: ReligiousWeightList
    var majorityReligion: ReligionType

    init(city: AbstractCity?) {

        self.city = city
        
        self.pressure = ReligiousWeightList()
        self.pressure.fill()
        
        self.majorityReligion = .atheism
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.city = nil
        self.pressure = try container.decode(ReligiousWeightList.self, forKey: .pressure)
        self.majorityReligion = try container.decode(ReligionType.self, forKey: .majorityReligion)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.pressure, forKey: .pressure)
        try container.encode(self.majorityReligion, forKey: .majorityReligion)
    }
    
    // MARK: methods
    
    public func turn(with gameModel: GameModel?) {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        // update pressure
        
        // Atheist pressure is 50 * population
        let atheismPressure: Double = 50.0 * Double(city.population())
        self.pressure.set(weight: atheismPressure, for: .atheism)
        
        let pressurePerTurnValue = self.pressurePerTurn(in: gameModel)
        
        for religionType in ReligionType.all {
            self.pressure.add(weight: pressurePerTurnValue.weight(of: religionType), for: religionType)
        }
        
        // find majority
        self.pressure.sort()
        if let bestReligion = self.pressure.items.first {
        
            if bestReligion.weight < self.pressure.totalWeights() / 2.0 {
                self.majorityReligion = .atheism
                return
            }
            
            if bestReligion.itemType != self.majorityReligion {
            
                // trigger event to user
                if city.player?.isHuman() ?? false {
                    gameModel?.userInterface?.showPopup(popupType: .religionAdopted, with: PopupData(religionType: self.majorityReligion, for: city.name))
                }
            }
            
            self.majorityReligion = bestReligion.itemType
        }
    }
    
    public func pressurePerTurn(in gameModel: GameModel?) -> ReligiousWeightList {
        
        guard let gameModel = gameModel else {
            fatalError("cant get game")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let pressures: ReligiousWeightList = ReligiousWeightList()
        pressures.fill()
        
        for player in gameModel.players {
            for foreignCityRef in gameModel.cities(of: player) {
                
                guard let foreignCity = foreignCityRef else {
                    fatalError("cant get foreign city")
                }
                
                guard let foreignCityDistricts = foreignCity.districts else {
                    fatalError("cant get foreign city district")
                }
                
                guard foreignCity.location != city.location else {
                    // we dont want to process our city
                    continue
                }
                
                guard foreignCity.location.distance(to: city.location) <= 10 else {
                    // Religious pressure values for each city are calculated cumulatively for all other cities with Majority Religions within 10 tiles.
                    continue
                }
                
                guard let foreignCityDominantReligion = foreignCity.cityReligion?.dominantReligion() else {
                    fatalError("cant get majority religion of foreign city")
                }
                
                var pressure: Double = 0.0
                
                // No pressure if the city does not have a Majority Religion.
                if foreignCityDominantReligion == .atheism {
                    pressure = 0.0
                } else if foreignCityDistricts.has(district: .holySite) {
                    // +2 Pressure exerted by the Majority Religion of the city if it also has a Holy Site.
                    pressure = 2.0
                } else {
                    // +1 Pressure exerted by the Majority Religion of the city.
                    pressure = 1.0
                }
                
                // TODO: +4 Pressure exerted by the Majority Religion of the city if it is also the Holy City.
                
                pressures.add(weight: pressure, for: foreignCityDominantReligion)
            }
        }
        
        // trade routes
        
        return pressures
    }
        
    public func dominantReligion() -> ReligionType {
        
        return self.majorityReligion
    }
    
    public func citizen(following religion: ReligionType) -> Int {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let sum: Double = self.pressure.totalWeights()
        
        if sum == 0.0 {
            return 0
        }
        
        let ratio: Double = self.pressure.weight(of: religion) / sum
        
        return Int((Double(city.population()) * ratio).rounded())
    }
    
    public func citizens() -> ReligiousWeightList {
        
        let citizensVal: ReligiousWeightList = ReligiousWeightList()

        for religionType in ReligionType.all {
            
            let citizen = self.citizen(following: religionType)
            if citizen > 0 {
                citizensVal.add(weight: citizen, for: religionType)
            }
        }
        
        citizensVal.removeZeroEntries()
        
        return citizensVal
    }
}
