//
//  CityGrowthViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.05.21.
//

import SwiftUI
import SmartAILibrary

class CityGrowthViewModel: ObservableObject {

    @Environment(\.gameEnvironment)
    var gameEnvironment: GameEnvironment

    @Published
    var lastTurnFoodHarvested: String

    @Published
    var foodConsumption: String

    @Published
    var foodSurplus: String

    @Published
    var amenitiesModifier: String

    @Published
    var housingModifier: String

    @Published
    var lastTurnFoodEarned: String

    @Published
    var growthInTurns: String

    // -------- housing ----------
    @Published
    var housingFromBuildings: String

    @Published
    var housingFromDistricts: String

    @Published
    var housingFromWater: String

    // -------- amenities ----------
    @Published
    var amenitiesFromLuxuries: String

    @Published
    var amenitiesFromEntertainment: String

    @Published
    var amenitiesFromReligion: String

    private var city: AbstractCity?

    init(city: AbstractCity? = nil) {

        // food
        self.lastTurnFoodHarvested = "-"
        self.foodConsumption = "-"
        self.foodSurplus = "-"
        self.amenitiesModifier = "-"
        self.housingModifier = "-"
        self.lastTurnFoodEarned = "-" // ???
        self.growthInTurns = "-"

        // housing
        self.housingFromBuildings = "-"
        self.housingFromDistricts = "-"
        self.housingFromWater = "-"

        // amenities
        self.amenitiesFromLuxuries = "-"
        self.amenitiesFromEntertainment = "-"
        self.amenitiesFromReligion = "-"

        if city != nil {
            self.update(for: city)
        }
    }

    func update(for city: AbstractCity?) {

        self.city = city

        // populate values
        if let city = city {

            guard let gameModel = self.gameEnvironment.game.value else {
                return
            }

            guard let humanPlayer = gameModel.humanPlayer() else {
                fatalError("cant get human player")
            }

            guard humanPlayer.leader == city.player?.leader else {
                fatalError("human player not city owner")
            }

            //
            if city.lastTurnFoodHarvested() < 0 {
                self.lastTurnFoodHarvested = "-\(String(format: "%.1f", city.lastTurnFoodHarvested()))"
            } else {
                self.lastTurnFoodHarvested = "+\(String(format: "%.1f", city.lastTurnFoodHarvested()))"
            }
            self.foodConsumption = "-\(String(format: "%.1f", city.foodConsumption()))"
            self.foodSurplus = String(format: "%.1f", (city.lastTurnFoodHarvested() - city.foodConsumption()))
            self.amenitiesModifier = String(format: "%.1f", city.amenitiesModifier(in: gameModel))
            self.housingModifier = String(format: "%.1f", city.housingModifier(in: gameModel))
            self.lastTurnFoodEarned = String(format: "%.1f", city.lastTurnFoodEarned())
            self.growthInTurns = "\(city.growthInTurns()) turns"

            // amenities
            self.amenitiesFromLuxuries = "\(city.amenitiesFromLuxuries())"
            let amenitiesFromEntertainmentValue = city.amenitiesFromDistrict() +
                city.amenitiesFromBuildings() + city.amenitiesFromWonders(in: gameModel)
            self.amenitiesFromEntertainment = "\(amenitiesFromEntertainmentValue)"
            self.amenitiesFromReligion = "0"

            // housing
            self.housingFromBuildings = "\(city.housingFromBuildings() + city.housingFromWonders(in: gameModel))"
            self.housingFromDistricts = "\(city.housingFromDistricts(in: gameModel))"
            self.housingFromWater = "\(city.baseHousing(in: gameModel))"

        }
    }
}
