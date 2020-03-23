//
//  City.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// Amenities https://www.youtube.com/watch?v=I_LH7BdkrWc

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
    var buildings: AbstractBuildings? { get }
    var districts: AbstractDistricts? { get }
    var location: HexPoint { get }
    
    var cityStrategy: CityStrategyAI? { get }
    var cityCitizens: CityCitizens? { get }
    //var cityEmphases: CityEmphases? { get }

    //static func found(name: String, at location: HexPoint, capital: Bool, owner: AbstractPlayer?) -> AbstractCity
    func initialize()
    
    func yields(in gameModel: GameModel?) -> Yields
    func foodConsumption() -> Double
    
    func isCapital() -> Bool

    func population() -> Int
    func set(population: Int, reassignCitizen: Bool, in gameModel: GameModel?)
    func change(population: Int, reassignCitizen: Bool, in gameModel: GameModel?)

    func turn(in gameModel: GameModel?)
    
    func has(district: DistrictType) -> Bool
    func has(building: BuildingType) -> Bool

    func canBuild(building: BuildingType) -> Bool
    func canTrain(unit: UnitType) -> Bool
    func canBuild(project: ProjectType) -> Bool

    func startTraining(unit: UnitType)
    func startBuilding(building: BuildingType)
    func startBuilding(district: DistrictType)

    func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int
    func unitProductionTurnsLeft(for unitType: UnitType) -> Int

    func currentBuildableItem() -> BuildableItem?

    func foodBasket() -> Double
    func set(foodBasket: Double)
    func hasOnlySmallFoodSurplus() -> Bool // < 2 food surplus
    func hasFoodSurplus() -> Bool // < 4 food surplus
    func hasEnoughFood() -> Bool

    func healthPoints() -> Int
    func set(healthPoints: Int)
    func damage() -> Int
    func maxHealthPoints() -> Int
    
    func power() -> Int
    
    func garrisonedUnit() -> AbstractUnit?
    func hasGarrison() -> Bool
    func setGarrison(unit: AbstractUnit?)
    
    func rangedCombatStrength(against defender: AbstractUnit?, on toTile: AbstractTile?, attacking: Bool) -> Int
    func defensiveStrength(against attacker: AbstractUnit?, on toTile: AbstractTile?, ranged: Bool) -> Int

    func work(tile: AbstractTile) throws
    
    func isFeatureSurrounded() -> Bool
    func isBlockaded() -> Bool
    func setRouteToCapitalConnected(value connected: Bool)
    
    func processSpecialist(specialistType: SpecialistType, change: Int)
    
    // military properties
    func threatValue() -> Int
    
    @discardableResult
    func doTask(taskType: CityTaskType, target: HexPoint?, in gameModel: GameModel?) -> CityTaskResultType
    
    func lastTurnGarrisonAssigned() -> Int
    func setLastTurnGarrisonAssigned(turn: Int)
    
    func doBuyPlot(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func numPlotsAcquired(by otherPlayer: AbstractPlayer?) -> Int
}

class City: AbstractCity {

    static let workRadius = 3
    
    let name: String
    var populationValue: Double
    let location: HexPoint
    private(set) var player: AbstractPlayer?
    private(set) var growthStatus: GrowthStatusType = .growth

    internal var districts: AbstractDistricts?
    internal var buildings: AbstractBuildings? // buildings that are currently build in this city
    internal var projects: AbstractProjects? // projects that are currently build in this city
    internal var buildQueue: BuildQueue
    internal var cityCitizens: CityCitizens?
    //internal var cityEmphases: CityEmphases?

    private var capitalValue: Bool
    
    private var healthPointsValue: Int // 0..200
    private var threatVal: Int
    
    private var isFeatureSurroundedValue: Bool
    private var productionLastTurn: Double = 1.0

    var foodBasketValue: Double
    private var foodLastTurn: Double = 1.0

    internal var cityStrategy: CityStrategyAI?
    
    private var madeAttack: Bool = false
    private var routeToCapitalConnectedThisTurn: Bool = false
    private var routeToCapitalConnectedLastTurn: Bool = false
    private var lastTurnGarrisonAssignedValue: Int = 0
    
    private var garrisonedUnitValue: AbstractUnit? = nil

    // MARK: constructor

    init(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) {

        self.name = name
        self.location = location
        self.capitalValue = capital
        self.populationValue = 1

        self.buildQueue = BuildQueue()

        self.foodBasketValue = 1.0

        self.player = owner

        self.isFeatureSurroundedValue = false
        self.threatVal = 0
        
        self.healthPointsValue = 200
    }

    func initialize() {

        self.districts = Districts(city: self)
        self.buildings = Buildings(city: self)

        if self.capitalValue {
            do {
                try self.buildings?.build(building: .palace)
            } catch {

            }
        }

        self.cityStrategy = CityStrategyAI(city: self)
        self.cityCitizens = CityCitizens(city: self)
    }
    
    func isCapital() -> Bool {
        
        return self.capitalValue
    }

    /*static func found(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) -> AbstractCity {
        
        let city = City(name: name, at: location, capital: capital, owner: owner)
        city.initialize()
        
        return city
    }*/

    // MARK: public methods

    func turn(in gameModel: GameModel?)  {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        if self.damage() > 0 {
            //CvAssertMsg(m_iDamage <= GC.getMAX_CITY_HIT_POINTS(), "Somehow a city has more damage than hit points. Please show this to a gameplay programmer immediately.");

            /*int iHitsHealed = GC.getCITY_HIT_POINTS_HEALED_PER_TURN();
            if (isCapital() && !GET_PLAYER(getOwner()).isMinorCiv())
            {
                iHitsHealed++;
            }
            int iBuildingDefense = m_pCityBuildings->GetBuildingDefense();
            iBuildingDefense *= (100 + m_pCityBuildings->GetBuildingDefenseMod());
            iBuildingDefense /= 100;
            iHitsHealed += iBuildingDefense / 500;
            iHitsHealed = min(5,iHitsHealed);
            changeDamage(-iHitsHealed);*/
        }
        if self.damage() < 0 {
            //self.setDamage(0)
        }
        
        //setDrafted(false);
        //setAirliftTargeted(false);
        //setCurrAirlift(0);
        //setMadeAttack(false);
        //GetCityBuildings()->SetSoldBuildingThisTurn(false);

        self.updateFeatureSurrounded(in: gameModel)

        self.cityStrategy?.turn(with: gameModel)

        self.cityCitizens?.doTurn(with: gameModel)

        //AI_doTurn();
        if !player.isHuman() {
            //AI_stealPlots();
        }

        let razed = false // self.doRazingTurn();

        if !razed {
            
            // self.doResistanceTurn();

            // let allowNoProduction = !doCheckProduction();

            // self.doGrowth();

            // self.doUpdateIndustrialRouteToCapital();

            // self.doProduction(bAllowNoProduction);

            // self.doDecay();

            // self.doMeltdown();

            for loopPoint in self.location.areaWith(radius: City.workRadius) {
                
                if let loopPlot = gameModel.tile(at: loopPoint) {
               
                    if cityCitizens.isWorked(at: loopPoint) {
                        loopPlot.doImprovement()
                    }
                }
            }

            // Following function also looks at WLTKD stuff
            // self.doTestResourceDemanded();

            // Culture accumulation
            // if (getJONSCulturePerTurn() > 0) {
            //     ChangeJONSCultureStored(getJONSCulturePerTurn());
            // }

            // Enough Culture to acquire a new Plot?
            // if (GetJONSCultureStored() >= GetJONSCultureThreshold()) {
            //     DoJONSCultureLevelIncrease();
            // }

            // Resource Demanded Counter
            // if (GetResourceDemandedCountdown() > 0) {
            //     ChangeResourceDemandedCountdown(-1)

            //     if (GetResourceDemandedCountdown() == 0) {
                    // Pick a Resource to demand
            //         self.doPickResourceDemanded();
            //   }
            // }

            //self.updateStrengthValue()

            // self.doNearbyEnemy()

            //Check for Achievements
            /*if(isHuman() && !GC.getGame().isGameMultiPlayer() && GET_PLAYER(GC.getGame().getActivePlayer()).isLocalPlayer()) {
                if(getJONSCulturePerTurn()>=100) {
                    gDLL->UnlockAchievement( ACHIEVEMENT_CITY_100CULTURE );
                }
                if(getYieldRate(YIELD_GOLD)>=100) {
                    gDLL->UnlockAchievement( ACHIEVEMENT_CITY_100GOLD );
                }
                if(getYieldRate(YIELD_SCIENCE)>=100 ) {
                    gDLL->UnlockAchievement( ACHIEVEMENT_CITY_100SCIENCE );
                }
            }*/

            // sending notifications on when routes are connected to the capital
            if !self.isCapital() {
                
                /*CvNotifications* pNotifications = GET_PLAYER(m_eOwner).GetNotifications();
                if (pNotifications)
                {
                    CvCity* pPlayerCapital = GET_PLAYER(m_eOwner).getCapitalCity();
                    CvAssertMsg(pPlayerCapital, "No capital city?");

                    if (m_bRouteToCapitalConnectedLastTurn != m_bRouteToCapitalConnectedThisTurn && pPlayerCapital)
                    {
                        Localization::String strMessage;
                        Localization::String strSummary;

                        if (m_bRouteToCapitalConnectedThisTurn) // connected this turn
                        {
                            strMessage = Localization::Lookup( "TXT_KEY_NOTIFICATION_TRADE_ROUTE_ESTABLISHED" );
                            strSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_SUMMARY_TRADE_ROUTE_ESTABLISHED");
                        }
                        else // lost connection this turn
                        {
                            strMessage = Localization::Lookup( "TXT_KEY_NOTIFICATION_TRADE_ROUTE_BROKEN" );
                            strSummary = Localization::Lookup("TXT_KEY_NOTIFICATION_SUMMARY_TRADE_ROUTE_BROKEN");
                        }

                        strMessage << getNameKey();
                        strMessage << pPlayerCapital->getNameKey();
                        pNotifications->Add( NOTIFICATION_GENERIC, strMessage.toUTF8(), strSummary.toUTF8(), -1, -1, -1 );
                    }
                }*/

                self.routeToCapitalConnectedLastTurn = self.routeToCapitalConnectedThisTurn
            }
        }
        
        /*
        let yields = self.yields(in: gameModel)

        self.updateGrowth(for: yields.food, in: gameModel)
        self.updateProduction(for: yields.production, in: gameModel)

        // reset food and production
        yields.food = 0
        yields.production = 0

        return yields*/
    }

    func foodBasket() -> Double {

        return self.foodBasketValue
    }

    internal func set(foodBasket: Double) {

        self.foodBasketValue = foodBasket
    }

    //    Be very careful with setting bReassignPop to false.  This assumes that the caller
    //  is manually adjusting the worker assignments *and* handling the setting of
    //  the CityCitizens unassigned worker value.
    func set(population newPopulation: Int, reassignCitizen: Bool = true, in gameModel: GameModel?) {

        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        let oldPopulation = self.population()
        let populationChange = newPopulation - oldPopulation;

        if oldPopulation != newPopulation {
            
            // If we are reducing population, remove the workers first
            if reassignCitizen && populationChange < 0 {
                
                // Need to Remove Citizens
                for _ in 0..<(-populationChange) {
                    cityCitizens.doRemoveWorstCitizen(in: gameModel)
                }

                // Fixup the unassigned workers
                let unassignedWorkers = cityCitizens.numUnassignedCitizens()
                cityCitizens.changeNumUnassignedCitizens(change: max(populationChange, -unassignedWorkers))
            }
            
            if populationChange > 0 {
                self.cityCitizens?.changeNumUnassignedCitizens(change: populationChange)
            }
        }
        
        self.populationValue = Double(newPopulation)
        
        // FIXME:
        // update yields?
    }
    
    func change(population change: Int, reassignCitizen: Bool = true, in gameModel: GameModel?) {
        
        self.set(population: self.population() + change, reassignCitizen: reassignCitizen, in: gameModel)
    }

    func population() -> Int {

        return Int(self.populationValue)
    }

    private func build(building: BuildingType) {

        do {
            try self.buildings?.build(building: building)
        } catch {
            fatalError("cant build building: already build")
        }
    }
    
    private func build(districtType: DistrictType) {
        
        do {
            try self.districts?.build(district: districtType)
        } catch {
            fatalError("cant build district: already build")
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
        
        guard let districts = self.districts else {
            return false
        }

        return districts.has(district: district)
    }
    
    func has(building: BuildingType) -> Bool {
        
        guard let buildings = self.buildings else {
            return false
        }
        
        return buildings.has(building: building)
    }
    
    func setRouteToCapitalConnected(value connected: Bool) {
        
        self.routeToCapitalConnectedThisTurn = connected
    }

    func startTraining(unit unitType: UnitType) {

        self.buildQueue.add(item: BuildableItem(unitType: unitType))
    }

    func startBuilding(building buildingType: BuildingType) {

        self.buildQueue.add(item: BuildableItem(buildingType: buildingType))
    }
    
    func startBuilding(district: DistrictType) {
        
        self.buildQueue.add(item: BuildableItem(districtType: district))
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

        let foodNeededForPopulation = self.foodConsumption()
        self.foodLastTurn = foodPerTurn

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
                    
                case .wonder:

                    if let wonderType = currentBuilding.wonderType {

                        fatalError("niy")
                        /*self.build(wonder: wonderType)

                        if player.isHuman() {
                            gameModel?.add(message: CityHasFinishedBuildingMessage(city: self, building: buildingType))
                        }*/
                    }
                    
                case .district:
                    
                    if let districtType = currentBuilding.districtType {

                        self.build(districtType: districtType)

                        if player.isHuman() {
                            gameModel?.add(message: CityHasFinishedDistrictMessage(city: self, district: districtType))
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
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                yieldsVal.food += 1
                yieldsVal.production += 1
                yieldsVal.gold += 1

                // these too?
                yieldsVal.science += 1
                yieldsVal.culture += 1
                yieldsVal.faith += 1
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {

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
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }

        var yields = Yields(food: 0, production: 0, gold: 0)

        if let centerTile = gameModel.tile(at: self.location) {
            yields += centerTile.yields(ignoreFeature: false)

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if yields.food < 2.0 {
                yields.food = 2.0
            }
            if yields.production < 1.0 {
                yields.production = 1.0
            }
        }

        for point in cityCitizens.workingTileLocations() {
            if let adjacentTile = gameModel.tile(at: point) {
                yields += adjacentTile.yields(ignoreFeature: false)
            }
        }

        return yields
    }

    func foodConsumption() -> Double {

        return Double(self.population()) * 2.0
    }
    
    func hasOnlySmallFoodSurplus() -> Bool {
        
        let exceedFood = self.foodLastTurn - Double(self.foodConsumption())
        
        return exceedFood < 2.0 && exceedFood > 0.0
    }
    
    func hasFoodSurplus() -> Bool {
        
        let exceedFood = self.foodLastTurn - Double(self.foodConsumption())
        
        return exceedFood < 4.0 && exceedFood > 0.0
    }
    
    func hasEnoughFood() -> Bool {
        
        let exceedFood = self.foodLastTurn - Double(self.foodConsumption())
        
        return exceedFood > 0.0
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
        let range = City.workRadius

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
    
    func isBlockaded() -> Bool {
        return false
    }

    func garrisonedUnit() -> AbstractUnit? {

        return self.garrisonedUnitValue
    }
    
    func hasGarrison() -> Bool {
        
        return self.garrisonedUnitValue != nil
    }
    
    func setGarrison(unit: AbstractUnit?) {
        
        self.garrisonedUnitValue = unit
    }

    func power() -> Int {

        return Int(pow(Double(self.defensiveStrength(against: nil, on: nil, ranged: false)) / 100.0, 1.5))
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

        self.cityCitizens?.setWorked(at: tile.point, worked: true, useUnassignedPool: true)
        try tile.setWorked(by: self)
    }
    
    func threatValue() -> Int {
        
        return self.threatVal
    }
    
    func processSpecialist(specialistType: SpecialistType, change: Int) {

        //fatalError("niy")
        if specialistType->getGreatPeopleUnitClass() != NO_UNITCLASS {
            let eGreatPeopleUnit = ((UnitTypes)(getCivilizationInfo().getCivilizationUnits(pkSpecialist->getGreatPeopleUnitClass())));

            if eGreatPeopleUnit != NO_UNIT {
                changeGreatPeopleUnitRate(eGreatPeopleUnit, pkSpecialist->getGreatPeopleRateChange() * iChange);
            }
        }

        self.changeBaseGreatPeopleRate(pkSpecialist->getGreatPeopleRateChange() * iChange);

        for (iI = 0; iI < NUM_YIELD_TYPES; iI++)
        {
            ChangeBaseYieldRateFromSpecialists(((YieldTypes)iI), (pkSpecialist->getYieldChange(iI) * iChange));
        }

        self.updateExtraSpecialistYield()

        changeSpecialistFreeExperience(pkSpecialist->getExperience() * iChange);

        // Culture
        int iCulturePerSpecialist = GetCultureFromSpecialist(eSpecialist);
        ChangeJONSCulturePerTurnFromSpecialists(iCulturePerSpecialist * iChange);
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
    
    func lastTurnGarrisonAssigned() -> Int {
        
        return self.lastTurnGarrisonAssignedValue
    }
    
    func setLastTurnGarrisonAssigned(turn: Int) {
        
        self.lastTurnGarrisonAssignedValue = turn
    }
    
    func doBuyPlot(at point: HexPoint, in gameModel: GameModel?) -> Bool {
        
        return false
    }
    
    func numPlotsAcquired(by otherPlayer: AbstractPlayer?) -> Int {
        
        return 0
    }
}
