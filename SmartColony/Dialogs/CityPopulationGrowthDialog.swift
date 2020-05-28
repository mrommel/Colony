//
//  CityPopulationGrowthDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class CityPopulationGrowthViewModel {
    
    let cityName: String
    let lastTurnFoodHarvested: String
    let foodConsumption: String
    let foodSurplus: String
    let amenitiesModifier: String
    let housingModifier: String
    let lastTurnFoodEarned: String
    let growthInTurns: String
    
    init(for city: AbstractCity?, in gameModel: GameModel?) {
        
        guard let city = city else {
            fatalError("cant get city")
        }
        
        self.cityName = city.name
        
        self.lastTurnFoodHarvested = String(format: "%.1f", city.lastTurnFoodHarvested())
        self.foodConsumption = String(format: "%.1f", city.foodConsumption())
        self.foodSurplus = String(format: "%.1f", (city.lastTurnFoodHarvested() - city.foodConsumption()))
        self.amenitiesModifier = String(format: "%.1f", city.amenitiesModifier(in: gameModel))
        self.housingModifier = String(format: "%.1f", city.housingModifier(in: gameModel))
        self.lastTurnFoodEarned = String(format: "%.1f", city.lastTurnFoodEarned())
        self.growthInTurns = "\(city.growthInTurns()) turns"
    }
}

/*
 - citizen growth overview
     - food per turn (/)
     - food consumption (/)
     - food surplus per turn = sum (/)
     - amenities growth bonus (in percent)
     - other growth bonuses (in percent) (which?)
     - modified food surplus per turn = sum
     - housing multiplier (in percent 25%)
     - occupied city multiplier (???)
     - total food surplus (/)
     - growth in turns (/)
 */
class CityPopulationGrowthDialog: Dialog {
    
    //weak var city: AbstractCity?
    //weak var gameModel: GameModel?
    
    let viewModel: CityPopulationGrowthViewModel
    
    init(with viewModel: CityPopulationGrowthViewModel) {

        self.viewModel = viewModel

        let uiParser = UIParser()
        guard let cityPopulationGrowthDialogConfiguration = uiParser.parse(from: "CityPopulationGrowthDialog") else {
            fatalError("cant load CityPopulationGrowthDialog configuration")
        }

        super.init(from: cityPopulationGrowthDialogConfiguration)
        
        // fill fields
        self.set(text: self.viewModel.cityName, identifier: "city_name")
        
        self.set(text: self.viewModel.lastTurnFoodHarvested, identifier: "food_per_turn_value")
        self.set(text: self.viewModel.foodConsumption, identifier: "food_consumption_value")
        // ----------
        self.set(text: self.viewModel.foodSurplus, identifier: "food_surplus_value")
        self.set(text: self.viewModel.amenitiesModifier, identifier: "amenities_modifier_value")
        // ... other growth bonus
        // ----------
        // ... modified food per turn
        self.set(text: self.viewModel.housingModifier, identifier: "housing_modifier_value")
        // ... occupied
        // ----------
        self.set(text: self.viewModel.lastTurnFoodEarned, identifier: "total_food_surplus_value")
        // ----------
        self.set(text: self.viewModel.growthInTurns, identifier: "growth_in_value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
