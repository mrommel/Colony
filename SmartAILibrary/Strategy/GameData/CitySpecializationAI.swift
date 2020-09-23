//
//  CitySpecializationAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum ProductionSpecialization: Int, Equatable, Codable {

    case none
    
    case militaryTraining // PRODUCTION_SPECIALIZATION_MILITARY_TRAINING
    case emergencyUnits // PRODUCTION_SPECIALIZATION_EMERGENCY_UNITS
    case militaryNaval // PRODUCTION_SPECIALIZATION_MILITARY_NAVAL
    case wonder // PRODUCTION_SPECIALIZATION_WONDER
    case spaceship // PRODUCTION_SPECIALIZATION_SPACESHIP
    
    static var all: [ProductionSpecialization] {
    
        return [.militaryTraining, .emergencyUnits, .militaryNaval, .wonder, .spaceship]
    }
}

class ProductionSpecializationList: WeightedList<ProductionSpecialization> {
    
    override func fill() {
        for productionSpecialization in ProductionSpecialization.all {
            self.add(weight: 0.0, for: productionSpecialization)
        }
    }
}

class CitySpecializationData {

    let city: AbstractCity?
    let weight: YieldList
    
    init(city: AbstractCity?) {
        self.city = city
        self.weight = YieldList()
        self.weight.fill()
    }
}

class CitySpecializationList: WeightedList<CitySpecializationType> {
    
    override func fill() {
        for citySpecializationType in CitySpecializationType.all {
            self.add(weight: 0.0, for: citySpecializationType)
        }
        self.add(weight: 0.0, for: .none)
    }
}

public class CitySpecializationAI {
    
    var player: Player?
    private var lastTurnEvaluated: Int  = 0
    private var specializationsDirty: Bool = false
    private var interruptWonders: Bool = false
    private var yieldWeights: YieldList
    
    private var wonderChosen: Bool = false
    private var wonderCity: AbstractCity? = nil
    private var specializationsNeeded: [CitySpecializationType] = []
    private var productionSubtypeWeights: ProductionSpecializationList
    private var nextSpecializationDesired: CitySpecializationType
    
    private var nextWonderWeight: Int
    private var nextWonderDesiredValue: WonderType
    
    private var numSpecializationsForThisYield: YieldList
    private var numSpecializationsForThisSubtype: ProductionSpecializationList
    
    private var bestValue: YieldList
    
    // MARK: constructors

    init(player: Player?) {

        self.player = player
        
        self.yieldWeights = YieldList()
        self.yieldWeights.fill()
        self.productionSubtypeWeights = ProductionSpecializationList()
        self.nextSpecializationDesired = .none
        
        self.nextWonderWeight = 0
        self.nextWonderDesiredValue = .none
        
        self.numSpecializationsForThisYield = YieldList()
        self.numSpecializationsForThisYield.fill()
        self.numSpecializationsForThisSubtype = ProductionSpecializationList()
        self.numSpecializationsForThisSubtype.fill()
        
        self.bestValue = YieldList()
        self.bestValue.fill()
    }
    
    func turn(in gameModel: GameModel?) {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let wonderProductionAI = player.wonderProductionAI else {
            fatalError("cant get wonderProductionAI")
        }
        
        // No city specializations for humans!
        guard !player.isHuman() else {
            return
        }

        // No city specializations early in the game
        if gameModel.currentTurn < 25 { /* AI_CITY_SPECIALIZATION_EARLIEST_TURN */
            return
        }

        // No city specialization if we don't have any cities
        if gameModel.cities(of: player).count < 1 {
            return
        }

        // See if need to update assignments
        if self.specializationsDirty || self.lastTurnEvaluated + 50 /* AI_CITY_SPECIALIZATION_REEVALUATION_INTERVAL */ > gameModel.currentTurn {

            (self.nextWonderDesiredValue, self.nextWonderWeight) = wonderProductionAI.chooseWonder(adjustForOtherPlayers: true, nextWonderWeight: self.nextWonderWeight, in: gameModel)
            
            self.weightSpecializations(in: gameModel)
            self.assignSpecializations(in: gameModel)
            
            self.specializationsDirty = false
            self.lastTurnEvaluated = gameModel.currentTurn

            // Do we need to choose production again at all our cities?
            if self.interruptWonders {
                
                for cityRef in gameModel.cities(of: player) {
                    
                    guard cityRef != nil else {
                        continue
                    }
                    
                    fatalError("niy")
                    /*if !city.isBuildingUnitForOperation() {
                        city.chooseProduction(interruptWonders: true)
                    }*/
                }
            }

            // Reset this flag -- need a new high priority event before we'll interrupt again
            self.interruptWonders = false
        }
    }
    
    /// Evaluate which specializations we need
    private func weightSpecializations(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let economicAI = player.economicAI else {
            fatalError("cant get economicAI")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        var foodYieldWeight = 0.0
        var productionYieldWeight = 0.0
        var goldYieldWeight = 0.0
        var scienceYieldWeight = 0.0
        //var generalEconomicWeight = 0.0

        // Clear old weights
        self.yieldWeights = YieldList()
        self.yieldWeights.fill()
        self.productionSubtypeWeights.items.removeAll()

        // Must have a capital to do any specialization
        if let capital = gameModel.capital(of: player), let capitalArea = gameModel.area(of: capital.location) {
            
            let flavorExpansion = max(0.0, Double(player.valueOfPersonalityFlavor(of: .expansion)))
            let flavorWonder = max(0.0, Double(player.valueOfPersonalityFlavor(of: .wonder)))
            let flavorGold = max(0.0, Double(player.valueOfPersonalityFlavor(of: .gold)))
            let flavorScience = max(0.0, Double(player.valueOfPersonalityFlavor(of: .science)))
            let flavorSpaceship = 0.0 // player.valueOfPersonalityFlavor(of: .sp)

            // COMPUTE NEW WEIGHTS

            //   Food
            let tilesInCapitalArea = gameModel.tiles(in: capitalArea)
            let numUnownedTiles = tilesInCapitalArea.filter({ !($0?.hasOwner() ?? true) }).count
            let numCities = gameModel.cities(of: player).count
            let numSettlers = gameModel.units(of: player).count(where: { $0!.task() == .settle })
            
            if economicAI.adopted(economicStrategy: .earlyExpansion) {
                foodYieldWeight += 500.0 /* AI_CITY_SPECIALIZATION_FOOD_WEIGHT_EARLY_EXPANSION */
            }
            foodYieldWeight += flavorExpansion * 5.0 /* AI_CITY_SPECIALIZATION_FOOD_WEIGHT_FLAVOR_EXPANSION */
            foodYieldWeight += (Double(numUnownedTiles) * 100.0) / Double(tilesInCapitalArea.count) * 5.0  /* AI_CITY_SPECIALIZATION_FOOD_WEIGHT_PERCENT_CONTINENT_UNOWNED */
            foodYieldWeight += Double(numCities) * -50.0 /* AI_CITY_SPECIALIZATION_FOOD_WEIGHT_NUM_CITIES */
            foodYieldWeight += Double(numSettlers) * -40.0 /* AI_CITY_SPECIALIZATION_FOOD_WEIGHT_NUM_SETTLERS */
            
            if numCities + numSettlers == 1 {
                foodYieldWeight *= 3.0  // Really want to get up over 1 city
            }
            
            if foodYieldWeight < 0.0 {
                foodYieldWeight = 0.0
            }

            //   Production
            productionYieldWeight = Double(self.weightProductionSubtypes(flavorWonder: Int(flavorWonder), flavorSpaceship: Int(flavorSpaceship), in: gameModel))

            //   Trade
            let landDisputeLevel = diplomacyAI.totalLandDisputeLevel(in: gameModel)
            goldYieldWeight += flavorGold * 20.0 /* AI_CITY_SPECIALIZATION_GOLD_WEIGHT_FLAVOR_GOLD */
            goldYieldWeight += Double(landDisputeLevel) * 10.0 /* AI_CITY_SPECIALIZATION_GOLD_WEIGHT_LAND_DISPUTE */

            //   Science
            scienceYieldWeight += flavorScience * 20.0 /* AI_CITY_SPECIALIZATION_SCIENCE_WEIGHT_FLAVOR_SCIENCE */
            scienceYieldWeight += flavorSpaceship * 10.0 /* AI_CITY_SPECIALIZATION_SCIENCE_WEIGHT_FLAVOR_SPACESHIP */

            //   General Economics
            //let generalEconomicWeight = 200.0 /* AI_CITY_SPECIALIZATION_GENERAL_ECONOMIC_WEIGHT */

            //   Add in any contribution from the current grand strategy
            for grandStrategyType in GrandStrategyAIType.all {
                
                if player.grandStrategyAI?.activeStrategy == grandStrategyType {
                    foodYieldWeight += grandStrategyType.yields().food
                    goldYieldWeight += grandStrategyType.yields().gold
                    scienceYieldWeight += grandStrategyType.yields().science
                }
            }

            // Add weights to our weighted vector
            self.yieldWeights.set(weight: foodYieldWeight, for: .food)
            self.yieldWeights.set(weight: productionYieldWeight, for: .production)
            self.yieldWeights.set(weight: goldYieldWeight, for: .gold)
            self.yieldWeights.set(weight: scienceYieldWeight, for: .science)
        }

        return
    }
    
    /// Assign specializations to cities
    func assignSpecializations(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var citiesWithoutSpecialization: [CitySpecializationData] = []
        
        self.nextSpecializationDesired = .none
        // citiesWithoutSpecialization.removeAll()

        let wonderSpecialiation = self.wonderSpecialization()

        // Find specializations needed (including for the next city we build)
        self.selectSpecializations(in: gameModel)

        // OBVIOUS ASSIGNMENTS: Loop through our cities making obvious assignments
        for loopCity in gameModel.cities(of: player) {

            guard let loopCityStrategy = loopCity?.cityStrategy else {
                continue
            }
            
            guard let loopCityLocation = loopCity?.location else {
                continue
            }
            
            // If this is the city to build our current wonder in, mark all that
            if self.wonderChosen && loopCity?.location == self.wonderCity?.location {
                
                if self.specializationsNeeded.contains(wonderSpecialiation) {
                    self.specializationsNeeded.removeAll(where: { $0 == wonderSpecialiation })
                    loopCityStrategy.setSpecialization(to: wonderSpecialiation)
                    continue
                }
            }

            // If city default is equal to a needed type, go with that
            var specialization = loopCityStrategy.defaultSpecialization()
            if self.specializationsNeeded.contains(specialization) {

                self.specializationsNeeded.removeAll(where: { $0 == specialization })
                loopCityStrategy.setSpecialization(to: specialization)
            } else {
                // If cities' current specialization is needed, stick with that
                specialization = loopCityStrategy.specialization()
                if self.specializationsNeeded.contains(specialization) {
                    self.specializationsNeeded.removeAll(where: { $0 == specialization })
                    loopCityStrategy.setSpecialization(to: specialization)
                } else {
                    // Save this city off (with detailed data about what it is good at) to assign later
                    let cityData = CitySpecializationData(city: loopCity)
                    
                    // food
                    let foodValue = max(0.0, self.plotValueFor(yield: .food, at: loopCityLocation, in: gameModel))
                    // AdjustValueBasedOnBuildings(pLoopCity, (YieldTypes)iI, cityData.m_iWeight[iI]);
                    cityData.weight.set(weight: foodValue, for: .food)
                    
                    // production
                    let productionValue = max(0.0, self.plotValueFor(yield: .production, at: loopCityLocation, in: gameModel))
                    // AdjustValueBasedOnBuildings(pLoopCity, (YieldTypes)iI, cityData.m_iWeight[iI]);
                    cityData.weight.set(weight: productionValue, for: .production)
                    
                    // gold
                    let goldValue = max(0.0, self.plotValueFor(yield: .gold, at: loopCityLocation, in: gameModel))
                    // AdjustValueBasedOnBuildings(pLoopCity, (YieldTypes)iI, cityData.m_iWeight[iI]);
                    cityData.weight.set(weight: goldValue, for: .gold)
                    
                    // science
                    let scienceValue = max(0.0, self.plotValueForScience(at: loopCityLocation, in: gameModel))
                    // AdjustValueBasedOnBuildings(pLoopCity, (YieldTypes)iI, cityData.m_iWeight[iI]);
                    cityData.weight.set(weight: scienceValue, for: .science)

                    citiesWithoutSpecialization.append(cityData)
                }
            }
        }

        // NEXT SPECIALIZATION NEEDED: Now figure out what we want to assign as our "next specialization needed"

        // If only one specialization left, it's easy
        if citiesWithoutSpecialization.isEmpty {
            if let firstSpecializationsNeeded = self.specializationsNeeded.first {
                self.nextSpecializationDesired = firstSpecializationsNeeded
                return
            }
        }

        // If all specializations left are "general economic", set that as next needed
        var allGeneral = true
        for specializationNeeded in self.specializationsNeeded {

            if specializationNeeded != self.economicDefaultSpecialization() {
                allGeneral = false
            }
        }

        if allGeneral {
            self.nextSpecializationDesired =  self.economicDefaultSpecialization()
            self.specializationsNeeded.removeAll(where: { $0 == self.specializationsNeeded.first })
        } else {
            // Find best possible sites for each of the yield types
            self.findBestSites(in: gameModel)

            // Compute the yield which we can improve the most with a new city
            //int iCurrentDelta;
            let bestDelta: YieldList = YieldList()
            bestDelta.fill()
            
            for cityWithoutSpecialization in citiesWithoutSpecialization {
                
                for yieldType in YieldType.all {
                    let currentDelta = cityWithoutSpecialization.weight.weight(of: yieldType) - bestValue.weight(of: yieldType)
                    if currentDelta > bestDelta.weight(of: yieldType) {
                        bestDelta.set(weight: currentDelta, for: yieldType)
                    }
                }
            }

            // Save yield improvements in a vector we can sort
            let yieldImprovements: YieldList = YieldList()
            yieldImprovements.fill()
            
            for yieldType in YieldType.all {
                if bestDelta.weight(of: yieldType) > 0 {
                    yieldImprovements.set(weight: 0.0, for: yieldType)
                } else {
                    yieldImprovements.set(weight: -bestDelta.weight(of: yieldType), for: yieldType)
                }
            }
            yieldImprovements.sort()

            // Take them out in order and see if we need this specialization
            var foundIt = false
            
            for mostImprovedYield in yieldImprovements.items {
                
                // Loop through needed specializations until we find one that matches
                for specializationNeeded in self.specializationsNeeded {
                    
                    let yieldType = specializationNeeded.yieldType()
                    if yieldType == mostImprovedYield.itemType {
                        self.nextSpecializationDesired = specializationNeeded
                        self.specializationsNeeded.removeAll(where: { $0 == specializationNeeded })
                        foundIt = true
                        break
                    }
                }
                
                if foundIt {
                    break
                }
            }
        }

        // REMAINING ASSIGNMENTS: Make the rest of the assignments
        for specializationNeeded in self.specializationsNeeded {

            let yieldType = specializationNeeded.yieldType()
            let coastal = specializationNeeded.mustBeCoastal()
            var bestCity = citiesWithoutSpecialization.last

            // Pick best existing city based on a better computation of existing city's value for a yield type
            var bestValue = -1.0
            for cityWithoutSpecialization in citiesWithoutSpecialization {

                if coastal {
                    
                    guard let city = cityWithoutSpecialization.city else {
                        continue
                    }
                    
                    if !gameModel.isCoastal(at: city.location)  {
                        continue
                    }
                }

                if yieldType == YieldType.none || yieldType == nil {
                    // General economic is all yields added together
                    var cityValue = 0.0
                    
                    for yieldTypeIterator in YieldType.all {
                        cityValue += cityWithoutSpecialization.weight.weight(of: yieldTypeIterator)
                    }
                    
                    if cityValue > bestValue {
                        bestValue = cityValue
                        bestCity = cityWithoutSpecialization
                    }
                } else {
                    if cityWithoutSpecialization.weight.weight(of: yieldType!) > bestValue {
                        bestValue = cityWithoutSpecialization.weight.weight(of: yieldType!)
                        bestCity = cityWithoutSpecialization
                    }
                }
            }

            // Found a city to set
            if bestCity?.city?.location != citiesWithoutSpecialization.last?.city?.location {
                
                if let city = bestCity?.city {
                
                    city.cityStrategy?.setSpecialization(to: specializationNeeded)
                    citiesWithoutSpecialization.removeAll(where: { $0.city?.location == bestCity?.city?.location })
                }
            } else {
                // No (coastal) city found, use default specialization as last resort
                if let city = citiesWithoutSpecialization.first?.city {
                    city.cityStrategy?.setSpecialization(to: self.economicDefaultSpecialization())
                    citiesWithoutSpecialization.removeAll(where: { $0.city?.location == city.location })
                }
            }
        }

        return
    }
    
    /// Find the best nearby city site for all yield types
    func findBestSites(in gameModel: GameModel?) {
     
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var plotValue: Double = 0.0
        
        // Clear output
        for yieldType in YieldType.all {
            self.bestValue.set(weight: 0.0, for: yieldType)
        }

        // Found value drops off based on distance, so safe to only look halfway out
        let evalDistance = 30 /* SETTLER_EVALUATION_DISTANCE */ / 2

        let citySiteEvaluator = gameModel.citySiteEvaluator()
        
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    if citySiteEvaluator.canCityBeFound(on: tile, by: self.player) {
                        
                        // Check if within range of any of our cities
                        // pNearestCity = GC.getMap().findCity(pPlot->getX(), pPlot->getY(), m_pPlayer->GetID(), NO_TEAM, true /* bSameArea */);
                        if let nearestCity: AbstractCity = gameModel.nearestCity(at: pt, of: self.player) {
                            
                            if pt.distance(to: nearestCity.location) <= evalDistance {
                                
                                for yieldType in YieldType.all {
                                    
                                    if yieldType != .science {
                                        plotValue = self.plotValueFor(yield: yieldType, at: pt, in: gameModel)
                                    } else {
                                        plotValue = self.plotValueForScience(at: pt, in: gameModel)
                                    }

                                    if plotValue > self.bestValue.weight(of: yieldType) {
                                        self.bestValue.set(weight: plotValue, for: yieldType)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //LogBestSites();

        return
    }
    
    /// Find specializations needed (including for the next city we build)
    func selectSpecializations(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        let specializationsToAssign = gameModel.cities(of: player).count + 1
        var oldWeight = 0.0
        var reductionAmount = 0.0

        self.specializationsNeeded.removeAll()
        self.wonderChosen = false

        // Clear info about what we've picked
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .none)
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .food)
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .production)
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .gold)
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .science)
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .culture)
        self.numSpecializationsForThisYield.set(weight: 0.0, for: .faith)

        for productionSpecialization in ProductionSpecialization.all {
            self.numSpecializationsForThisSubtype.set(weight: 0.0, for: productionSpecialization)
        }

        var wonderType: WonderType? = nil
        if let wonderBuildCity = self.wonderBuildCity() {
            if wonderBuildCity.currentBuildableItem()?.type == .wonder {
                wonderType = wonderBuildCity.currentBuildableItem()?.wonderType
            }
        }

        // Do we have a wonder build in progress that we can't interrupt?
        if !self.interruptWonders && wonderType != nil {
            
            self.specializationsNeeded.append(self.wonderSpecialization())
            self.numSpecializationsForThisYield.add(weight: 1.0, for: .production)
            oldWeight = self.yieldWeights.weight(of: .production)
            reductionAmount = self.productionSubtypeWeights.weight(of: self.wonderSubtype())
            self.yieldWeights.set(weight: oldWeight - reductionAmount, for: .production)

            // Only one wonder at a time, so zero out the weight for this subtype entirely
            self.productionSubtypeWeights.set(weight: 0.0, for: self.wonderSubtype())
            self.wonderChosen = true
        } else {
            self.wonderCity = nil
        }

        // LOOP as many times as we have cities PLUS ONE
        while self.specializationsNeeded.count < specializationsToAssign {
            
            // Find highest weighted specialization
            self.yieldWeights.sort()

            // Mark that we need one city of this type
            guard let yield = self.yieldWeights.items.first else {
                fatalError("explode")
            }
            
            var tmpCitySpecializationType: CitySpecializationType = .none
            
            if self.numSpecializationsForThisYield.weight(of: yield.itemType) > 1.0 {
                
                if yield.itemType == .production {
                    tmpCitySpecializationType = self.selectProductionSpecialization(reductionAmount: &reductionAmount)

                    let oldWeight = yield.weight
                    self.numSpecializationsForThisYield.add(weight: 1, for: yield.itemType)
                    let newWeight = oldWeight - reductionAmount
                    self.yieldWeights.set(weight: newWeight, for: yield.itemType)
                }
            } else {
                tmpCitySpecializationType = self.firstSpecialization(for: yield.itemType)

                // Reduce weight for this specialization based on dividing original weight by <num of this type + 1>
                let oldWeight = yield.weight
                self.numSpecializationsForThisYield.add(weight: 1, for: yield.itemType)
                let newWeight = oldWeight * self.numSpecializationsForThisYield.weight(of: yield.itemType) / (self.numSpecializationsForThisYield.weight(of: yield.itemType) + 1.0)
                self.yieldWeights.set(weight: newWeight, for: yield.itemType)
            }
            
            self.specializationsNeeded.append(tmpCitySpecializationType)
        }
    }
    
    func firstSpecialization(for yieldType: YieldType) -> CitySpecializationType {
        
        for citySpecializationType in CitySpecializationType.all {
            if let citySpecializationTypeYieldType = citySpecializationType.yieldType() {
                if citySpecializationTypeYieldType == yieldType {
                    return citySpecializationType
                }
            }
        }
        
        return .generalEconomic
    }
    
    /// Find production specializations needed
    func selectProductionSpecialization(reductionAmount: inout Double) -> CitySpecializationType {
         
        var specialization: CitySpecializationType = .none

        // Find highest weighted subtype
        self.productionSubtypeWeights.sort()

        let subtype: ProductionSpecialization = self.productionSubtypeWeights.chooseBest() ?? .militaryTraining

        // If this is the wonder type, make sure we have a city to build it
        if subtype == .wonder {
            
            if let city = self.findBestWonderCity() {
                self.wonderCity = city
                self.wonderChosen = true
            } else {
                // No wonder city, substitute default specialization instead
                specialization = .generalEconomic
            }
            
            reductionAmount = self.productionSubtypeWeights.weight(of: subtype)
            self.productionSubtypeWeights.set(weight: 0.0, for: subtype)
            
        } else {
            // Reduce weight for this subtype based on dividing original weight by <num of this type + 1>
            let oldWeight = self.productionSubtypeWeights.weight(of: subtype)
            self.numSpecializationsForThisSubtype.add(weight: 1, for: subtype)
            let newWeight = oldWeight * self.numSpecializationsForThisSubtype.weight(of: subtype) / (self.numSpecializationsForThisSubtype.weight(of: subtype) + 1.0)
            reductionAmount = oldWeight - newWeight
            self.productionSubtypeWeights.set(weight: newWeight, for: subtype)
        }

        return specialization
    }
    
    func findBestWonderCity() -> AbstractCity? {
        
        return nil
    }
    
    func wonderBuildCity() -> AbstractCity? {
    
        return self.wonderCity
    }
    
    func wonderSubtype() -> ProductionSpecialization {
        
        fatalError("niy")
    }
    
    /// Evaluate strength of a city plot for providing science
    func plotValueForScience(at location: HexPoint, in gameModel: GameModel?) -> Double {
    
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // Roughly half of weight comes from food yield
        // The other half will be are there open tiles we can easily build schools on
        var totalFoodYield = 0
        var totalClearTileWeight = 0
        var multiplier = 0
        var potentialYield = 0.0
        let firstRingMultiplier = 8 // AI_CITY_SPECIALIZATION_YIELD_WEIGHT_FIRST_RING
        let secondRingMultiplier = 5 // AI_CITY_SPECIALIZATION_YIELD_WEIGHT_SECOND_RING
        let thirdRingMultiplier = 2 // AI_CITY_SPECIALIZATION_YIELD_WEIGHT_THIRD_RING

        // Evaluate potential from plots not currently being worked
        for loopPoint in location.areaWith(radius: 2) {
        
            if loopPoint == location {
                continue
            }
            
            guard let loopPlot = gameModel.tile(at: loopPoint) else {
                continue
            }
            
            var isClear = false
            
            if !loopPlot.hasAnyResource(for: player) {
                if !loopPlot.hasAnyFeature() {
                    if !loopPlot.hasHills() {
                        if loopPlot.improvement() == .none {
                            isClear = true
                        }
                    }
                }
            }

            potentialYield = loopPlot.yields(for: self.player, ignoreFeature: false).food + loopPlot.yields(for: self.player, ignoreFeature: false).science

            // If owned by someone else, not worth anything
            if loopPlot.hasOwner() && loopPlot.owner()?.leader != self.player?.leader {
                multiplier = 0
            } else {
                let distance = loopPoint.distance(to: location)
                if distance == 1 {
                    multiplier = firstRingMultiplier
                } else if distance == 2 {
                    multiplier = secondRingMultiplier
                } else if distance == 3 {
                    multiplier = thirdRingMultiplier
                }
            }

            totalFoodYield += Int(potentialYield) * multiplier
            if isClear {
                totalClearTileWeight += multiplier
            }
        }
 
        return Double(totalFoodYield + totalClearTileWeight)
    }
    
    /// Evaluate strength of an existing city for providing a specific type of yield (except Science!)
    func plotValueFor(yield: YieldType, at location: HexPoint, in  gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var totalPotentialYield = 0.0
        var multiplier = 0.0
        var potentialYield = 0.0
        let firstRingMultiplier = 8.0 // AI_CITY_SPECIALIZATION_YIELD_WEIGHT_FIRST_RING
        let secondRingMultiplier = 5.0 // AI_CITY_SPECIALIZATION_YIELD_WEIGHT_SECOND_RING
        let thirdRingMultiplier = 2.0 // AI_CITY_SPECIALIZATION_YIELD_WEIGHT_THIRD_RING

        // Evaluate potential from plots not currently being worked
        for loopPoint in location.areaWith(radius: 2) {
        
            if loopPoint == location {
                continue
            }
            
            guard let loopPlot = gameModel.tile(at: loopPoint) else {
                continue
            }
            
            potentialYield = loopPlot.yields(for: self.player, ignoreFeature: false).value(of: yield)

            // If owned by someone else, not worth anything
            if loopPlot.hasOwner() && loopPlot.owner()?.leader != self.player?.leader {
                multiplier = 0.0
            } else {
                let distance = loopPoint.distance(to: location)
                if distance == 1 {
                    multiplier = firstRingMultiplier
                } else if distance == 2 {
                    multiplier = secondRingMultiplier
                } else if distance == 3 {
                    multiplier = thirdRingMultiplier
                }
            }
            
            totalPotentialYield += potentialYield * multiplier
        }

        return totalPotentialYield
    }
    
    /// Find the specialization type for building wonders
    func economicDefaultSpecialization() -> CitySpecializationType {
        
        for citySpecializationType in CitySpecializationType.all {

            if citySpecializationType.isDefault() {
                return citySpecializationType
            }
        }

        return .generalEconomic
    }
    
    /// Find the specialization type for building wonders
    func wonderSpecialization() -> CitySpecializationType {
        
        for citySpecializationType in CitySpecializationType.all {

            if citySpecializationType.isWonder() {
                return citySpecializationType
            }
        }

        return .generalEconomic
    }
    
    /// Compute the weight of each production subtype (return value is total of all these weights)
    func weightProductionSubtypes(flavorWonder: Int, flavorSpaceship: Int, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let militaryAI = self.player?.militaryAI else {
            fatalError("cant get militaryAI")
        }
        
        var criticalDefenseOn = false

        var militaryTrainingWeight = 0.0
        var emergencyUnitWeight = 0.0
        var seaWeight = 0.0
        var wonderWeight = 0.0
        let spaceshipWeight = 0.0

        let flavorOffense = Double(player.personalAndGrandStrategyFlavor(for: .offense))
        let unitsRequested = player.numUnitsNeededToBeBuilt()

        // LONG-TERM MILITARY BUILD-UP
        militaryTrainingWeight += flavorOffense * 10.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_TRAINING_PER_OFFENSE */
        //militaryTrainingWeight += m_pPlayer->GetDiplomacyAI()->GetPersonalityMajorCivApproachBias(MAJOR_CIV_APPROACH_WAR) * 10 /* AI_CITY_SPECIALIZATION_PRODUCTION_TRAINING_PER_PERSONALITY */

        // EMERGENCY UNITS
        emergencyUnitWeight += Double(unitsRequested) * 10.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_OPERATIONAL_UNITS_REQUESTED */
        emergencyUnitWeight += Double(militaryAI.numberOfPlayersAtWarWith(in: gameModel)) * 100.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_CIVS_AT_WAR_WITH */

        // Is our capital under threat?
        let capitalUnterThreatCityStrategy: CityStrategyType = CityStrategyType.capitalUnderThreat
        
        if let capital = gameModel.capital(of: player), let cityStrategy = capital.cityStrategy {
        
            if cityStrategy.adopted(cityStrategy: capitalUnterThreatCityStrategy) {
                emergencyUnitWeight += 50.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_CAPITAL_THREAT */
            }
        }

        // Add in weights depending on what the military AI is up to
        if militaryAI.adopted(militaryStrategy: .warMobilization) {
            militaryTrainingWeight += 150.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_WAR_MOBILIZATION */
        }
        
        if militaryAI.adopted(militaryStrategy: .empireDefense) {
            emergencyUnitWeight += 150.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_EMPIRE_DEFENSE */
        }
        
        if militaryAI.adopted(militaryStrategy: .empireDefenseCritical) {
            criticalDefenseOn = true
            emergencyUnitWeight += 1000.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_EMPIRE_DEFENSE_CRITICAL */
        }

        // Override all this if have too many units!
        if militaryAI.adopted(militaryStrategy: .enoughMilitaryUnits) {
            militaryTrainingWeight = 0.0
            emergencyUnitWeight = 0.0
        }

        if militaryAI.adopted(militaryStrategy: .needNavalUnits) {
            seaWeight += 50.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_NEED_NAVAL_UNITS */
        }
        
        if militaryAI.adopted(militaryStrategy: .needNavalUnitsCritical) {
            seaWeight += 250.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_NEED_NAVAL_UNITS_CRITICAL */
        }
        
        if militaryAI.adopted(militaryStrategy: .enoughNavalUnits) {
            seaWeight = 0.0
        }

        // Wonder is MIN between weight of wonders available to build and value from flavors (but not less than zero)
        let wonderFlavorWeight = Double(flavorWonder) * 200.0 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_FLAVOR_WONDER */
        let weightOfWonders = Double(self.nextWonderWeight) * 0.8 /* AI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_NEXT_WONDER */
        wonderWeight = min(wonderFlavorWeight, weightOfWonders)
        wonderWeight = max(wonderWeight, 0.0)

        // One-half of normal weight if critical defense is on
        if criticalDefenseOn {
            wonderWeight /= 2.0
        }

        /*if canBuildSpaceshipParts() {
            spaceshipWeight += iFlavorSpaceship * GC.getAI_CITY_SPECIALIZATION_PRODUCTION_WEIGHT_FLAVOR_SPACESHIP() /* 5 */;
        }*/

        for grandStrategy in GrandStrategyAIType.all {

            if player.grandStrategyAI?.activeStrategy == grandStrategy {
                if grandStrategy.yields().value(of: .production) > 0.0 {
                        
                    if grandStrategy.flavor(for: .offense) > 0 {
                        militaryTrainingWeight += grandStrategy.yields().production
                    } /*else if (grandStrategy->GetFlavorValue((FlavorTypes)GC.getInfoTypeForString("FLAVOR_SPACESHIP")) > 0)
                        {
                            spaceshipWeight += grandStrategy->GetSpecializationBoost(YIELD_PRODUCTION);
                        }*/
                }
            }
        }

        // Add weights to our weighted vector
        self.productionSubtypeWeights.add(weight: Double(militaryTrainingWeight), for: .militaryTraining)
        self.productionSubtypeWeights.add(weight: Double(emergencyUnitWeight), for: .emergencyUnits)
        self.productionSubtypeWeights.add(weight: Double(seaWeight), for: .militaryNaval)
        self.productionSubtypeWeights.add(weight: Double(wonderWeight), for: .wonder)
        self.productionSubtypeWeights.add(weight: Double(spaceshipWeight), for: .spaceship)

        return Int(militaryTrainingWeight + emergencyUnitWeight + seaWeight + wonderWeight + spaceshipWeight)
    }
    
    func nextWonderDesired() -> WonderType {
        
        return self.nextWonderDesiredValue
    }
    
    func setSpecializationsDirty() {
        
        self.specializationsDirty = true
    }
}
