//
//  City.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 27.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

// Amenities https://www.youtube.com/watch?v=I_LH7BdkrWc

public enum GrowthStatusType {

    case none

    case constant
    case starvation
    case growth
}

public enum CityError: Error {

    case tileOwned
    case tileOwnedByAnotherCity
    case tileWorkedAlready

    case cantWorkCenter
}

public enum CityTaskType {
    
    case rangedAttack
}

public enum CityTaskResultType {
    
    case aborted
    case completed
}

public protocol AbstractCity: class, Codable {

    var name: String { get }
    var player: AbstractPlayer? { get set }
    var leader: LeaderType { get } // for restore from file only
    var buildings: AbstractBuildings? { get }
    var wonders: AbstractWonders? { get }
    var districts: AbstractDistricts? { get }
    var location: HexPoint { get }
    
    var buildQueue: BuildQueue { get }
    
    var cityStrategy: CityStrategyAI? { get }
    var cityCitizens: CityCitizens? { get }
    //var cityEmphases: CityEmphases? { get }

    //static func found(name: String, at location: HexPoint, capital: Bool, owner: AbstractPlayer?) -> AbstractCity
    func initialize(in gameModel: GameModel?)
    
    func foodConsumption() -> Double
    
    func isCapital() -> Bool
    func doFoundMessage()

    func population() -> Int
    func set(population: Int, reassignCitizen: Bool, in gameModel: GameModel?)
    func change(population: Int, reassignCitizen: Bool, in gameModel: GameModel?)

    func turn(in gameModel: GameModel?)
    
    func has(district: DistrictType) -> Bool
    func has(building: BuildingType) -> Bool

    func canBuild(building: BuildingType) -> Bool
    func canTrain(unit: UnitType) -> Bool
    func canBuild(project: ProjectType) -> Bool
    func canBuild(wonder: WonderType, in gameModel: GameModel?) -> Bool
    func canConstruct(district: DistrictType, in gameModel: GameModel?) -> Bool

    func startTraining(unit: UnitType)
    func startBuilding(building: BuildingType)
    func startBuilding(wonder: WonderType)
    func startBuilding(district: DistrictType)

    func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int
    func unitProductionTurnsLeft(for unitType: UnitType) -> Int
    
    func featureProduction() -> Double
    func changeFeatureProduction(change: Double)
    func setFeatureProduction(to: Double)

    func currentBuildableItem() -> BuildableItem?
    
    func foodPerTurn(in gameModel: GameModel?) -> Double
    func productionPerTurn(in gameModel: GameModel?) -> Double
    func goldPerTurn(in gameModel: GameModel?) -> Double
    func sciencePerTurn(in gameModel: GameModel?) -> Double
    func culturePerTurn(in gameModel: GameModel?) -> Double
    func faithPerTurn(in gameModel: GameModel?) -> Double

    func foodBasket() -> Double
    func set(foodBasket: Double)
    func hasOnlySmallFoodSurplus() -> Bool // < 2 food surplus
    func hasFoodSurplus() -> Bool // < 4 food surplus
    func hasEnoughFood() -> Bool
    
    func lastTurnFoodHarvested() -> Double
    // ...
    func amenitiesModifier(in gameModel: GameModel?) -> Double
    func housingModifier(in gameModel: GameModel?) -> Double
    func lastTurnFoodEarned() -> Double
    func growthInTurns() -> Int
    
    func maintenanceCostsPerTurn() -> Double
    
    func productionLastTurn() -> Double
    
    func resetLuxuries()
    func luxuriesNeeded() -> Double
    func add(luxury: ResourceType)
    func has(luxury: ResourceType) -> Bool

    func healthPoints() -> Int
    func set(healthPoints: Int)
    func damage() -> Int
    func maxHealthPoints() -> Int
    
    func power() -> Int
    func updateStrengthValue()
    
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
    
    @discardableResult
    func doBuyPlot(at point: HexPoint, in gameModel: GameModel?) -> Bool
    func numPlotsAcquired(by otherPlayer: AbstractPlayer?) -> Int
    func buyPlotCost(at point: HexPoint, in gameModel: GameModel?) -> Int
    func buyPlotScore(in gameModel: GameModel?) -> (Int, HexPoint)
    func changeNumPlotsAcquiredBy(otherPlayer: AbstractPlayer?, change: Int)
    
    func isProductionAutomated() -> Bool
    func setProductionAutomated(to newValue: Bool, clear: Bool, in gameModel: GameModel?)
}

class LeaderWeightList: WeightedList<LeaderType> {
    
    override func fill() {
        
        for leaderType in LeaderType.all {
            self.add(weight: 0.0, for: leaderType)
        }
    }
}

public class City: AbstractCity {

    static let workRadius = 3
    
    enum CodingKeys: CodingKey {
        
        case name
        case population
        case location
        case leader
        case capital
        
        case districts
        case buildings
        case wonders
        case projects
        case buildQueue
        case cityCitizens
        
        case healthPoints
        
        case isFeatureSurrounded
        case productionLastTurn
        case featureProduction

        case foodBasket
        case lastTurnFoodHarvested
        case lastTurnFoodEarned

        case cityStrategy
        
        case madeAttack
        case routeToCapitalConnectedThisTurn
        case routeToCapitalConnectedLastTurn
        case lastTurnGarrisonAssigned
        
        case luxuries
        
        case baseYieldRateFromSpecialists
        case extraSpecialistYield
    
        case productionAutomated
        
        case numPlotsAcquiredList
    }
    
    public let name: String
    var populationValue: Double
    public let location: HexPoint
    public var player: AbstractPlayer?
    private(set) public var leader: LeaderType // for restoring from file
    private(set) var growthStatus: GrowthStatusType = .growth
    private var capitalValue: Bool

    public var districts: AbstractDistricts?
    public var buildings: AbstractBuildings? // buildings that are currently build in this city
    public var wonders: AbstractWonders?
    internal var projects: AbstractProjects? // projects that are currently build in this city
    public var buildQueue: BuildQueue
    public var cityCitizens: CityCitizens?
    //internal var cityEmphases: CityEmphases?
    
    private var healthPointsValue: Int // 0..200
    private var threatVal: Int
    
    private var isFeatureSurroundedValue: Bool
    private var productionLastTurnValue: Double = 1.0
    private var featureProductionValue: Double = 0

    var foodBasketValue: Double
    private var lastTurnFoodHarvestedValue: Double = 1.0
    private var lastTurnFoodEarnedValue: Double = 0.0

    public var cityStrategy: CityStrategyAI?
    
    private var madeAttack: Bool = false
    private var routeToCapitalConnectedThisTurn: Bool = false
    private var routeToCapitalConnectedLastTurn: Bool = false
    private var lastTurnGarrisonAssignedValue: Int = 0
    
    private var garrisonedUnitValue: AbstractUnit? = nil
    
    private var luxuries: [ResourceType] = []
    
    // yields
    private var baseYieldRateFromSpecialists: YieldList
    private var extraSpecialistYield: YieldList
    
    private var productionAutomatedValue: Bool
    
    private var numPlotsAcquiredList: LeaderWeightList

    // MARK: constructor

    public init(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) {

        self.name = name
        self.location = location
        self.capitalValue = capital
        self.populationValue = 0

        self.buildQueue = BuildQueue()

        self.foodBasketValue = 1.0

        self.player = owner
        self.leader = owner!.leader

        self.isFeatureSurroundedValue = false
        self.threatVal = 0
        
        self.healthPointsValue = 200
        
        self.baseYieldRateFromSpecialists = YieldList()
        self.baseYieldRateFromSpecialists.fill()
        
        self.extraSpecialistYield = YieldList()
        self.extraSpecialistYield.fill()
        
        self.productionAutomatedValue = false
        
        self.numPlotsAcquiredList = LeaderWeightList()
        self.numPlotsAcquiredList.fill()
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.populationValue = try container.decode(Double.self, forKey: .population)
        self.location = try container.decode(HexPoint.self, forKey: .location)
        self.leader = try container.decode(LeaderType.self, forKey: .leader)
        self.capitalValue = try container.decode(Bool.self, forKey: .capital)
        
        self.buildQueue = BuildQueue()

        self.foodBasketValue = 1.0
        
        self.isFeatureSurroundedValue = false
        self.threatVal = 0
        
        self.healthPointsValue = 200
        
        self.baseYieldRateFromSpecialists = YieldList()
        self.baseYieldRateFromSpecialists.fill()
        
        self.extraSpecialistYield = YieldList()
        self.extraSpecialistYield.fill()
        
        self.productionAutomatedValue = false
        
        self.numPlotsAcquiredList = LeaderWeightList()
        self.numPlotsAcquiredList.fill()
        
        self.districts = try container.decode(Districts.self, forKey: .districts)
        self.buildings = try container.decode(Buildings.self, forKey: .buildings)
        self.wonders = try container.decode(Wonders.self, forKey: .wonders)
        self.projects = try container.decode(Projects.self, forKey: .projects)
        self.buildQueue = try container.decode(BuildQueue.self, forKey: .buildQueue)
        self.cityCitizens = try container.decode(CityCitizens.self, forKey: .cityCitizens)
        
        self.healthPointsValue = try container.decode(Int.self, forKey: .healthPoints)
        
        self.isFeatureSurroundedValue = try container.decode(Bool.self, forKey: .isFeatureSurrounded)
        self.productionLastTurnValue = try container.decode(Double.self, forKey: .productionLastTurn)
        self.featureProductionValue = try container.decode(Double.self, forKey: .featureProduction)

        self.foodBasketValue = try container.decode(Double.self, forKey: .foodBasket)
        self.lastTurnFoodHarvestedValue = try container.decode(Double.self, forKey: .lastTurnFoodHarvested)
        self.lastTurnFoodEarnedValue = try container.decode(Double.self, forKey: .lastTurnFoodEarned)

        self.cityStrategy = try container.decode(CityStrategyAI.self, forKey: .cityStrategy)
        
        self.madeAttack = try container.decode(Bool.self, forKey: .madeAttack)
        self.routeToCapitalConnectedThisTurn = try container.decode(Bool.self, forKey: .routeToCapitalConnectedThisTurn)
        self.routeToCapitalConnectedLastTurn = try container.decode(Bool.self, forKey: .routeToCapitalConnectedLastTurn)
        self.lastTurnGarrisonAssignedValue = try container.decode(Int.self, forKey: .lastTurnGarrisonAssigned)
        
        //self.garrisonedUnitValue = try container.decode(CityCitizens.self, forKey: .cityCitizens): AbstractUnit? = nil
        
        self.luxuries = try container.decode([ResourceType].self, forKey: .luxuries)
        
        // yields
        self.baseYieldRateFromSpecialists = try container.decode(YieldList.self, forKey: .baseYieldRateFromSpecialists)
        self.extraSpecialistYield = try container.decode(YieldList.self, forKey: .extraSpecialistYield)
        
        self.productionAutomatedValue = try container.decode(Bool.self, forKey: .productionAutomated)
        
        self.numPlotsAcquiredList = try container.decode(LeaderWeightList.self, forKey: .numPlotsAcquiredList)
        
        // setup
        self.districts?.city = self
        self.buildings?.city = self
        self.wonders?.city = self
        self.projects?.city = self
        self.cityCitizens?.city = self
        
        self.cityStrategy?.city = self
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.name, forKey: .name)
        try container.encode(self.populationValue, forKey: .population)
        try container.encode(self.location, forKey: .location)
        try container.encode(self.player!.leader, forKey: .leader)
        try container.encode(self.capitalValue, forKey: .capital)
        
        try container.encode(self.districts as! Districts, forKey: .districts)
        try container.encode(self.buildings as! Buildings, forKey: .buildings)
        try container.encode(self.wonders as! Wonders, forKey: .wonders)
        try container.encode(self.projects as! Projects, forKey: .projects)
        try container.encode(self.buildQueue, forKey: .buildQueue)
        try container.encode(self.cityCitizens, forKey: .cityCitizens)
        
        try container.encode(self.healthPointsValue, forKey: .healthPoints)
        
        try container.encode(self.isFeatureSurroundedValue, forKey: .isFeatureSurrounded)
        try container.encode(self.productionLastTurnValue, forKey: .productionLastTurn)
        try container.encode(self.featureProductionValue, forKey: .featureProduction)

        try container.encode(self.foodBasketValue, forKey: .foodBasket)
        try container.encode(self.lastTurnFoodHarvestedValue, forKey: .lastTurnFoodHarvested)
        try container.encode(self.lastTurnFoodEarnedValue, forKey: .lastTurnFoodEarned)

        try container.encode(self.cityStrategy, forKey: .cityStrategy)
        
        try container.encode(self.madeAttack, forKey: .madeAttack)
        try container.encode(self.routeToCapitalConnectedThisTurn, forKey: .routeToCapitalConnectedThisTurn)
        try container.encode(self.routeToCapitalConnectedLastTurn, forKey: .routeToCapitalConnectedLastTurn)
        try container.encode(self.lastTurnGarrisonAssignedValue, forKey: .lastTurnGarrisonAssigned)
        
        //try container.encode(self.featureProductionValue, forKey: .featureProduction)
        //private var garrisonedUnitValue: AbstractUnit? = nil
        
        try container.encode(self.luxuries, forKey: .luxuries)
        
        try container.encode(self.baseYieldRateFromSpecialists, forKey: .baseYieldRateFromSpecialists)
        try container.encode(self.extraSpecialistYield, forKey: .extraSpecialistYield)
        
        try container.encode(self.productionAutomatedValue, forKey: .productionAutomated)
        
        try container.encode(self.numPlotsAcquiredList, forKey: .numPlotsAcquiredList)
    }

    public func initialize(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        self.districts = Districts(city: self)
        try! self.districts?.build(district: .cityCenter)
        
        self.buildings = Buildings(city: self)
        self.wonders = Wonders(city: self)
        self.projects = Projects(city: self)

        if self.capitalValue {
            do {
                try self.buildings?.build(building: .palace)
            } catch {

            }
        }

        self.cityStrategy = CityStrategyAI(city: self)
        self.cityCitizens = CityCitizens(city: self)
        
        // Update Proximity between this Player and all others
        for otherPlayer in gameModel.players {

            if otherPlayer.leader != self.player?.leader {
                
                if otherPlayer.isAlive() && diplomacyAI.hasMet(with: otherPlayer) {
                    // Fixme
                    // Players do NOT have to know one another in order to calculate proximity.  Having this info available (even when they haven't met) can be useful
                    player.doUpdateProximity(towards: otherPlayer, in: gameModel)
                    otherPlayer.doUpdateProximity(towards: player, in: gameModel)
                }
            }
        }
        
        self.doUpdateCheapestPlotInfluence(in: gameModel)
        
        // discover the surrounding area
        for pointToDiscover in self.location.areaWith(radius: 2) {
         
            if let tile = gameModel.tile(at: pointToDiscover) {
                tile.discover(by: self.player, in: gameModel)
            }
        }
        
        // claim ownership for direct neighbors (if not taken)
        for pointToClaim in self.location.areaWith(radius: 1) {
            
            if let tile = gameModel.tile(at: pointToClaim) {
                do {
                    // FIXME 
                    try tile.set(owner: self.player)
                    try tile.setWorkingCity(to: self)
                } catch {
                    //fatalError("cant set owner")
                }
            }
        }
        
        self.cityCitizens?.doFound(in: gameModel)
        
        self.player?.updatePlots(in: gameModel)
        
        self.set(population: 1, in: gameModel)
    }
    
    public func doFoundMessage() {
        
        print("show popup func doFoundMessage()")
        return
    }
    
    public func isCapital() -> Bool {
        
        return self.capitalValue
    }

    /*static func found(name: String, at location: HexPoint, capital: Bool = false, owner: AbstractPlayer?) -> AbstractCity {
        
        let city = City(name: name, at: location, capital: capital, owner: owner)
        city.initialize()
        
        return city
    }*/

    // MARK: public methods

    public func turn(in gameModel: GameModel?)  {

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

            let allowNoProduction = !self.doCheckProduction(in: gameModel)

            self.doGrowth(in: gameModel)

            // self.doUpdateIndustrialRouteToCapital();

            self.doProduction(allowNoProduction: allowNoProduction, in: gameModel)

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

            self.updateStrengthValue()

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
    }
    
    public func updateStrengthValue() {
        
    }
    
    public func lastTurnFoodHarvested() -> Double {
        
        return self.lastTurnFoodHarvestedValue
    }
    
    private func setLastTurn(foodHarvested: Double) {
        
        self.lastTurnFoodHarvestedValue = foodHarvested
    }
    
    public func lastTurnFoodEarned() -> Double {
        
        return self.lastTurnFoodEarnedValue
    }
    
    private func setLastTurn(foodEarned: Double) {
        
        self.lastTurnFoodEarnedValue = foodEarned
    }
    
    func foodFromTiles(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var foodValue: Double = 0.0
        
        if let centerTile = gameModel.tile(at: self.location) {
            
            foodValue += centerTile.yields(for: self.player, ignoreFeature: false).food

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if foodValue < 2.0 {
                foodValue = 2.0
            }
        }

        for point in cityCitizens.workingTileLocations() {
            
            // DEBUG
            /*if cityCitizens.isWorked(at: point) {
                print("-- working tile at: \(point)")
            } else {
                print("-- non working tile at: \(point)")
            }*/
            
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    foodValue += adjacentTile.yields(for: self.player, ignoreFeature: false).food
                }
            }
        }
        
        return foodValue
    }
    
    func foodFromGovernmentType() -> Double {
        
        guard let player = self.player else {
            fatalError("no player provided")
        }
        
        var foodFromGovernmentType: Double = 0.0
        
        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                foodFromGovernmentType += 1
            }
        }

        return foodFromGovernmentType
    }
    
    func foodFromBuilding(in gameModel: GameModel?) -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }
        
        var foodFromBuilding: Double = 0.0
        
        // gather food from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                foodFromBuilding += building.yields().food
            }
        }
        
        // handle special building rules
        if buildings.has(building: .waterMill) {
            foodFromBuilding += self.amountOfNearby(resource: .rice, in: gameModel)
            foodFromBuilding += self.amountOfNearby(resource: .wheat, in: gameModel)
        }
        
        if buildings.has(building: .lighthouse) {
            foodFromBuilding += self.amountOfNearby(terrain: .shore, in: gameModel)
            // fixme: lake feature
        }
        
        return foodFromBuilding
    }
    
    private func amountOfNearby(resource: ResourceType, in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var resourceValue = 0.0
        
        for neighbor in self.location.areaWith(radius: 2) {
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                if neighborTile.resource(for: self.player) == resource {
                    resourceValue += 1.0
                }
            }
        }
        
        return resourceValue
    }
    
    private func amountOfNearby(terrain: TerrainType, in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var terrainValue = 0.0
        
        for neighbor in self.location.areaWith(radius: 2) {
            
            if let neighborTile = gameModel.tile(at: neighbor) {
                if neighborTile.terrain() == terrain {
                    terrainValue += 1.0
                }
            }
        }
        
        return terrainValue
    }
    
    public func foodPerTurn(in gameModel: GameModel?) -> Double {
        
        var foodPerTurn: Double = 0.0
        
        foodPerTurn += self.foodFromTiles(in: gameModel)
        foodPerTurn += self.foodFromGovernmentType()
        foodPerTurn += self.foodFromBuilding(in: gameModel)
        
        return foodPerTurn
    }
    
    private func housingPerTurn(in gameModel: GameModel?) -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
        
        var housing = self.baseHousing(in: gameModel)
        housing += buildings.housing()
        housing += self.housingFromImprovements(in: gameModel)
         
        return housing
    }
    
    // Each Farm, Pasture, Plantation, or Camp supports a small amount of Citizen6 Population — 1 Housing6 Housing for every 2 such improvements.
    private func housingFromImprovements(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var farms: Int = 0
        var pastures: Int = 0
        var plantations: Int = 0
        var camps: Int = 0
        
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    
                    // farms
                    if adjacentTile.has(improvement: .farm) {
                        farms += 1
                    }
                    
                    // pastures
                    if adjacentTile.has(improvement: .pasture) {
                        pastures += 1
                    }
                    
                    // plantations
                    if adjacentTile.has(improvement: .plantation) {
                        plantations += 1
                    }
                    
                    // camps
                    if adjacentTile.has(improvement: .camp) {
                        camps += 1
                    }
                }
            }
        }
        
        var housingValue: Double = 0.0
        
        housingValue += Double((farms / 2))
        housingValue += Double((pastures / 2))
        housingValue += Double((plantations / 2))
        housingValue += Double((camps / 2))
        
        return housingValue
    }
    
    // https://civilization.fandom.com/wiki/Housing_(Civ6)
    public func housingModifier(in gameModel: GameModel?) -> Double {
        
        let housing = self.housingPerTurn(in: gameModel)
        let housingDiff = Int(housing) - Int(self.populationValue)
        
        if housingDiff >= 2 { // 2 or more    100%
            return 1.0
        } else if housingDiff == 1 { // 1    50%
            return 0.5
        } else if 0 <= housingDiff && housingDiff <= -4 { // 0 to -4    25%
            return 0.25
        } else { // -5 or less    0%
            return 0.0
        }
    }
    
    public func resetLuxuries() {
        
        self.luxuries = []
    }
    
    public func luxuriesNeeded() -> Double {
        
        let amenitiesFromBuildings = self.amenitiesFromBuildings()
        let amenitiesFromWonders = self.amenitiesFromWonders()
        return Double(self.population()) - 2.0 - Double(self.luxuries.count) - amenitiesFromBuildings - amenitiesFromWonders
    }
    
    public func add(luxury: ResourceType) {
        
        guard luxury.usage() == .luxury else {
            fatalError("resource must be luxury")
        }
        
        self.luxuries.append(luxury)
    }
    
    public func has(luxury: ResourceType) -> Bool {
        
        return self.luxuries.contains(luxury)
    }
    
    private func amenitiesFromLuxuries() -> Double {
        
        return Double(self.luxuries.count)
    }
    
    private func amenitiesFromBuildings() -> Double {
    
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
        
        var amenitiesFromBuildings: Double = 0.0
        
        // gather amenities from buildingss
        for building in BuildingType.all {
            if buildings.has(building: building) {
                amenitiesFromBuildings += Double(building.amenities())
            }
        }
        
        return amenitiesFromBuildings
    }

    private func amenitiesFromWonders() -> Double {
    
        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }
        
        var amenitiesFromWonders: Double = 0.0
        
        // gather amenities from buildingss
        for wonder in WonderType.all {
            if wonders.has(wonder: wonder) {
                amenitiesFromWonders += Double(wonder.amenities())
            }
        }
        
        return amenitiesFromWonders
    }
    
    public func amenitiesPerTurn(in gameModel: GameModel?) -> Double {
        
        var amenitiesPerTurn: Double = 0.0
        
        amenitiesPerTurn += self.amenitiesFromLuxuries()
        //amenitiesPerTurn += self.amenitiesFromGovernmentType()
        amenitiesPerTurn += self.amenitiesFromBuildings()
        amenitiesPerTurn += self.amenitiesFromWonders()
        
        return amenitiesPerTurn
    }
    
    public func amenitiesState(in gameModel: GameModel?) -> AmenitiesState {
        
        let amenities = self.amenitiesPerTurn(in: gameModel)
        let amenitiesDiff = amenities - self.populationValue + 2.0 // first two people dont need amentities
        
        if amenitiesDiff >= 3.0 {
            return .ecstatic
        } else if amenitiesDiff == 1.0 || amenitiesDiff == 2.0 {
            return .happy
        } else if amenitiesDiff == 0.0 {
            return .content
        } else if amenitiesDiff == -1.0 || amenitiesDiff == -2.0 {
            return .displeased
        } else if amenitiesDiff == -3.0 || amenitiesDiff == -4.0 {
            return .unhappy
        } else if amenitiesDiff == -5.0 || amenitiesDiff == -6.0 {
            return .unrest
        } else {
            return .revolt
        }
    }
    
    // https://civilization.fandom.com/wiki/Amenities_(Civ6)
    public func amenitiesModifier(in gameModel: GameModel?) -> Double {
        
        switch self.amenitiesState(in: gameModel) {
            
        case .ecstatic: return 1.2
        case .happy: return 1.1
        case .content: return 1.0
        case .displeased: return 0.85
        case .unhappy: return 0.70
        case .unrest: return 0.0
        case .revolt: return 0.0
        }
    }
    
    public func doGrowth(in gameModel: GameModel?) {
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // update housing value
        self.buildings?.updateHousing()

        let foodPerTurn = self.foodPerTurn(in: gameModel)
        self.setLastTurn(foodHarvested: foodPerTurn)
        let foodEatenPerTurn = self.foodConsumption()
        var foodDiff = foodPerTurn - foodEatenPerTurn

        if foodDiff < 0 {
            
            // notify human about starvation
            if player.isHuman() {
                self.player?.notifications()?.addNotification(of: .starving, for: self.player, message: "The City of \(self.name) is starving! If it runs out of stored Food, a Citizen will die!", summary: "\(self.name) is Starving!", at: self.location)
            }
        }
        
        // housing
        foodDiff *= self.housingModifier(in: gameModel)
        
        // amenities
        foodDiff *= self.amenitiesModifier(in: gameModel)

        self.setLastTurn(foodEarned: foodDiff)
        
        self.set(foodBasket: self.foodBasket() + foodDiff)

        if self.foodBasket() >= self.growthThreshold() {
            
            if cityCitizens.isForcedAvoidGrowth() {
                // don't grow a city, if we are at avoid growth
                self.set(foodBasket: self.growthThreshold())
            } else {
                self.set(foodBasket: 0)
                self.set(population: self.population() + 1, in: gameModel)

                gameModel?.userInterface?.update(city: self)
                
                // Only show notification if the city is small
                if self.populationValue <= 5 {
                    
                    if player.isHuman() {
                        //gameModel?.add(message: CityGrowthMessage(in: self))
                        self.player?.notifications()?.addNotification(of: .cityGrowth, for: self.player, message: "The City of \(self.name) now has \(self.population()) [ICON_CITIZEN] Citizens! The new Citizen will automatically work the land near the City for additional [ICON_FOOD] Food, [ICON_PRODUCTION] Production or [ICON_GOLD] Gold.", summary: "\(self.name) has Grown!", at: self.location)
                    }
                }
            }
        } else if self.foodBasket() < 0 {
            
            self.set(foodBasket: 0)

            if self.population() > 1 {
                self.set(population: self.population() - 1, in: gameModel)
            }
        }
    }
    
    public func growthInTurns() -> Int {
        
        let foodNeeded = self.growthThreshold() - self.foodBasket()
        
        if self.lastTurnFoodEarned() == 0.0 {
            return Int(foodNeeded)
        }

        return Int(foodNeeded / self.lastTurnFoodEarned())
    }
    
    func baseHousing(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        if let tile = gameModel.tile(at: self.location) {
            for neighbor in self.location.neighbors() {
                if let neighborTile = gameModel.tile(at: neighbor) {
                    if tile.isRiverToCross(towards: neighborTile) {
                        return 5
                    }
                }
            }
        }
        
        if gameModel.isCoastal(at: self.location) {
            return 3
        }
        
        return 2
    }
    
    func doCheckProduction(in gameModel: GameModel?) -> Bool {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }

        var okay = true

        let maxedUnitGoldPercent = 100 /* MAXED_UNIT_GOLD_PERCENT*/
        let maxedBuildingGoldPercent = 100 /* MAXED_BUILDING_GOLD_PERCENT */
        let maxedProjectGoldPercent = 300 /* MAXED_PROJECT_GOLD_PERCENT */

        /*for unitType in UnitType.all {
            
            let unitProduction = self.unitProduction(of: unitType)
            if unitProduction > 0 {
                
                if player.isProductionMaxedUnitClass((UnitClassTypes)(pkUnitInfo)->GetUnitClassType()) {
                    
                    let productionGold = ((unitProduction * maxedUnitGoldPercent) / 100)

                    if productionGold > 0 {
                        
                        player.GetTreasury()->ChangeGold(iProductionGold);

                        if (getOwner() == GC.getGame().getActivePlayer())
                        {
                            Localization::String localizedText = Localization::Lookup("TXT_KEY_MISC_LOST_WONDER_PROD_CONVERTED");
                            localizedText << getNameKey() << GC.getUnitInfo((UnitTypes)iI)->GetTextKey() << iProductionGold;
                            DLLUI->AddCityMessage(0, GetIDInfo(), getOwner(), false, GC.getEVENT_MESSAGE_TIME(), localizedText.toUTF8());
                        }
                    }

                    setUnitProduction(((UnitTypes)iI), 0);
                }
            }
        }*/

        /*for buildingType in BuildingType.all {
            
            const BuildingTypes eExpiredBuilding = static_cast<BuildingTypes>(iI);
            CvBuildingEntry* pkExpiredBuildingInfo = GC.getBuildingInfo(eExpiredBuilding);

            //skip if null
            if(pkExpiredBuildingInfo == NULL)
                continue;

            int iBuildingProduction = m_pCityBuildings->GetBuildingProduction(eExpiredBuilding);
            if (iBuildingProduction > 0)
            {
                const BuildingClassTypes eExpiredBuildingClass = (BuildingClassTypes) (pkExpiredBuildingInfo->GetBuildingClassType());

                if (thisPlayer.isProductionMaxedBuildingClass(eExpiredBuildingClass))
                {
                    // Beaten to a world wonder by someone?
                    if (isWorldWonderClass(pkExpiredBuildingInfo->GetBuildingClassInfo()))
                    {
                        for (iPlayerLoop = 0; iPlayerLoop < MAX_MAJOR_CIVS; iPlayerLoop++)
                        {
                            eLoopPlayer = (PlayerTypes) iPlayerLoop;

                            // Found the culprit
                            if (GET_PLAYER(eLoopPlayer).getBuildingClassCount(eExpiredBuildingClass) > 0)
                            {
                                GET_PLAYER(getOwner()).GetDiplomacyAI()->ChangeNumWondersBeatenTo(eLoopPlayer, 1);
                                break;
                            }
                        }

                        auto_ptr<ICvCity1> pDllCity(new CvDllCity(this));
                        DLLUI->AddDeferredWonderCommand(WONDER_REMOVED, pDllCity.get(), (BuildingTypes) eExpiredBuilding, 0);
                        //Add "achievement" for sucking it up
                        gDLL->IncrementSteamStatAndUnlock( ESTEAMSTAT_BEATWONDERS, 10, ACHIEVEMENT_SUCK_AT_WONDERS );
                    }

                    iProductionGold = ((iBuildingProduction * iMaxedBuildingGoldPercent) / 100);

                    if (iProductionGold > 0)
                    {
                        thisPlayer.GetTreasury()->ChangeGold(iProductionGold);

                        if (getOwner() == GC.getGame().getActivePlayer())
                        {
                            Localization::String localizedText = Localization::Lookup("TXT_KEY_MISC_LOST_WONDER_PROD_CONVERTED");
                            localizedText << getNameKey() << pkExpiredBuildingInfo->GetTextKey() << iProductionGold;
                            DLLUI->AddCityMessage(0, GetIDInfo(), getOwner(), false, GC.getEVENT_MESSAGE_TIME(), localizedText.toUTF8());
                        }
                    }

                    m_pCityBuildings->SetBuildingProduction(eExpiredBuilding, 0);
                }
            }
        }*/

        /*for projectType in ProjectType.all {
            
            int iProjectProduction = getProjectProduction((ProjectTypes)iI);
            if (iProjectProduction > 0)
            {
                if (thisPlayer.isProductionMaxedProject((ProjectTypes)iI))
                {
                    iProductionGold = ((iProjectProduction * iMaxedProjectGoldPercent) / 100);

                    if (iProductionGold > 0)
                    {
                        thisPlayer.GetTreasury()->ChangeGold(iProductionGold);

                        if (getOwner() == GC.getGame().getActivePlayer())
                        {
                            Localization::String localizedText = Localization::Lookup("TXT_KEY_MISC_LOST_WONDER_PROD_CONVERTED");
                            localizedText << getNameKey() << GC.getProjectInfo((ProjectTypes)iI)->GetTextKey() << iProductionGold;
                            DLLUI->AddCityMessage(0, GetIDInfo(), getOwner(), false, GC.getEVENT_MESSAGE_TIME(), localizedText.toUTF8());
                        }
                    }

                    setProjectProduction(((ProjectTypes)iI), 0);
                }
            }
        }*/

        if !self.isProduction() && player.isHuman() && !self.isProductionAutomated() {
            
            self.player?.notifications()?.addNotification(of: .productionNeeded, for: self.player, message: "Your city \(self.name) needs something to work on.", summary: "need production", at: self.location)
            return okay
        }

        // Can now construct an Upgraded version of this Unit
        /*for (iI = 0; iI < iNumUnitInfos; iI++)
        {
            if (getFirstUnitOrder((UnitTypes)iI) != -1)
            {
                // If we can still actually train this Unit type then don't auto-upgrade it yet
                if (canTrain((UnitTypes)iI, true))
                {
                    continue;
                }

                eUpgradeUnit = allUpgradesAvailable((UnitTypes)iI);

                if (eUpgradeUnit != NO_UNIT)
                {
                    CvAssertMsg(eUpgradeUnit != iI, "Trying to upgrade a Unit to itself");
                    iUpgradeProduction = getUnitProduction((UnitTypes)iI);
                    setUnitProduction(((UnitTypes)iI), 0);
                    setUnitProduction(eUpgradeUnit, iUpgradeProduction);

                    pOrderNode = headOrderQueueNode();

                    while (pOrderNode != NULL)
                    {
                        if (pOrderNode->eOrderType == ORDER_TRAIN)
                        {
                            if (pOrderNode->iData1 == iI)
                            {
                                thisPlayer.changeUnitClassMaking(((UnitClassTypes)(GC.getUnitInfo((UnitTypes)(pOrderNode->iData1))->GetUnitClassType())), -1);
                                pOrderNode->iData1 = eUpgradeUnit;
                                thisPlayer.changeUnitClassMaking(((UnitClassTypes)(GC.getUnitInfo((UnitTypes)(pOrderNode->iData1))->GetUnitClassType())), 1);
                            }
                        }

                        pOrderNode = nextOrderQueueNode(pOrderNode);
                    }
                }
            }
        }*/

        // Can now construct an Upgraded version of this Building
        /*for (iI = 0; iI < iNumBuildingInfos; iI++)
        {
            const BuildingTypes eBuilding = static_cast<BuildingTypes>(iI);
            CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
            if(pkBuildingInfo)
            {
                if (getFirstBuildingOrder(eBuilding) != -1)
                {
                    BuildingClassTypes eBuildingClass = (BuildingClassTypes) pkBuildingInfo->GetReplacementBuildingClass();

                    if (eBuildingClass != NO_BUILDINGCLASS)
                    {
                        BuildingTypes eUpgradeBuilding = ((BuildingTypes) (thisPlayer.getCivilizationInfo().getCivilizationBuildings(eBuildingClass)));

                        if (canConstruct(eUpgradeBuilding))
                        {
                            CvAssertMsg(eUpgradeBuilding != iI, "Trying to upgrade a Building to itself");
                            iUpgradeProduction = m_pCityBuildings->GetBuildingProduction(eBuilding);
                            m_pCityBuildings->SetBuildingProduction((eBuilding), 0);
                            m_pCityBuildings->SetBuildingProduction(eUpgradeBuilding, iUpgradeProduction);

                            pOrderNode = headOrderQueueNode();

                            while (pOrderNode != NULL)
                            {
                                if (pOrderNode->eOrderType == ORDER_CONSTRUCT)
                                {
                                    if (pOrderNode->iData1 == iI)
                                    {
                                        CvBuildingEntry* pkOrderBuildingInfo = GC.getBuildingInfo((BuildingTypes)pOrderNode->iData1);
                                        CvBuildingEntry* pkUpgradeBuildingInfo = GC.getBuildingInfo(eUpgradeBuilding);

                                        if(NULL != pkOrderBuildingInfo && NULL != pkUpgradeBuildingInfo)
                                        {
                                            const BuildingClassTypes eOrderBuildingClass = (BuildingClassTypes)pkOrderBuildingInfo->GetBuildingClassType();
                                            const BuildingClassTypes eUpgradeBuildingClass = (BuildingClassTypes)pkUpgradeBuildingInfo->GetBuildingClassType();

                                            thisPlayer.changeBuildingClassMaking(eOrderBuildingClass, -1);
                                            pOrderNode->iData1 = eUpgradeBuilding;
                                            thisPlayer.changeBuildingClassMaking(eUpgradeBuildingClass, 1);

                                        }
                                    }
                                }

                                pOrderNode = nextOrderQueueNode(pOrderNode);
                            }
                        }
                    }
                }
            }
        }*/

        okay = self.cleanUpQueue(in: gameModel)

        return okay
    }
    
    /// remove items in the queue that are no longer valid
    func cleanUpQueue(in gameModel: GameModel?) -> Bool {
        
        var okay = true

        for buildItem in self.buildQueue {
 
            if !self.canContinueProduction(item: buildItem, in: gameModel) {
                self.buildQueue.remove(item: buildItem)
                okay = false
            }
        }

        return okay
    }
    
    func canContinueProduction(item: BuildableItem, in gameModel: GameModel?) -> Bool {
        
        switch item.type {
            
            case .unit:
                return self.canTrain(unit: item.unitType!)
            case .building:
                return self.canBuild(building: item.buildingType!)
            case .wonder:
                return self.canBuild(wonder: item.wonderType!, in: gameModel)
            case .district:
                return self.canConstruct(district: item.districtType!, in: gameModel)
            case .project:
                return self.canBuild(project: item.projectType!)
        }
    }

    func isProduction() -> Bool {
        
        if self.buildQueue.peek() != nil {
            return true
        }
        
        return false
    }
    
    public func isProductionAutomated() -> Bool {
        
        return self.productionAutomatedValue
    }

    public func setProductionAutomated(to newValue: Bool, clear: Bool, in gameModel: GameModel?) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if self.isProductionAutomated() != newValue {
            
            self.productionAutomatedValue = newValue

            /*if ((getOwner() == GC.getGame().getActivePlayer()) && isCitySelected())
            {
                DLLUI->setDirty(SelectionButtons_DIRTY_BIT, true);
            }*/

            // if automated and not network game and all 3 modifiers down, clear the queue and choose again
            if newValue && clear {
                self.buildQueue.clear()
            }
            
            if !isProduction() && !player.isHuman() {
                self.AI_chooseProduction(interruptWonders: false, in: gameModel)
            }
        }
    }
    
    private func goldFromTiles(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var goldValue: Double = 0.0
        
        if let centerTile = gameModel.tile(at: self.location) {
            
            goldValue += centerTile.yields(for: self.player, ignoreFeature: false).gold
        }
        
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    goldValue += adjacentTile.yields(for: self.player, ignoreFeature: false).gold
                }
            }
        }
        
        return goldValue
    }
    
    private func goldFromGovernmentType() -> Double {
        
        guard let player = self.player else {
            fatalError("no player provided")
        }
        
        var foodFromGovernmentType: Double = 0.0
        
        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                foodFromGovernmentType += 1
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {

                foodFromGovernmentType += 1
            }
        }
        
        return foodFromGovernmentType
    }
    
    private func goldFromBuildings() -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("Cant get buildings")
        }
        
        var goldFromBuildings: Double = 0.0
        
        // 
        if buildings.has(building: .palace) {
            goldFromBuildings += BuildingType.palace.yields().gold
        }
        
        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                goldFromBuildings += building.yields().gold
            }
        }
        
        return goldFromBuildings
    }
    
    public func goldPerTurn(in gameModel: GameModel?) -> Double {
        
        var goldPerTurn: Double = 0.0
        
        goldPerTurn += self.goldFromTiles(in: gameModel)
        goldPerTurn += self.goldFromGovernmentType()
        goldPerTurn += self.goldFromBuildings()
        
        return goldPerTurn
    }
    
    private func scienceFromTiles(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var scienceFromTiles: Double = 0.0
        
        if let centerTile = gameModel.tile(at: self.location) {
            
            scienceFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).science
        }
        
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    scienceFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).science
                }
            }
        }
        
        return scienceFromTiles
    }
    
    private func scienceFromGovernmentType() -> Double {
        
        guard let player = self.player else {
            fatalError("Cant get player")
        }
        
        var scienceFromGovernmentValue: Double = 0.0
        
        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                scienceFromGovernmentValue += 1
            }
        }
        
        return scienceFromGovernmentValue
    }
    
    private func scienceFromBuildings() -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
         
        var scienceFromBuildings: Double = 0.0
        
        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                scienceFromBuildings += building.yields().science
            }
        }
        
        return scienceFromBuildings
    }
    
    private func scienceFromPopulation() -> Double {
        
        // science & culture from population
        return self.populationValue * 0.5
    }
    
    public func sciencePerTurn(in gameModel: GameModel?) -> Double {
        
        var sciencePerTurn: Double = 0.0
        
        sciencePerTurn += self.scienceFromTiles(in: gameModel)
        sciencePerTurn += self.scienceFromGovernmentType()
        sciencePerTurn += self.scienceFromBuildings()
        sciencePerTurn += self.scienceFromPopulation()
        sciencePerTurn += self.baseYieldRateFromSpecialists.weight(of: .science)
        
        return sciencePerTurn
    }
    
    private func cultureFromTiles(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var cultureFromTiles: Double = 0.0
        
        if let centerTile = gameModel.tile(at: self.location) {
            
            cultureFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).culture
        }
        
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    cultureFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).culture
                }
            }
        }
        
        return cultureFromTiles
    }
    
    private func cultureFromGovernmentType() -> Double {
        
        guard let player = self.player else {
            fatalError("Cant get player")
        }
        
        var cultureFromGovernmentValue: Double = 0.0
        
        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                cultureFromGovernmentValue += 1
            }
        }
        
        return cultureFromGovernmentValue
    }
    
    private func cultureFromBuildings() -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
         
        var cultureFromBuildings: Double = 0.0
        
        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                cultureFromBuildings += building.yields().culture
            }
        }
        
        return cultureFromBuildings
    }
    
    private func cultureFromPopulation() -> Double {
        
        // science & culture from population
        return self.populationValue * 0.3
    }
    
    public func culturePerTurn(in gameModel: GameModel?) -> Double {
        
        var culturePerTurn: Double = 0.0
        
        culturePerTurn += self.cultureFromTiles(in: gameModel)
        culturePerTurn += self.cultureFromGovernmentType()
        culturePerTurn += self.cultureFromBuildings()
        culturePerTurn += self.cultureFromPopulation()
        culturePerTurn += self.baseYieldRateFromSpecialists.weight(of: .culture)
        
        return culturePerTurn
    }
    
    private func faithFromTiles(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var faithFromTiles: Double = 0.0
        
        if let centerTile = gameModel.tile(at: self.location) {
            
            faithFromTiles += centerTile.yields(for: self.player, ignoreFeature: false).faith
        }
        
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    faithFromTiles += adjacentTile.yields(for: self.player, ignoreFeature: false).faith
                }
            }
        }
        
        return faithFromTiles
    }
    
    private func faithFromGovernmentType() -> Double {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        var faithFromGovernmentValue: Double = 0.0
        
        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                faithFromGovernmentValue += 1
            }

            // godKing
            if government.has(card: .godKing) && self.capitalValue == true {

                faithFromGovernmentValue += 1
            }
        }
        
        return faithFromGovernmentValue
    }
    
    private func faithFromBuildings() -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }
        
        var faithFromBuildings: Double = 0.0
        
        // gather yields from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                faithFromBuildings += building.yields().faith
            }
        }
        
        return faithFromBuildings
    }
    
    public func faithPerTurn(in gameModel: GameModel?) -> Double {
        
        var faithPerTurn: Double = 0.0
        
        faithPerTurn += self.faithFromTiles(in: gameModel)
        faithPerTurn += self.faithFromGovernmentType()
        faithPerTurn += self.faithFromBuildings()
        
        return faithPerTurn
    }
    
    public func productionPerTurn(in gameModel: GameModel?) -> Double {
    
        var productionPerTurn: Double = 0.0
        
        productionPerTurn += self.productionFromTiles(in: gameModel)
        productionPerTurn += self.productionFromGovernmentType()
        productionPerTurn += self.productionFromBuilding()
        productionPerTurn += self.featureProduction()
        
        return productionPerTurn
    }
    
    private func productionFromTiles(in gameModel: GameModel?) -> Double {
        
        guard let gameModel = gameModel else {
            fatalError("no game model provided")
        }
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("no cityCitizens provided")
        }
        
        var productionValue: Double = 0.0
        
        if let centerTile = gameModel.tile(at: self.location) {
            
            productionValue += centerTile.yields(for: self.player, ignoreFeature: false).production

            // The yield of the tile occupied by the city center will be increased to 2 Food and 1 Production, if either was previously lower (before any bonus yields are applied).
            if productionValue < 1.0 {
                productionValue = 1.0
            }
        }
        
        for point in cityCitizens.workingTileLocations() {
            if cityCitizens.isWorked(at: point) {
                if let adjacentTile = gameModel.tile(at: point) {
                    productionValue += adjacentTile.yields(for: self.player, ignoreFeature: false).production
                }
            }
        }
        
        return productionValue
    }
    
    func productionFromGovernmentType() -> Double {
        
        guard let player = self.player else {
            fatalError("no player provided")
        }
        
        var productionFromGovernmentType: Double = 0.0
        
        // yields from government
        if let government = player.government {

            // https://civilization.fandom.com/wiki/Autocracy_(Civ6)
            // Capital receives +1 boost to all yields.
            if government.currentGovernment() == .autocracy && self.capitalValue == true {

                productionFromGovernmentType += 1
            }

            // urbanPlanning: +1 Production in all cities.
            if government.has(card: .urbanPlanning) {

                productionFromGovernmentType += 1
            }
        }

        return productionFromGovernmentType
    }
    
    func productionFromBuilding() -> Double {
        
        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }
        
        var foodFromBuilding: Double = 0.0
        
        // gather food from builds
        for building in BuildingType.all {
            if buildings.has(building: building) {
                foodFromBuilding += building.yields().production
            }
        }
        
        return foodFromBuilding
    }
    
    //    --------------------------------------------------------------------------------
    func doProduction(allowNoProduction: Bool, in gameModel: GameModel?) {

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if !player.isHuman() || self.isProductionAutomated() {
            if !self.isProduction() /*|| self.isProductionProcess() || AI_isChooseProductionDirty() */ {
                self.AI_chooseProduction(interruptWonders: false, in: gameModel /*bInterruptWonders*/)
            }
        }

        if !allowNoProduction && !self.isProduction() {
            return
        }

        // processes are wealth or science
        /*if self.isProductionProcess() {
            return
        }*/

        if self.isProduction() {

            /*if (isProductionBuilding())
            {
                const OrderData* pOrderNode = headOrderQueueNode();
                int iData1 = -1;
                if (pOrderNode != NULL)
                {
                    iData1 = pOrderNode->iData1;
                }

                const BuildingTypes eBuilding = static_cast<BuildingTypes>(iData1);
                CvBuildingEntry* pkBuildingInfo = GC.getBuildingInfo(eBuilding);
                if(pkBuildingInfo)
                {
                    if (isWorldWonderClass(pkBuildingInfo->GetBuildingClassInfo()))
                    {
                        if (m_pCityBuildings->GetBuildingProduction(eBuilding) == 0) // otherwise we are probably already showing this
                        {
                            auto_ptr<ICvCity1> pDllCity(new CvDllCity(this));
                            DLLUI->AddDeferredWonderCommand(WONDER_CREATED, pDllCity.get(), eBuilding, 0);
                        }
                    }
                }
            }*/

            let production = self.productionPerTurn(in: gameModel)
            self.updateProduction(for: production, in: gameModel)

            //setOverflowProduction(0);
            self.setFeatureProduction(to: 0.0)
        } else {
            // changeOverflowProductionTimes100(getCurrentProductionDifferenceTimes100(false, false));
            fatalError("shfdfgj")
        }
    }
    
    // TODO rename
    func AI_chooseProduction(interruptWonders: Bool, in gameModel: GameModel?) {
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let citySpecializationAI = player.citySpecializationAI else {
            fatalError("cant get citySpecializationAI")
        }
        
        var buildWonder = false

        // See if this is the one AI city that is supposed to be building wonders
        if citySpecializationAI.wonderBuildCity()?.location == self.location {
            
            // Is it still working on that wonder and we don't want to interrupt it?
            if !interruptWonders {
                
                if self.productionWonder() != nil {
                    // Stay the course
                    return
                }
            }

            // So we're the wonder building city but it is not underway yet...

            // Has the designated wonder been poached by another civ?
            let nextWonderType = citySpecializationAI.nextWonderDesired()
            if !self.canBuild(wonder: nextWonderType, in: gameModel) {
                // Reset city specialization
                //citySpecializationAI.->SetSpecializationsDirty(SPECIALIZATION_UPDATE_WONDER_BUILT_BY_RIVAL);
                fatalError("need to trigger the selection of new wonder")
            } else {
                buildWonder = true
            }
        }

        if buildWonder {
            
            self.startBuilding(wonder: citySpecializationAI.nextWonderDesired())

            /*if (GC.getLogging() && GC.getAILogging())
            {
                CvString playerName;
                FILogFile *pLog;
                CvString strBaseString;
                CvString strOutBuf;

                m_pCityStrategyAI->LogCityProduction(buildable, false);

                playerName = kOwner.getCivilizationShortDescription();
                pLog = LOGFILEMGR.GetLog(kOwner.GetCitySpecializationAI()->GetLogFileName(playerName), FILogFile::kDontTimeStamp);
                strBaseString.Format ("%03d, ", GC.getGame().getElapsedGameTurns());
                strBaseString += playerName + ", ";
                strOutBuf.Format("%s, WONDER - Started %s, Turns: %d", getName().GetCString(), GC.getBuildingInfo((BuildingTypes)buildable.m_iIndex)->GetDescription(), buildable.m_iTurnsToConstruct);
                strBaseString += strOutBuf;
                pLog->Msg(strBaseString);
            }*/
        } else {
            self.cityStrategy?.chooseProduction(in: gameModel)
            gameModel?.userInterface?.update(city: self)
        }

        return;
    }

    public func foodBasket() -> Double {

        return self.foodBasketValue
    }

    public func set(foodBasket: Double) {

        self.foodBasketValue = foodBasket
    }
    
    // MARK: production
    
    public func productionLastTurn() -> Double {
        
        return self.productionLastTurnValue
    }

    //    Be very careful with setting bReassignPop to false.  This assumes that the caller
    //  is manually adjusting the worker assignments *and* handling the setting of
    //  the CityCitizens unassigned worker value.
    public func set(population newPopulation: Int, reassignCitizen: Bool = true, in gameModel: GameModel?) {

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
    
    public func change(population change: Int, reassignCitizen: Bool = true, in gameModel: GameModel?) {
        
        self.set(population: self.population() + change, reassignCitizen: reassignCitizen, in: gameModel)
    }

    public func population() -> Int {

        return Int(self.populationValue)
    }
    
    private func train(unitType: UnitType, in gameModel: GameModel?) {
        
        let unit = Unit(at: self.location, type: unitType, owner: self.player)
        gameModel?.add(unit: unit)
        
        gameModel?.userInterface?.show(unit: unit)
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

    public func canBuild(building: BuildingType) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let buildings = self.buildings else {
            fatalError("cant get buildings")
        }

        if buildings.has(building: building) {
            return false
        }

        if let requiredTech = building.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }
        
        if let requiredCivic = building.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        if !self.has(district: building.district()) {
            return false
        }

        return true
    }
    
    public func canBuild(wonder: WonderType, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let wonders = self.wonders else {
            fatalError("cant get wonders")
        }
        
        if wonders.has(wonder: wonder) {
            return false
        }
        
        if let requiredTech = wonder.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }
        
        if let requiredCivic = wonder.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }

        //
        if gameModel.alreadyBuilt(wonder: wonder) {
            return false
        }

        return true
    }
    
    public func canConstruct(district districtType: DistrictType, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // can build only once
        if self.has(district: districtType) {
            return false
        }
        
        if let requiredTech = districtType.requiredTech() {
            if !player.has(tech: requiredTech) {
                return false
            }
        }
        
        if let requiredCivic = districtType.requiredCivic() {
            if !player.has(civic: requiredCivic) {
                return false
            }
        }
        
        var foundValidNeighbor = false
        for neighbor in self.location.neighbors() {
            if districtType.canConstruct(on: neighbor, in: gameModel) {
                foundValidNeighbor = true
            }
        }
        
        if foundValidNeighbor == false {
            return false
        }
        
        return true
    }

    public func canTrain(unit unitType: UnitType) -> Bool {

        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        // filter great people
        if unitType.productionCost() < 0 {
            return false
        }

        if let requiredTech = unitType.requiredTech() {
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

    public func canBuild(project: ProjectType) -> Bool {

        return false
    }

    public func has(district: DistrictType) -> Bool {

        if district == .cityCenter {
            return true
        }
        
        guard let districts = self.districts else {
            return false
        }

        return districts.has(district: district)
    }
    
    public func has(building: BuildingType) -> Bool {
        
        guard let buildings = self.buildings else {
            return false
        }
        
        return buildings.has(building: building)
    }
    
    func productionWonder() -> WonderType? {
        
        if let currentProduction = self.buildQueue.peek() {
            
            if currentProduction.type == .wonder {
                return currentProduction.wonderType
            }
        }
        
        return nil
    }
    
    public func setRouteToCapitalConnected(value connected: Bool) {
        
        self.routeToCapitalConnectedThisTurn = connected
    }

    public func startTraining(unit unitType: UnitType) {

        self.buildQueue.add(item: BuildableItem(unitType: unitType))
    }

    public func startBuilding(building buildingType: BuildingType) {

        self.buildQueue.add(item: BuildableItem(buildingType: buildingType))
    }
    
    public func startBuilding(wonder wonderType: WonderType) {
        
        self.buildQueue.add(item: BuildableItem(wonderType: wonderType))
    }
    
    public func startBuilding(district: DistrictType) {
        
        self.buildQueue.add(item: BuildableItem(districtType: district))
    }

    public func buildingProductionTurnsLeft(for buildingType: BuildingType) -> Int {

        if let buildingTypeItem = self.buildQueue.building(of: buildingType) {
            return Int(buildingTypeItem.productionLeft() / self.productionLastTurnValue)
        }

        return 100
    }

    public func unitProductionTurnsLeft(for unitType: UnitType) -> Int {

        if let unitTypeItem = self.buildQueue.unit(of: unitType) {
            return Int(unitTypeItem.productionLeft() / self.productionLastTurnValue)
        }

        return 100
    }

    public func currentBuildableItem() -> BuildableItem? {

        return self.buildQueue.peek()
    }

    func growthThreshold() -> Double {

        // https://forums.civfanatics.com/threads/formula-thread.600534/
        // https://forums.civfanatics.com/threads/mathematical-model-comparison.634332/
        //Population growth (food)
        // 15+8*n+n^1.5 (n is current population-1)
        // 15+8*(N-1)+(N-1)^1.5
        // 1=>2 =>> 15+0+0^1.5=15
        // 2=>3 =>> 15+8+1^1.5=24
        // 3=>4 =>> 15+16+2^1.5=34

        var growthThreshold = 15.0 /* BASE_CITY_GROWTH_THRESHOLD */
        growthThreshold += (self.populationValue - 1.0) * 8.0 /* CITY_GROWTH_MULTIPLIER */
        growthThreshold += pow(self.populationValue - 1.0, 1.5 /* CITY_GROWTH_EXPONENT */ )

        return growthThreshold
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

                        self.train(unitType: unitType, in: gameModel)

                        if player.isHuman() {
                            //gameModel?.add(message: CityHasFinishedTrainingMessage(city: self, unit: unitType))
                            //self.player?.notifications()?.add(type: <#T##NotificationType#>, message: <#T##String#>, summary: <#T##String#>, at: <#T##HexPoint#>)
                        }
                    }

                case .building:

                    if let buildingType = currentBuilding.buildingType {

                        self.build(building: buildingType)

                        if player.isHuman() {
                            //gameModel?.add(message: CityHasFinishedBuildingMessage(city: self, building: buildingType))
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
                            //gameModel?.add(message: CityHasFinishedDistrictMessage(city: self, district: districtType))
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
                //gameModel?.add(message: CityNeedsBuildableMessage(city: self))
            } else {
                self.cityStrategy?.chooseProduction(in: gameModel)
            }
        }

        self.productionLastTurnValue = productionPerTurn
    }

    public func featureProduction() -> Double {
        
        return self.featureProductionValue
    }
    
    public func changeFeatureProduction(change: Double) {
        
        self.featureProductionValue += change
    }
    
    public func setFeatureProduction(to value: Double) {
        
        self.featureProductionValue = value
    }

    // Each Citizen6 Citizen living in a city consumes 2 Food per turn, which forms the city's total food consumption.
    public func foodConsumption() -> Double {

        return Double(self.population()) * 2.0
    }
    
    public func hasOnlySmallFoodSurplus() -> Bool {
        
        let exceedFood = self.lastTurnFoodEarnedValue - Double(self.foodConsumption())
        
        return exceedFood < 2.0 && exceedFood > 0.0
    }
    
    public func hasFoodSurplus() -> Bool {
        
        let exceedFood = self.lastTurnFoodEarnedValue - Double(self.foodConsumption())
        
        return exceedFood < 4.0 && exceedFood > 0.0
    }
    
    public func hasEnoughFood() -> Bool {
        
        let exceedFood = self.lastTurnFoodEarnedValue - Double(self.foodConsumption())
        
        return exceedFood > 0.0
    }

    public func maintenanceCostsPerTurn() -> Double {

        guard let districts = self.districts else {
            fatalError("no districts set")
        }
        
        guard let buildings = self.buildings else {
            fatalError("no buildings set")
        }

        var costs = 0.0

        // gather costs from districts
        for district in DistrictType.all {
            if districts.has(district: district) {
                costs += Double(district.maintenanceCost())
            }
        }
        
        // gather costs from buildings
        for building in BuildingType.all {
            if buildings.has(building: building) {
                costs += Double(building.maintenanceCost())
            }
        }

        return costs
    }

    // MARK: attack / damage
    
    public func rangedCombatStrength(against defender: AbstractUnit?, on toTile: AbstractTile?, attacking: Bool) -> Int {
        
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
    
    public func defensiveStrength(against attacker: AbstractUnit?, on ownTile: AbstractTile?, ranged: Bool) -> Int {
        
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
    
    public func isFeatureSurrounded() -> Bool {
        
        return self.isFeatureSurroundedValue
    }
    
    public func isBlockaded() -> Bool {
        return false
    }

    public func garrisonedUnit() -> AbstractUnit? {

        return self.garrisonedUnitValue
    }
    
    public func hasGarrison() -> Bool {
        
        return self.garrisonedUnitValue != nil
    }
    
    public func setGarrison(unit: AbstractUnit?) {
        
        self.garrisonedUnitValue = unit
    }

    public func power() -> Int {

        return Int(pow(Double(self.defensiveStrength(against: nil, on: nil, ranged: false)) / 100.0, 1.5))
    }
    
    public func healthPoints() -> Int {
        
        return self.healthPointsValue
    }
    
    public func set(healthPoints: Int) {
        
        self.healthPointsValue = healthPoints
    }
    
    public func damage() -> Int {
        
        return max(0, self.maxHealthPoints() - self.healthPointsValue)
    }
    
    public func maxHealthPoints() -> Int {
        
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

    public func work(tile: AbstractTile) throws {

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
        try tile.setWorkingCity(to: self)
    }
    
    public func threatValue() -> Int {
        
        return self.threatVal
    }
    
    public func processSpecialist(specialistType: SpecialistType, change: Int) {

        // Civ6: Another difference with the previous game is that Specialists now provide yields only and not Great Person Points, which makes them somewhat less important.
        for yieldType in YieldType.all {
            self.changeBaseYieldRateFromSpecialists(for: yieldType, change: Int(specialistType.yields().value(of: yieldType)) * change)
        }

        self.updateExtraSpecialistYield()
    }
    
    func updateExtraSpecialistYield() {
        
        for yieldType in YieldType.all {
            
            let oldYield = self.extraSpecialistYield.weight(of: yieldType)

            var newYield = 0.0

            for specialistType in SpecialistType.all {
                newYield += Double(self.calculateExtraSpecialistYield(for: yieldType, and: specialistType))
            }

            if oldYield != newYield {
                self.extraSpecialistYield.set(weight: newYield, for: yieldType)
                self.changeBaseYieldRateFromSpecialists(for: yieldType, change: Int(newYield - oldYield))
            }
        }
    }
    
    func calculateExtraSpecialistYield(for yieldType: YieldType, and specialistType: SpecialistType) -> Int {
        
        /*guard let player = self.player else {
            fatalError("cant get player")
        }*/
        
        guard let cityCitizens = self.cityCitizens else {
            fatalError("cant get cityCitizens")
        }
        
        //let yieldMultiplier = player.specialistExtraYield(for: specialistType, and: yieldType) + player.getSpecialistExtraYield(yieldType) /* + player.leader.traits().GetPlayerTraits()->GetSpecialistYieldChange(eSpecialist, eIndex);*/
        let yieldMultiplier = specialistType.yields().value(of: yieldType)
        let extraYield = Int(Double(cityCitizens.specialistCount(of: specialistType)) * yieldMultiplier)

        return extraYield
    }
    
    /// Base yield rate from Specialists
    func changeBaseYieldRateFromSpecialists(for yieldType: YieldType, change: Int) {
        
        if change != 0 {
            let oldYield = self.baseYieldRateFromSpecialists.weight(of: yieldType)
            self.baseYieldRateFromSpecialists.add(weight: Double(change) + oldYield, for: yieldType)

            // notify ui
            /*if (getTeam() == GC.getGame().getActiveTeam())
            {
                if (isCitySelected()) {
                    DLLUI->setDirty(CityScreen_DIRTY_BIT, true);
                }
            }*/
        }
    }
    
    public func doTask(taskType: CityTaskType, target: HexPoint? = nil, in gameModel: GameModel?) -> CityTaskResultType {
        
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
    
    public func lastTurnGarrisonAssigned() -> Int {
        
        return self.lastTurnGarrisonAssignedValue
    }
    
    public func setLastTurnGarrisonAssigned(turn: Int) {
        
        self.lastTurnGarrisonAssignedValue = turn
    }
    
    /// Buy the plot and set it's owner to us (executed by the network code)
    @discardableResult
    public func doBuyPlot(at point: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            return false
        }
        
        let cost = self.buyPlotCost(at: point, in: gameModel)
        player.treasury?.changeGold(by: Double(-cost))
        player.changeNumPlotsBought(change: 1)
        
        // See if there's anyone else nearby that could get upset by this action
        for tilePoint in self.location.areaWith(radius: City.workRadius) {
            
            if let city = gameModel.city(at: tilePoint) {
                
                if !player.isEqual(to: city.player) {
                    city.changeNumPlotsAcquiredBy(otherPlayer: city.player, change: 1)
                }
            }
        }
        
        self.doAcquirePlot(at: point, in: gameModel)
        
        //Achievement test for purchasing 1000 tiles
        return true
    }
    
    /// How much will purchasing this plot cost -- (-1,-1) will return the generic price
    public func buyPlotCost(at point: HexPoint, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        if point.x == -1 && point.y == -1 {
            return player.buyPlotCost()
        }

        guard let tile = gameModel.tile(at: point) else {
            return -1
        }

        // Base cost
        var cost = player.buyPlotCost()

        // Influence cost (e.g. Hills are more expensive than flat land)
        /*guard let cityTile = gameModel.tile(at: self.location) else {
            fatalError("cant get city tile")
        }*/
        
        var distance = gameModel.calculateInfluenceDistance(from: self.location, to: point, limit: City.workRadius, abc: false)

        // Critical hit!
        if point.distance(to: self.location) > City.workRadius {
            return 9999
        }

        // Reduce distance by the cheapest available (so that the costs don't ramp up ridiculously fast)
        distance -= (self.cheapestPlotInfluence() - 1)    // Subtract one because we want 1 to be the lowest value possible

        var influenceCost = distance *  100 /* PLOT_INFLUENCE_DISTANCE_MULTIPLIER */

        // Resource here?
        if tile.resource(for: player) != .none {
            influenceCost -= 100 /* PLOT_BUY_RESOURCE_COST */
        }

        if influenceCost > 100 {
            cost *= influenceCost
            cost /= 100
        }

        // Game Speed Mod
        // iCost *= GC.getGame().getGameSpeedInfo().getGoldPercent();
        // iCost /= 100;

        // cost *= (100 + self.plotBuyCostModifier());
        // cost /= 100;

        // Now round so the number looks neat
        let divisor = 5 /* PLOT_COST_APPEARANCE_DIVISOR */
        cost /= divisor
        cost *= divisor

        return cost
    }
    
    /// What is the cheapest plot we can get
    func doUpdateCheapestPlotInfluence(in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        var lowestCost = Int.max

        for loopPoint in self.location.areaWith(radius: City.workRadius) {
            
            guard let loopPlot = gameModel.tile(at: loopPoint) else {
                continue
            }
                
            // If the plot's not owned by us, it doesn't matter
            if loopPlot.hasOwner() {
                continue
            }

            // we can use the faster, but slightly inaccurate pathfinder here - after all we are using a rand in the equation
            let influenceCost = gameModel.calculateInfluenceDistance(from: self.location, to: loopPoint, limit: City.workRadius, abc: false)

            if influenceCost > 0 {
                // Are we the cheapest yet?
                if influenceCost < lowestCost {
                    lowestCost = influenceCost
                }
            }
        }

        self.set(cheapestPlotInfluence: lowestCost)
    }
    
    var cheapestPlotInfluenceValue: Int = 0
    
    func set(cheapestPlotInfluence: Int) {
        self.cheapestPlotInfluenceValue = cheapestPlotInfluence
    }
    
    func cheapestPlotInfluence() -> Int {
        
        return self.cheapestPlotInfluenceValue
    }
    
    /// Compute how valuable buying a plot is to this city
    public func buyPlotScore(in gameModel: GameModel?) -> (Int, HexPoint) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var bestScore = -1
        var bestPoint: HexPoint = HexPoint.zero

        //int iDX, iDY;

        for tilePoint in self.location.areaWith(radius: City.workRadius) {
            
            guard let tile = gameModel.tile(at: tilePoint) else {
                continue
            }
            
            if self.canBuyPlot(at: tilePoint, in: gameModel) {
                
                let tempScore = self.individualPlotScore(for: tile, in: gameModel)
                
                if tempScore > bestScore {
                    bestScore = tempScore
                    bestPoint = tilePoint
                }
            }
        }

        return (bestScore, bestPoint)
    }
    
    /// Can a specific plot be bought for the city
    func canBuyPlot(at point: HexPoint, ignoreCost: Bool = true, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let player = self.player else {
            return false
        }
        
        guard let targetPlot = gameModel.tile(at: point) else {
            return false
        }

        // if this plot belongs to someone, bail!
        if targetPlot.hasOwner() {
            return false
        }

        // Must be adjacent to a plot owned by this city
        var foundAdjacent = false
        for adjacentPoint in point.neighbors() {
        
            guard let adjacentPlot = gameModel.tile(at: adjacentPoint) else {
                continue
            }
            
            if player.isEqual(to: adjacentPlot.owner()) {
                
                if adjacentPlot.workingCity()?.location == self.location {
                    foundAdjacent = true
                    break
                }
            }
        }

        if !foundAdjacent {
            return false
        }

        // Max range of 3
        if point.distance(to: self.location) > City.workRadius {
            return false
        }

        // check money
        if !ignoreCost {
            
            guard let treasury = player.treasury else {
                fatalError("cant get treasury")
            }
            
            if Int(treasury.value()) < self.buyPlotCost(at: point, in: gameModel) {
                return false
            }
        }

        return true;
    }
    
    /// Compute value of a plot we might buy
    func individualPlotScore(for tile: AbstractTile?, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let player = self.player else {
            fatalError("cant get player")
        }
        
        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        guard let cityStrategyAI = self.cityStrategy else {
            fatalError("cant get cityStrategyAI")
        }
        
        var rtnValue = 0;

        let specializationType = cityStrategyAI.specialization()
        var specializationYield: YieldType = .none

        if specializationType != .none {
            specializationYield = specializationType.yieldType()!
        }

        // Does it have a resource?
        let resource = tile.resource(for: player)
        if resource != .none {
            
            if let revealTech = resource.revealTech() {
                if player.has(tech: revealTech) {
                    
                    let resourceUsage = resource.usage()
                    if resourceUsage == .strategic {
                        // strategic resource?
                        rtnValue += 50 /* AI_PLOT_VALUE_STRATEGIC_RESOURCE */
                    } else if resourceUsage == .luxury {
                        // Luxury resource?
                        var luxuryValue = 40 /* AI_PLOT_VALUE_LUXURY_RESOURCE */

                        // Luxury we don't have yet?
                        if player.numAvailable(resource: resource) == 0 {
                            luxuryValue *= 2
                        }

                        rtnValue += luxuryValue
                    }
                }
            }
        }

        var yieldValue = 0
        
        // Valuate the yields from this plot
        for yieldType in YieldType.all {

            yieldValue = Int(tile.yields(for: self.player, ignoreFeature: false).value(of: yieldType))
            var tempValue = 0

            if yieldType == specializationYield {
                tempValue += yieldValue * 20 /* AI_PLOT_VALUE_SPECIALIZATION_MULTIPLIER */
            } else {
                tempValue += yieldValue * 10 /* AI_PLOT_VALUE_YIELD_MULTIPLIER */
            }

            // Deficient? If so, give it a boost
            if cityStrategyAI.isDeficient(for: yieldType, in: gameModel) {
                tempValue *= 5 /* AI_PLOT_VALUE_DEFICIENT_YIELD_MULTIPLIER */
            }

            yieldValue += tempValue
        }

        rtnValue += yieldValue

        // For each player not on our team, check how close their nearest city is to this plot
        //CvPlayer& owningPlayer = GET_PLAYER(m_eOwner);
        //CvDiplomacyAI* owningPlayerDiploAI = owningPlayer.GetDiplomacyAI();
        
        for loopPlayer in gameModel.players {
            
            if loopPlayer.isAlive() {
                
                if !player.isEqual(to: loopPlayer) && player.hasMet(with: loopPlayer) {
                    
                    let landDisputeLevel = diplomacyAI.landDisputeLevel(with: loopPlayer)
                    
                    if landDisputeLevel != .none {
                         
                        if let city = tile.workingCity() {

                            let distance = tile.point.distance(to: city.location)

                            // Only want to account for civs with a city within 10 tiles
                            if distance < 10 {
                                
                                switch landDisputeLevel {
                                case .fierce:
                                    rtnValue += (10 - distance) *  6 /* AI_PLOT_VALUE_FIERCE_DISPUTE */
                                case .strong:
                                    rtnValue += (10 - distance) * 4 /* AI_PLOT_VALUE_STRONG_DISPUTE */
                                case .weak:
                                    rtnValue += (10 - distance) * 2 /* AI_PLOT_VALUE_WEAK_DISPUTE */
                                default:
                                    // NOOP
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }

        // Modify value based on cost - the higher it is compared to the "base" cost the less the value
        let cost = self.buyPlotCost(at: tile.point, in: gameModel)
        rtnValue *= player.buyPlotCost()

        // Protect against div by 0.
        if cost != 0 {
            rtnValue /= cost
        } else {
            rtnValue = 0
        }

        return rtnValue
    }
    
    /// Acquire the plot and set it's owner to us
    func doAcquirePlot(at point: HexPoint, in gameModel: GameModel?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }
        
        do {
            try tile.set(owner: self.player)
        } catch {
            fatalError("cant set owner")
        }
        
        self.player?.addPlot(at: point)

        self.doUpdateCheapestPlotInfluence(in: gameModel)
    }
    
    public func changeNumPlotsAcquiredBy(otherPlayer: AbstractPlayer?, change: Int) {
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        self.numPlotsAcquiredList.add(weight: change, for: otherPlayer.leader)
    }
    
    public func numPlotsAcquired(by otherPlayer: AbstractPlayer?) -> Int {
        
        guard let otherPlayer = otherPlayer else {
            fatalError("cant get otherPlayer")
        }
        
        return Int(self.numPlotsAcquiredList.weight(of: otherPlayer.leader))
    }
}
