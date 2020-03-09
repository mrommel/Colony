//
//  City.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum GrowthStatusType {

    case none

    case constant
    case starvation
    case growth
}

enum CityError: Error {

    case tileOwned
    case tileOwnedByAnotherCity
    case tileWorkedAlready

    case cantWorkCenter
}

enum CityTaskType {
    
    case rangedAttack
}

enum CityTaskResultType {
    
    case aborted
    case completed
}

protocol AbstractCity {

    var name: String { get }
    var player: AbstractPlayer? { get }
    var capital: Bool { get }
    var buildings: AbstractBuildings? { get }
    var location: HexPoint { get }
    
    var cityStrategy: CityStrategyAI? { get }

    //static func found(name: String, at location: HexPoint, capital: Bool, owner: AbstractPlayer?) -> AbstractCity
    func initialize()

    func population() -> Int
    func set(population: Int)

    func turn(in gameModel: GameModel?) -> Yields

    func canBuild(building: BuildingType) -> Bool
    func canTrain(unit: UnitType) -> Bool
    func canBuild(project: ProjectType) -> Bool

    func startTraining(unit: UnitType)
    func startBuilding(building: BuildingType)

    func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int
    func unitProductionTurnsLeft(for unitType: UnitType) -> Int

    func currentBuildableItem() -> BuildableItem?

    func foodBasket() -> Double
    func set(foodBasket: Double)

    func healthPoints() -> Int
    func set(healthPoints: Int)
    func damage() -> Int
    func maxHealthPoints() -> Int
    
    func power() -> Int
    
    //func defensiveStrength() -> Int
    func rangedCombatStrength(against defender: AbstractUnit?, on toTile: AbstractTile?, attacking: Bool) -> Int
    func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool) -> Int

    func work(tile: AbstractTile) throws
    
    func isFeatureSurrounded() -> Bool
    
    // military properties
    func threatValue() -> Int
    
    @discardableResult
    func doTask(taskType: CityTaskType, target: HexPoint?, in gameModel: GameModel?) -> CityTaskResultType
}

class City: AbstractCity {

    let name: String
    var populationValue: Double
    let location: HexPoint
    private(set) var capital: Bool
    private(set) var player: AbstractPlayer?
    private(set) var growthStatus: GrowthStatusType = .growth

    internal var districts: AbstractDistricts?
    internal var buildings: AbstractBuildings? // buildings that are currently build in this city
    internal var projects: AbstractProjects? // projects that are currently build in this city
    internal var buildQueue: BuildQueue

    private var healthPointsValue: Int // 0..200
    private var strengthValue: Int
    private var threatVal: Int
    
    private var isFeatureSurroundedValue: Bool
    private var productionLastTurn: Double = 1.0

    var foodBasketValue: Double
    var workedTiles: [HexPoint]

    internal var cityStrategy: CityStrategyAI?
    
    private var madeAttack: Bool = false

    // MARK: constructor

    init(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) {

        self.name = name
        self.location = location
        self.capital = capital
        self.populationValue = 1

        self.buildQueue = BuildQueue()

        self.foodBasketValue = 1.0
        self.workedTiles = []

        self.player = owner

        self.strengthValue = 0
        self.isFeatureSurroundedValue = false
        self.threatVal = 0
        
        self.healthPointsValue = 200
    }

    func initialize() {

        self.districts = Districts(city: self)

        self.buildings = Buildings(city: self)

        if self.capital {
            do {
                try self.buildings?.build(building: .palace)
            } catch {

            }
        }

        self.cityStrategy = CityStrategyAI(city: self)
    }

    /*static func found(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) -> AbstractCity {
        
        let city = City(name: name, at: location, capital: capital, owner: owner)
        city.initialize()
        
        return city
    }*/

    // MARK: public methods

    func turn(in gameModel: GameModel?) -> Yields {

        self.cityStrategy?.turn(with: gameModel)
        self.updateFeatureSurrounded(in: gameModel)

        let yields = self.yields(in: gameModel)

        self.updateGrowth(for: yields.food, in: gameModel)
        self.updateProduction(for: yields.production, in: gameModel)

        // reset food and production
        yields.food = 0
        yields.production = 0

        return yields
    }

    func foodBasket() -> Double {

        return self.foodBasketValue
    }

    internal func set(foodBasket: Double) {

        self.foodBasketValue = foodBasket
    }

    func set(population: Int) {

        self.populationValue = Double(population)
    }

    func population() -> Int {

        return Int(self.populationValue)
    }

    func build(building: BuildingType) {

        do {
            try self.buildings?.build(building: building)
        } catch {
            fatalError("cant build building: already build")
        }
    }

    func canBuild(building: BuildingType) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        if buildings.has(building: building) {
            return false
        }

        if let requiredTech = building.required() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if !self.has(district: building.district()) {
            return false
        }

        return true
    }

    func canTrain(unit unitType: UnitType) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        if let requiredTech = unitType.required() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }

        if unitType == .settler {
            if self.population() <= 1 {
                return false
            }
        }

        if let requiredCivilization = unitType.civilization() {
            if player.leader.civilization() != requiredCivilization {
                return false
            }
        }

        return true
    }

    func canBuild(project: ProjectType) -> Bool {

        return false
    }

    func has(district: DistrictType) -> Bool {

        if district == .cityCenter {
            return true
        }

        return false // FIXME
    }

    func startTraining(unit unitType: UnitType) {

        self.buildQueue.add(item: BuildableItem(unitType: unitType))
    }

    func startBuilding(building buildingType: BuildingType) {

        self.buildQueue.add(item: BuildableItem(buildingType: buildingType))
    }

    func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int {

        if let buildingTypeItem = self.buildQueue.building(of: buildingType) {
            return Int(buildingTypeItem.productionLeft() / self.productionLastTurn)
        }

        return 100
    }

    func unitProductionTurnsLeft(for unitType: UnitType) -> Int {

        if let unitTypeItem = self.buildQueue.unit(of: unitType) {
            return Int(unitTypeItem.productionLeft() / self.productionLastTurn)
        }

        return 100
    }

    func currentBuildableItem() -> BuildableItem? {

        return self.buildQueue.peek()
    }

    // MARK: private methods

    private func updateGrowth(for foodPerTurn: Double, in gameModel: GameModel?) {

        guard let player = player else {
            fatalError("cant get player")
        }

        let foodNeededForPopulation = self.foodForPopulation()

        let foodDelta = foodPerTurn - foodNeededForPopulation

        self.foodBasketValue += foodDelta

        if foodDelta == 0 {

            self.growthStatus = .constant

        } else if foodDelta > 0 {

            if self.foodBasketValue > self.foodNeededForGrowth() {

                // notify human about growth
                if player.isHuman() {

                    //gameModel?.growthStatusNotification?(self, .growth)
                    gameModel?.add(message: GrowthStatusMessage(in: self, growth: .growth))
                }

                self.populationValue += 1
                self.foodBasketValue = 0
            }

            self.growthStatus = .growth
        } else {

            if self.foodBasketValue <= 0 {

                // notify human about starvation
                if player.isHuman() {

                    //gameModel?.growthStatusNotification?(self, .starvation)
                    gameModel?.add(message: GrowthStatusMessage(in: self, growth: .starvation))
                }

                if self.populationValue > 0 {
                    self.populationValue -= 1
                }

                self.growthStatus = .starvation
            } else {

                self.growthStatus = .constant
            }
        }
    }

    func foodNeededForGrowth() -> Double {

        return Double(self.population()) * 4.0
    }

    func updateProduction(for productionPerTurn: Double, in gameModel: GameModel?) {

        guard let player = player else {
            fatalError("cant get player")
        }

        if let currentBuilding = self.currentBuildableItem() {

            currentBuilding.add(production: productionPerTurn)

            if currentBuilding.ready() {

                self.buildQueue.pop()

                switch currentBuilding.type {

                case .unit:
                    if let unitType = currentBuilding.unitType {

                        //self.build(building: buildingType)

                        if player.isHuman() {
                            gameModel?.add(message: CityHasFinishedTrainingMessage(city: self, unit: unitType))
                        }
                    }

                case .building:

                    if let buildingType = currentBuilding.buildingType {

                        self.build(building: buildingType)

                        if player.isHuman() {
                            gameModel?.add(message: CityHasFinishedBuildingMessage(city: self, building: buildingType))
                        }
                    }
                case .project:
                    // NOOP - FIXME
                    break
                }

                if !player.isHuman() {
                    self.cityStrategy?.chooseProduction(in: gameModel)
                }
            }

        } else {

            if player.isHuman() {
                gameModel?.add(message: CityNeedsBuildableMessage(city: self))
            } else {
                self.cityStrategy?.chooseProduction(in: gameModel)
            }
        }

        self.productionLastTurn = productionPerTurn
    }

    func yields(in gameModel: GameModel?) -> Yields {

        guard let player = self.player else {
            fatalError("no player provided")
        }

        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }

        // from tiles
        var yieldsVal = self.yieldsFromTiles(in: gameModel)

        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capital == true {

                yieldsVal.food += 1
                yieldsVal.production += 1
                yieldsVal.gold += 1

                // these too?
                yieldsVal.science += 1
                yieldsVal.culture += 1
                yieldsVal.faith += 1
            }

            // godKing
            if government.has(card: .godKing) && self.capital == true {

                yieldsVal.gold += 1
                yieldsVal.faith += 1
            }

            // urbanPlanning: +1 Production in all cities.
            if government.has(card: .urbanPlanning) {

                yieldsVal.production += 1
            }
        }

        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                yieldsVal += building.yields()
            }
        }

        // science & culture from population
        yieldsVal.science += (self.populationValue * 0.5)
        yieldsVal.culture += (self.populationValue * 0.3)

        // reduce gold by maintenance costs
        yieldsVal.gold -= self.maintenanceCostsPerTurn()

        return yieldsVal
    }

    func yieldsFromTiles(in gameModel: GameModel?) -> Yields {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        var yields = Yields(food: 0, production: 0, gold: 0)

        if let centerTile = gameModel.tile(at: self.location) {
            yields += centerTile.yields()

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if yields.food < 2.0 {
                yields.food = 2.0
            }
            if yields.production < 1.0 {
                yields.production = 1.0
            }
        }

        for point in self.workedTiles {
            if let adjacentTile = gameModel.tile(at: point) {
                yields += adjacentTile.yields()
            }
        }

        return yields
    }

    func foodForPopulation() -> Double {

        return Double(self.population()) * 2.0
    }

    func maintenanceCostsPerTurn() -> Double {

        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }

        var costs = 0.0

        // gather costs from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                costs += Double(building.maintenanceCosts())
            }
        }

        return costs
    }

    // MARK: attack / damage
    
    func rangedCombatStrength(against defender: AbstractUnit?, on toTile: AbstractTile?, attacking: Bool) -> Int {
        
        guard let player = self.player else {
            fatalError("no player provided")
        }
        
        var rangedStrength = 15 // slinger / no requirement
        
        // https://civilization.fandom.com/wiki/Archer_(Civ6)
        if player.has(tech: .archery) {
            rangedStrength = 25
        }
        
        // https://civilization.fandom.com/wiki/Crossbowman_(Civ6)
        if player.has(tech: .machinery) {
            rangedStrength = 40
        }
        
        // https://civilization.fandom.com/wiki/Field_Cannon_(Civ6)
        /*if player.has(tech: .ballistics) {
            rangedStrength = 60
        }*/
        
        // FIXME: ratio?
        
        return rangedStrength
    }
    
    func defensiveStrength(against attacker: AbstractUnit?, on ownTile: AbstractTile?, ranged: Bool) -> Int {
        
        guard let buildings = self.buildings else {
            fatalError("no buildings provided")
        }

        var strengthValue = 0
        
        /* Base strength, equal to that of the strongest melee unit your civilization currently possesses minus 10, or to the unit which is garrisoned inside the city (whichever is greater). Note also that Corps or Army units are capable of pushing this number higher than otherwise possible for this Era, so when you station such a unit in a city, its CS will increase accordingly; */
        if let unit = self.garrisonedUnit() {
            
            let unitStrength = unit.combatStrength()
            let warriorStrength = UnitType.warrior.meleeStrength() - 10
            
            strengthValue = max(warriorStrength, unitStrength)
        } else {
            strengthValue = UnitType.warrior.meleeStrength() - 10
        }

        // Building Defense
        /* Wall defenses add +3 CS per each level of Walls (up to +9 for Renaissance Walls); this bonus is lost if/when the walls are brought down. Note that this bonus is only valid for 'ancient defenses' (i.e. pre-Urban Defenses Walls). If a city never built any walls and then got Urban Defenses, it will never get this bonus, despite actually having modern defensive capabilities. */
        /* The Capital6 Capital gains an additional boost of 3 CS thanks to its Palace; this is called "Palace Guard" in the strength breakdown. This can increase to +8 when Victor has moved to the city (takes 3 turns). */
        let buildingDefense = buildings.defense()
        strengthValue += buildingDefense

        // Terrain mod
        // Bonus if the city is built on a Hill; this is the normal +3 bonus which is native to Hills.
        if let tile = ownTile {
            if tile.hasHills() {
                strengthValue += 3 // CITY_STRENGTH_HILL_MOD
            }
        }
        
        return strengthValue
    }

    func updateFeatureSurrounded(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }

        var totalPlots = 0
        var featuredPlots = 0

        // Look two tiles around this city in every direction to see if at least half the plots are covered in a removable feature
        let range = 2

        let surroundingArea = self.location.areaWith(radius: range)

        for pt in surroundingArea {

            if !gameModel.valid(point: pt) {
                continue
            }

            // Increase total plot count
            totalPlots += 1

            if let tile = gameModel.tile(at: pt) {

                var hasRemovableFeature = false
                for feature in FeatureType.all {
                    if tile.has(feature: feature) && feature.isRemovable() {
                        hasRemovableFeature = true
                    }
                }

                if hasRemovableFeature {
                    featuredPlots += 1
                }
            }
        }

        // At least half have coverage?
        if featuredPlots >= totalPlots / 2 {
            self.isFeatureSurroundedValue = true
        } else {
            self.isFeatureSurroundedValue = false
        }
    }
    
    func isFeatureSurrounded() -> Bool {
        
        return self.isFeatureSurroundedValue
    }

    func garrisonedUnit() -> AbstractUnit? {

        // FIXME
        return nil
    }

    func power() -> Int {

        return Int(pow(Double(self.strengthValue) / 100.0, 1.5))
    }
    
    func healthPoints() -> Int {
        
        return self.healthPointsValue
    }
    
    func set(healthPoints: Int) {
        
        self.healthPointsValue = healthPoints
    }
    
    func damage() -> Int {
        
        return max(0, self.maxHealthPoints() - self.healthPointsValue)
    }
    
    func maxHealthPoints() -> Int {
        
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
        
        var healthPointsVal = 200
        
        if buildings.has(building: .ancientWalls) {
            healthPointsVal += 100
        }
        
        return healthPointsVal
    }

    // MARK: add citizen to work on tile

    func work(tile: AbstractTile) throws {

        if !tile.hasOwner() {
            throw CityError.tileOwned
        }

        if tile.owner()?.leader != self.player?.leader {
            throw CityError.tileOwnedByAnotherCity
        }

        if tile.isWorked() {
            throw CityError.tileWorkedAlready
        }

        if tile.point == self.location {
            throw CityError.cantWorkCenter
        }

        self.workedTiles.append(tile.point)
        try tile.setWorked(by: self)
    }
    
    func threatValue() -> Int {
        
        return self.threatVal
    }
    
    func doTask(taskType: CityTaskType, target: HexPoint? = nil, in gameModel: GameModel?) -> CityTaskResultType {
        
        switch taskType {
            
        case .rangedAttack:
            return self.rangeStrike(at: target!, in: gameModel)
        }
    }
    
    private func canRangeStrike(at point: HexPoint) -> Bool {
        
        fatalError("not implemented yet")
    }
    
    private func rangeStrike(at point: HexPoint, in gameModel: GameModel?) -> CityTaskResultType {
        
        guard let tile = gameModel?.tile(at: point) else {
            return .aborted
        }

        if !self.canRangeStrike(at: point) {
            return .aborted
        }

        self.madeAttack = true

        // No City
        if !tile.isCity() {
            
            guard let defender = gameModel?.unit(at: point) else {
                return .aborted
            }
            
            let combatResult = Combat.predictRangedAttack(between: self, and: defender, in: gameModel)

            defender.set(healthPoints: defender.healthPoints() - combatResult.defenderDamage)
            
            return .completed
        }

        return .aborted
    }
}
