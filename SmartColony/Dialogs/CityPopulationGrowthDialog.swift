//
//  CityPopulationGrowthDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

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
    
    weak var city: AbstractCity?
    weak var gameModel: GameModel?
    
    init(for city: AbstractCity?, in gameModel: GameModel?) {

        self.city = city
        self.gameModel = gameModel
        
        guard let city = self.city else {
            fatalError("cant get city")
        }

        let uiParser = UIParser()
        guard let cityPopulationGrowthDialogConfiguration = uiParser.parse(from: "CityPopulationGrowthDialog") else {
            fatalError("cant load CityPopulationGrowthDialog configuration")
        }

        super.init(from: cityPopulationGrowthDialogConfiguration)
        
        // fill fields
        self.set(text: city.name, identifier: "city_name")
        
        self.set(text: "\(city.lastTurnFoodHarvested())", identifier: "food_per_turn_value")
        self.set(text: "\(city.foodConsumption())", identifier: "food_consumption_value")
        // ----------
        self.set(text: "\(city.lastTurnFoodHarvested() - city.foodConsumption())", identifier: "food_surplus_value")
        self.set(text: "\(city.amenitiesModifier(in: gameModel))", identifier: "amenities_modifier_value")
        // ... other growth bonus
        // ----------
        // ... modified food per turn
        self.set(text: "\(city.housingModifier(in: gameModel))", identifier: "housing_modifier_value")
        // ... occupied
        // ----------
        self.set(text: "\(city.lastTurnFoodEarned())", identifier: "total_food_surplus_value")
        // ----------
        self.set(text: "\(city.growthInTurns())", identifier: "growth_in_value")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
