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

struct BuilderAIScratchPad {
    
    var turn: Int
    var routeType: RouteType
    var leader: LeaderType
    var value: Int
}

protocol AbstractTile {
    
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
    func improvement() -> TileImprovementType
    func possibleImprovements() -> [TileImprovementType]
    func build(improvement: TileImprovementType) throws
    func has(improvement: TileImprovementType) -> Bool
    func removeImprovement()
    func build(route: RouteType) throws
    func has(route: RouteType) -> Bool
    func canBuild(buildType: BuildType, by player: AbstractPlayer?) -> Bool
    func isImprovementPillaged() -> Bool
    func setImprovement(pillaged: Bool)
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
    func worked() -> AbstractCity?
    func setWorked(by city: AbstractCity?) throws
    
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
    func hasAnyResource() -> Bool
    func resource() -> ResourceType
    func has(resource: ResourceType) -> Bool
    func set(resource: ResourceType)
    func has(resourceType: ResourceUsageType) -> Bool
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
    
    func movementCost(for movementType: UnitMovementType, from source: AbstractTile) -> Double
    
    // scratch pad
    func builderAIScratchPad() -> BuilderAIScratchPad
    func set(builderAIScratchPad: BuilderAIScratchPad)
}

class Tile: AbstractTile {

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
    
    private var builderAIScrtchPadValue: BuilderAIScratchPad
    
    init(point: HexPoint, terrain: TerrainType, hills: Bool = false, feature: FeatureType = .none) {

        self.point = point
        self.terrainVal = terrain
        self.hillsVal = hills

        self.improvementValue = .none
        self.improvementPillagedValue = false
        self.routeValue = .none
        self.routePillagedValue = false
        self.resourceValue = .none
        self.resourceQuantityValue = 0
        self.featureValue = feature
        
        self.ownerValue = nil
        self.discovered = TileDiscovered()
        
        self.area = nil
        self.ocean = nil
        self.continent = nil
        
        self.builderAIScrtchPadValue = BuilderAIScratchPad(turn: -1, routeType: .none, leader: .none, value: -1)
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

    func build(improvement: TileImprovementType) throws {

        // can't add an improvement, if something is already installed
        if self.improvementValue != .none {
            throw TileError.alreadyImproved
        }
        
        // check if improvement is allowed here
        if !self.possibleImprovements().contains(improvement) {
            throw TileError.invalidImprovement
        }
        
        self.improvementValue = improvement
    }
    
    func has(improvement: TileImprovementType) -> Bool {
        
        return self.improvementValue == improvement
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
    
    func build(route: RouteType) throws {
        fatalError("niy")
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
    
    func worked() -> AbstractCity? {
        
        return self.workedBy
    }
    
    func removeWorked() throws {
        
        if !self.isWorked() {
            throw TileError.notWorkedYet
        }
        
        self.workedBy = nil
    }
    
    func setWorked(by city: AbstractCity?) throws {
        
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
        
        self.discovered.discover(by: player)
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
    
    func resource() -> ResourceType {
        
        return self.resourceValue
    }
    
    func hasAnyResource() -> Bool {
        
        return self.resourceValue != .none
    }
    
    func has(resource: ResourceType) -> Bool {
        
        return self.resourceValue == resource
    }
    
    func set(resource: ResourceType) {
        
        self.resourceValue = resource
    }
    
    func has(resourceType: ResourceUsageType) -> Bool {
        
        return self.resourceValue.usage() == resourceType
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
        
        return self.builderAIScrtchPadValue
    }
    
    func set(builderAIScratchPad: BuilderAIScratchPad) {
        
        self.builderAIScrtchPadValue = builderAIScratchPad
    }
}