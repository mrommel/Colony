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

public enum ArtifactType: Int, Codable {

    case none = 0

    // land
    case barbarianCamp
    case sarcophagus
    case ancientRuin
    case razedCity
    case battleMelee
    case battleRanged
    // case writing

    // sea
    case battleSeaMelee
    case battleSeaRanged
}

public class ArchaeologicalRecord: Codable {

    enum CodingKeys: CodingKey {

        case artifactType
        case leader1
        case leader2
        case era
    }

    var artifactType: ArtifactType
    var leader1: LeaderType
    var leader2: LeaderType
    var era: EraType

    init() {

        self.artifactType = .none
        self.leader1 = .none
        self.leader2 = .none
        self.era = .none
    }

    init(artifactType: ArtifactType, leader1: LeaderType, leader2: LeaderType, era: EraType) {

        self.artifactType = artifactType
        self.leader1 = leader1
        self.leader2 = leader2
        self.era = era
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.artifactType = try container.decode(ArtifactType.self, forKey: .artifactType)
        self.leader1 = try container.decode(LeaderType.self, forKey: .leader1)
        self.leader2 = try container.decode(LeaderType.self, forKey: .leader2)
        self.era = try container.decode(EraType.self, forKey: .era)
    }
}

public protocol AbstractTile: Codable, NSCopying {

    var point: HexPoint { get }
    var area: HexArea? { get set }

    func yields(for player: AbstractPlayer?, ignoreFeature: Bool) -> Yields
    func yieldsWith(buildType: BuildType, for player: AbstractPlayer?, ignoreFeature: Bool) -> Yields

    // terrain & hills
    func set(terrain: TerrainType)
    func terrain() -> TerrainType

    func hasHills() -> Bool
    func set(hills: Bool)

    func isOpenGround() -> Bool
    func isWater() -> Bool
    func isLand() -> Bool
    func domain() -> UnitDomainType
    func isRoughGround() -> Bool
    func isImpassable(for movementType: UnitMovementType) -> Bool

    // improvements
    func hasAnyImprovement() -> Bool
    func improvement() -> ImprovementType
    func possibleImprovements() -> [ImprovementType]
    func has(improvement: ImprovementType) -> Bool
    func removeImprovement()
    func set(improvement improvementType: ImprovementType)
    func isImprovementPillaged() -> Bool
    func setImprovement(pillaged: Bool)

    func has(route: RouteType) -> Bool
    func hasAnyRoute() -> Bool
    func isRoute() -> Bool
    func isValidRoute(for unit: AbstractUnit?) -> Bool

    func canBuild(buildType: BuildType, by player: AbstractPlayer?) -> Bool
    @discardableResult
    func changeBuildProgress(of buildType: BuildType, change: Int, for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func buildProgress(of buildType: BuildType) -> Int

    func productionFromFeatureRemoval(by buildType: BuildType) -> Int
    func doImprovement()

    func canBePillaged() -> Bool

    func isRoutePillaged() -> Bool
    func setRoute(pillaged: Bool)
    func set(route: RouteType)
    func route() -> RouteType

    // methods related to owner of this tile
    func hasOwner() -> Bool
    func owner() -> AbstractPlayer?
    func ownerLeader() -> LeaderType
    func set(owner: AbstractPlayer?) throws
    func change(owner: AbstractPlayer?) throws
    func removeOwner() throws
    func isCloseToBorder(of playerRef: AbstractPlayer?, in gameModel: GameModel?) -> Bool

    // methods related to working city
    func isCity() -> Bool
    func set(city: AbstractCity?) throws
    func isWorked() -> Bool
    func workingCity() -> AbstractCity?
    func workingCityName() -> String?
    func removeWorked() throws
    func setWorkingCity(to city: AbstractCity?) throws

    // district
    func startBuilding(district: DistrictType)
    func isBuilding(district: DistrictType) -> Bool
    func cancelBuildingDistrict()
    func buildingDistrict() -> DistrictType

    func build(district: DistrictType)
    func has(district: DistrictType) -> Bool
    func district() -> DistrictType

    func buildingsInDistrict() -> [BuildingType]

    // wonder
    func startBuilding(wonder: WonderType)
    func isBuilding(wonder: WonderType) -> Bool
    func cancelBuildingWonder()
    func buildingWonder() -> WonderType

    func build(wonder: WonderType)
    func has(wonder: WonderType) -> Bool
    func wonder() -> WonderType

    // appeal
    func appealLevel(in gameModel: GameModel?) -> AppealLevel
    func appeal(in gameModel: GameModel?) -> Int

    func defenseModifier(for player: AbstractPlayer?) -> Int
    func isFriendlyTerritory(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func isFriendlyCity(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func isVisibleToEnemy(of player: AbstractPlayer?, in gameModel: GameModel?) -> Bool
    func isEnemyTerritory(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool

    // discovered
    func isDiscovered(by player: AbstractPlayer?) -> Bool
    func discover(by player: AbstractPlayer?, in gameModel: GameModel?)

    // visible
    func isVisible(to player: AbstractPlayer?) -> Bool
    func isVisibleAny() -> Bool
    func sight(by player: AbstractPlayer?)
    func conceal(to player: AbstractPlayer?)
    func canSee(tile: AbstractTile?, for player: AbstractPlayer?, range: Int, hasSentry: Bool, in gameModel: GameModel?) -> Bool
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
    func set(resourceQuantity: Int)
    func resourceQuantity() -> Int
    func canHave(resource: ResourceType, ignoreLatitude: Bool, in mapModel: MapModel?) -> Bool

    // ocean / continent
    func set(ocean: Ocean?)
    func set(continent: Continent?)
    func isOn(continent: Continent?) -> Bool
    func sameContinent(as otherTile: AbstractTile) -> Bool
    func continentIdentifier() -> String?

    // river
    func isRiver() -> Bool
    func isRiverIn(direction: HexDirection) throws -> Bool
    func isRiverInNorth() -> Bool
    func isRiverInNorthEast() -> Bool
    func isRiverInSouthEast() -> Bool
    func isRiverToCross(towards target: AbstractTile, wrapX wrapXValue: Int) -> Bool
    func resetRiver()
    func set(river: River?, with flow: FlowDirection) throws
    func isRiverIn(flow: FlowDirection) -> Bool

    func movementCost(for movementType: UnitMovementType, from source: AbstractTile, wrapX wrapXValue: Int) -> Double
    func needsEmbarkation(by unit: AbstractUnit?) -> Bool

    func isValidDomainFor(unit: AbstractUnit?) -> Bool
    func isValidDomainForAction(of unit: AbstractUnit?) -> Bool

    // archeology
    func archaeologicalRecord() -> ArchaeologicalRecord
    func addArchaeologicalRecord(with artifact: ArtifactType, era: EraType, leader1: LeaderType, leader2: LeaderType)

    // scratch pad
    func builderAIScratchPad() -> BuilderAIScratchPad
    func set(builderAIScratchPad: BuilderAIScratchPad)
}

// swiftlint:disable type_body_length
public class Tile: AbstractTile {

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
        case owner
        case workedByCityName

        case riverName
        case riverFlowNorth
        case riverFlowNorthEast
        case riverFlowSouthEast

        case buildProgress

        case buildingDistrict
        case district
        case buildingWonder
        case wonder

        case archaeologicalRecord
    }

    public var point: HexPoint
    public var area: HexArea?

    private var terrainVal: TerrainType
    private var hillsVal: Bool

    private var ocean: Ocean?
    private var continentValue: Continent?

    private var resourceValue: ResourceType
    private var resourceQuantityValue: Int
    private var featureValue: FeatureType
    private var improvementValue: ImprovementType
    private var improvementPillagedValue: Bool
    private var routeValue: RouteType
    private var routePillagedValue: Bool

    private var discovered: TileDiscovered
    private var ownerValue: AbstractPlayer?
    private var ownerLeaderValue: LeaderType // only for serialization
    private var workedBy: AbstractCity?
    private var workedByCityName: String? // only for serialization
    private var city: AbstractCity?

    private var riverName: String?
    private var riverFlowNorth: FlowDirection = .none
    private var riverFlowNorthEast: FlowDirection = .none
    private var riverFlowSouthEast: FlowDirection = .none

    private var buildProgressList: BuildProgressList

    private var builderAIScratchPadValue: BuilderAIScratchPad

    private var buildingDistrictValue: DistrictType
    private var districtValue: DistrictType

    private var buildingWonderValue: WonderType
    private var wonderValue: WonderType

    private var archaeologicalRecordValue: ArchaeologicalRecord

    public init(point: HexPoint, terrain: TerrainType, hills: Bool = false, feature: FeatureType = .none) {

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
        self.ownerLeaderValue = .none
        self.discovered = TileDiscovered()

        self.area = nil
        self.ocean = nil
        self.continentValue = nil

        self.buildProgressList = BuildProgressList()
        self.buildProgressList.fill()

        self.builderAIScratchPadValue = BuilderAIScratchPad(turn: -1, routeType: .none, leader: .none, value: -1)

        self.buildingDistrictValue = DistrictType.none
        self.districtValue = DistrictType.none

        self.buildingWonderValue = WonderType.none
        self.wonderValue = WonderType.none

        self.archaeologicalRecordValue = ArchaeologicalRecord()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.point = try container.decode(HexPoint.self, forKey: .point)
        self.terrainVal = try container.decode(TerrainType.self, forKey: .terrain)
        self.hillsVal = try container.decode(Bool.self, forKey: .hills)

        self.resourceValue = try container.decode(ResourceType.self, forKey: .resource)
        self.resourceQuantityValue = try container.decode(Int.self, forKey: .resourceQuantity)
        self.featureValue = try container.decode(FeatureType.self, forKey: .feature)
        self.improvementValue = try container.decode(ImprovementType.self, forKey: .improvement)
        self.improvementPillagedValue = try container.decode(Bool.self, forKey: .improvementPillaged)
        self.routeValue = try container.decode(RouteType.self, forKey: .route)
        self.routePillagedValue = try container.decode(Bool.self, forKey: .routePillaged)

        self.ownerValue = nil
        self.ownerLeaderValue = try container.decodeIfPresent(LeaderType.self, forKey: .owner) ?? .none

        self.workedBy = nil
        self.workedByCityName = try container.decodeIfPresent(String.self, forKey: .workedByCityName)

        self.discovered = try container.decodeIfPresent(TileDiscovered.self, forKey: .discovered) ?? TileDiscovered()

        self.area = nil
        self.ocean = nil
        self.continentValue = nil

        self.riverName = try container.decodeIfPresent(String.self, forKey: .riverName)
        self.riverFlowNorth = try container.decodeIfPresent(FlowDirection.self, forKey: .riverFlowNorth) ?? .none
        self.riverFlowNorthEast = try container.decodeIfPresent(FlowDirection.self, forKey: .riverFlowNorthEast) ?? .none
        self.riverFlowSouthEast = try container.decodeIfPresent(FlowDirection.self, forKey: .riverFlowSouthEast) ?? .none

        if container.contains(.buildProgress) {
            self.buildProgressList = try container.decode(BuildProgressList.self, forKey: .buildProgress)
        } else {
            self.buildProgressList = BuildProgressList()
            self.buildProgressList.fill()
        }

        self.builderAIScratchPadValue = BuilderAIScratchPad(turn: -1, routeType: .none, leader: .none, value: -1)

        self.buildingDistrictValue = try container.decode(DistrictType.self, forKey: .buildingDistrict)
        self.districtValue = try container.decode(DistrictType.self, forKey: .district)

        self.buildingWonderValue = try container.decode(WonderType.self, forKey: .buildingWonder)
        self.wonderValue = try container.decode(WonderType.self, forKey: .wonder)

        self.archaeologicalRecordValue =
            try container.decodeIfPresent(ArchaeologicalRecord.self, forKey: .archaeologicalRecord) ?? ArchaeologicalRecord()
    }

    public func encode(to encoder: Encoder) throws {

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

        if !self.discovered.isEmpty() {
            try container.encode(self.discovered, forKey: .discovered)
        }

        if let leader = self.owner()?.leader {
            try container.encode(leader, forKey: .owner)
        }

        if let cityName = self.workedBy?.name {
            try container.encode(cityName, forKey: .workedByCityName)
        }

        try container.encodeIfPresent(self.riverName, forKey: .riverName) // can be nil
        if self.riverFlowNorth != .none {
            try container.encode(self.riverFlowNorth, forKey: .riverFlowNorth)
        }
        if self.riverFlowNorthEast != .none {
            try container.encode(self.riverFlowNorthEast, forKey: .riverFlowNorthEast)
        }
        if self.riverFlowSouthEast != .none {
            try container.encode(self.riverFlowSouthEast, forKey: .riverFlowSouthEast)
        }

        if !self.buildProgressList.isZero() {
            try container.encode(self.buildProgressList, forKey: .buildProgress)
        }

        try container.encode(self.buildingDistrictValue, forKey: .buildingDistrict)
        try container.encode(self.districtValue, forKey: .district)

        try container.encode(self.buildingWonderValue, forKey: .buildingWonder)
        try container.encode(self.wonderValue, forKey: .wonder)

        try container.encode(self.archaeologicalRecordValue, forKey: .archaeologicalRecord)
    }

    public func copy(with zone: NSZone? = nil) -> Any {

        let copy = Tile(point: self.point, terrain: self.terrainVal, hills: self.hillsVal, feature: self.featureValue)

        copy.resourceValue = self.resourceValue
        copy.resourceQuantityValue = self.resourceQuantityValue
        copy.featureValue = self.featureValue
        copy.improvementValue = self.improvementValue
        copy.improvementPillagedValue = self.improvementPillagedValue
        copy.routeValue = self.routeValue
        copy.routePillagedValue = self.routePillagedValue

        copy.discovered = self.discovered
        copy.ownerValue = self.ownerValue

        copy.workedBy = self.workedBy
        copy.riverName = self.riverName
        copy.riverFlowNorth = self.riverFlowNorth
        copy.riverFlowNorthEast = self.riverFlowNorthEast
        copy.riverFlowSouthEast = self.riverFlowSouthEast

        copy.buildProgressList = self.buildProgressList

        copy.buildingDistrictValue = self.buildingDistrictValue
        copy.districtValue = self.districtValue

        copy.buildingWonderValue = self.buildingWonderValue
        copy.wonderValue = self.wonderValue

        copy.archaeologicalRecordValue = self.archaeologicalRecordValue

        return copy
    }

    // for tests

    public func set(terrain: TerrainType) {

        self.terrainVal = terrain
    }

    public func terrain() -> TerrainType {

        return self.terrainVal
    }

    public func hasHills() -> Bool {

        return self.hillsVal
    }

    public func set(hills: Bool) {

        self.hillsVal = hills
    }

    public func defenseModifier(for player: AbstractPlayer?) -> Int {

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

    /// Is this a plot that's friendly to our team? (owned by us or someone we have Open Borders with)
    public func isFriendlyTerritory(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        // No friendly territory for barbs!
        if player.isBarbarian() {
            return false
        }

        // Nobody owns this plot
        if !self.hasOwner() {
            return false
        }

        // Our territory
        if player.isEqual(to: self.owner()) {
            return true
        }

        guard let diplomaticAI = player.diplomacyAI else {
            fatalError("cant get diplomaticAI")
        }

        // territory of player we have open border with
        if diplomaticAI.isOpenBorderAgreementActive(by: self.owner()) {
            return true
        }

        return false
    }

    public func isEnemyTerritory(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let player = player else {
            fatalError("cant get player")
        }

        // only enemy territory for barbs!
        if player.isBarbarian() {
            return true
        }

        // Nobody owns this plot
        if !self.hasOwner() {
            return false
        }

        // Our territory
        if player.isEqual(to: self.owner()) {
            return false
        }

        guard let diplomaticAI = player.diplomacyAI else {
            fatalError("cant get diplomaticAI")
        }

        // territory of player we have open border with
        if diplomaticAI.isAtWar(with: self.owner()) {
            return true
        }

        return false
    }

    public func isFriendlyCity(for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        return self.isFriendlyTerritory(for: player, in: gameModel) && self.isCity()
    }

    public func isVisibleToEnemy(of player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = player else {
            fatalError("cant get player")
        }

        guard let diplomacyAI = player.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        for loopPlayer in gameModel.players {

            if loopPlayer.isBarbarian() {
                continue
            }

            if player.isEqual(to: loopPlayer) {
                continue
            }

            if diplomacyAI.isAtWar(with: loopPlayer) {
                if self.isVisible(to: loopPlayer) {
                    return true
                }
            }
        }

        return false
    }

    public func isOpenGround() -> Bool {

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

    public func isRoughGround() -> Bool {

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

    public func yields(for player: AbstractPlayer?, ignoreFeature: Bool) -> Yields {

        var returnYields = Yields(food: 0, production: 0, gold: 0, science: 0)

        let baseYields = self.terrainVal.yields()
        returnYields += baseYields

        if self.hillsVal && self.terrainVal.isLand() {
            returnYields += Yields(food: 0, production: 1, gold: 0, science: 0)
        }

        if ignoreFeature == false && self.featureValue != .none {
            returnYields += self.featureValue.yields()
        }

        let visibleResource = self.resource(for: player)
        returnYields += visibleResource.yields()

        if self.improvementValue != .none && !self.isImprovementPillaged() {
            returnYields += self.improvementValue.yields(for: player, on: visibleResource)
        }

        return returnYields
    }

    /*func hasYield() -> Bool {
        
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
    }*/

    public func yieldsWith(buildType: BuildType, for player: AbstractPlayer?, ignoreFeature: Bool = false) -> Yields {

        // Will the build remove the feature?
        var ignoreFeatureValue = ignoreFeature

        if self.featureValue != .none {
            if buildType.canRemove(feature: self.featureValue) {
                ignoreFeatureValue = true
            }
        }

        var yields = self.yields(for: player, ignoreFeature: ignoreFeatureValue)

        // //////////////
        var improvementFromBuild = buildType.improvement()
        if improvementFromBuild == nil {
            // might be repair
            if /*!self.isImprovementPillaged() ||*/ buildType == .repair {
                improvementFromBuild = self.improvement()
            }
        }

        if let improvementFromBuild = improvementFromBuild {

            yields += improvementFromBuild.yields(for: player, on: self.resource(for: player))
        }

        // //////////////
        var routeFromBuild = buildType.route()
        if routeFromBuild == nil {
            // might be repair
            if /*!self.isRoutePillaged() ||*/ buildType == .repair {
                routeFromBuild = self.routeValue
            }
        }

        return yields
    }

    // MARK: improvement methods

    public func hasAnyImprovement() -> Bool {

        return self.improvementValue != .none
    }

    public func improvement() -> ImprovementType {

        return self.improvementValue
    }

    public func possibleImprovements() -> [ImprovementType] {

        var possibleTileImprovements: [ImprovementType] = []

        for improvementType in ImprovementType.all {

            if improvementType.isPossible(on: self) {
                possibleTileImprovements.append(improvementType)
            }
        }

        return possibleTileImprovements
    }

    public func removeImprovement() {

        self.set(improvement: .none)
    }

    func removeGoodyHut(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.set(improvement: .none)

        // Make sure the player's know to recalculate their goody hut searches
        for player in gameModel.players {

            if player.isAlive() {
                player.economicAI?.setExplorationPlotsDirty()
            }
        }
    }

    public func has(improvement: ImprovementType) -> Bool {

        return self.improvementValue == improvement
    }

    public func set(improvement improvementType: ImprovementType) {

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

                if let area = self.area {
                    area.updateNumber(of: oldImprovement, by: -1)
                }

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
                // SetPlayerThatClearedBarbCampHere(NO_PLAYER);
            }

            // setUpgradeProgress(0);

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
                if let player = self.owner() {
                    let culture = improvementType.yields(for: player, on: resource(for: player)).culture
                    // ComputeCultureFromImprovement(newImprovementEntry, eNewValue);
                    if culture != 0 {
                    // self.changeCulture(culture)
                    }
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

                if let area = self.area {
                    area.updateNumber(of: improvementType, by: 1)
                }

                if let player = self.owner() {

                    player.changeImprovementCount(of: improvementType, change: 1)

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
        }
    }

    public func isImprovementPillaged() -> Bool {

        return self.improvementPillagedValue
    }

    public func setImprovement(pillaged: Bool) {

        self.improvementPillagedValue = pillaged
    }

    public func doImprovement() {

    }

    public func productionFromFeatureRemoval(by buildType: BuildType) -> Int {

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

    public func has(route: RouteType) -> Bool {

        return self.routeValue == route
    }

    public func hasAnyRoute() -> Bool {

        return self.routeValue != .none
    }

    //    --------------------------------------------------------------------------------
    public func isRoute() -> Bool {

        return self.routeValue != .none
    }

    //    --------------------------------------------------------------------------------
    public func isValidRoute(for unitRef: AbstractUnit?) -> Bool {

        if self.routeValue != .none && !self.routePillagedValue {

            guard let unit = unitRef else {
                return true
            }

            if unit.domain() == self.domain() {

                // no owner - no enemy
                return !unit.isEnemy(of: self.ownerValue) || unit.isEnemyRoute()
            }
        }

        return false
    }

    public func canBePillaged() -> Bool {

        return self.improvementValue.canBePillaged()
    }

    public func isRoutePillaged() -> Bool {

        return self.routePillagedValue
    }

    public func setRoute(pillaged: Bool) {

        self.routePillagedValue = pillaged

        if pillaged {
            fatalError("need to update city connections")
            // GET_PLAYER(ePlayer).GetCityConnections()->Update();
        }
    }

    public func set(route routeType: RouteType) {

        self.routeValue = routeType
    }

    public func route() -> RouteType {

        return self.routeValue
    }

    public func canBuild(buildType: BuildType, by player: AbstractPlayer?) -> Bool {

        // Can't build nothing!
        if buildType == .none {
            return false
        }

        if let improvement = buildType.improvement() {

            if self.district() != .none {
                return false
            }

            if !improvement.isPossible(on: self) {
                return false
            }
        }

        return true
    }

    func costPerTurn() -> Int {

        return self.improvementValue.costPerTurn()
    }

    // MARK: owner methods

    public func removeOwner() throws {

        if ownerValue == nil {
            throw TileError.emptyOwner
        }

        self.ownerValue = nil
        self.ownerLeaderValue = .none
    }

    public func set(owner: AbstractPlayer?) throws {

        if owner == nil {
            throw TileError.emptyOwner
        }

        if self.hasOwner() {
            throw TileError.alreadyOwned
        }

        self.ownerValue = owner
        self.ownerLeaderValue = owner!.leader
    }

    public func change(owner: AbstractPlayer?) throws {

        if owner == nil {
            throw TileError.emptyOwner
        }

        self.ownerValue = owner
        self.ownerLeaderValue = owner!.leader
    }

    public func owner() -> AbstractPlayer? {

        return self.ownerValue
    }

    public func hasOwner() -> Bool {

        return self.ownerValue != nil
    }

    public func ownerLeader() -> LeaderType {

        return self.ownerLeaderValue
    }

    /// Is this Plot within a certain range of any of a player's Cities?
    public func isCloseToBorder(of playerRef: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let player = playerRef else {
            return false
        }

        var minDistance: Int = Int.max

        // do not use estimated turns here, performance is not good
        for cityRef in gameModel.cities(of: player) {

            guard let city = cityRef else {
                continue
            }

            let distance = city.location.distance(to: self.point)
            if distance < minDistance {
                minDistance = distance
            }
        }

        let range = 5 /* AI_DIPLO_PLOT_RANGE_FROM_CITY_HOME_FRONT */
        return minDistance < range
    }

    // MARK: work related methods

    public func isCity() -> Bool {

        return self.city != nil
    }

    public func set(city: AbstractCity?) throws {

        self.city = city
    }

    public func isWorked() -> Bool {

        return self.workedBy != nil
    }

    public func workingCity() -> AbstractCity? {

        return self.workedBy
    }

    public func workingCityName() -> String? {

        return self.workedByCityName
    }

    public func removeWorked() throws {

        if !self.isWorked() {
            throw TileError.notWorkedYet
        }

        self.workedBy = nil
        self.workedByCityName = nil
    }

    public func setWorkingCity(to city: AbstractCity?) throws {

        if city == nil {
            throw TileError.emptyWorker
        }

        if self.isWorked() {
            throw TileError.alreadyWorked
        }

        self.workedBy = city
    }

    // MARK: ...

    public func isDiscovered(by player: AbstractPlayer?) -> Bool {

        return self.discovered.isDiscovered(by: player)
    }

    public func discover(by player: AbstractPlayer?, in gameModel: GameModel?) {

        guard let player = player else {
            fatalError("cant get player")
        }

        if !self.isDiscovered(by: player) {

            self.discovered.discover(by: player)

            if gameModel?.tutorialInfos() == .movementAndExploration && player.isHuman() {
                let numberOfDiscoveredPlots = player.numberOfDiscoveredPlots(in: gameModel)
                if numberOfDiscoveredPlots >= 50 {
                    gameModel?.userInterface?.finish(tutorial: .movementAndExploration)
                }
            }
        }
    }

    // MARK: sight

    public func isVisible(to player: AbstractPlayer?) -> Bool {

        return self.discovered.isVisible(to: player)
    }

    public func isVisibleAny() -> Bool {

        return self.discovered.isVisibleAny()
    }

    public func sight(by player: AbstractPlayer?) {

        self.discovered.sight(by: player)
    }

    public func conceal(to player: AbstractPlayer?) {

        self.discovered.conceal(to: player)
    }

    // MARK: feature methods

    public func hasAnyFeature() -> Bool {

        return self.featureValue != .none
    }

    public func feature() -> FeatureType {

        return self.featureValue
    }

    public func has(feature: FeatureType) -> Bool {

        return self.featureValue == feature
    }

    public func set(feature: FeatureType) {

        self.featureValue = feature
    }

    // MARK: resource methods

    public func hasAnyResource(for player: AbstractPlayer?) -> Bool {

        return self.resource(for: player) != .none
    }

    // if no player is provided, no check for tech
    public func resource(for player: AbstractPlayer?) -> ResourceType {

        if self.resourceValue != .none {

            var valid = true

            // check if already visible to player
            if let revealTech = self.resourceValue.revealTech() {
                if let player = player {
                    if !player.has(tech: revealTech) {
                        valid = false
                    }
                }
            }

            if let revealCivic = self.resourceValue.revealCivic() {
                if let player = player {
                    if !player.has(civic: revealCivic) {
                        valid = false
                    }
                }
            }

            if valid {
                return self.resourceValue
            }
        }

        return .none
    }

    public func has(resource: ResourceType, for player: AbstractPlayer?) -> Bool {

        return self.resource(for: player) == resource
    }

    public func set(resource: ResourceType) {

        self.resourceValue = resource
    }

    public func has(resourceType: ResourceUsageType, for player: AbstractPlayer?) -> Bool {

        return self.resource(for: player).usage() == resourceType
    }

    public func set(resourceQuantity: Int) {

        self.resourceQuantityValue = resourceQuantity
    }

    public func resourceQuantity() -> Int {

        return self.resourceQuantityValue
    }

    public func isWater() -> Bool {

        return self.terrainVal.isWater()
    }

    public func isLand() -> Bool {

        return self.terrainVal.isLand()
    }

    public func domain() -> UnitDomainType {

        return self.terrainVal.isWater() ? .sea : .land
    }

    func isFlatlands() -> Bool {

        if !self.terrainVal.isLand() {
            return false
        }

        /*if self.hillsVal {
            return false
        }*/

        if self.featureValue == .mountains || self.featureValue == .mountEverest || self.featureValue == .mountKilimanjaro {
            return false
        }

        return true
    }

    public func isValidDomainFor(unit: AbstractUnit?) -> Bool {

        if self.isValidDomainForAction(of: unit) {
            return true
        }

        return self.isCity()
    }

    public func isValidDomainForAction(of unit: AbstractUnit?) -> Bool {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        switch unit.domain() {

        case .none: return false

        case .land, .immobile:
            return (!self.terrain().isWater() /*|| unit.IsHoveringUnit()*/ || unit.canMoveAllTerrain() || unit.isEmbarked())
        case .sea:
            return (self.terrain().isWater() || unit.canMoveAllTerrain())
        case .air:
            return false
        }
    }

    public func canHave(resource: ResourceType, ignoreLatitude: Bool = false, in mapModel: MapModel?) -> Bool {

        guard let mapModel = mapModel else {
            fatalError("cant get gameModel")
        }

        if resource == .none {
            return true
        }

        // only one resource per tile
        if self.resourceValue != .none {
            return false
        }

        // no resources on natural wonders
        if self.feature().isNaturalWonder() {
            return false
        }

        // no resources on mountains
        if self.feature() == .mountains {
            return false
        }

        if self.feature() != .none {

            if !resource.placedOn(feature: self.featureValue) {
                return false
            }

            if !resource.placedOn(featureTerrain: self.terrainVal) {
                return false
            }
        } else {
            // only checked if no feature
            if !resource.placedOn(terrain: self.terrainVal) {
                return false
            }
        }

        if self.hasHills() {
            if !resource.placedOnHills() {
                return false
            }
        } else if self.isFlatlands() {
            if !resource.isFlatlands() {
                return false
            }
        }

        if mapModel.river(at: self.point) {
            if !resource.placedOnRiverSide() {
                return false
            }
        }

        /*if (thisResourceInfo.getMinAreaSize() != -1)
        {
            if (area()->getNumTiles() < thisResourceInfo.getMinAreaSize())
            {
                return false;
            }
        }*/

        /*if !ignoreLatitude {
            if (getLatitude() > thisResourceInfo.getMaxLatitude())
            {
                return false;
            }

            if (getLatitude() < thisResourceInfo.getMinLatitude())
            {
                return false;
            }
        }*/

        /*if !self.isPotentialCityWork() {
            return false
        }*/

        // FIXME: make sure that no valuable resources are out of reach
        /*if self.terrainVal == .shore {
            if !isAdjacentToLand() {
                return false
            }
        }*/

        return true
    }

    // MARK: ocean / continent methods

    public func set(ocean: Ocean?) {

        self.ocean = ocean
    }

    public func set(continent: Continent?) {

        self.continentValue = continent
    }

    public func resetRiver() {

        self.riverName = nil
        self.riverFlowNorth = .none
        self.riverFlowNorthEast = .none
        self.riverFlowSouthEast = .none
    }

    public func set(river: River?, with flow: FlowDirection) throws {
        self.riverName = river?.name

        try setRiver(flow: flow)
    }

    public func isRiver() -> Bool {

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
            throw FlowDirectionError.unsupported(flow: .none, direction: direction)
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
            throw FlowDirectionError.unsupported(flow: flow, direction: .north)
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
            throw FlowDirectionError.unsupported(flow: flow, direction: direction)
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
            throw FlowDirectionError.unsupported(flow: flow, direction: .north)
        }

        self.riverFlowNorth = flow
    }

    // river in north east can flow to northwest or southeast direction
    public func isRiverInNorthEast() -> Bool {
        return self.riverFlowNorthEast == .northWest || self.riverFlowNorthEast == .southEast
    }

    public func setRiverFlowInNorthEast(flow: FlowDirection) throws {

        guard flow == .northWest || flow == .southEast else {
            throw FlowDirectionError.unsupported(flow: flow, direction: .northeast)
        }

        self.riverFlowNorthEast = flow
    }

    // river in south east can flow to northeast or southwest direction
    public func isRiverInSouthEast() -> Bool {
        return self.riverFlowSouthEast == .southWest || self.riverFlowSouthEast == .northEast
    }

    public func setRiverFlowInSouthEast(flow: FlowDirection) throws {

        guard flow == .southWest || flow == .northEast else {
            throw FlowDirectionError.unsupported(flow: flow, direction: .southeast)
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

    public func isImpassable(for movementType: UnitMovementType) -> Bool {

        // start with terrain cost
        let terrainCost = self.terrain().movementCost(for: movementType)

        if terrainCost == UnitMovementType.max {
            return true
        }

        if self.featureValue != .none {

            let featureCost = self.featureValue.movementCost(for: movementType)

            if featureCost == UnitMovementType.max {
                return true
            }
        }

        return false
    }

    /// cost to enter a terrain given the specified movementType
    /// -1.0 means not possible
    public func movementCost(for movementType: UnitMovementType, from source: AbstractTile, wrapX wrapXValue: Int = -1) -> Double {

        // start with terrain cost
        var terrainCost = self.terrain().movementCost(for: movementType)

        if terrainCost == UnitMovementType.max {
            return UnitMovementType.max
        }

        // hills
        var hillCosts = self.hillsVal ? 1.0 : 0.0

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
        if source.isRiverToCross(towards: self, wrapX: wrapXValue) {
            riverCost = 3.0 // FIXME - river cost per movementType
        }

        // https://civilization.fandom.com/wiki/Roads_(Civ6)
        if self.hasAnyRoute() {
            terrainCost = self.routeValue.movementCost()

            if self.routeValue != .ancientRoad {
                riverCost =  0.0
            }

            hillCosts = 0.0
            featureCosts = 0.0
        }

        return terrainCost + hillCosts + featureCosts + riverCost
    }

    public func needsEmbarkation(by unitRef: AbstractUnit?) -> Bool {

        // embarkation only on water plots
        if !self.isWater() || self.featureValue == .ice /* || IsAllowsWalkWater()*/ {
            return false
        }

        guard let unit = unitRef else {
            return true
        }

        // only land units need to embark
        if unit.domain() != .land || unit.canMoveAllTerrain() {
            return false
        }

        // some units can flip between different types
        /*if unit.isConvertUnit())
            return false;*/

        // we know it's a land unit and a water plot by now
        return true
    }

    func isNeighbor(to candidate: HexPoint, wrapX wrapXValue: Int = -1) -> Bool {

        return self.point.distance(to: candidate, wrapX: wrapXValue) == 1
    }

    public func isRiverToCross(towards target: AbstractTile, wrapX wrapXValue: Int = -1) -> Bool {

        if !self.isNeighbor(to: target.point, wrapX: wrapXValue) {
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

    // https://civilization.fandom.com/wiki/Sight_(Civ6)
    public func seeThroughLevel() -> Int {

        var level = 0

        if self.hasHills() {
            level += 1
        }

        if self.has(feature: .mountains) {
            level += 3
        }

        if self.has(feature: .forest) || self.has(feature: .rainforest) {
            level += 1
        }

        return level
    }

    public func canSee(tile: AbstractTile?, for player: AbstractPlayer?, range: Int, hasSentry: Bool = false, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            return false
        }

        if tile.point == self.point {
            return true
        }

        let wrappedX: Int = gameModel.wrappedX() ? gameModel.mapSize().width() : -1

        if self.point.isNeighbor(of: tile.point, wrapX: wrappedX) {
            return true
        }

        let seeThruLevel = hasSentry ? 2 : 1

        let distance = self.point.distance(to: tile.point, wrapX: wrappedX)
        if distance <= range {

            var tmpPoint = self.point

            while !tmpPoint.isNeighbor(of: tile.point, wrapX: wrappedX) {

                guard let dir = tmpPoint.direction(towards: tile.point) else {
                    return false
                }
                tmpPoint = tmpPoint.neighbor(in: dir)
                tmpPoint = gameModel.wrap(point: tmpPoint)

                if let tmpTile = gameModel.tile(at: tmpPoint) {
                    if tmpTile.seeThroughLevel() > seeThruLevel {
                        return false
                    }
                }
            }

            return true
        }

        return false
    }

    public func isOn(continent: Continent?) -> Bool {

        return self.continentValue?.identifier == continent?.identifier
    }

    public func sameContinent(as otherTile: AbstractTile) -> Bool {

        return otherTile.isOn(continent: self.continentValue)
    }

    public func continentIdentifier() -> String? {

        if let identifier = self.continentValue?.identifier {
            return "\(identifier)"
        }

        return nil
    }

    // scratch pad
    public func builderAIScratchPad() -> BuilderAIScratchPad {

        return self.builderAIScratchPadValue
    }

    public func set(builderAIScratchPad: BuilderAIScratchPad) {

        self.builderAIScratchPadValue = builderAIScratchPad
    }

    // MARK: build progress

    func buildProgress(buildType: BuildType) -> Int {

        return Int(self.buildProgressList.weight(of: buildType))
    }

    // Returns true if build finished...
    @discardableResult
    public func changeBuildProgress(of buildType: BuildType, change: Int, for player: AbstractPlayer?, in gameModel: GameModel?) -> Bool {

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
                    self.updateEurekas(with: improvementType, for: player, in: gameModel)

                    self.set(improvement: improvementType)
                }

                // Constructed Route
                if let routeType = buildType.route() {

                    self.set(route: routeType)
                }

                // Remove Feature
                if self.hasAnyFeature() {

                    if !buildType.keeps(feature: self.feature()) && buildType.canRemove(feature: self.feature()) {

                        let (production, cityRef) = self.featureProduction(by: buildType, for: player)

                        if production > 0 {

                            guard let city = cityRef else {
                                fatalError("no city found")
                            }

                            guard let cityPlayer = city.player else {
                                fatalError("no city player found")
                            }

                            city.changeFeatureProduction(change: Double(production))

                            if cityPlayer.isHuman() {

                                gameModel?.userInterface?.showTooltip(
                                    at: self.point,
                                    type: .clearedFeature(feature: self.feature(), production: production, cityName: city.name),
                                    delay: 3
                                )
                            }
                        }

                        self.set(feature: .none)
                    }
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

    func updateEurekas(with improvementType: ImprovementType, for player: AbstractPlayer, in gameModel: GameModel?) {

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
                techs.triggerEureka(for: .masonry, in: gameModel)
            }
        }

        // Wheel - To Boost: Mine a resource
        if !techs.eurekaTriggered(for: .wheel) {
            if improvementType == .mine && self.hasAnyResource(for: player) {
                techs.triggerEureka(for: .wheel, in: gameModel)
            }
        }

        // Irrigation - To Boost: Farm a resource
        if !techs.eurekaTriggered(for: .irrigation) {
            if improvementType == .farm && self.hasAnyResource(for: player) {
                techs.triggerEureka(for: .irrigation, in: gameModel)
            }
        }

        // Horseback Riding - To Boost: Build a pasture
        if !techs.eurekaTriggered(for: .horsebackRiding) {
            if improvementType == .pasture {
                techs.triggerEureka(for: .horsebackRiding, in: gameModel)
            }
        }

        // Iron Working - To Boost: Build a Iron Mine
        if !techs.eurekaTriggered(for: .ironWorking) {
            if improvementType == .mine && self.resourceValue == .iron {
                techs.triggerEureka(for: .ironWorking, in: gameModel)
            }
        }

        // Apprenticeship - To Boost: Build 3 mines
        if !techs.eurekaTriggered(for: .apprenticeship) {
            if improvementType == .mine {
                techs.changeEurekaValue(for: .apprenticeship, change: 1)

                if techs.eurekaValue(for: .apprenticeship) >= 3 {
                    techs.triggerEureka(for: .apprenticeship, in: gameModel)
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
        if !civics.inspirationTriggered(for: .craftsmanship) {

            // increase for any improvement
            civics.changeInspirationValue(for: .craftsmanship, change: 1)

            if civics.inspirationValue(for: .craftsmanship) >= 3 {
                civics.triggerInspiration(for: .craftsmanship, in: gameModel)
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

    public func buildProgress(of buildType: BuildType) -> Int {

        return Int(self.buildProgressList.weight(of: buildType))
    }

    public func appealLevel(in gameModel: GameModel?) -> AppealLevel {

        return AppealLevel.from(appeal: self.appeal(in: gameModel))
    }

    public func appeal(in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Mountain tiles have a base Appeal of Breathtaking (4),
        // which is unaffected by surrounding features.
        if self.featureValue == .mountains {
            return 4
        }

        // Natural wonder tiles have a base Appeal of Breathtaking (5),
        // which is also unaffected by surrounding features.
        if self.featureValue.isNaturalWonder() {
            return 5
        }

        var appealValue: Int = 0
        var nextRiverOrLake: Bool = gameModel.river(at: self.point)
        var neighborCliffsOfDoverOrUluru: Bool = false
        var neighborPillagedCount: Int = 0
        var neighborBadFeaturesCount: Int = 0
        var neighborBadImprovementsCount: Int = 0
        var neighborBadDistrictsCount: Int = 0
        var neighborGoodTerrainsCount: Int = 0
        var neighborGoodDistrictsCount: Int = 0
        var neighborWondersCount: Int = 0
        var neighborNaturalWondersCount: Int = 0

        for neighbor in self.point.neighbors() {

            guard let neighborTile = gameModel.tile(at: neighbor) else {
                continue
            }

            if neighborTile.has(feature: .lake) {
                nextRiverOrLake = true
            }

            if neighborTile.has(feature: .rainforest) ||
                neighborTile.has(feature: .marsh) ||
                neighborTile.has(feature: .floodplains) {
                neighborBadFeaturesCount += 1
            }

            if neighborTile.has(feature: .cliffsOfDover) || neighborTile.has(feature: .uluru) {
                neighborCliffsOfDoverOrUluru = true
            }

            if neighborTile.feature().isNaturalWonder() &&
                !(neighborTile.has(feature: .cliffsOfDover) || neighborTile.has(feature: .uluru)) {
                neighborNaturalWondersCount += 1
            }

            if neighborTile.isImprovementPillaged() {
                neighborPillagedCount += 1
            }

            if neighborTile.has(improvement: .barbarianCamp) ||
                neighborTile.has(improvement: .mine) ||
                neighborTile.has(improvement: .quarry) ||
                neighborTile.has(improvement: .oilWell) {

                neighborBadImprovementsCount += 1
            }

            if neighborTile.has(district: .industrialZone) ||
                neighborTile.has(district: .encampment) ||
                // neighborTile.has(district: .aerodrome) ||
                neighborTile.has(district: .spaceport) {

                neighborBadDistrictsCount += 1
            }

            if gameModel.isCoastal(at: neighbor) ||
                neighborTile.has(feature: .mountains) ||
                neighborTile.has(feature: .forest) ||
                neighborTile.has(feature: .oasis) {

                neighborGoodTerrainsCount += 1
            }

            if neighborTile.hasAnyFeature() && !neighborTile.hasAnyImprovement() {
                // check for governor effects of reyna
                if let city = neighborTile.workingCity() {
                    if let governor = city.governor(), governor.type == .reyna {
                        // forestryManagement - Tiles adjacent to unimproved features receive +1 Appeal in this city.
                        if governor.has(title: .forestryManagement) {
                            neighborGoodTerrainsCount += 1
                        }
                    }
                }
            }

            if neighborTile.wonder() != .none {

                neighborWondersCount += 1
            }

            if neighborTile.has(district: .holySite) ||
                neighborTile.has(district: .theatherSquare) ||
                neighborTile.has(district: .entertainmentComplex) ||
                neighborTile.has(district: .waterPark) ||
                // # dam
                // # canal
                neighborTile.has(district: .preserve) {

                neighborGoodDistrictsCount += 1
            }
        }

        // +2 for each adjacent Sphinx (in Gathering Storm), Ice Hockey Rink, City Park, or natural wonder (except the ones that provide a larger bonus).
        // #
        appealValue += neighborNaturalWondersCount * 2

        // +1 for each adjacent Holy Site, Theater Square, Entertainment Complex, Water Park, Dam, Canal, Preserve, or wonder.
        appealValue += neighborGoodDistrictsCount
        appealValue += neighborWondersCount

        // +1 for each adjacent Sphinx (in vanilla Civilization VI and Rise and Fall), Château, Pairidaeza, Golf Course, Nazca Line, or Rock-Hewn Church.
        // #

        // +1 for each adjacent Mountain, Coast, Woods, or Oasis.
        appealValue += neighborGoodTerrainsCount

        // -1 for each adjacent barbarian outpost, Mine, Quarry, Oil Well, Offshore Oil Rig, Airstrip, Industrial Zone, Encampment, Aerodrome, or Spaceport.
        appealValue -= neighborBadImprovementsCount
        appealValue -= neighborBadDistrictsCount

        // -1 for each adjacent Rainforest, Marsh, or Floodplain.
        appealValue -= neighborBadFeaturesCount

        // -1 for each adjacent pillaged tile.
        appealValue -= neighborPillagedCount

        // +1 if the tile is next to a River or Lake.
        if nextRiverOrLake {
            appealValue += 1
        }

        // +4 if adjacent to the Cliffs of Dover (in Gathering Storm) or Uluru.
        if neighborCliffsOfDoverOrUluru {
            appealValue += 4
        }

        return appealValue
    }

    public func startBuilding(district: DistrictType) {

        self.buildingDistrictValue = district
    }

    public func isBuilding(district: DistrictType) -> Bool {

        return self.buildingDistrictValue == district
    }

    public func cancelBuildingDistrict() {

        self.buildingDistrictValue = .none
    }

    public func buildingDistrict() -> DistrictType {

        return self.buildingDistrictValue
    }

    public func build(district: DistrictType) {

        if self.hasAnyFeature() {
            self.set(feature: .none)
        }

        if self.hasAnyImprovement() {
            self.removeImprovement()
        }

        self.buildingDistrictValue = .none
        self.districtValue = district
    }

    public func has(district: DistrictType) -> Bool {

        return self.districtValue == district
    }

    public func district() -> DistrictType {

        return self.districtValue
    }

    public func buildingsInDistrict() -> [BuildingType] {

        guard let city = self.workingCity() else {
            return []
        }

        guard self.districtValue != .none else {
            return []
        }

        var result: [BuildingType] = []

        for buildingType in BuildingType.all
            where buildingType.district() == self.districtValue && city.has(building: buildingType) {

            result.append(buildingType)
        }

        return result
    }

    // wonder
    public func startBuilding(wonder: WonderType) {

        self.buildingWonderValue = wonder
    }

    public func isBuilding(wonder: WonderType) -> Bool {

        return self.buildingWonderValue == wonder
    }

    public func cancelBuildingWonder() {

        self.buildingWonderValue = .none
    }

    public func buildingWonder() -> WonderType {

        return self.buildingWonderValue
    }

    public func build(wonder: WonderType) {

        self.buildingWonderValue = .none
        self.wonderValue = wonder
    }

    public func has(wonder: WonderType) -> Bool {

        return self.wonderValue == wonder
    }

    public func wonder() -> WonderType {

        return self.wonderValue
    }

    public func archaeologicalRecord() -> ArchaeologicalRecord {

        return self.archaeologicalRecordValue
    }

    public func addArchaeologicalRecord(with artifact: ArtifactType, era: EraType, leader1: LeaderType, leader2: LeaderType) {

        self.archaeologicalRecordValue.artifactType = artifact
        self.archaeologicalRecordValue.era = era
        self.archaeologicalRecordValue.leader1 = leader1
        self.archaeologicalRecordValue.leader2 = leader2
    }
}

extension Tile: Equatable {

    public static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.point == rhs.point
    }
}
