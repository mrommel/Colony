//
//  CityCitizens.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CityFocusType {
    
    case none //NO_CITY_AI_FOCUS_TYPE = -1,

    case food // CITY_AI_FOCUS_TYPE_FOOD,
    case production // CITY_AI_FOCUS_TYPE_PRODUCTION,
    case gold // CITY_AI_FOCUS_TYPE_GOLD,
    case greatPeople // CITY_AI_FOCUS_TYPE_GREAT_PEOPLE,
    case science // CITY_AI_FOCUS_TYPE_SCIENCE,
    case culture // CITY_AI_FOCUS_TYPE_CULTURE,
    case productionGrowth // CITY_AI_FOCUS_TYPE_PROD_GROWTH,
    case goldGrowth // CITY_AI_FOCUS_TYPE_GOLD_GROWTH,
    case faith // CITY_AI_FOCUS_TYPE_FAITH,
}

class SpecialistCountList: WeightedList<SpecialistType> {
    
    override func fill() {
        for specialistType in SpecialistType.all {
            self.add(weight: 0.0, for: specialistType)
        }
    }
    
    func amount(of specialistType: SpecialistType) -> Int {
        
        return Int(self.weight(of: specialistType))
    }
    
    func increase(of specialistType: SpecialistType) {
        
        self.set(weight: Double(self.amount(of: specialistType) + 1), for: specialistType)
    }
    
    func decrease(of specialistType: SpecialistType) {
        
        self.set(weight: Double(self.amount(of: specialistType) - 1), for: specialistType)
    }
}

class GreatPersonProgressList: WeightedList<SpecialistType> {
    
    override func fill() {
        for specialistType in SpecialistType.all {
            self.add(weight: 0.0, for: specialistType)
        }
    }
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvCityCitizens
//!  \brief        Keeps track of Citizens and Specialists in a City
//
//!  Key Attributes:
//!  - One instance for each city
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class CityCitizens {
    
    private var city: AbstractCity?
    
    // surrounding tiles
    private var workingPlots: [WorkingPlot]
    private var focusTypeValue: CityFocusType
    
    private var forceAvoidGrowth: Bool = false
    private var automated: Bool
    private var inited: Bool
    
    private var numCitizensWorkingPlotsValue: Int = 0
    private var numForcedWorkingPlotsValue: Int = 0
    private var numUnassignedCitizensValue: Int = 0
    private var numDefaultSpecialistsValue: Int = 0
    private var numForcedSpecialistsValue: Int = 0
    
    private var noAutoAssignSpecialistsValue: Bool = false
    private var avoidGrowthValue: Bool = false
    private var forceAvoidGrowthValue:  Bool = false
    
    private var numSpecialists: SpecialistCountList // m_aiSpecialistCounts
    private var numSpecialistsInBuilding: [SpecialistBuildingTuple]
    private var numForcedSpecialistsInBuilding: [SpecialistBuildingTuple]
    
    private var specialistGreatPersonProgress: GreatPersonProgressList
    
    // internal classes
    
    struct WorkingPlot {
        
        let location: HexPoint
        var worked: Bool
        var workedForced: Bool = false
    }
    
    struct SpecialistBuildingTuple {
        
        let buildingType: BuildingType
        var specialists: Int
    }
    
    // MARK: constructor
    
    init(city: AbstractCity?) {
        
        self.city = city
        
        self.automated = false
        self.inited = false
        self.focusTypeValue = .productionGrowth
        self.workingPlots = []
        
        self.numSpecialists = SpecialistCountList()
        self.numSpecialists.fill()
        
        self.numSpecialistsInBuilding = []
        self.numForcedSpecialistsInBuilding = []
        
        self.specialistGreatPersonProgress = GreatPersonProgressList()
        self.specialistGreatPersonProgress.fill()
        
        self.initialize()
    }
    
    func initialize() {
        
        guard let city = self.city else {
            fatalError("no city set")
        }
        
        for location in city.location.areaWith(radius: City.workRadius) {
            self.workingPlots.append(WorkingPlot(location: location, worked: false))
        }
    }
    
    func doFound(in gameModel: GameModel?) {
        
        guard let city = self.city else {
            fatalError("no city set")
        }
        
        // always work the home plot (center)
        self.setWorked(at: city.location, worked: true, useUnassignedPool: false)
    }
    
    func doTurn(with gameModel: GameModel?) {
    
        guard let gameModel = gameModel else {
            fatalError("no gameModel provided")
        }
        
        guard let city = self.city else {
            fatalError("no city set")
        }
        
        guard let cityStrategy = city.cityStrategy else {
            fatalError("no cityStrategy set")
        }
        
        guard let player = city.player else {
            fatalError("no player set")
        }
        
        guard let economicAI = player.economicAI else {
            fatalError("no economicAI set")
        }
        
        self.doVerifyWorkingPlots(in: gameModel)

        if !player.isHuman() {
            
            if gameModel.turnsElapsed % 8 == 0 {
                
                self.setFocusType(focus: .goldGrowth)
                self.setNoAutoAssignSpecialists(true, in: gameModel)
                self.setForcedAvoidGrowth(false, in: gameModel)
                
                if city.hasOnlySmallFoodSurplus() {
                    self.setFocusType(focus: .none)
                    self.setNoAutoAssignSpecialists(true, in: gameModel)
                }
            }
            
            if city.isCapital() && cityStrategy.specialization() == .productionWonder {
                
                self.setFocusType(focus: .none)
                self.setNoAutoAssignSpecialists(false, in: gameModel)
                self.setForcedAvoidGrowth(false, in: gameModel)
                
                if city.hasFoodSurplus() {
                    self.setFocusType(focus: .food)
                    self.setNoAutoAssignSpecialists(true, in: gameModel)
                }
            } else if cityStrategy.specialization() == .productionWonder {
                
                self.setFocusType(focus: .production)
                self.setNoAutoAssignSpecialists(false, in: gameModel)
                self.setForcedAvoidGrowth(false, in: gameModel)
                
                if city.hasOnlySmallFoodSurplus() {
                    self.setFocusType(focus: .none)
                    self.setNoAutoAssignSpecialists(true, in: gameModel)
                    self.setForcedAvoidGrowth(false, in: gameModel)
                }
            } else if city.population() < 5 {
                // we want a balanced growth
                self.setFocusType(focus: .none)
                self.setNoAutoAssignSpecialists(true, in: gameModel)
                self.setForcedAvoidGrowth(false, in: gameModel)
            } else {
                // Are we running at a deficit?
                let inDeficit = economicAI.adopted(economicStrategy: .losingMoney)
                if inDeficit {
                    self.setFocusType(focus: .goldGrowth)
                    self.setNoAutoAssignSpecialists(false, in: gameModel)
                    self.setForcedAvoidGrowth(false, in: gameModel)
                    
                    if city.hasOnlySmallFoodSurplus() {
                        self.setFocusType(focus: .none);
                        self.setNoAutoAssignSpecialists(true, in: gameModel);
                    }
                }
                else if gameModel.turnsElapsed % 3 == 0 && player.grandStrategyAI?.activeStrategy == .culture {
                    
                    self.setFocusType(focus: .culture)
                    self.setNoAutoAssignSpecialists(true, in: gameModel)
                    self.setForcedAvoidGrowth(false, in: gameModel)
                    
                    if city.hasOnlySmallFoodSurplus() {
                        self.setFocusType(focus: .none);
                        self.setNoAutoAssignSpecialists(true, in: gameModel)
                    }
                } else {
                    // we aren't a small city, building a wonder, or going broke
                    self.setNoAutoAssignSpecialists(false, in: gameModel)
                    self.setForcedAvoidGrowth(false, in: gameModel)
                    
                    let currentSpecialization = cityStrategy.specialization()
                    if currentSpecialization != .none {
                        
                        if let yieldType = currentSpecialization.yieldType() {

                            if yieldType == .food {
                                self.setFocusType(focus: .food)
                            } else if yieldType == .production {
                                self.setFocusType(focus: .productionGrowth)
                            } else if yieldType == .gold {
                                self.setFocusType(focus: .gold)
                            } else if yieldType == .science {
                                self.setFocusType(focus: .science)
                            } else {
                                self.setFocusType(focus: .none)
                            }
                        } else {
                            self.setFocusType(focus: .none)
                        }
                    } else {
                        self.setFocusType(focus: .none)
                    }
                }
            }
        }

        self.doReallocateCitizens(in: gameModel)
    }
    
    /// Optimize our Citizen Placement
    func doReallocateCitizens(in gameModel: GameModel?) {
        
        guard let buildings = self.city?.buildings else {
            fatalError("cant get buildings")
        }
        
        // Make sure we don't have more forced working plots than we have citizens working.  If so, clean it up before reallocating
        self.doValidateForcedWorkingPlots(in: gameModel)

        // Remove all of the allocated guys
        let numCitizensToRemove = self.numCitizensWorkingPlots()
        for _ in 0..<numCitizensToRemove {
            self.doRemoveWorstCitizen(in: gameModel)
        }

        // Remove Non-Forced Specialists in Buildings
        for buildingType in BuildingType.all {
            
            // Have this Building in the City?
            if buildings.has(building: buildingType) {
                
                // Don't include Forced guys
                let numSpecialistsToRemove = self.numSpecialists(in: buildingType) - self.numForcedSpecialists(in: buildingType)
                
                // Loop through guys to remove (if there are any)
                for _ in 0..<numSpecialistsToRemove {
                    self.doRemoveSpecialist(from: buildingType, forced: false, in: gameModel)
                }
            }
        }

        // Remove Default Specialists
        let numDefaultsToRemove = self.numDefaultSpecialists() - self.numForcedDefaultSpecialists()
        for _ in 0..<numDefaultsToRemove {
            self.changeNumDefaultSpecialists(change: -1)
        }

        // Now put all of the unallocated guys back
        let numToAllocate = self.numUnassignedCitizens()
        for _ in 0..<numToAllocate {
            self.doAddBestCitizenFromUnassigned(in: gameModel)
        }
    }
    
    /// Make sure we don't have more forced working plots than we have citizens to work
    func doValidateForcedWorkingPlots(in gameModel: GameModel?) {
        
        let numForcedWorkingPlotsToDemote = self.numForcedWorkingPlots() - self.numCitizensWorkingPlots()

        if numForcedWorkingPlotsToDemote > 0 {
            for _ in 0..<numForcedWorkingPlotsToDemote {
                self.doDemoteWorstForcedWorkingPlot(in: gameModel)
            }
        }
    }
    
    /// Remove the Forced status from the worst ForcedWorking plot
    func doDemoteWorstForcedWorkingPlot(in gameModel: GameModel?) {
        
        var bestPlotValue = -1
        var bestPlotID: HexPoint? = nil

        // Look at all workable Plots
        for workableTile in self.workableTiles(in: gameModel) {
            
            guard let city = self.city else {
                fatalError("cant get city")
            }
            
            guard let workableTile = workableTile else {
                continue
            }
            
            // skip home plot
            if workableTile.point == city.location {
                continue
            }
            
            if self.isForcedWorked(at: workableTile.point) {
            
                let value = self.GetPlotValue(of: workableTile.point, useAllowGrowthFlag: false, in: gameModel)

                // First, or worst yet?
                if bestPlotValue == -1 || value < bestPlotValue {
                    bestPlotValue = value
                    bestPlotID = workableTile.point
                }
            }
        }

        if let bestPlotID = bestPlotID {
            self.forceWorkingPlot(at: bestPlotID, force: false)
        }
    }
    
    /// Removes and uninitializes a Specialist for this building
    func doRemoveSpecialist(from buildingType: BuildingType, forced: Bool, eliminatePopulation: Bool = false, in gameModel: GameModel?) {

        guard let city = self.city else {
            fatalError("no city set")
        }
        
        let specialistType = buildingType.specialistType()

        let numSpecialistsAssigned = self.numSpecialists(in: buildingType)

        // Need at least 1 assigned to remove
        if numSpecialistsAssigned > 0 {
            
            // Decrease count for the whole city
            self.numSpecialists.decrease(of: specialistType)
            self.decreaseNumberOfSpecialists(in: buildingType)

            if forced {
                self.decreaseNumberOfForcedSpecialists(in: buildingType)
            }

            city.processSpecialist(specialistType: specialistType, change: -1)

            // Do we kill this population or reassign him?
            if eliminatePopulation {
                city.change(population: -1, reassignCitizen: false, in: gameModel)
            } else {
                self.changeNumUnassignedCitizens(change: 1);
            }

            /* FIXME notify ui
            GC.GetEngineUserInterface()->setDirty(GameData_DIRTY_BIT, true);
            GC.GetEngineUserInterface()->setDirty(CityInfo_DIRTY_BIT, true);
            //GC.GetEngineUserInterface()->setDirty(InfoPane_DIRTY_BIT, true );
            GC.GetEngineUserInterface()->setDirty(CityScreen_DIRTY_BIT, true);
            GC.GetEngineUserInterface()->setDirty(ColoredPlots_DIRTY_BIT, true);

            auto_ptr<ICvCity1> pCity = GC.WrapCityPointer(GetCity());

            GC.GetEngineUserInterface()->SetSpecificCityInfoDirty(pCity.get(), CITY_UPDATE_TYPE_SPECIALISTS);
            */
        }
    }
    
    func numSpecialists(in buildingType: BuildingType) -> Int {
        
        if let specialistsTuple = self.numSpecialistsInBuilding.first(where: { $0.buildingType == buildingType}) {
            return specialistsTuple.specialists
        }
        
        return 0
    }
    
    func increaseNumberOfSpecialists(in buildingType: BuildingType) {
        
        // update
        if var specialistsTuple = self.numSpecialistsInBuilding.first(where: { $0.buildingType == buildingType}) {
            specialistsTuple.specialists = specialistsTuple.specialists + 1
            return
        }

        // create new entry
        self.numSpecialistsInBuilding.append(CityCitizens.SpecialistBuildingTuple(buildingType: buildingType, specialists: 1))
    }
    
    func decreaseNumberOfSpecialists(in buildingType: BuildingType) {
        
        // update
        if var specialistsTuple = self.numSpecialistsInBuilding.first(where: { $0.buildingType == buildingType}) {
            specialistsTuple.specialists = specialistsTuple.specialists - 1
            return
        }

        fatalError("cant find entry for \(buildingType)")
    }
    
    func increaseNumberOfForcedSpecialists(in buildingType: BuildingType) {
        
        // update
        if var specialistsTuple = self.numForcedSpecialistsInBuilding.first(where: { $0.buildingType == buildingType}) {
            specialistsTuple.specialists = specialistsTuple.specialists + 1
            return
        }

        // create new entry
        self.numForcedSpecialistsInBuilding.append(CityCitizens.SpecialistBuildingTuple(buildingType: buildingType, specialists: 1))
    }
    
    func decreaseNumberOfForcedSpecialists(in buildingType: BuildingType) {
        
        // update
        if var specialistsTuple = self.numForcedSpecialistsInBuilding.first(where: { $0.buildingType == buildingType}) {
            specialistsTuple.specialists = specialistsTuple.specialists - 1
            return
        }

        fatalError("cant find entry for \(buildingType)")
    }
    
    func numForcedSpecialists(in buildingType: BuildingType) -> Int {
           
        if let specialistsTuple = self.numForcedSpecialistsInBuilding.first(where: { $0.buildingType == buildingType}) {
            return specialistsTuple.specialists
        }
           
        return 0
    }
    
    /// Changes how many Default Specialists are assigned in this City
    func changeNumDefaultSpecialists(change: Int) {
        
        self.numDefaultSpecialistsValue += change

        let specialistType: SpecialistType = .citizen
        self.numSpecialists.add(weight: change, for: specialistType)
        self.city?.processSpecialist(specialistType: specialistType, change: change)

        self.changeNumUnassignedCitizens(change: -change)
    }
    
    /// How many Default Specialists have been forced assigned in this City?
    func changeNumForcedDefaultSpecialists(change: Int) {
        
        self.numDefaultSpecialistsValue += change
    }
    
    func setFocusType(focus: CityFocusType) {
        
        self.focusTypeValue = focus
    }
    
    func focusType() -> CityFocusType {
        
        return self.focusTypeValue
    }
    
    /// Sets this City's Specialists to be under automation
    func setNoAutoAssignSpecialists(_ noAutoAssignSpecialists: Bool, in gameModel: GameModel?) {
        
        if self.noAutoAssignSpecialistsValue != noAutoAssignSpecialists {
            self.noAutoAssignSpecialistsValue = noAutoAssignSpecialists

            // If we're giving the AI control clear all manually assigned Specialists
            if !noAutoAssignSpecialists {
                self.doClearForcedSpecialists()
            }

            self.doReallocateCitizens(in: gameModel)
        }
    }
    
    /// Remove forced status from all Specialists
    func doClearForcedSpecialists() {
        
        // Loop through all Buildings
        self.numForcedSpecialistsInBuilding.removeAll()
    }
    
    func setForcedAvoidGrowth(_ forcedAvoidGrowth: Bool, in gameModel: GameModel?) {
        
        if self.forceAvoidGrowthValue != forcedAvoidGrowth {
            self.forceAvoidGrowthValue = forcedAvoidGrowth
            self.doReallocateCitizens(in: gameModel)
        }
    }
    
    /// Is our City working a CvPlot?
    func isWorked(at location: HexPoint) -> Bool {
        
        if let plot = self.workingPlots.first(where: { $0.location == location }) {
            return plot.worked
        }
        
        fatalError("not a valid plot to check for this city")
    }
    
    
    /// Has our City been told it MUST a particular CvPlot?
    private func isForcedWorked(at location: HexPoint) -> Bool {
        if let plot = self.workingPlots.first(where: { $0.location == location }) {
            return plot.workedForced
        }
        
        fatalError("not a valid plot to check for this city")
    }
    
    private func forceWorkingPlot(at location: HexPoint, force: Bool) {
        
        if var plot = self.workingPlots.first(where: { $0.location == location }) {
            plot.workedForced = force
        }
        
        fatalError("not a valid plot to check for this city")
    }
    
    /// Tell a City to start or stop working a Plot.  Citizens will go to/from the Unassigned Pool if the 3rd argument is true
    func setWorked(at location: HexPoint, worked: Bool, useUnassignedPool: Bool = true) {
        
        guard let city = self.city else {
            fatalError("no city set")
        }
        
        if var plot = self.workingPlots.first(where: { $0.location == location }) {
            
            if plot.worked != worked {
                
                // Don't look at the center Plot of a City, because we always work it for free
                if plot.location != city.location {
                    
                    plot.worked = worked
                    
                    // Alter the count of Plots being worked by Citizens
                    if worked {
                        self.changeNumCitizensWorkingPlots(change: 1)
                        
                        if useUnassignedPool {
                            self.changeNumUnassignedCitizens(change: -1)
                        }
                    } else {
                        self.changeNumCitizensWorkingPlots(change: -1)
                        
                        if useUnassignedPool {
                            self.changeNumUnassignedCitizens(change: 1)
                        }
                    }
                } 
            }
            
            return
        }
        
        fatalError("not a valid plot to check for this city")
    }
    
    func workingTileLocations() -> [HexPoint] {
        
        var locations: [HexPoint] = []
        
        for plot in self.workingPlots {
            
            locations.append(plot.location)
        }
        
        return locations
    }
    
    /// How many Citizens need to be given a job?
    func numUnassignedCitizens() -> Int {
        
        return self.numUnassignedCitizensValue
    }

    /// Changes how many Citizens need to be given a job
    func changeNumUnassignedCitizens(change: Int) {
        
        self.numUnassignedCitizensValue += change
        
        guard self.numUnassignedCitizensValue >= 0 else {
            fatalError("unassigned citizen must be positiv")
        }
    }

    /// How many Citizens are working Plots?
    func numCitizensWorkingPlots() -> Int {
        
        return self.numCitizensWorkingPlotsValue
    }
    
    /// Changes how many Citizens are working Plots
    func changeNumCitizensWorkingPlots(change: Int) {
        
        self.numCitizensWorkingPlotsValue += change
    }
    
    /// How many plots have we forced to be worked?
    func numForcedWorkingPlots() -> Int {
        
        return self.numForcedWorkingPlotsValue
    }
    
    func changeNumForcedWorkingPlots(change: Int) {
        
        self.numForcedWorkingPlotsValue += change
    }

    
    /// What is the Building Type the AI likes the Specialist of most right now?
    func bestSpecialistBuilding(in gameModel: GameModel?) -> BuildingType {
        
        guard let buildings = self.city?.buildings else {
            fatalError("cant get buildings")
        }
        
        var bestBuilding: BuildingType = .none
        var bestSpecialistValue = -1

        //SpecialistTypes eSpecialist;
        //int iValue;

        // Loop through all Buildings
        for buildingType in BuildingType.all {
            
            // Have this Building in the City?
            if buildings.has(building: buildingType) {
                
                // Can't add more than the max
                if buildingType.canAddSpecialist() {
                    
                    let specialistType = buildingType.specialistType()

                    var value = self.specialistValue(for: specialistType, in: gameModel)

                    // Add a bit more weight to a Building if it has more slots (10% per).  This will bias the AI to fill a single building over spreading Specialists out
                    var temp = ((buildingType.specialistCount() - 1) * value * 10)
                    temp /= 100;
                    value += temp

                    if value > bestSpecialistValue {
                        bestBuilding = buildingType
                        bestSpecialistValue = value
                    }
                }
            }
        }

        return bestBuilding
    }
    
    /// How valuable is eSpecialist?
    func specialistValue(for specialistType: SpecialistType, in gameModel: GameModel?) -> Int {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        guard let cityStrategy = city.cityStrategy else {
            fatalError("cant get cityStrategy")
        }
        
        var value = 20

        let deficientYield = cityStrategy.deficientYield(in: gameModel)

        // Does this Specialist help us with a Deficient Yield?

        let focusType = self.focusType()
        
        if focusType == .science {
            value += Int(specialistType.yields().science) * 3
        } else if focusType == .culture {
            value += specialistType.cutlurePerTurn() * 3
        } else if focusType == .gold {
            value += Int(specialistType.yields().gold) * 3
        } else if focusType == .production {
            if deficientYield == .production {
                value += (value * Int(specialistType.yields().value(of: deficientYield)))
            }
            value += Int(specialistType.yields().production) * 2
        } else if focusType == .greatPeople {
            // FIXME value += (GetSpecialistGreatPersonProgress(eSpecialist) / 5);
            if deficientYield != .none {
                value += (value * Int(specialistType.yields().value(of: deficientYield)))
            }
        } else if focusType == .food {
            value += Int(specialistType.yields().food) * 3
        } else if focusType == .productionGrowth {
            if deficientYield == .production {
                value += (value * Int(specialistType.yields().value(of: deficientYield)))
            }
            value += Int(specialistType.yields().production) * 2
        } else if focusType == .goldGrowth {
            value += Int(specialistType.yields().gold) * 2
        } else {
            if deficientYield != .none {
                value += (value * Int(specialistType.yields().value(of: deficientYield)))
            }
            // if we are nearing completion of a GP
            value += (self.specialistGreatPersonProgress(for: specialistType) / 10)
        }

        // GPPs are always good
        value += specialistType.greatPeopleRateChange()

        return value
    }
    
    func specialistGreatPersonProgress(for specialistType: SpecialistType) -> Int {
        
        return Int(self.specialistGreatPersonProgress.weight(of: specialistType))
    }
    
    /// Pick the best Plot to work from one of our unassigned pool
    @discardableResult
    func doAddBestCitizenFromUnassigned(in gameModel: GameModel?) -> Bool {
        
        // We only assign the unassigned here, folks
        if self.numUnassignedCitizens() == 0 {
            return false
        }

        // Maybe we want to add a Specialist?
        if !self.isNoAutoAssignSpecialists() {
            
            // Have to want it right now: look at Food situation, mainly
            if self.isAIWantSpecialistRightNow(in: gameModel) {
                
                let bestBuilding = self.bestSpecialistBuilding(in: gameModel)

                // Is there a Specialist we can assign?
                if bestBuilding != .none {
                    
                    self.doAddSpecialistToBuilding(buildingType: bestBuilding, forced: false, in: gameModel)
                    return true
                }
            }
        }

        let (bestPlot, _) = self.bestCityPlotWithValue(wantBest: true, wantWorked: false, in: gameModel)

        // Found a Valid Plot to place a guy?
        if let bestPlot = bestPlot {
            // Now assign the guy to the best possible Plot
            self.setWorked(at: bestPlot, worked: true, useUnassignedPool: true)
            return true
        } else {
            // No valid Plot - change this guy into a default Specialist
            self.changeNumDefaultSpecialists(change: 1)
        }

        return false
    }
    
    /// Adds and initializes a Specialist for this building
    func doAddSpecialistToBuilding(buildingType: BuildingType, forced: Bool, in gameModel: GameModel?) {

        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let specialistType = buildingType.specialistType()

        // Can't add more than the max
        if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
            
            // If we're force-assigning a specialist, then we can reduce the count on forced default specialists
            if forced {
                if self.numForcedDefaultSpecialists() > 0 {
                    self.changeNumForcedDefaultSpecialists(change: -1)
                }
            }

            // If we don't already have an Unassigned Citizen to turn into a Specialist, find one from somewhere
            if self.numUnassignedCitizens() == 0 {
                
                self.doRemoveWorstCitizen(removeForcedStatus: true, dontChangeSpecialist:  specialistType, in: gameModel)
                
                if self.numUnassignedCitizens() == 0 {
                    // Still nobody, all the citizens may be assigned to the eSpecialist we are looking for, try again
                    if !self.doRemoveWorstSpecialist(dontRemoveFromBuilding: buildingType, in: gameModel) {
                        return // For some reason we can't do this, we must exit, else we will be going over the population count
                    }
                }
            }

            // Increase count for the whole city
            self.numSpecialists.increase(of: specialistType)
            self.increaseNumberOfSpecialists(in: buildingType)

            if forced {
                self.increaseNumberOfForcedSpecialists(in: buildingType)
            }

            city.processSpecialist(specialistType: specialistType, change: 1)

            self.changeNumUnassignedCitizens(change: -1)

            /*
             FIXME: notify UI
             ICvUserInterface2* pkIFace = GC.GetEngineUserInterface();
            pkIFace->setDirty(GameData_DIRTY_BIT, true);
            pkIFace->setDirty(CityInfo_DIRTY_BIT, true);
            //pkIFace->setDirty(InfoPane_DIRTY_BIT, true );
            pkIFace->setDirty(CityScreen_DIRTY_BIT, true);
            pkIFace->setDirty(ColoredPlots_DIRTY_BIT, true);

            CvCity* pkCity = GetCity();
            auto_ptr<ICvCity1> pCity = GC.WrapCityPointer(pkCity);

            pkIFace->SetSpecificCityInfoDirty(pCity.get(), CITY_UPDATE_TYPE_SPECIALISTS);*/
        }
    }
    
    /// Does the AI want a Specialist?
    func isAIWantSpecialistRightNow(in gameModel: GameModel?) -> Bool {
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        guard let cityStrategy = city.cityStrategy else {
            fatalError("cant get cityStrategy")
        }
        
        var weight = 100

        // If the City is Size 1 or 2 then we probably don't want Specialists
        if city.population() < 3 {
            weight /= 2
        }

        let foodPerTurn = city.yields(in: gameModel).food
        let foodEatenPerTurn = city.foodConsumption()
        let surplusFood = foodPerTurn - foodEatenPerTurn

        let focusType = self.focusType()

        // If we don't yet have enough Food to feed our City, we don't want no Specialists!
        if surplusFood <= 0 {
            weight /= 3
        } else if self.isAvoidGrowth() && (focusType == .none || focusType == .greatPeople) {
            weight *= 2
        }
        else if surplusFood <= 2 {
            weight /= 2;
        }
        else if surplusFood > 2 {
            if focusType == .none || focusType == .greatPeople || focusType == .productionGrowth {
                weight *= 100 + (20 * (Int(surplusFood) - 4))
                weight /= 100
            }
        }

        // If we're deficient in Production then we're less likely to want Specialists
        if cityStrategy.isDeficient(for: .production) {
            weight *= 50
            weight /= 100
        }
        // if we've got some slackers in town (since they provide Production)
        else if self.numDefaultSpecialists() > 0 && focusType != .production && focusType != .productionGrowth {
            weight *= 150
            weight /= 100
        }

        // Someone told this AI it should be focused on something that is usually gotten from specialists
        if focusType == .greatPeople {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {

                // Have this Building in the City?
                if city.has(building: buildingType) {
                    // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                        weight *= 3
                        break
                    }
                }
            }
        } else if focusType == .culture {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {
                
                // Have this Building in the City?
                if city.has(building: buildingType) {
                    
                    // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                        
                        if buildingType.specialistType().cutlurePerTurn() > 0 {
                            weight *= 3
                            break
                        }
                    }
                }
            }
        } else if focusType == .science {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {

                // Have this Building in the City?
                if city.has(building: buildingType) {
                    
                    // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                        
                        if buildingType.specialistType().yields().value(of: .science) > 0 {
                            weight *= 3
                        }

                        /* FIXME
                         if (GetPlayer()->getSpecialistExtraYield(YIELD_SCIENCE) > 0)
                        {
                            iWeight *= 3;
                        }*/

                        /* FIXME
                        if (GetPlayer()->GetPlayerTraits()->GetSpecialistYieldChange(eSpecialist, YIELD_SCIENCE) > 0)
                        {
                            iWeight *= 3;
                        }*/
                    }
                }
            }
        } else if focusType == .production {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {

                // Have this Building in the City?
                if city.has(building: buildingType) {
                    
                    // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                        
                        if buildingType.specialistType().yields().value(of: .production) > 0 {
                            weight *= 150
                            weight /= 100
                        }

                        /* FIXME
                         if (GetPlayer()->getSpecialistExtraYield(YIELD_PRODUCTION) > 0)
                        {
                            iWeight *= 2;
                        }*/

                        /* FIXME
                        if (GetPlayer()->GetPlayerTraits()->GetSpecialistYieldChange(eSpecialist, YIELD_PRODUCTION) > 0)
                        {
                            iWeight *= 2;
                        }*/
                    }
                }
            }
        }
        else if focusType == .gold {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {

                // Have this Building in the City?
                if city.has(building: buildingType) {
                    
                    // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                        
                        if buildingType.specialistType().yields().value(of: .gold) > 0 {
                            weight *= 150
                            weight /= 100
                            break
                        }
                    }
                }
            }
        } else if focusType == .food {
            weight *= 50
            weight /= 100
        } else if focusType == .productionGrowth {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {

                // Have this Building in the City?
                if city.has(building: buildingType) {
                    
                    // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                        
                        if buildingType.specialistType().yields().value(of: .production) > 0 {
                            weight *= 150
                            weight /= 100
                            break
                        }
                    }
                }
                
            }
        }
        else if focusType == .goldGrowth {
            
            // Loop through all Buildings
            for buildingType in BuildingType.all {

                // Have this Building in the City?
                if city.has(building: buildingType) {
                    
                        // Can't add more than the max
                    if self.isCanAddSpecialistToBuilding(buildingType: buildingType) {
                            
                            if buildingType.specialistType().yields().value(of: .gold) > 0 {
                                weight *= 150
                                weight /= 100
                            }

                            /* FIXME
                            if (GetPlayer()->getSpecialistExtraYield(YIELD_GOLD) > 0)
                            {
                                iWeight *= 2;
                            }*/

                            /* FIXME
                            if (GetPlayer()->GetPlayerTraits()->GetSpecialistYieldChange(eSpecialist, YIELD_GOLD) > 0)
                            {
                                iWeight *= 2;
                            }*/
                        }
                    
                }
            }
        }

        // Does the AI want it enough?
        if weight >= 150 {
            return true
        }

        return false
    }
    
    /// Is this City avoiding growth?
    func isAvoidGrowth() -> Bool {

        /* FIXME
        if (GetPlayer()->GetExcessHappiness() < 0)
        {
            return true;
        }*/

        return self.avoidGrowthValue
    }
    
    func isForcedAvoidGrowth() -> Bool {

        /* FIXME
        if (GetPlayer()->GetExcessHappiness() < 0)
        {
            return true;
        }*/

        return self.forceAvoidGrowthValue
    }
    
    /// Are we in the position to add another Specialist to eBuilding?
    func isCanAddSpecialistToBuilding(buildingType: BuildingType) -> Bool {

        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let numSpecialistsAssigned = self.numSpecialists(in: buildingType)

        if numSpecialistsAssigned < city.population() &&    // Limit based on Pop of City
            numSpecialistsAssigned < buildingType.specialistCount() &&                // Limit for this particular Building
            numSpecialistsAssigned < 5 /* MAX_SPECIALISTS_FROM_BUILDING */    // Overall Limit
        {
            return true
        }

        return false
    }
    
    /// Are this City's Specialists under automation?
    func isNoAutoAssignSpecialists() -> Bool {
        
        return self.noAutoAssignSpecialistsValue
    }

    /// Pick the worst Plot to stop working
    @discardableResult
    func doRemoveWorstCitizen(removeForcedStatus: Bool = false, dontChangeSpecialist: SpecialistType = .none, in gameModel: GameModel?) -> Bool {
        
        guard let city = self.city else {
            fatalError("no city set")
        }
        
        // Are all of our guys already not working Plots?
        if self.numUnassignedCitizens() == city.population() {
            return false
        }

        // Find default Specialist to pull off, if there is one
        if self.numDefaultSpecialists() > 0 {
            
            // Do we either have unforced default specialists we can remove?
            if self.numDefaultSpecialists() > self.numForcedDefaultSpecialists() {
                self.changeNumDefaultSpecialists(change: -1)
                return true;
            }
            
            if self.numDefaultSpecialists() > city.population() {
                self.changeNumForcedDefaultSpecialists(change: -1)
                self.changeNumDefaultSpecialists(change: -1)
                return true;
            }
        }

        // No Default Specialists, remove a working Pop, if there is one
        let (worstPlot, _) = self.bestCityPlotWithValue(wantBest: false, wantWorked: true, in: gameModel)

        if let worstPlot = worstPlot {
            self.setWorked(at: worstPlot, worked: false)

            // If we were force-working this Plot, turn it off
            if removeForcedStatus {
                if self.isForcedWorked(at: worstPlot) {
                    self.forceWorkingPlot(at: worstPlot, force: false)
                }
            }

            return true
        } else {
            // Have to resort to pulling away a good Specialist
            if self.doRemoveWorstSpecialist(dontChangeSpecialist: dontChangeSpecialist, in: gameModel) {
                return true
            }
        }

        return false
    }
    
    /// Find the worst Specialist and remove him from duty
    func doRemoveWorstSpecialist(dontChangeSpecialist: SpecialistType = .none, dontRemoveFromBuilding: BuildingType = .none, in gameModel: GameModel?) -> Bool {
        
        for buildingType in BuildingType.all {

            if buildingType == dontRemoveFromBuilding {
                continue
            }

            // We might not be allowed to change this Building's Specialists
            if dontChangeSpecialist == buildingType.specialistType() {
                continue
            }

            if self.numSpecialists(in: buildingType) > 0 {
                self.doRemoveSpecialist(from: buildingType, forced: true, in: gameModel)
                return true
            }
        }

        return false
    }
    
    func numDefaultSpecialists() -> Int {
        
        return self.numDefaultSpecialistsValue
    }
    
    func numForcedDefaultSpecialists() -> Int {
        
        return self.numForcedSpecialistsValue
    }
    
    func workableTiles(in gameModel: GameModel?) -> [AbstractTile?] {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        let area = city.location.areaWith(radius: City.workRadius)
        var result: [AbstractTile?] = []
        result.reserveCapacity(area.size)
        
        for neighbor in area {
            if let tile = gameModel.tile(at: neighbor) {
                result.append(tile)
            }
        }
        
        return result
    }

    /// Find a Plot the City is either working or not, and the best/worst value for it - this function does "double duty" depending on what the user wants to find
    func bestCityPlotWithValue(wantBest: Bool, wantWorked: Bool, in gameModel: GameModel?) -> (HexPoint?, Int?) {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        guard let player = city.player else {
            fatalError("cant get player")
        }

        var bestPlotValue: Int = -1
        var bestPlotID: HexPoint? = nil

        // Look at all workable Plots
        for workableTile in self.workableTiles(in: gameModel) {

            guard let workableTile = workableTile else {
                continue
            }
            
            // skip home plot
            if workableTile.point == city.location {
                continue
            }
            
            // Is this a Plot this City controls?
            if !player.isEqual(to: workableTile.owner()) {
                continue
            }
                    
            // Working the Plot and wanting to work it, or Not working it and wanting to find one to work?
            
            if (self.isWorked(at: workableTile.point) && wantWorked) || (!self.isWorked(at: workableTile.point) && !wantWorked) {
                
                // Working the Plot or CAN work the Plot?
                if wantWorked || self.isCanWork(at: workableTile.point, in: gameModel) {
                    
                    var value = self.GetPlotValue(of: workableTile.point, useAllowGrowthFlag: wantBest, in: gameModel)

                    let slotForceWorked = self.isForcedWorked(at: workableTile.point)

                    if slotForceWorked {
                        
                        // Looking for best, unworked Plot: Forced plots are FIRST to be picked
                        if wantBest && !wantWorked {
                            value += 10000
                        }
                        
                        // Looking for worst, worked Plot: Forced plots are LAST to be picked, so make it's value incredibly high
                        if !wantBest && wantWorked {
                            value += 10000
                        }
                    }

                    // First Plot? or Best Plot so far? or Worst Plot so far?
                    if bestPlotValue == -1 || (wantBest && value > bestPlotValue) || (!wantBest && value < bestPlotValue) {
                        bestPlotValue = value;
                        bestPlotID = workableTile.point
                    }
                }
            }
        }

        return (bestPlotID, bestPlotValue)
    }
    
    /// What is the overall value of the current Plot?
    func GetPlotValue(of point: HexPoint, useAllowGrowthFlag: Bool, in gameModel: GameModel?) -> Int {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = gameModel.tile(at: point) else {
            fatalError("cant get tile")
        }
        
        guard let city = self.city else {
            fatalError("cant get city")
        }
        
        var value = 0.0
        
        let yields = tile.yields(ignoreFeature: false)

        // Yield Values
        var foodYieldValue = 12 /* AI_CITIZEN_VALUE_FOOD */ * yields.value(of: .food)
        var productionYieldValue = 8 /* AI_CITIZEN_VALUE_PRODUCTION */ * yields.value(of: .production)
        var goldYieldValue = 10 /* AI_CITIZEN_VALUE_GOLD */ * yields.value(of: .gold)
        var scienceYieldValue = 6 /* AI_CITIZEN_VALUE_SCIENCE */ * yields.value(of: .science)
        var cultureYieldValue = 8 /* AI_CITIZEN_VALUE_CULTURE */ * yields.culture

        // How much surplus food are we making?
        //let excessFoodTimes100 = city.foo city.foodConsumption()

        let avoidGrowth = self.isAvoidGrowth()

        // City Focus
        let focusType = self.focusType()
        if focusType == .food {
            foodYieldValue *= 5
        } else if focusType == .production {
            productionYieldValue *= 4
        } else if focusType == .gold {
            goldYieldValue *= 4;
        } else if focusType == .science {
            scienceYieldValue *= 4
        } else if focusType == .culture {
            cultureYieldValue *= 4
        } else if focusType == .goldGrowth {
            foodYieldValue *= 2
            goldYieldValue *= 5
        } else if focusType == .productionGrowth {
            foodYieldValue *= 2
            productionYieldValue *= 5
        }

        // Food can be worth less if we don't want to grow
        if useAllowGrowthFlag && city.hasEnoughFood() && avoidGrowth {
            // If we at least have enough Food to feed everyone, zero out the value of additional food
            foodYieldValue = 0
        } else {
            // We want to grow here
            // If we have a non-default and non-food focus, only worry about getting to 0 food
            if focusType != .none && focusType != .food && focusType != .productionGrowth && focusType != .goldGrowth {

                if !city.hasEnoughFood() {
                    foodYieldValue *= 2
                }
            } else if !avoidGrowth {
                // If our surplus is not at least 2, really emphasize food plots
                if city.hasOnlySmallFoodSurplus() {
                    foodYieldValue *= 2
                }
            }
        }

        if ((focusType == .none || focusType == .productionGrowth || focusType == .goldGrowth) && !avoidGrowth && city.population() < 5) {
            foodYieldValue *= 3
        }

        value += foodYieldValue
        value += productionYieldValue
        value += goldYieldValue
        value += scienceYieldValue
        value += cultureYieldValue

        return Int(value)
    }
    
    /// Check all Plots by this City to see if we can actually be working them (if we are)
    private func doVerifyWorkingPlots(in gameModel: GameModel?) {

        for workingPlot in self.workingPlots {
            self.doVerify(workingPlot: workingPlot, in: gameModel)
        }
    }
    
    /// If we're working this plot make sure we're allowed, and if we're not then correct the situation
    private func doVerify(workingPlot: WorkingPlot?, in gameModel: GameModel?) {
        
        if let workingPlot = workingPlot {
            
            if workingPlot.worked {
                if !self.isCanWork(at: workingPlot.location, in: gameModel) {
                    self.setWorked(at: workingPlot.location, worked: false)
                    self.doAddBestCitizenFromUnassigned(in: gameModel)
                }
            }
        }
    }
    
    /// Can our City work a particular CvPlot?
    private func isCanWork(at location: HexPoint, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }
        
        guard let tile = gameModel.tile(at: location) else {
            fatalError("Cant get tile")
        }
        
        if tile.workingCity()?.location != self.city?.location {
            return false
        }

        if !tile.hasYield() && tile.yields(ignoreFeature: false).culture <= 0 {
            return false
        }

        if self.isBlockaded(tile: tile, in: gameModel) {
            return false
        }

        return true
    }
    
    // Is there a naval blockade on this water tile?
    func isBlockaded(tile: AbstractTile?, in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("Cant get gameModel")
        }
        
        guard let tile = tile else {
            fatalError("cant get tile")
        }
        
        guard let player = self.city?.player else {
            fatalError("cant get tile")
        }
        
        // See if there are any enemy boats near us that are blockading this plot
        let blockadeDistance = 2 /*NAVAL_PLOT_BLOCKADE_RANGE */

        // Might be a better way to do this that'd be slightly less CPU-intensive
        for nearbyPoint in tile.point.areaWith(radius: blockadeDistance) {
            
            guard let nearbyTile = gameModel.tile(at: nearbyPoint) else {
                continue
            }
            
            // Must be water in the same Area
            if nearbyTile.terrain().isWater() && nearbyTile.area == tile.area {

                    // Enemy boat within range to blockade our plot?
                if gameModel.isEnemyVisible(at: nearbyTile.point, for: player) {
                    return true
                }
            }
        }

        return false
    }
    
    func specialistCount(of specialistType: SpecialistType) -> Int {
        
        return self.numSpecialists.amount(of: specialistType)
    }
}
