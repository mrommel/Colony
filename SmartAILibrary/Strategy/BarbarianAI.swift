//
//  BarbarianAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 15.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension Array2D {

    convenience init(size: MapSize) {

        self.init(width: size.width(), height: size.height())
    }
}

class BarbarianAI: Codable {

    enum CodingKeys: CodingKey {

        case barbCampSpawnCounter
        case barbCampNumUnitsSpawned
    }

    var barbCampSpawnCounter: Array2D<Int>
    var barbCampNumUnitsSpawned: Array2D<Int>
    private var atWarWithAllPlayersChecked: Bool = false

    init(with gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Default values
        self.barbCampSpawnCounter = Array2D<Int>(size: gameModel.mapSize())
        self.barbCampSpawnCounter.fill(with: -1)

        self.barbCampNumUnitsSpawned = Array2D<Int>(size: gameModel.mapSize())
        self.barbCampNumUnitsSpawned.fill(with: -1)
    }

    public required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.barbCampSpawnCounter = try container.decode(Array2D<Int>.self, forKey: .barbCampSpawnCounter)
        self.barbCampNumUnitsSpawned = try container.decode(Array2D<Int>.self, forKey: .barbCampNumUnitsSpawned)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.barbCampSpawnCounter, forKey: .barbCampSpawnCounter)
        try container.encode(self.barbCampNumUnitsSpawned, forKey: .barbCampNumUnitsSpawned)
    }

    private func ensureAtWarWithAllPlayers(in gameModel: GameModel?) {

        if self.atWarWithAllPlayersChecked {

            guard let gameModel = gameModel else {
                fatalError("cant get gameModel")
            }

            guard let barbarianPlayer = gameModel.barbarianPlayer() else {
                fatalError("cant get barbarian player")
            }

            for player in gameModel.players {

                if !player.hasMet(with: barbarianPlayer) {
                    barbarianPlayer.doFirstContact(with: player, in: gameModel)
                }

                if !barbarianPlayer.isAtWar(with: player) {
                    barbarianPlayer.doDeclareWar(to: player, in: gameModel)
                }
            }

            self.atWarWithAllPlayersChecked = true
        }
    }

    /// Called every turn
    /// CvBarbarians::BeginTurn()
    func doTurn(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.ensureAtWarWithAllPlayers(in: gameModel)

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                if barbCampSpawnCounter[x, y]! > 0 {

                    // No Camp here any more
                    if let plot = gameModel.tile(x: x, y: y) {

                        if plot.has(improvement: .barbarianCamp) {

                            barbCampSpawnCounter[x, y]! -= 1

                        } else {
                            barbCampSpawnCounter[x, y]! = -1
                            barbCampNumUnitsSpawned[x, y]! = -1
                        }
                    }
                } else if barbCampSpawnCounter[x, y]! < -1 {
                    // Counter is negative, meaning a camp was cleared here recently and isn't allowed to respawn in the area for a while
                    barbCampSpawnCounter[x, y]! += 1
                }
            }
        }
    }

    /// Gameplay informing a camp has been attacked - make it more likely to spawn
    func doCampAttacked(at point: HexPoint) {

        let counter: Int = self.barbCampSpawnCounter[point]!

        // Halve the amount of time to spawn
        let newValue = counter / 2

        self.barbCampSpawnCounter[point] = newValue
    }

    /// Camp cleared, so reset counter
    func doBarbCampCleared(by leader: LeaderType, at point: HexPoint, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        self.barbCampSpawnCounter[point] = -16

        gameModel.tile(at: point)?.addArchaeologicalRecord(with: .barbarianCamp, era: gameModel.worldEra(), leader1: leader, leader2: .none)
    }

    /// CvBarbarians::DoCamps()
    func doCamps(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let barbarianPlayer = gameModel.barbarianPlayer() else {
            fatalError("cant get barbarianPlayer")
        }

        var numCampsInExistence = 0
        var numNotVisiblePlots = 0
        var numValidCampPlots = 0
        let alwaysRevealedBarbCamp = false

        // Figure out how many Nonvisible tiles we have to base # of camps to spawn on
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                if let loopPlot = gameModel.tile(x: x, y: y) {

                    // See how many camps we already have
                    if loopPlot.has(improvement: .barbarianCamp) {
                        numCampsInExistence += 1
                    }

                    if !loopPlot.isWater() {
                        if !loopPlot.isVisibleAny() {
                            numNotVisiblePlots += 1
                        }
                    }
                }
            }
        }

        numValidCampPlots = numNotVisiblePlots

        let fogTilesPerBarbarianCamp = mapSize.fogTilesPerBarbarianCamp()
        let campTargetNum = (fogTilesPerBarbarianCamp != 0) ? numValidCampPlots / fogTilesPerBarbarianCamp : 0
        var numCampsToAdd = campTargetNum - numCampsInExistence

        // int iMaxCampsThisArea;

        // added the barbarian chance for the FoR scenario
        if numCampsToAdd > 0 {

            // First turn of the game add 1/3 of the Target number of Camps
            if gameModel.currentTurn == 0 {
                numCampsToAdd *= 33 /* BARBARIAN_CAMP_FIRST_TURN_PERCENT_OF_TARGET_TO_ADD */
                numCampsToAdd /= 100
            } else {
                // Every other turn of the game there's a 1 in 2 chance of adding a new camp
                if Double.random > 0.5 {
                    numCampsToAdd = 1
                } else {
                    numCampsToAdd = 0
                }
            }

            // Don't want to get stuck in an infinite or almost so loop
            var count = 0
            let numLandPlots = gameModel.numberOfLandPlots()

            // Do a random roll to bias in favor of Coastal land Tiles so that the Barbs will spawn Boats :) - required 1/6 of the time
            var wantsCoastal = Int.random(in: 0..<6 /* BARBARIAN_CAMP_COASTAL_SPAWN_ROLL */) == 0 ? true : false

            let playerCapitalMinDistance = 4 /* BARBARIAN_CAMP_MINIMUM_DISTANCE_CAPITAL */
            let barbCampMinDistance = 7 /* BARBARIAN_CAMP_MINIMUM_DISTANCE_ANOTHER_CAMP */
            let maxDistanceToLook = playerCapitalMinDistance > barbCampMinDistance ? playerCapitalMinDistance : barbCampMinDistance

            // Find Plots to put the Camps
            repeat {
                count += 1

                let plotLocation = gameModel.randomLocation()

                guard let loopPlot = gameModel.tile(at: plotLocation) else {
                    continue
                }

                // Plot must be valid (not Water, nonvisible)
                if !loopPlot.isWater() {

                    if !loopPlot.isImpassable(for: .walk) && !loopPlot.has(feature: .mountains) {

                        if !loopPlot.hasOwner() && !loopPlot.isVisibleAny() {

                            // NO RESOURCES FOR NOW, MAY REPLACE WITH SOMETHING COOLER
                            if loopPlot.hasAnyResource(for: nil) {

                                // No camps on 1-tile islands
                                if let area = loopPlot.area {

                                    if area.points.count > 1 {

                                        if gameModel.isCoastal(at: loopPlot.point) || !wantsCoastal {

                                            // Max Camps for this area
                                            var maxCampsThisArea = campTargetNum * area.points.count / numLandPlots
                                            // Add 1 just in case the above algorithm rounded something off
                                            maxCampsThisArea += 1

                                            // Already enough Camps in this Area?
                                            if area.number(of: .barbarianCamp) <= maxCampsThisArea {

                                                // Don't look at Tiles that already have a Camp
                                                if !loopPlot.hasAnyImprovement() {

                                                    // Don't look at Tiles that can't have an improvement
                                                    if !loopPlot.hasAnyFeature() || !loopPlot.feature().isNoImprovement() {
                                                        var somethingTooClose = false

                                                        // Look at nearby Plots to make sure another camp isn't too close
                                                        for nearbyCampLocation in plotLocation.areaWith(radius: maxDistanceToLook) {

                                                            guard let nearbyCampPlot = gameModel.tile(at: nearbyCampLocation) else {
                                                                continue
                                                            }

                                                            let plotDistance = nearbyCampLocation.distance(to: plotLocation)

                                                            // Can't be too close to a player
                                                            if plotDistance <= playerCapitalMinDistance {

                                                                if nearbyCampPlot.isCity() {
                                                                    if let nearbyCity = gameModel.city(at: nearbyCampPlot.point) {

                                                                        if nearbyCity.isCapital() {
                                                                            somethingTooClose = true
                                                                            break
                                                                        }
                                                                    }
                                                                }
                                                            }

                                                            // Can't be too close to another Camp
                                                            if plotDistance <= barbCampMinDistance {
                                                                if nearbyCampPlot.has(improvement: .barbarianCamp) {
                                                                    somethingTooClose = true
                                                                    break
                                                                }
                                                            }

                                                            if somethingTooClose {
                                                                break
                                                            }
                                                        }

                                                        // Found a camp too close, check another Plot
                                                        if somethingTooClose {
                                                            continue
                                                        }

                                                        // Last check
                                                        if !self.isValidForBarbarianCamp(at: plotLocation, in: gameModel) {
                                                            continue
                                                        }

                                                        loopPlot.set(improvement: .barbarianCamp)
                                                        self.doCampActivationNotice(at: plotLocation, in: gameModel)

                                                        // show notification, when tile is visible to human player
                                                        if loopPlot.isVisible(to: gameModel.humanPlayer()) {

                                                            gameModel.humanPlayer()?.notifications()?.add(
                                                                notification: .barbarianCampDiscovered(location: loopPlot.point)
                                                            )
                                                        }

                                                        if let bestUnitType = self.randomBarbarianUnitType(in: area, for: .defense, in: gameModel) {
                                                            let barbarianUnit = Unit(at: loopPlot.point, type: bestUnitType, owner: barbarianPlayer)
                                                            gameModel.add(unit: barbarianUnit)
                                                            gameModel.userInterface?.show(unit: barbarianUnit, at: loopPlot.point)
                                                        }

                                                        numCampsToAdd -= 1

                                                        // Seed the next Camp for Coast or not
                                                        /* BARBARIAN_CAMP_COASTAL_SPAWN_ROLL */
                                                        wantsCoastal = Int.random(number: 5) == 0 ? true : false
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } while numCampsToAdd > 0 && count < numLandPlots
        }

        if alwaysRevealedBarbCamp {
            // GC.getMap().updateDeferredFog();
        }
    }

    /// What turn are we now allowed to Spawn Barbarians on?
    func canBarbariansSpawn(in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        return gameModel.areBarbariansReleased()
    }

    /// Determines when to Spawn a new Barb Unit from a Camp
    func shouldSpawnBarbarianUnitFromCamp(at point: HexPoint) -> Bool {

        if self.barbCampSpawnCounter[point] == 0 {
            return true
        }

        return false
    }

    func doUnits(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        if !self.canBarbariansSpawn(in: gameModel) {
            return
        }

        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                if let loopPlot = gameModel.tile(x: x, y: y) {

                    // Found a Camp to spawn near
                    if loopPlot.has(improvement: .barbarianCamp) {

                        if self.shouldSpawnBarbarianUnitFromCamp(at: loopPlot.point) {

                            self.doSpawnBarbarianUnit(at: loopPlot.point, ignoreMaxBarbarians: false, finishMoves: false, in: gameModel)
                            self.doCampActivationNotice(at: loopPlot.point, in: gameModel)
                        }
                    }
                }
            }
        }
    }

    /// Spawn a Barbarian Unit somewhere adjacent to pPlot
    func doSpawnBarbarianUnit(at point: HexPoint, ignoreMaxBarbarians: Bool, finishMoves: Bool, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let barbarianPlayer = gameModel.barbarianPlayer() else {
            fatalError("cant get barbarianPlayer")
        }

        guard let plot = gameModel.tile(at: point) else {
            fatalError("cant get plot")
        }

        let range = 2 /* MAX_BARBARIANS_FROM_CAMP_NEARBY_RANGE */

        // is this camp empty - first priority is to fill it
        if gameModel.unit(at: point, of: .combat) == nil {

            if let unitType = self.randomBarbarianUnitType(in: plot.area!, for: .fastAttack, in: gameModel) {

                let unit = Unit(at: point, type: unitType, owner: barbarianPlayer)
                gameModel.add(unit: unit)
                gameModel.userInterface?.show(unit: unit, at: point)

                if finishMoves {
                    unit.finishMoves()
                }
                return
            }
        }

        // Look at nearby Plots to see if there are already too many Barbs nearby
        var numNearbyUnits: Int = 0

        for loopPoint in point.areaWith(radius: range) {

            if let loopUnit = gameModel.unit(at: loopPoint, of: .combat) {

                if loopUnit.isBarbarian() {
                    numNearbyUnits += 1
                }
            }
        }

        if numNearbyUnits <= 2 /* MAX_BARBARIANS_FROM_CAMP_NEARBY */ || ignoreMaxBarbarians {

            // CvPlot* pLoopPlot;

            // Barbs only get boats after some period of time has passed
            let canSpawnBoats = gameModel.currentTurn > 30 /* BARBARIAN_NAVAL_UNIT_START_TURN_SPAWN */
            var validSpawnLocations: [HexPoint] = []

            // Look to see, if adjacent Tiles are valid locations to spawn a Unit
            for loopPoint in point.neighbors() {

                if let loopPlot = gameModel.tile(at: loopPoint) {

                    if gameModel.unit(at: loopPoint, of: .combat) == nil {

                        if !loopPlot.isImpassable(for: .walk) && !loopPlot.has(feature: .mountains) {

                            if !loopPlot.isCity() && !loopPlot.has(feature: .lake) {
                                // Water Tiles are only valid when the Barbs have the proper Tech
                                if !loopPlot.isWater() || canSpawnBoats {
                                    validSpawnLocations.append(loopPoint)
                                }
                            }
                        }
                    }
                }
            }

            // Any valid locations?
            if !validSpawnLocations.isEmpty {

                let spawnLocation = validSpawnLocations.randomItem()
                guard let spawnPlot = gameModel.tile(at: spawnLocation) else {
                    fatalError("cant get spawnPlot")
                }

                var unitTask: UnitTaskType = .fastAttack

                if spawnPlot.isWater() {
                    // Naval Barbs
                    unitTask = .attackSea
                }

                if let spawnArea = spawnPlot.area {
                    if let unitType = self.randomBarbarianUnitType(in: spawnArea, for: unitTask, in: gameModel) {

                        let unit = Unit(at: spawnLocation, type: unitType, owner: barbarianPlayer)
                        gameModel.add(unit: unit)
                        gameModel.userInterface?.show(unit: unit, at: spawnLocation)

                        if finishMoves {
                            unit.finishMoves()
                        }
                    }
                } else {
                    print("no area at: \(spawnPlot.point)")
                }
            }
        }
    }

    func isValidForBarbarianCamp(at point: HexPoint, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        let range = 4

        for loopLocation in point.areaWith(radius: range) {

            if gameModel.valid(point: loopLocation) {
                if self.barbCampSpawnCounter[loopLocation]! < -1 {
                    return false
                }
            }
        }

        return true
    }

    /// Gameplay informing us when a Camp has either been created or spawned a Unit so we can reseed the spawn counter
    func doCampActivationNotice(at point: HexPoint, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        // Default to between 8 and 12 turns per spawn
        var numTurnsToSpawn = 8 + Int.random(number: 5)

        // Raging
        // if (kGame.isOption(GAMEOPTION_RAGING_BARBARIANS))
        //    iNumTurnsToSpawn /= 2;

        // Num Units Spawned
        let numUnitsSpawned = self.barbCampNumUnitsSpawned[point]!

        // Reduce turns between spawn if we've pumped out more guys (meaning we're further into the game)
        numTurnsToSpawn -= min(3, numUnitsSpawned) // -1 turns if we've spawned one Unit, -3 turns if we've spawned three

        // Increment # of barbs spawned from this camp
        self.barbCampNumUnitsSpawned[point]! += 1 // This starts at -1 so when a camp is first created it will bump up to 0, which is correct

        // Difficulty level can add time between spawns (e.g. Settler is +8 turns)
        numTurnsToSpawn += gameModel.handicap.barbarianSpawnMod()

        self.barbCampSpawnCounter[point]! = numTurnsToSpawn
    }

    func randomBarbarianUnitType(in area: HexArea, for task: UnitTaskType, in gameModel: GameModel?) -> UnitType? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let barbarianPlayer = gameModel.barbarianPlayer() else {
            fatalError("cant get barbarianPlayer")
        }

        var bestUnitType: UnitType?
        var bestValue: Int = -1

        for unitTypeLoop in UnitType.all {

            var valid = false

            if let type = unitTypeLoop.unitType(for: .barbarian) {

                valid = type.meleeStrength() > 0 || type.rangedStrength() > 0

                if valid {
                    // Unit has combat strength, make sure it isn't only defensive (and with no ranged combat ability)
                    if type.range() == 0 {
                        /*for(int iLoop = 0; iLoop < GC.getNumPromotionInfos(); iLoop++)
                        {
                            const PromotionTypes ePromotion = static_cast<PromotionTypes>(iLoop);
                            CvPromotionEntry* pkPromotionInfo = GC.getPromotionInfo(ePromotion);
                            if(pkPromotionInfo)
                            {
                                if(kUnit.GetFreePromotions(iLoop))
                                {
                                    if(pkPromotionInfo->IsOnlyDefensive())
                                    {
                                        valid = false
                                        break
                                    }
                                }
                            }
                        }*/
                    }
                }

                /*if valid {
                    if(pArea->isWater() && kUnit.GetDomainType() != DOMAIN_SEA) {
                        valid = false;
                    } else if(!pArea->isWater() && kUnit.GetDomainType() != DOMAIN_LAND) {
                        valid = false;
                    }
                }*/

                if valid {
                    if !barbarianPlayer.canTrain(unitType: type, continueFlag: false, testVisible: false, ignoreCost: true, ignoreUniqueUnitStatus: false) {
                        valid = false
                    }
                }

                if valid {
                    if let requiredTech = type.requiredTech() {
                        if !barbarianPlayer.has(tech: requiredTech) {
                            valid = false
                        }
                    }
                }

                if valid {
                    var value = 1 + Int.random(number: 1000)

                    if type.unitTasks().contains(task) {
                        value += 200
                    }

                    if value > bestValue {
                        bestUnitType = type
                        bestValue = value
                    }
                }
            }
        }

        return bestUnitType
    }
}
