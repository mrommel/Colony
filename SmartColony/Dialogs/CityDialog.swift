//
//  CityDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class CityDialog: Dialog {
    
    weak var city: AbstractCity?
    
    init(for city: AbstractCity?, in gameModel: GameModel?) {
    
        self.city = city
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let uiParser = UIParser()
        guard let cityDialogConfiguration = uiParser.parse(from: "CityDialog") else {
            fatalError("cant load cityDialogConfiguration configuration")
        }
        
        super.init(from: cityDialogConfiguration)
        
        // fill fields
        self.set(text: city.name, identifier: "city_name")
        self.set(text: "\(city.population())", identifier: "population_value")
        
        self.set(yieldValue: city.foodPerTurn(in: gameModel), identifier: "food_yield")
        self.set(yieldValue: city.productionPerTurn(in: gameModel), identifier: "production_yield")
        self.set(yieldValue: city.goldPerTurn(in: gameModel), identifier: "gold_yield")
        self.set(yieldValue: city.sciencePerTurn(in: gameModel), identifier: "science_yield")
        self.set(yieldValue: city.culturePerTurn(in: gameModel), identifier: "culture_yield")
        self.set(yieldValue: city.faithPerTurn(in: gameModel), identifier: "faith_yield")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
