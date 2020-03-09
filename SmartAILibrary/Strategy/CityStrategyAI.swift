//
//  CityStrategyAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class CityStrategyAI {

    let city: AbstractCity?
    let cityStrategyAdoption: CityStrategyAdoption
    var flavors: Flavors
    
    private var buildingProductionAI: BuildingProductionAI?
    private var unitProductionAI: UnitProductionAI?

    // MARK: internal classes

    class CityStrategyAdoptionItem {

        let cityStrategy: CityStrategyType
        var adopted: Bool
        var turnOfAdoption: Int
        
        init(cityStrategy: CityStrategyType, adopted: Bool, turnOfAdoption: Int) {
            
            self.cityStrategy = cityStrategy
            self.adopted = adopted
            self.turnOfAdoption = turnOfAdoption
        }
    }

    class CityStrategyAdoption {

        var adoptions: [CityStrategyAdoptionItem]

        init() {

            self.adoptions = []

            for cityStrategyType in CityStrategyType.all {

                adoptions.append(CityStrategyAdoptionItem(cityStrategy: cityStrategyType, adopted: false, turnOfAdoption: -1))
            }
        }

        func adopted(cityStrategy: CityStrategyType) -> Bool {

            if let item = self.adoptions.first(where: { $0.cityStrategy == cityStrategy }) {

                return item.adopted
            }

            return false
        }

        func turnOfAdoption(of cityStrategy: CityStrategyType) -> Int {

            if let item = self.adoptions.first(where: { $0.cityStrategy == cityStrategy }) {

                return item.turnOfAdoption
            }

            fatalError("cant get turn of adoption - not set")
        }

        func adopt(cityStrategy: CityStrategyType, turnOfAdoption: Int) {

            if let item = self.adoptions.first(where: { $0.cityStrategy == cityStrategy }) {

                item.adopted = true
                item.turnOfAdoption = turnOfAdoption
            }
        }

        func abandon(cityStrategy: CityStrategyType) {

            if let item = self.adoptions.first(where: { $0.cityStrategy == cityStrategy }) {

                item.adopted = false
                item.turnOfAdoption = -1
            }
        }
    }

    // MARK: constructor

    init(city: AbstractCity?) {

        self.city = city
        self.cityStrategyAdoption = CityStrategyAdoption()
        self.flavors = Flavors()
        
        self.buildingProductionAI = BuildingProductionAI(city: city)
        self.unitProductionAI = UnitProductionAI(city: city)
    }
    
    func adopted(cityStrategy: CityStrategyType) -> Bool {
        
        return self.cityStrategyAdoption.adopted(cityStrategy: cityStrategy)
    }

    func turn(with gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }

        guard let city = self.city else {
            fatalError("no city given")
        }

        guard let player = city.player else {
            fatalError("no player given")
        }

        for cityStrategyType in CityStrategyType.all {

            // Minor Civs can't run some Strategies
            // FIXME

            // check tech
            let requiredTech = cityStrategyType.required()
            let isTechGiven = requiredTech == nil ? true : player.has(tech: requiredTech!)
            let obsoleteTech = cityStrategyType.obsolete()
            let isTechObsolete = obsoleteTech == nil ? false : player.has(tech: obsoleteTech!)

            // Do we already have this CityStrategy adopted?
            var shouldCityStrategyStart = true
            if self.cityStrategyAdoption.adopted(cityStrategy: cityStrategyType) {

                shouldCityStrategyStart = false
            } else if !isTechGiven {

                shouldCityStrategyStart = false
            }

            var shouldCityStrategyEnd = false
            if self.cityStrategyAdoption.adopted(cityStrategy: cityStrategyType) {

                // If Strategy is Permanent we can't ever turn it off
                if !cityStrategyType.permanent() {

                    if cityStrategyType.checkEachTurns() > 0 {

                        // Is it a turn where we want to check to see if this Strategy is maintained?
                        if gameModel.turnsElapsed - self.cityStrategyAdoption.turnOfAdoption(of: cityStrategyType) % cityStrategyType.checkEachTurns() == 0 {
                            shouldCityStrategyEnd = true
                        }
                    }

                    if shouldCityStrategyEnd && cityStrategyType.minimumAdoptionTurns() > 0 {

                        // Has the minimum # of turns passed for this Strategy?
                        if gameModel.turnsElapsed < self.cityStrategyAdoption.turnOfAdoption(of: cityStrategyType) + cityStrategyType.minimumAdoptionTurns() {
                            shouldCityStrategyEnd = false
                        }
                    }
                }
            }

            // Check CityStrategy Triggers
            // Functionality and existence of specific CityStrategies is hardcoded here, but data is stored in XML so it's easier to modify
            if shouldCityStrategyStart || shouldCityStrategyEnd {

                // Has the Tech which obsoletes this Strategy? If so, Strategy should be deactivated regardless of other factors
                var strategyShouldBeActive = false

                // Strategy isn't obsolete, so test triggers as normal
                if !isTechObsolete {
                    strategyShouldBeActive = cityStrategyType.shouldBeActive(for: self.city, in: gameModel)
                }

                // This variable keeps track of whether or not we should be doing something (i.e. Strategy is active now but should be turned off, OR Strategy is inactive and should be enabled)
                var bAdoptOrEndStrategy = false

                // Strategy should be on, and if it's not, turn it on
                if strategyShouldBeActive {
                    if shouldCityStrategyStart {

                        bAdoptOrEndStrategy = true
                    } else if shouldCityStrategyEnd {

                        bAdoptOrEndStrategy = false
                    }
                }
                // Strategy should be off, and if it's not, turn it off
                    else {
                        if shouldCityStrategyStart {

                            bAdoptOrEndStrategy = false
                        } else if shouldCityStrategyEnd {

                            bAdoptOrEndStrategy = true
                        }
                }

                if bAdoptOrEndStrategy {

                    if shouldCityStrategyStart {

                        self.cityStrategyAdoption.adopt(cityStrategy: cityStrategyType, turnOfAdoption: gameModel.turnsElapsed)
                    } else if shouldCityStrategyEnd {

                        self.cityStrategyAdoption.abandon(cityStrategy: cityStrategyType)
                    }
                }
            }
        }

        self.updateFlavors()
    }

    func updateFlavors() {

        self.flavors.reset()

        for cityStrategyType in CityStrategyType.all {
            
            if self.cityStrategyAdoption.adopted(cityStrategy: cityStrategyType) {
                
                print("CityStrategy: \(cityStrategyType)")
                
                for cityStrategyTypeFlavor in cityStrategyType.flavorModifiers() {

                    self.flavors += cityStrategyTypeFlavor
                }
            }
        }

        // FIXME: inform sub AI
        for flavorType in FlavorType.all {
            
            var flavorValue = self.flavors.value(of: flavorType)
            
            // limit
            if flavorValue < 0 {
                flavorValue = 0
            }
            
            self.buildingProductionAI?.add(weight: flavorValue, for: flavorType)
            self.unitProductionAI?.add(weight: flavorValue, for: flavorType)
        }
    }
    
    func chooseProduction(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("no game model given")
        }
        
        guard let player = self.city?.player else {
            fatalError("no player given")
        }
        
        guard let city = self.city else {
            fatalError("no city given")
        }
        
        guard let buildingProductionAI = self.buildingProductionAI else {
            fatalError("no buildingProductionAI given")
        }
        
        guard let unitProductionAI = self.unitProductionAI else {
            fatalError("no unitProductionAI given")
        }
        
        let unitsOfPlayer = gameModel.units(of: player)
        let buildables = BuildableItemWeights()
        
        let settlerOnMap = unitsOfPlayer.count(where: { $0?.task == .settle })
        
        // Check units for operations first
        // FIXME
        
        // Loop through adding the available buildings
        for buildingType in BuildingType.all {
            
            if city.canBuild(building: buildingType) {
                
                var weight = buildingProductionAI.weight(for: buildingType)
                let buildableItem = BuildableItem(buildingType: buildingType)
                
                // reweight
                let turnsLeft = city.buildingProductionTurnsLeft(for: buildingType)
                let totalCostFactor = 0.15 /* AI_PRODUCTION_WEIGHT_BASE_MOD */ + 0.004 /* AI_PRODUCTION_WEIGHT_MOD_PER_TURN_LEFT */ * Double(turnsLeft)
                let weightDivisor = pow(Double(turnsLeft), totalCostFactor)
                weight = Int(Double(weight) / weightDivisor)
                
                buildables.add(weight: weight, for: buildableItem)
            }
        }
        
        // Loop through adding the available units
        for unitType in UnitType.all {
            
            if city.canTrain(unit: unitType) {
                
                var weight = unitProductionAI.weight(for: unitType)
                let buildableItem = BuildableItem(unitType: unitType)
                
                // reweight
                let turnsLeft = city.unitProductionTurnsLeft(for: unitType)
                let totalCostFactor = 0.15 /* AI_PRODUCTION_WEIGHT_BASE_MOD */ + 0.004 /* AI_PRODUCTION_WEIGHT_MOD_PER_TURN_LEFT */ * Double(turnsLeft)
                let weightDivisor = pow(Double(turnsLeft), totalCostFactor)
                weight = Int(Double(weight) / weightDivisor)
                
                if unitType.defaultTask() == .settle {
                    
                    if settlerOnMap >= 2 {
                        weight = 0
                    } else {
                        // FIXME: check settle areas
                    }
                }
                
                buildables.add(weight: weight, for: buildableItem)
            }
        }
        
        // Loop through adding the available projects
        for projectType in ProjectType.all {
            
            if city.canBuild(project: projectType) {
                
                // FIXME
            }
        }
        
        buildables.sort()
        if let selection = buildables.chooseFromTopChoices() {
            
            switch selection.type {
                
            case .unit:
                if let unitType = selection.unitType {
                    city.startTraining(unit: unitType)
                }
            case .building:
                if let buildingType = selection.buildingType {
                    city.startBuilding(building: buildingType)
                }
            case .project:
                // FIXME
                break
            }

        }
    }
}
