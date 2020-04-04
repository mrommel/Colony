//
//  Tile.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum TileError: Error {
    
    case alreadyImproved
    case invalidImprovement
    
    // owner related errors
    case emptyOwner
    case alreadyOwned
    
    // work related errors
    case notWorkedYet
    case emptyWorker
    case alreadyWorked
}

public struct BuilderAIScratchPad {
    
    var turn: Int
    var routeType: RouteType
    var leader: LeaderType
    var value: Int
}

class BuildProgressList: WeightedList<BuildType> {
    
    override func fill() {
        
        for buildType in BuildType.all {
            self.add(weight: 0, for: buildType)
        }
    }
}

public protocol AbstractTile: Codable {
    
    var point: HexPoint { get }
    var area: HexArea? { get set }
    
    func yields(ignoreFeature: Bool) -> Yields
    func hasYield() -> Bool
    func yieldsWith(buildType: BuildType, ignoreFeature: Bool) -> Yields
    
    // terrain & hills
    func set(terrain: TerrainType)
    func terrain() -> TerrainType
    
    func hasHills() -> Bool
    func set(hills: Bool)
    
    func isOpenGround() -> Bool
    func isRoughGround() -> Bool
    func isImpassable() -> Bool
    
    // improvements
    func hasAnyImprovement() -> Bool
    func improvement() -> TileImprovementType
    func possibleImprovements() -> [TileImprovementType]
    func has(improvement: TileImprovementType) -> Bool
    func removeImprovement()
    func set(improvement improvementType: TileImprovementType)
    func isImprovementPillaged() -> Bool
    func setImprovement(pillaged: Bool)
    
    func has(route: RouteType) -> Bool
    
    func canBuild(buildType: BuildType, by player: AbstractPlayer?) -> Bool
    @discardableResult
    func changeBuildProgress(of buildType: BuildType, change: Int, for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func buildProgress(of buildType: BuildType) -> Int
    
    func productionFromFeatureRemoval(by buildType: BuildType) -> Int
    func doImprovement()
    
    func canBePillaged() -> Bool
    
    func isRoutePillaged() -> Bool
    func setRoute(pillaged: Bool)
    
    // methods related to owner of this tile
    func hasOwner() -> Bool
    func owner() -> AbstractPlayer?
    func set(owner: AbstractPlayer?) throws
    
    // methods related to working city
    func isCity() -> Bool
    func build(city: AbstractCity?) throws
    func isWorked() -> Bool
    func workingCity() -> AbstractCity?
    func setWorkingCity(to city: AbstractCity?) throws
    
    func defenseModifier(for player: AbstractPlayer?) -> Int
    func isFriendlyTerritory(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func isFriendlyCity(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func isVisibleToEnemy(of player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    
    // discovered
    func isDiscovered(by player: AbstractPlayer?) -> Bool
    func discover(by player: AbstractPlayer?)
    
    // visible
    func isVisible(to player: AbstractPlayer?) -> Bool
    func sight(by player: AbstractPlayer?)
    func conceal(to player: AbstractPlayer?)
    func canSee(tile: AbstractTile?, for player: AbstractPlayer?, range: Int, in gameModel: GameModel?) -> Bool
    func seeThroughLevel() -> Int
    
    // features
    func hasAnyFeature() -> Bool
    func feature() -> FeatureType
    func has(feature: FeatureType) -> Bool
    func set(feature: FeatureType)
    
    // resources
    func hasAnyResource(for player: AbstractPlayer?) -> Bool
    func resource(for player: AbstractPlayer?) -> ResourceType
    func has(resource: ResourceType, for player: AbstractPlayer?) -> Bool
    func set(resource: ResourceType)
    func has(resourceType: ResourceUsageType, for player: AbstractPlayer?) -> Bool
    func resourceQuantity() -> Int
    
    // ocean / continent
    func set(ocean: Ocean?)
    func set(continent: Continent?)
    func isOn(continent: Continent?) -> Bool
    func sameContinent(as otherTile: AbstractTile) -> Bool
    
    // river
    func isRiver() -> Bool
    func isRiverIn(direction: HexDirection) throws -> Bool
    func isRiverInNorth() -> Bool
    func isRiverInNorthEast() -> Bool
    func isRiverInSouthEast() -> Bool
    func isRiverToCross(towards target: AbstractTile) -> Bool
    func set(river: River?, with flow: FlowDirection) throws
    
    func movementCost(for movementType: UnitMovementType, from source: AbstractTile) -> Double
    
    // scratch pad
    func builderAIScratchPad() -> BuilderAIScratchPad
    func set(builderAIScratchPad: BuilderAIScratchPad)
}

class Tile: AbstractTile {

    enum CodingKeys: CodingKey {
        
        case point
        case terrain
        case hills
        case resource
        case resourceQuantity
        case feature
        case improvement
        case improvementPillaged
        case route
        case routePillaged
        
        case discovered
        // case owner
        
        case riverName
        case riverFlowNorth
        case riverFlowNorthEast
        case riverFlowSouthEast
        
        case buildProgress
    }
    
    var point: HexPoint
    var area: HexArea?
    
    private var terrainVal: TerrainType
    private var hillsVal: Bool
    
    private var ocean: Ocean?
    private var continent: Continent?
    
    private var resourceValue: ResourceType
    private var resourceQuantityValue: Int
    private var featureValue: FeatureType
    private var improvementValue: TileImprovementType
    private var improvementPillagedValue: Bool
    private var routeValue: RouteType
    private var routePillagedValue: Bool
    
    private var discovered: TileDiscovered
    private var ownerValue: AbstractPlayer?
    private var workedBy: AbstractCity? = nil
    private var city: AbstractCity? = nil
    
    private var riverName: String? = nil
    private var riverFlowNorth: FlowDirection = .none
    private var riverFlowNorthEast: FlowDirection = .none
    private var riverFlowSouthEast: FlowDirection = .none
    
    private var buildProgressList: BuildProgressList
    
    private var builderAIScratchPadValue: BuilderAIScratchPad
    
    init(point: HexPoint, terrain: TerrainType, hills: Bool = false, feature: FeatureType = .none) {

        self.point = point
        self.terrainVal = terrain
        self.hillsVal = hills

        self.resourceValue = .none
        self.resourceQuantityValue = 0
        self.featureValue = feature
        self.improvementValue = .none
        self.improvementPillagedValue = false
        self.routeValue = .none
        self.routePillagedValue = false
        

        self.ownerValue = nil
        self.discovered = TileDiscovered()
        
        self.area = nil
        self.ocean = nil
        self.continent = nil
        
        self.buildProgressList = BuildProgressList()
        self.buildProgressList.fill()
        
        self.builderAIScratchPadValue = BuilderAIScratchPad(turn: -1, routeType: .none, leader: .none, value: -1)
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.point = try container.decode(HexPoint.self, forKey: .point)
        self.terrainVal = try container.decode(TerrainType.self, forKey: .terrain)
        self.hillsVal = try container.decode(Bool.self, forKey: .hills)
        
        self.resourceValue = try container.decode(ResourceType.self, forKey: .resource)
        self.resourceQuantityValue = try container.decode(Int.self, forKey: .resourceQuantity)
        self.featureValue = try container.decode(FeatureType.self, forKey: .feature)
        self.improvementValue = try container.decode(TileImprovementType.self, forKey: .improvement)
        self.improvementPillagedValue = try container.decode(Bool.self, forKey: .improvementPillaged)
        self.routeValue = try container.decode(RouteType.self, forKey: .route)
        self.routePillagedValue = try container.decode(Bool.self, forKey: .routePillaged)
        
        self.ownerValue = nil
        self.discovered = try container.decode(TileDiscovered.self, forKey: .discovered)
        
        self.area = nil
        self.ocean = nil
        self.continent = nil
        
        self.riverName = try container.decode(String.self, forKey: .riverName)
        self.riverFlowNorth = try container.decode(FlowDirection.self, forKey: .riverFlowNorth)
        self.riverFlowNorthEast = try container.decode(FlowDirection.self, forKey: .riverFlowNorthEast)
        self.riverFlowSouthEast = try container.decode(FlowDirection.self, forKey: .riverFlowSouthEast)
        
        self.buildProgressList = try container.decode(BuildProgressList.self, forKey: .buildProgress)
        
        self.builderAIScratchPadValue = BuilderAIScratchPad(turn: -1, routeType: .none, leader: .none, value: -1)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.point, forKey: .point)
        try container.encode(self.terrainVal, forKey: .terrain)
        try container.encode(self.hillsVal, forKey: .hills)
        try container.encode(self.resourceValue, forKey: .resource)
        try container.encode(self.resourceQuantityValue, forKey: .resourceQuantity)
        try container.encode(self.featureValue, forKey: .feature)
        try container.encode(self.improvementValue, forKey: .improvement)
        try container.encode(self.improvementPillagedValue, forKey: .improvementPillaged)
        try container.encode(self.routeValue, forKey: .route)
        try container.encode(self.routePillagedValue, forKey: .routePillaged)
        
        try container.encode(self.discovered, forKey: .discovered)
        // case owner
        
        try container.encode(self.riverName, forKey: .riverName)
        try container.encode(self.riverFlowNorth, forKey: .riverFlowNorth)
        try container.encode(self.riverFlowNorthEast, forKey: .riverFlowNorthEast)
        try container.encode(self.riverFlowSouthEast, forKey: .riverFlowSouthEast)
        
        try container.encode(self.buildProgressList, forKey: .buildProgress)
    }
    
    // for tests
    
    internal func set(terrain: TerrainType) {
        
        self.terrainVal = terrain
    }
    
    func terrain() -> TerrainType {
        
        return self.terrainVal
    }
    
    func hasHills() -> Bool {
        
        return self.hillsVal
    }
    
    func set(hills: Bool) {
        
        self.hillsVal = hills
    }
    
    func defenseModifier(for player: AbstractPlayer?) -> Int {
        
        var modifier = 0
        
        // Can only get Defensive Bonus from ONE thing - they don't stack
        var featureModifier = 0
        for feature in FeatureType.all {
            if feature == .mountains {
                continue
            }
            
            featureModifier = max(featureModifier, feature.defenseModifier())
        }

        if self.hasHills() || self.has(feature: .mountains) {
            // Hill (and mountain)
            modifier += 3 // HILLS_EXTRA_DEFENSE
        } else if featureModifier > 0 {
            // Features
            modifier = featureModifier
        } else {
            // Terrain
            modifier = self.terrain().defenseModifier()
        }

        if self.improvement() != .none {
            modifier += self.improvement().defenseModifier()
        }
        
        return modifier
    }
    
    func isFriendlyTerritory(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        fatalError("not implemented yet")
    }
    
    func isFriendlyCity(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        fatalError("not implemented yet")
    }
    
    func isVisibleToEnemy(of player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        fatalError("not implemented yet")
    }
    
    func isOpenGround() -> Bool {
        
        if self.hasHills() {
            return false
        }
        
        for feature in FeatureType.all {
            if self.has(feature: .mountains) {
                if feature.isRough() {
                    return false
                }
            }
        }
        
        return true
    }
    
    func isRoughGround() -> Bool {
        
        if self.hasHills() {
            return true
        }
        
        for feature in FeatureType.all {
            if self.has(feature: .mountains) {
                if feature.isRough() {
                    return true
                }
            }
        }
        
        return false
    }
    
    // end for tests

    func yields(ignoreFeature: Bool) -> Yields {

        var returnYields = Yields(food: 0, production: 0, gold: 0, science: 0)

        let baseYields = self.terrainVal.yields()
        returnYields += baseYields

        if self.hillsVal && self.terrainVal.isLand() {
            returnYields += Yields(food: 0, production: 1, gold: 0, science: 0)
        }
        
        if ignoreFeature == false && self.featureValue != .none {
            returnYields += self.featureValue.yields()
        }
        
        returnYields += self.resourceValue.yields()

        if self.improvementValue != .none && !self.isImprovementPillaged() {
            returnYields += self.improvementValue.yields()
        }
        
        if self.routeValue != .none && !self.isRoutePillaged() {
            returnYields += self.routeValue.yields()
        }

        return returnYields
    }
    
    func hasYield() -> Bool {
        
        let yield = self.yields(ignoreFeature: false)
        
        if yield.food > 0 {
            return true
        }
        
        if yield.production > 0 {
            return true
        }
        
        if yield.gold > 0 {
            return true
        }
        
        return false
    }
    
    func yieldsWith(buildType: BuildType, ignoreFeature: Bool = false) -> Yields {
        
        // Will the build remove the feature?
        var ignoreFeatureValue = ignoreFeature
        
        if self.featureValue != .none {
            if buildType.canRemove(feature: self.featureValue) {
                ignoreFeatureValue = true
            }
        }
        
        var yields = self.yields(ignoreFeature: ignoreFeatureValue)
        
        // //////////////
        var improvementFromBuild = buildType.improvement()
        if improvementFromBuild == nil {
            // might be repair
            if /*!self.isImprovementPillaged() ||*/ buildType == .repair {
                improvementFromBuild = self.improvement()
            }
        }
        
        if let improvementFromBuild = improvementFromBuild {
            
            yields += improvementFromBuild.yields()
        }
        
        // //////////////
        var routeFromBuild = buildType.route()
        if routeFromBuild == nil {
            // might be repair
            if /*!self.isRoutePillaged() ||*/ buildType == .repair {
                routeFromBuild = self.routeValue
            }
        }
        
        if let routeFromBuild = routeFromBuild {
            
            yields += routeFromBuild.yields()
        }
        
        return yields
    }
    
    // MARK: improvement methods
    
    func hasAnyImprovement() -> Bool {
        
        return self.improvementValue != .none
    }
    
    func improvement() -> TileImprovementType {
        
        return self.improvementValue
    }

    func possibleImprovements() -> [TileImprovementType] {

        var possibleTileImprovements: [TileImprovementType] = []
        
        for improvementType in TileImprovementType.all {
            
            if improvementType.isPossible(on: self) {
                possibleTileImprovements.append(improvementType)
            }
        }
        
        return possibleTileImprovements
    }

    func removeImprovement() {

        self.improvementValue = .none
    }
    
    func has(improvement: TileImprovementType) -> Bool {
        
        return self.improvementValue == improvement
    }
    
    func set(improvement improvementType: TileImprovementType) {
        
        let oldImprovement = self.improvement()

        if oldImprovement != improvementType {
            
            if oldImprovement != .none {
 
                // Culture from Improvement
                /*int iCulture = ComputeCultureFromImprovement(oldImprovementEntry, eOldImprovement);
                if (iCulture != 0)
                {
                    ChangeCulture(-iCulture);
                }*/

                // If this improvement can add culture to nearby improvements, update them as well
                /*if (oldImprovementEntry.GetCultureAdjacentSameType() > 0)
                {
                    for (iI = 0; iI < NUM_DIRECTION_TYPES; iI++)
                    {
                        CvPlot *pAdjacentPlot = plotDirection(getX(), getY(), ((DirectionTypes)iI));
                        if (pAdjacentPlot && pAdjacentPlot->getImprovementType() == eOldImprovement)
                        {
                            pAdjacentPlot->ChangeCulture(-oldImprovementEntry.GetCultureAdjacentSameType());
                        }
                    }
                }*/

                /*if (area())
                {
                    area()->changeNumImprovements(eOldImprovement, -1);
                }*/
                
                // Someone owns this plot
                if let player = self.owner() {

                    player.changeImprovementCount(of: oldImprovement, change: -1)

                    // Maintenance change!
                    /*if (MustPayMaintenanceHere(owningPlayerID)) {
                    GET_PLAYER(owningPlayerID).GetTreasury()->ChangeBaseImprovementGoldMaintenance(-GC.getImprovementInfo(getImprovementType())->GetGoldMaintenance());
                    }*/

                    // Update the amount of a Resource used up by the previous Improvement that is being removed
                    /*int iNumResourceInfos = GC.getNumResourceInfos();
                    for (int iResourceLoop = 0; iResourceLoop < iNumResourceInfos; iResourceLoop++)
                    {
                        if (oldImprovementEntry.GetResourceQuantityRequirement(iResourceLoop) > 0)
                        {
                            player.ch.changeNumResourceUsed((ResourceTypes) iResourceLoop, -oldImprovementEntry.GetResourceQuantityRequirement(iResourceLoop));
                        }
                    }*/
                }

                // Someone had built something here in an unowned plot, remove effects of the old improvement
                /*if (GetPlayerResponsibleForImprovement() != NO_PLAYER)
                {
                    // Maintenance change!
                    if (MustPayMaintenanceHere(GetPlayerResponsibleForImprovement()))
                    {
                        GET_PLAYER(GetPlayerResponsibleForImprovement()).GetTreasury()->ChangeBaseImprovementGoldMaintenance(-GC.getImprovementInfo(getImprovementType())->GetGoldMaintenance());
                    }

                    SetPlayerResponsibleForImprovement(NO_PLAYER);
                }*/
            }

            self.improvementValue = improvementType

            /*if (getImprovementType() == NO_IMPROVEMENT)
            {
                setImprovementDuration(0);
            }*/

            // Reset who cleared a Barb camp here last (if we're putting a new one down)
            if improvementType == .barbarianCamp {
                //SetPlayerThatClearedBarbCampHere(NO_PLAYER);
            }

            //setUpgradeProgress(0);

            // make sure this plot is not disabled
            self.setImprovement(pillaged: false)

            /*for (iI = 0; iI < MAX_TEAMS; ++iI)
            {
                if (GET_TEAM((TeamTypes)iI).isAlive())
                {
                    if (isVisible((TeamTypes)iI))
                    {
                        setRevealedImprovementType((TeamTypes)iI, eNewValue);
                    }
                }
            }*/

            if improvementType != .none {
                
                // Culture from Improvement
                let culture = improvementType.yields().culture //ComputeCultureFromImprovement(newImprovementEntry, eNewValue);
                if culture != 0 {
                    //self.changeCulture(culture)
                }

                // If this improvement can add culture to nearby improvements, update them as well
                /*if (newImprovementEntry.GetCultureAdjacentSameType() > 0)
                {
                    for (iI = 0; iI < NUM_DIRECTION_TYPES; iI++)
                    {
                        CvPlot *pAdjacentPlot = plotDirection(getX(), getY(), ((DirectionTypes)iI));
                        if (pAdjacentPlot && pAdjacentPlot->getImprovementType() == eNewValue)
                        {
                            pAdjacentPlot->ChangeCulture(newImprovementEntry.GetCultureAdjacentSameType());
                        }
                    }
                }*/

                /*if (area())
                {
                    area()->changeNumImprovements(eNewValue, 1);
                }*/
                
                if let player = self.owner() {
                    
                    player.changeImprovementCount(of: improvementType, change: 1);

                    // Maintenance
                    /*if (MustPayMaintenanceHere(owningPlayerID))
                    {
                        GET_PLAYER(owningPlayerID).GetTreasury()->ChangeBaseImprovementGoldMaintenance(newImprovementEntry.GetGoldMaintenance());
                    }*/

                    // Add Resource Quantity to total
                    if self.resourceValue != .none {
                        
                        /*if (GET_TEAM(getTeam()).GetTeamTechs()->HasTech((TechTypes) GC.getResourceInfo(getResourceType())->getTechCityTrade()))
                        {
                            if (newImprovementEntry.IsImprovementResourceTrade(getResourceType()))
                            {
                                owningPlayer.changeNumResourceTotal(getResourceType(), getNumResourceForPlayer(owningPlayerID));

                                // Activate Resource city link?
                                if (GetResourceLinkedCity() != NULL && !IsResourceLinkedCityActive())
                                    SetResourceLinkedCityActive(true);
                            }
                        }*/
                    }

                    /*ResourceTypes eResource = getResourceType(getTeam());

                    if (eResource != NO_RESOURCE)
                    {
                        if (newImprovementEntry.IsImprovementResourceTrade(eResource))
                        {
                            if (GC.getResourceInfo(eResource)->getResourceUsage() == RESOURCEUSAGE_LUXURY)
                            {
                                owningPlayer.DoUpdateHappiness();
                            }
                        }
                    }*/
                }
            }

            // If we're removing an Improvement that hooked up a resource then we need to take away the bonus
            if oldImprovement != .none && !self.isCity() {
                
                if let player = self.owner() {
                    
                    // Remove Resource Quantity from total
                    if self.resource(for: player) != .none {
                        
                        fatalError("fixme")
                        /*if (GET_TEAM(getTeam()).GetTeamTechs()->HasTech((TechTypes) GC.getResourceInfo(getResourceType())->getTechCityTrade()))
                        {
                            if (GC.getImprovementInfo(eOldImprovement)->IsImprovementResourceTrade(getResourceType()))
                            {
                                owningPlayer.changeNumResourceTotal(getResourceType(), -getNumResourceForPlayer(owningPlayerID));

                                // Disconnect resource link
                                if (GetResourceLinkedCity() != NULL)
                                    SetResourceLinkedCityActive(false);
                            }
                        }*/
                    }

                    let resource = self.resource(for: player)

                    if resource != .none {
                        
                        /*if (GC.getImprovementInfo(eOldImprovement)->IsImprovementResourceTrade(eResource))
                        {
                            if (GC.getResourceInfo(eResource)->getResourceUsage() == RESOURCEUSAGE_LUXURY)
                            {
                                player.doUpdateHappiness()
                            }
                        }*/
                    }
                }
            }

            // self.updateYield();
        }
    }
    
    func isImprovementPillaged() -> Bool {
        
        return self.improvementPillagedValue
    }
    
    func setImprovement(pillaged: Bool) {
        
        self.improvementPillagedValue = pillaged
    }
    
    func doImprovement() {
        
    }
    
    func productionFromFeatureRemoval(by buildType: BuildType) -> Int {
        
        if !self.hasAnyFeature() {
            return 0
        }
        
        var production = 0
        
        for feature in FeatureType.all {
            
            if self.has(feature: feature) {
                if !buildType.canRemove(feature: feature) {
                    return 0
                }
                
                production += buildType.productionFromRemoval(of: feature)
            }
        }
        
        return 0
    }
    
    func has(route: RouteType) -> Bool {
        
        return self.routeValue == route
    }
    
    func canBePillaged() -> Bool {
        
        return self.improvementValue.canBePillaged()
    }
    
    func isRoutePillaged() -> Bool {
        
        return self.routePillagedValue
    }
    
    func setRoute(pillaged: Bool) {
        
        self.routePillagedValue = pillaged
        
        if pillaged {
            fatalError("need to update city connections")
            // GET_PLAYER(ePlayer).GetCityConnections()->Update();
        }
    }
    
    func set(route routeType: RouteType) {
        
        self.routeValue = routeType
    }
    
    func canBuild(buildType: BuildType, by player: AbstractPlayer?) -> Bool {
        
        // Can't build nothing!
        if buildType == .none {
            return false
        }
        
        return true
    }
    
    func costPerTurn() -> Int {
        
        return self.improvementValue.costPerTurn()
    }
    
    // MARK: owner methods
    
    func removeOwner() throws {
        
        if ownerValue == nil {
            throw TileError.emptyOwner
        }
        
        self.ownerValue = nil
    }
    
    func set(owner: AbstractPlayer?) throws {
        
        if owner == nil {
            throw TileError.emptyOwner
        }
        
        if self.hasOwner() {
            throw TileError.alreadyOwned
        }
        
        self.ownerValue = owner
    }
    
    func owner() -> AbstractPlayer? {
        
        return self.ownerValue
    }
    
    func hasOwner() -> Bool {
        
        return self.ownerValue != nil
    }
    
    // MARK: work related methods
    
    func isCity() -> Bool {
        
        return self.city != nil
    }
    
    func build(city: AbstractCity?) throws {
        
        self.city = city
    }
    
    func isWorked() -> Bool {
        
        return self.workedBy != nil
    }
    
    func workingCity() -> AbstractCity? {
        
        return self.workedBy
    }
    
    func removeWorked() throws {
        
        if !self.isWorked() {
            throw TileError.notWorkedYet
        }
        
        self.workedBy = nil
    }
    
    func setWorkingCity(to city: AbstractCity?) throws {
        
        if city == nil {
            throw TileError.emptyWorker
        }
        
        if self.isWorked() {
            throw TileError.alreadyWorked
        }
        
        self.workedBy = city
    }
    
    // MARK: ...
    
    func isDiscovered(by player: AbstractPlayer?) -> Bool {
        
        return self.discovered.isDiscovered(by: player)
    }
    
    func discover(by player: AbstractPlayer?) {
        
        guard let player = player else {
            fatalError("cant get player")
        }
        
        guard let techs = player.techs else {
            fatalError("cant get techs")
        }
        
        if !self.isDiscovered(by: player) {
        
            if !techs.eurekaTriggered(for: .astrology) {
                if self.featureValue.isWonder() {
                    techs.triggerEureka(for: .astrology)
                }
            }
            
            self.discovered.discover(by: player)
        }
    }
    
    // MARK: sight
    
    func isVisible(to player: AbstractPlayer?) -> Bool {
        
        return self.discovered.isVisible(to: player)
    }
    
    func sight(by player: AbstractPlayer?) {
        
        self.discovered.sight(by: player)
    }
    
    func conceal(to player: AbstractPlayer?) {
        
        self.discovered.conceal(to: player)
    }
    
    // MARK: feature methods
    
    func hasAnyFeature() -> Bool {
        
        return self.featureValue != .none
    }
    
    func feature() -> FeatureType {
        
        return self.featureValue
    }
    
    func has(feature: FeatureType) -> Bool {
        
        return self.featureValue == feature
    }
    
    func set(feature: FeatureType) {
        
        self.featureValue = feature
    }
    
    // MARK: resource methods
    
    func hasAnyResource(for player: AbstractPlayer?) -> Bool {
        
        return self.resource(for: player) != .none
    }
    
    func resource(for player: AbstractPlayer?) -> ResourceType {
        
        guard let player = player else {
            fatalError("no player provided")
        }
        
        if self.resourceValue != .none {
            
            var valid = true
            
            // check if already visible to player
            if let revealTech = self.resourceValue.revealTech() {
                if !player.has(tech: revealTech) {
                    valid = false
                }
            }
            
            if valid {
                return self.resourceValue
            }
        }
        
        return .none
    }
    
    func has(resource: ResourceType, for player: AbstractPlayer?) -> Bool {
        
        return self.resource(for: player) == resource
    }
    
    func set(resource: ResourceType) {
        
        self.resourceValue = resource
    }
    
    func has(resourceType: ResourceUsageType, for player: AbstractPlayer?) -> Bool {
        
        return self.resource(for: player).usage() == resourceType
    }
    
    func resourceQuantity() -> Int {
        
        return self.resourceQuantityValue
    }
    
    // MARK: ocean / continent methods
    
    func set(ocean: Ocean?) {
        
        self.ocean = ocean
    }
    
    func set(continent: Continent?) {
        
        self.continent = continent
    }
    
    func set(river: River?, with flow: FlowDirection) throws {
        self.riverName = river?.name
        
        try setRiver(flow: flow)
    }
    
    func isRiver() -> Bool {
        
        return self.riverName != nil && (self.isRiverInNorth() || self.isRiverInNorthEast() || self.isRiverInSouthEast())
    }
    
    public func isRiverIn(direction: HexDirection) throws -> Bool {
        switch direction {
        case .north:
            return self.isRiverInNorth()
        case .northeast:
            return self.isRiverInNorthEast()
        case .southwest:
            return self.isRiverInSouthEast()
            
        default:
            throw FlowDirectionError.unsupported(flow: .none, in: direction)
        }
    }
    
    private func setRiver(flow: FlowDirection) throws {
        
        switch flow {
        case .northEast:
            try self.setRiverFlowInSouthEast(flow: flow)
        case .southWest:
            try self.setRiverFlowInSouthEast(flow: flow)
        case .northWest:
            try self.setRiverFlowInNorthEast(flow: flow)
        case .southEast:
            try self.setRiverFlowInNorthEast(flow: flow)
        case .east:
            try self.setRiverFlowInNorth(flow: flow)
        case .west:
            try self.setRiverFlowInNorth(flow: flow)
        default:
            throw FlowDirectionError.unsupported(flow: flow, in: .north)
        }
    }
    
    public func setRiver(flow: FlowDirection, in direction: HexDirection) throws {
        
        switch direction {
        case .north:
            try self.setRiverFlowInNorth(flow: flow)
        case .northeast:
            try self.setRiverFlowInNorthEast(flow: flow)
        case .southeast:
            try self.setRiverFlowInSouthEast(flow: flow)
        default:
            throw FlowDirectionError.unsupported(flow: flow, in: direction)
        }
    }
    
    public func isRiverIn(flow: FlowDirection) -> Bool {
        
        return self.riverFlowNorth == flow || self.riverFlowNorthEast == flow || self.riverFlowSouthEast == flow
    }
    
    // river in north can flow from east or west direction
    public func isRiverInNorth() -> Bool {
        return self.riverFlowNorth == .east || self.riverFlowNorth == .west
    }
    
    public func setRiverFlowInNorth(flow: FlowDirection) throws {
        
        guard flow == .east || flow == .west else {
            throw FlowDirectionError.unsupported(flow: flow, in: .north)
        }
        
        self.riverFlowNorth = flow
    }
    
    // river in north east can flow to northwest or southeast direction
    public func isRiverInNorthEast() -> Bool {
        return self.riverFlowNorthEast == .northWest || self.riverFlowNorthEast == .southEast
    }
    
    public func setRiverFlowInNorthEast(flow: FlowDirection) throws {
        
        guard flow == .northWest || flow == .southEast else {
            throw FlowDirectionError.unsupported(flow: flow, in: .northeast)
        }
        
        self.riverFlowNorthEast = flow
    }
    
    // river in south east can flow to northeast or southwest direction
    public func isRiverInSouthEast() -> Bool {
        return self.riverFlowSouthEast == .southWest || self.riverFlowSouthEast == .northEast
    }
    
    public func setRiverFlowInSouthEast(flow: FlowDirection) throws {
        
        guard flow == .southWest || flow == .northEast else {
            throw FlowDirectionError.unsupported(flow: flow, in: .southeast)
        }
        
        self.riverFlowSouthEast = flow
    }
    
    public var flows: [FlowDirection] {
        var result: [FlowDirection] = []
        
        if self.isRiverInNorth() {
            result.append(self.riverFlowNorth)
        }
        
        if self.isRiverInNorthEast() {
            result.append(self.riverFlowNorthEast)
        }
        
        if self.isRiverInSouthEast() {
            result.append(self.riverFlowSouthEast)
        }
        
        return result
    }
    
    func isImpassable() -> Bool {
        
        // start with terrain cost
        let terrainCost = self.terrain().movementCost(for: .walk)
        
        if terrainCost == UnitMovementType.max {
            return true
        }
        
        if self.featureValue != .none {
            
            let featureCost = self.featureValue.movementCost(for: .walk)
            
            if featureCost == UnitMovementType.max {
                return true
            }
        }
        
        return false
    }
    
    /// cost to enter a terrain given the specified movementType
    /// -1.0 means not possible
    func movementCost(for movementType: UnitMovementType, from source: AbstractTile) -> Double {
        
        // start with terrain cost
        let terrainCost = self.terrain().movementCost(for: movementType)
        
        if terrainCost == UnitMovementType.max {
            return UnitMovementType.max
        }

        // add feature costs
        var featureCosts: Double = 0.0
        if self.featureValue != .none {
            
            let featureCost = self.featureValue.movementCost(for: movementType)
            
            if featureCost == UnitMovementType.max {
                return UnitMovementType.max
            }
            
            featureCosts = featureCost
        }
        
        // add river crossing cost
        var riverCost: Double = 0.0
        if source.isRiverToCross(towards: self) {
            riverCost = 1.0 // FIXME - river cost per movementType
        }

        return terrainCost + featureCosts + riverCost
    }
    
    func isNeighbor(to candidate: HexPoint) -> Bool {
        
        return self.point.distance(to: candidate) == 1
    }
    
    func isRiverToCross(towards target: AbstractTile) -> Bool {
        
        if !self.isNeighbor(to: target.point) {
            return false
        }
        
        guard let direction = self.point.direction(towards: target.point) else {
            return false
        }
        
        switch direction {
        case .north:
            return self.isRiverInNorth()
            
        case .northeast:
            return self.isRiverInNorthEast()
            
        case .southeast:
            return self.isRiverInSouthEast()
            
        case .south:
            return target.isRiverInNorth()
            
        case .southwest:
            return target.isRiverInNorthEast()
            
        case .northwest:
            return target.isRiverInSouthEast()
        }
    }
    
    func seeThroughLevel() -> Int {
        
        var level = 0
        
        if self.terrainVal == .ocean {
            level += 1
        }
        
        if self.hasHills() {
            level += 1
        }
        
        if self.has(feature: .mountains) {
            level += 2
        }
        
        if self.has(feature: .forest) || self.has(feature: .rainforest) {
            level += 1
        }
        
        return level
    }
    
    // FIXME wrap world !
    func canSee(tile: AbstractTile?, for player: AbstractPlayer?, range: Int, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let tile = tile else {
            return false
        }

        if tile.point == self.point {
            return true
        }

        if self.point.isNeighbor(of: tile.point) {
            return true
        }
        
        let distance = self.point.distance(to: tile.point)
        if distance <= range {
         
            var tmpPoint = self.point
 
            while !tmpPoint.isNeighbor(of: tile.point) {
                
                guard let dir = tmpPoint.direction(towards: tile.point) else {
                    return false
                }
                tmpPoint = tmpPoint.neighbor(in: dir)
                
                if let tmpTile = gameModel.tile(at: tmpPoint) {
                    if tmpTile.seeThroughLevel() > 1 {
                        return false
                    }
                }
            }
            
            return true
        }

        return false
    }
    
    func isOn(continent: Continent?) -> Bool {
        
        return self.continent?.identifier == continent?.identifier
    }
    
    func sameContinent(as otherTile: AbstractTile) -> Bool {
        
        return otherTile.isOn(continent: self.continent)
    }
    
    // scratch pad
    func builderAIScratchPad() -> BuilderAIScratchPad {
        
        return self.builderAIScratchPadValue
    }
    
    func set(builderAIScratchPad: BuilderAIScratchPad) {
        
        self.builderAIScratchPadValue = builderAIScratchPad
    }
    
    // MARK: build progress
    
    func buildProgress(buildType: BuildType) -> Int {
        
        return Int(self.buildProgressList.weight(of: buildType))
    }
    
    // Returns true if build finished...
    @discardableResult
    func changeBuildProgress(of buildType: BuildType, change: Int, for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {
        
        /*guard let gameModel = gameModel else {
         fatalError("cant get gameModel")
         }*/
        
        guard let player = player else {
            fatalError("cant get player")
        }
        
        var finished = false
        
        if change != 0 {
            
            self.buildProgressList.add(weight: change, for: buildType)
            
            if self.buildProgress(buildType: buildType) >= buildType.buildTime(on: self) {
                
                self.buildProgressList.set(weight: 0, for: buildType)
                
                // Constructed Improvement
                if let improvementType = buildType.improvement() {
                    
                    // eurekas
                    self.updateEurekas(with: improvementType, for: player)
                    
                    self.set(improvement: improvementType)
                    
                    // Unowned plot, someone has to foot the bill
                    if !self.hasOwner() {
                        fatalError("someone must pay")
                        /*if (MustPayMaintenanceHere(ePlayer))
                         {
                         GET_PLAYER(ePlayer).GetTreasury()->ChangeBaseImprovementGoldMaintenance(GC.getImprovementInfo(eImprovement)->GetGoldMaintenance());
                         }
                         SetPlayerResponsibleForImprovement(ePlayer);*/
                    }
                }
                
                // Constructed Route
                if let routeType = buildType.route() {
                    
                    self.set(route: routeType)
                    
                    // Unowned plot, someone has to foot the bill
                    if !self.hasOwner() {
                        fatalError("someone must pay")
                        /*if (MustPayMaintenanceHere(ePlayer))
                         {
                         GET_PLAYER(ePlayer).GetTreasury()->ChangeBaseImprovementGoldMaintenance(pkRouteInfo->GetGoldMaintenance());
                         }
                         SetPlayerResponsibleForRoute(ePlayer);*/
                    }
                }
            }
            
            // Remove Feature
            if self.hasAnyFeature() {
                
                if buildType.canRemove(feature: self.feature()) {
                    
                    let (production, cityRef) = self.featureProduction(by: buildType, for: player)
                    
                    if production > 0 {
                        
                        guard let city = cityRef else {
                            fatalError("no city found")
                        }
                        
                        guard let cityPlayer = city.player else {
                            fatalError("no city player found")
                        }
                        
                        city.changeFeatureProduction(change: production)
                        
                        if cityPlayer.isHuman() {
                            fatalError("fixme")
                            // Das Entfernen der Geländeart {@1_FeatName} hat {2_Num} [ICON_PRODUCTION] für die Stadt {@3_CityName} eingebracht.
                            // gameModel.add(message: <#T##AbstractGameMessage#>)
                            /*    strBuffer = GetLocalizedText("TXT_KEY_MISC_CLEARING_FEATURE_RESOURCE", GC.getFeatureInfo(getFeatureType())->GetTextKey(), iProduction, pCity->getNameKey());
                             GC.GetEngineUserInterface()->AddCityMessage(0, pCity->GetIDInfo(), pCity->getOwner(), false, GC.getEVENT_MESSAGE_TIME(), strBuffer);*/
                        }
                    }
                    
                    self.set(feature: .none)
                }
                
                // Repairing a Pillaged Tile
                if buildType.repair() {
                    
                    if self.isImprovementPillaged() {
                        self.setImprovement(pillaged: false)
                    } else if self.isRoutePillaged() {
                        self.setRoute(pillaged: false)
                    }
                }
                
                if buildType.removeRoute() {
                    self.set(route: .none)
                }
                
                finished = true
            }
        }
        
        return finished
    }
    
    func updateEurekas(with improvementType: TileImprovementType, for player: AbstractPlayer) {
        
        guard let techs = player.techs else {
            fatalError("Cant get techs of player")
        }
        
        guard let civics = player.civics else {
            fatalError("Cant get civics of player")
        }
        
        // Techs
        // -----------------------------------------------------
        
        // Masonry - To Boost: Build a quarry
        if !techs.eurekaTriggered(for: .masonry) {
            if improvementType == .quarry {
                techs.triggerEureka(for: .masonry)
            }
        }
        
        // Wheel - To Boost: Mine a resource
        if !techs.eurekaTriggered(for: .wheel) {
            if improvementType == .mine && self.hasAnyResource(for: player) {
                techs.triggerEureka(for: .wheel)
            }
        }
        
        // Irrigation - To Boost: Farm a resource
        if !techs.eurekaTriggered(for: .irrigation) {
            if improvementType == .farm && self.hasAnyResource(for: player) {
                techs.triggerEureka(for: .irrigation)
            }
        }
        
        // Horseback Riding - To Boost: Build a pasture
        if !techs.eurekaTriggered(for: .horsebackRiding) {
            if improvementType == .pasture {
                techs.triggerEureka(for: .horsebackRiding)
            }
        }
        
        // Iron Working - To Boost: Build a Iron Mine
        if !techs.eurekaTriggered(for: .ironWorking) {
            if improvementType == .mine && self.resourceValue == .iron {
                techs.triggerEureka(for: .ironWorking)
            }
        }
        
        // Military Tactics - To Boost: Build 3 mines
        if !techs.eurekaTriggered(for: .militaryTactics) {
            if improvementType == .mine {
                techs.changeEurekaValue(for: .militaryTactics, change: 1)
                
                if techs.eurekaValue(for: .militaryTactics) >= 3 {
                    techs.triggerEureka(for: .militaryTactics)
                }
            }
        }
        
        // Ballistics - To Boost: Build 2 Forts
        /*if !techs.eurekaTriggered(for: .ballistics) {
            if improvementType == .fort {
                techs.changeEurekaValue(for: .ballistics, change: 1)
                
                if techs.eurekaValue(for: .ballistics) >= 2 {
                    techs.triggerEureka(for: .ballistics)
                }
            }
        }*/
        
        // Rifling - To Boost: Build a Niter Mine
        /*if !techs.eurekaTriggered(for: .rifling) {
            if improvementType == .mine && self.resourceValue == .niter {
                techs.triggerEureka(for: .rifling)
            }
        }*/
        
        // Civics
        // -----------------------------------------------------
        // Craftmanship - To Boost: Improve 3 tiles
        if !civics.eurekaTriggered(for: .craftsmanship) {
            
            // increase for any improvement
            civics.changeEurekaValue(for: .craftsmanship, change: 1)
            
            if civics.eurekaValue(for: .craftsmanship) >= 3 {
                civics.triggerEureka(for: .craftsmanship)
            }
        }
    }
    
    func featureProduction(by buildType: BuildType, for player: AbstractPlayer?) -> (Int, AbstractCity?) {
        
        if self.featureValue == .none {
            return (0, nil)
        }
        
        let cityRef = self.workingCity()
        if cityRef == nil {
            fatalError("niy - try to find next city to give production to")
        }
        
        guard let city = cityRef else {
            return (0, nil)
        }
        
        // base value
        var production = buildType.productionFromRemoval(of: self.featureValue)
        
        // Distance mod
        production -= (max(0, self.point.distance(to: city.location) - 2) * 5)
        
        return (production, city)
    }
    
    func buildProgress(of buildType: BuildType) -> Int {
        
        return Int(self.buildProgressList.weight(of: buildType))
    }
}
