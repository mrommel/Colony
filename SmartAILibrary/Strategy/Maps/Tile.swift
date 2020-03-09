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

protocol AbstractTile {
    
    var point: HexPoint { get }
    var area: HexArea? { get set }
    
    func yields() -> Yields
    
    // terrain & hills
    func set(terrain: TerrainType)
    func terrain() -> TerrainType
    
    func hasHills() -> Bool
    func set(hills: Bool)
    
    func isOpenGround() -> Bool
    func isRoughGround() -> Bool
    func isImpassable() -> Bool
    
    // improvements
    func improvement() -> TileImprovementType?
    func possibleImprovements() -> [TileImprovementType]
    func build(improvement: TileImprovementType) throws
    func has(improvement: TileImprovementType) -> Bool
    func canBePillaged() -> Bool
    func removeImprovement()
    
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
    func isFriendlyTerritory(for player: AbstractPlayer?) -> Bool
    func isVisibleToEnemy(of player: AbstractPlayer?) -> Bool
    
    // discovered
    func isDiscovered(by player: AbstractPlayer?) -> Bool
    func discover(by player: AbstractPlayer?)
    
    // visible
    func isVisible(to player: AbstractPlayer?) -> Bool
    func sight(by player: AbstractPlayer?)
    func conceal(to player: AbstractPlayer?)
    
    // features
    func has(feature: FeatureType) -> Bool
    func add(feature: FeatureType)
    
    // resources
    func hasAnyResource() -> Bool
    func has(resource: ResourceType) -> Bool
    func set(resource: ResourceType)
    func has(resourceType: ResourceUsageType) -> Bool
    
    // ocean / continent
    func set(ocean: Ocean?)
    func set(continent: Continent?)
    
    // river
    func isRiver() -> Bool
    func isRiverIn(direction: HexDirection) throws -> Bool
    func isRiverInNorth() -> Bool
    func isRiverInNorthEast() -> Bool
    func isRiverInSouthEast() -> Bool
    func isRiverToCross(towards target: AbstractTile) -> Bool
    
    func movementCost(for movementType: UnitMovementType, from source: AbstractTile) -> Double
}

class Tile: AbstractTile {

    var point: HexPoint
    var area: HexArea?
    
    private var terrainVal: TerrainType
    private var hillsVal: Bool
    
    private var ocean: Ocean?
    private var continent: Continent?
    
    private var resource: ResourceType
    private var features: [FeatureType]
    private var improvementValue: TileImprovementType
    
    private var discovered: TileDiscovered
    private var ownerValue: AbstractPlayer?
    private var workedBy: AbstractCity? = nil
    private var city: AbstractCity? = nil
    
    private var riverName: String? = nil
    private var riverFlowNorth: FlowDirection = .none
    private var riverFlowNorthEast: FlowDirection = .none
    private var riverFlowSouthEast: FlowDirection = .none
    
    init(point: HexPoint, terrain: TerrainType, hills: Bool = false, features: [FeatureType] = []) {

        self.point = point
        self.terrainVal = terrain
        self.hillsVal = hills

        self.improvementValue = .none
        self.resource = .none
        self.features = features
        
        self.ownerValue = nil
        self.discovered = TileDiscovered()
        
        self.area = nil
        self.ocean = nil
        self.continent = nil
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

        if let improvement = self.improvement() {
            modifier += improvement.defenseModifier()
        }
        
        return modifier
    }
    
    func isFriendlyTerritory(for player: AbstractPlayer?) -> Bool {
        
        fatalError("not implemented yet")
    }
    
    func isVisibleToEnemy(of player: AbstractPlayer?) -> Bool {
        
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

    func yields() -> Yields {

        var returnYields = Yields(food: 0, production: 0, gold: 0, science: 0)

        let baseYields = self.terrainVal.yields()
        returnYields += baseYields

        if self.hillsVal && self.terrainVal.isLand() {
            returnYields += Yields(food: 0, production: 1, gold: 0, science: 0)
        }
        
        for feature in self.features {
            returnYields += feature.yields()
        }
        
        returnYields += self.resource.yields()

        returnYields += self.improvementValue.yields()

        return returnYields
    }
    
    // MARK: improvement methods
    
    func improvement() -> TileImprovementType? {
        
        if self.improvementValue != .none {
            return self.improvementValue
        }
        
        return nil
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
    
    func canBePillaged() -> Bool {
        
        return self.improvementValue.canBePillaged()
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
    
    func has(feature: FeatureType) -> Bool {
        
        self.features.contains(feature)
    }
    
    func add(feature: FeatureType) {
        
        self.features.append(feature)
    }
    
    // MARK: resource methods
    
    func hasAnyResource() -> Bool {
        
        return self.resource != .none
    }
    
    func has(resource: ResourceType) -> Bool {
        
        return self.resource == resource
    }
    
    func set(resource: ResourceType) {
        
        self.resource = resource
    }
    
    func has(resourceType: ResourceUsageType) -> Bool {
        
        return self.resource.usage() == resourceType
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
        
        for feature in self.features {
            
            let featureCost = feature.movementCost(for: .walk)
            
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
        for feature in self.features {
            
            let featureCost = feature.movementCost(for: movementType)
            
            if featureCost == UnitMovementType.max {
                return UnitMovementType.max
            }
            
            featureCosts += featureCost
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
}
