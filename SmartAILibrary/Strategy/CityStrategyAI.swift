//
//  CityStrategyAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class FlavorList: WeightedList<FlavorType> {
    
    override func fill() {
        for flavorType in FlavorType.all {
            self.add(weight: 0.0, for: flavorType)
        }
    }
}

class YieldList: WeightedList<YieldType> {
    
    override func fill() {
        for yieldType in YieldType.all {
            self.add(weight: 0.0, for: yieldType)
        }
        self.add(weight: 0.0, for: .none)
    }
}

struct YieldValue: Comparable {

    let location: HexPoint
    let value: Double
    
    static func < (lhs: YieldValue, rhs: YieldValue) -> Bool {
        return lhs.value > rhs.value
    }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvCityStrategyAI
//!  \brief        Manages operations for a single city in the game world
//
//!  Key Attributes:
//!  - One instance for each city
//!  - Receives instructions from other AI components (usually as flavor changes) to
//!    specialize, switch production, etc.
//!  - Oversees both the city governor AI and the AI managing what the city is building
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class CityStrategyAI {

    let city: AbstractCity?
    let cityStrategyAdoption: CityStrategyAdoption
    var flavors: Flavors
    var focusYield: YieldType
    
    private var buildingProductionAI: BuildingProductionAI?
    private var unitProductionAI: UnitProductionAI?
    
    
    
    private var defaultSpecializationValue: CitySpecializationType
    private var specializationValue: CitySpecializationType
    private var flavorWeights: FlavorList
    
    private var bestYieldAverage: YieldList
    private var yieldDeltaValue: YieldList

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
        self.focusYield = .none
        
        self.buildingProductionAI = BuildingProductionAI(city: city)
        self.unitProductionAI = UnitProductionAI(city: city)
        
        self.specializationValue = .generalEconomic
        self.defaultSpecializationValue = .generalEconomic
        self.flavorWeights = FlavorList()
        self.flavorWeights.fill()
        
        self.bestYieldAverage = YieldList()
        self.bestYieldAverage.fill()
        
        self.yieldDeltaValue = YieldList()
        self.yieldDeltaValue.fill()
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
                
                //print("CityStrategy: \(cityStrategyType)")
                
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
        
        let settlerOnMap = unitsOfPlayer.count(where: { $0!.has(task: .settle) })
        
        // Check units for operations first
        // FIXME
        
        // Loop through adding the available buildings
        for buildingType in BuildingType.all {
            
            if city.canBuild(building: buildingType) {
                
                var weight: Double = Double(buildingProductionAI.weight(for: buildingType))
                let buildableItem = BuildableItem(buildingType: buildingType)
                
                // reweight
                let turnsLeft = city.buildingProductionTurnsLeft(for: buildingType)
                let totalCostFactor = 0.15 /* AI_PRODUCTION_WEIGHT_BASE_MOD */ + 0.004 /* AI_PRODUCTION_WEIGHT_MOD_PER_TURN_LEFT */ * Double(turnsLeft)
                let weightDivisor = pow(Double(turnsLeft), totalCostFactor)
                weight = weight / weightDivisor
                
                buildables.add(weight: weight, for: buildableItem)
            }
        }
        
        // Loop through adding the available units
        for unitType in UnitType.all {
            
            if city.canTrain(unit: unitType) {
                
                var weight = Double(unitProductionAI.weight(for: unitType))
                let buildableItem = BuildableItem(unitType: unitType)
                
                // reweight
                let turnsLeft = city.unitProductionTurnsLeft(for: unitType)
                let totalCostFactor = 0.15 /* AI_PRODUCTION_WEIGHT_BASE_MOD */ + 0.004 /* AI_PRODUCTION_WEIGHT_MOD_PER_TURN_LEFT */ * Double(turnsLeft)
                let weightDivisor = pow(Double(turnsLeft), totalCostFactor)
                weight = Double(weight) / weightDivisor
                
                if unitType.defaultTask() == .settle {
                    
                    if settlerOnMap >= 2 {
                        weight = 0.0
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
                
            case .wonder:
                if let wonderType = selection.wonderType {
                    city.startBuilding(wonder: wonderType)
                }
                
            case .district:
                if let districtType = selection.districtType {
                    city.startBuilding(district: districtType)
                }
            case .project:
                // FIXME
                break
            }
        }
    }
    
    func updateBestYields(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        guard let player = city.player else {
            fatalError("cant get player")
        }
        
        guard let cityStrategy = city.cityStrategy else {
            fatalError("cant get cityStrategy")
        }
        
        guard let cityCitizens = city.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        guard let buildings = city.buildings else {
            fatalError("cant get buildings")
        }
        
        self.focusYield = .none

        self.resetBestYields()

        let populationToEvaluate = city.population() + 2
        
        var bestFoodYields: [YieldValue] = []
        var bestProductionYields: [YieldValue] = []
        var bestGoldYields: [YieldValue] = []

        for workingTileLocation in cityCitizens.workingTileLocations() {
 
            guard let workingTile = gameModel.tile(at: workingTileLocation) else {
                continue
            }
            
            if workingTile.workingCity()?.location != city.location {
                continue
            }
            
            let yields = workingTile.yields(ignoreFeature: false)
            bestFoodYields.append(YieldValue(location: workingTileLocation, value: yields.food))
            bestProductionYields.append(YieldValue(location: workingTileLocation, value: yields.production))
            bestGoldYields.append(YieldValue(location: workingTileLocation, value: yields.gold))
        }

        bestFoodYields.sort()
        bestProductionYields.sort()
        bestGoldYields.sort()

        let slotsToEvaluate = min(bestFoodYields.count, populationToEvaluate)
        if slotsToEvaluate <= 0 {
            return
        }
        
        // add in additional food from the city plot and the city buildings that provide food
        let buildingFood = BuildingType.all.map({ buildings.has(building: $0) ? $0.yields().food : 0.0 }).reduce(0.0, +)
        self.bestYieldAverage.set(weight: (bestFoodYields.map({ $0.value }).reduce(0.0, +) + buildingFood) / Double(slotsToEvaluate), for: .food)
        
        self.bestYieldAverage.set(weight: bestProductionYields.map({ $0.value }).reduce(0.0, +) / Double(slotsToEvaluate), for: .production)
        self.bestYieldAverage.set(weight: bestGoldYields.map({ $0.value }).reduce(0.0, +) / Double(slotsToEvaluate), for: .gold)
        
        var specialization: CitySpecializationType = cityStrategy.specialization()
        if cityStrategy.specialization() == .none {
            
            if player.isHuman() {
                
                // find a specialization type according to the citizen focus type
                let focusType = cityCitizens.focusType()

                if focusType == .food {
                    specialization = .settlerPump
                } else if focusType == .gold {
                    specialization = .commerce
                }
            }

            // if the human did not have a city ai specialization
            if specialization == .none {
                specialization = .generalEconomic
            }
        }
        
        self.yieldDeltaValue.set(weight: self.bestYieldAverage.weight(of: .food), for: .food)
        self.yieldDeltaValue.set(weight: self.bestYieldAverage.weight(of: .production), for: .production)
        self.yieldDeltaValue.set(weight: self.bestYieldAverage.weight(of: .gold), for: .gold)

        self.focusYield = specialization.yieldType() ?? .none
    }
    
    private func resetBestYields() {
        
        self.bestYieldAverage = YieldList()
        self.bestYieldAverage.fill()
        
        self.yieldDeltaValue = YieldList()
        self.yieldDeltaValue.fill()
    }
    
    /// Set special production emphasis for this city
    @discardableResult
    func setSpecialization(to type: CitySpecializationType) -> Bool {
        
        if self.specializationValue != type {
          
            self.specializationValue = type
            
            // Clear out Temp array and fill
            for flavorType in FlavorType.all {

                self.flavorWeights.set(weight: Double(type.flavorModifier(for: flavorType)), for: flavorType)
            }

            return true
        }
        
        return false
    }
    
    func defaultSpecialization() -> CitySpecializationType {
        
        return self.defaultSpecializationValue
    }
    
    func updateDefaultSpecialization(to value: CitySpecializationType) {
        
        self.defaultSpecializationValue = value
    }
    
    func specialization() -> CitySpecializationType {
        
        return self.specializationValue
    }
    
    // Determines what yield type is in a deficient state. If none, then NO_YIELD is returned
    func deficientYield(in gameModel: GameModel?) -> YieldType {
        
        if self.isDeficient(for: .food) {
            return .food
        } else if self.isDeficient(for: .production) {
            return .production
        }
        
        return .none
    }
    
    func isDeficient(for yieldType: YieldType) -> Bool {
        
        var desiredYield = self.deficientYieldValue(for: yieldType)
        var yieldAverage = self.yieldAverage(for: yieldType)

        desiredYield = round(desiredYield * 100.0)
        yieldAverage = round(yieldAverage * 100.0)

        return yieldAverage < desiredYield
    }
    
    /// Get the average value of the yield for this city
    func yieldAverage(for yieldType: YieldType) -> Double {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        guard let player = city.player else {
            fatalError("cant get player")
        }
        
        guard let cityCitizens = city.cityCitizens else {
            fatalError("cant get cityCitizens")
        }

        var tilesWorked = 0
        var yieldAmount = 0.0
        
        for plot in player.plots {

            guard let plot = plot else {
                continue
            }
            
            if !cityCitizens.isWorked(at: plot.point) {
                continue;
            }

            tilesWorked += 1
            yieldAmount += plot.yields(ignoreFeature: false).value(of: yieldType)
        }

        var ratio = 0.0;
        if tilesWorked > 0 {
            ratio = yieldAmount / Double(tilesWorked)
        }

        return ratio
    }
    
    /// Get the deficient value of the yield for this city
    func deficientYieldValue(for yieldType: YieldType) -> Double {

        switch yieldType {

        case .none: return -999.0
            
        case .food: return 2.0 // AI_CITYSTRATEGY_YIELD_DEFICIENT_FOOD
        case .production: return 0.8 // AI_CITYSTRATEGY_YIELD_DEFICIENT_PRODUCTION
        case .gold: return 0.0 // AI_CITYSTRATEGY_YIELD_DEFICIENT_GOLD
        case .science: return 0.0 // AI_CITYSTRATEGY_YIELD_DEFICIENT_SCIENCE
        }
    }
    
    func yieldDelta(for yieldtype: YieldType) -> Double {
        
        return self.yieldDeltaValue.weight(of: yieldtype)
    }
}
