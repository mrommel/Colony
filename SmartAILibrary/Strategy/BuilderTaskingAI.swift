//
//  BuilderTaskingAI.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 10.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum BuilderDirectiveType: Int, Codable {

    case none

    case buildImprovementOnResource // BUILD_IMPROVEMENT_ON_RESOURCE, // enabling a special resource
    case buildImprovement // BUILD_IMPROVEMENT,               // improving a tile
    case buildRoute // BUILD_ROUTE,                   // build a route on a tile
    case repair // REPAIR,                           // repairing a pillaged route or improvement
    case chop // CHOP,                           // remove a feature to improve production
    case removeRoad // REMOVE_ROAD,                   // remove a road from a plot
}

class BuilderDirective: Codable {

    enum CodingKeys: CodingKey {
        case type
        case build
        case resource
        case target
        case moveTurnsAway
    }

    var type: BuilderDirectiveType
    var build: BuildType
    let resource: ResourceType
    var target: HexPoint
    var moveTurnsAway: Int

    init(type: BuilderDirectiveType, build: BuildType, resource: ResourceType, target: HexPoint, moveTurnsAway: Int) {

        self.type = type
        self.build = build
        self.resource = resource
        self.target = target
        self.moveTurnsAway = moveTurnsAway
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(BuilderDirectiveType.self, forKey: .type)
        self.build = try container.decode(BuildType.self, forKey: .build)
        self.resource = try container.decode(ResourceType.self, forKey: .resource)
        self.target = try container.decode(HexPoint.self, forKey: .target)
        self.moveTurnsAway = try container.decode(Int.self, forKey: .moveTurnsAway)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.build, forKey: .build)
        try container.encode(self.resource, forKey: .resource)
        try container.encode(self.target, forKey: .target)
        try container.encode(self.moveTurnsAway, forKey: .moveTurnsAway)
    }
}

extension BuilderDirective: Hashable {

    static func == (lhs: BuilderDirective, rhs: BuilderDirective) -> Bool {
        return lhs.type == rhs.type && lhs.build == rhs.build && lhs.target == rhs.target
    }

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.type)
        hasher.combine(self.build)
        hasher.combine(self.target)
    }
}

class BuilderDirectiveWeightedList: WeightedList<BuilderDirective> {

}

public class BuilderTaskingAI {

    var player: Player?

    var numCities: Int
    var nonTerritoryPlots: [AbstractTile?]

    // MARK: constructors

    init(player: Player?) {

        self.player = player

        self.numCities = 0
        self.nonTerritoryPlots = []
    }

    func update(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        self.updateRoutePlots(in: gameModel)

        let cities = gameModel.cities(of: player)
        self.numCities = cities.count

        for cityRef in cities {

            if let city = cityRef {
                city.cityStrategy?.updateBestYields(in: gameModel)
            }
        }
    }

    /// Looks at city connections and marks plots that can be added as routes by EvaluateBuilder
    private func updateRoutePlots(in gameModel: GameModel?) {

        self.nonTerritoryPlots.removeAll()

        return
    }

    /// Use the flavor settings to determine what the worker should do
    func evaluateBuilder(unit: AbstractUnit?, onlyKeepBest: Bool = false, onlyEvaluateWorkersPlot: Bool = false, in gameModel: GameModel?) -> BuilderDirective? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        // number of cities has changed mid-turn, so we need to re-evaluate what workers should do
        if gameModel.cities(of: player).count != self.numCities {
            self.update(in: gameModel)
        }

        var tiles: [AbstractTile?] = []

        if onlyEvaluateWorkersPlot {

            // can't build on plots others own
            if let tile = gameModel.tile(at: unit.location) {
                if player.isEqual(to: tile.owner()) {
                    tiles.append(tile)
                }
            }
        } else {

            for point in player.area {
                if let tile = gameModel.tile(at: point) {
                    if player.isEqual(to: tile.owner()) {
                        tiles.append(tile)
                    }
                }
            }
        }

        let directives = BuilderDirectiveWeightedList()

        // go through all the plots the player has under their control
        for tile in tiles {

            if !self.shouldBuilderConsiderPlot(tile: tile, for: unit, in: gameModel) {
                continue
            }

            // distance weight
            // find how many turns the plot is away
            let moveTurnsAway = self.findTurnsAway(unit: unit, on: tile, in: gameModel)
            if moveTurnsAway < 0 {
                continue
            }

            directives.append(contentsOf: self.addRouteDirectives(unit: unit, on: tile, dist: moveTurnsAway, in: gameModel))
            directives.append(contentsOf: self.addImprovingResourcesDirectives(unit: unit, on: tile, dist: moveTurnsAway, in: gameModel))
            directives.append(contentsOf: self.addImprovingPlotsDirectives(unit: unit, on: tile, dist: moveTurnsAway, in: gameModel))
            directives.append(contentsOf: self.addChopDirectives(unit: unit, on: tile, dist: moveTurnsAway, in: gameModel))
            // FIXME m_aDirectives.append(contentsOf: self.addScrubFalloutDirectives(unit, plot, moveTurnsAway))
        }

        // we need to evaluate the tiles outside of our territory to build roads
        for nonTerritoryPlot in self.nonTerritoryPlots {

            guard let pPlot = nonTerritoryPlot else {
                continue
            }

            if onlyEvaluateWorkersPlot {
                if pPlot.point != unit.location {
                    continue
                }
            }

            if !self.shouldBuilderConsiderPlot(tile: pPlot, for: unit, in: gameModel) {
                continue
            }

            // distance weight
            // find how many turns the plot is away
            let moveTurnsAway = self.findTurnsAway(unit: unit, on: pPlot, in: gameModel)
            if moveTurnsAway < 0 {
                continue
            }

            directives.append(contentsOf: self.addRouteDirectives(unit: unit, on: pPlot, dist: moveTurnsAway, in: gameModel))
        }

        if let bestDirective = directives.chooseLargest() {
            return bestDirective
        }

        return nil
    }

    /// Evaluating a plot to determine what improvement could be best there
    func addImprovingPlotsDirectives(unit: AbstractUnit?, on tile: AbstractTile?, dist: Int, in gameModel: GameModel?) -> BuilderDirectiveWeightedList {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let player = unit.player else {
            fatalError("cant get player")
        }

        guard let tile = tile else {
            fatalError("cant get pPlot")
        }

        let existingImprovement = tile.improvement()

        // if we have a great improvement in a plot that's not pillaged, DON'T DO NOTHIN'
        /*if let existingImprovement = existingImprovement && existingImprovement != .none && GC.getImprovementInfo(eExistingImprovement)->IsCreatedByGreatPerson() && !pPlot->IsImprovementPillaged())
        {
            return;
        }*/

        // if it's not within a city radius
        if !gameModel.isWithinCityRadius(plot: tile, of: player) {
            return BuilderDirectiveWeightedList()
        }

        // check to see if a non-bonus resource is here. if so, bail out!
        let resource = tile.resource(for: player)
        if resource != .none {
            if resource.usage() != .bonus {
                return BuilderDirectiveWeightedList()
            }
        }

        guard tile.workingCity() != nil else {
            return BuilderDirectiveWeightedList()
        }

        let directiveList: BuilderDirectiveWeightedList = BuilderDirectiveWeightedList()
        var tmpBuildType: BuildType = .none

        for buildType in BuildType.all {

            tmpBuildType = buildType

            guard let improvement = tmpBuildType.improvement() else {
                continue
            }

            // if this improvement has a defense modifier, ignore it for now
            if improvement.defenseModifier() > 0 {
                continue
            }

            if improvement == tile.improvement() {
                if tile.isImprovementPillaged() {
                    tmpBuildType = .repair
                } else {
                    continue
                }
            } else {
                // if the plot has an unpillaged great person's creation on it, DO NOT DESTROY
                if existingImprovement != ImprovementType.none {
                    /*if improvement.->IsCreatedByGreatPerson() || GET_PLAYER(pUnit->getOwner()).isOption(PLAYEROPTION_SAFE_AUTOMATION))
                    {
                        continue;
                    }*/
                }
            }

            // Only check to make sure our unit can build this after possibly switching this to a repair build in the block of code above
            if !unit.canBuild(build: tmpBuildType, at: tile.point, testVisible: true, testGold: true, in: gameModel) {
                continue
            }

            // UpdateProjectedPlotYields(pPlot, eBuild);
            let score = self.scorePlot(for: tile, on: tmpBuildType)

            // if we're going backward, bail out!
            if score <= 0 {
                continue
            }

            var directiveType = BuilderDirectiveType.buildImprovement
            var weight = 1 /* BUILDER_TASKING_BASELINE_BUILD_IMPROVEMENTS */
            if tmpBuildType == .repair {
                directiveType = .repair
                weight = 200 /* BUILDER_TASKING_BASELINE_REPAIR */
            } else if improvement.yields(for: player, on: resource).culture > 0 {
                weight = Int(100 /* BUILDER_TASKING_BASELINE_ADDS_CULTURE */ * improvement.yields(for: player, on: resource).culture)
                /*let adjacentCulture = pImprovement->GetCultureAdjacentSameType();

                if (iAdjacentCulture > 0)
                {
                    iScore *= pPlot->ComputeCultureFromImprovement(*pImprovement, eImprovement);
                }*/
            }

            let buildTimeWeight = max(1, tmpBuildType.buildTime(on: tile) + dist)
            weight += (unit.location == tile.point) ? 10 : 0 // bonus for current plot
            weight += 100 / buildTimeWeight
            weight *= score
            // weight = CorrectWeight(iWeight);

            let directive = BuilderDirective(type: directiveType, build: tmpBuildType, resource: .none, target: tile.point, moveTurnsAway: dist)
            directiveList.add(weight: Double(weight), for: directive)
        }

        return directiveList
    }

    /// Determines if the builder should "chop" the feature in the tile
    func addChopDirectives(unit: AbstractUnit?, on pPlot: AbstractTile?, dist: Int, in gameModel: GameModel?) -> BuilderDirectiveWeightedList {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let player = unit.player else {
            fatalError("cant get player")
        }

        guard let pPlot = pPlot else {
            fatalError("cant get pPlot")
        }

        // if it's not within a city radius
        if !gameModel.isWithinCityRadius(plot: pPlot, of: player) {
            return BuilderDirectiveWeightedList()
        }

        let improvement = pPlot.improvement()

        if improvement == .none {
            return BuilderDirectiveWeightedList()
        }

        // check to see if a resource is here. If so, bail out!
        let resource = pPlot.resource(for: player)
        if resource != .none {
            return BuilderDirectiveWeightedList()
        }

        guard let city = pPlot.workingCity() else {
            return BuilderDirectiveWeightedList()
        }

        if let cityCitizens = city.cityCitizens, cityCitizens.isWorked(at: pPlot.point) {
            return BuilderDirectiveWeightedList()
        }

        let feature = pPlot.feature()
        if feature == .none {
            // no feature in this tile, so bail
            return BuilderDirectiveWeightedList()
        }

        var chopBuild: BuildType = .none
        for buildType in BuildType.all {

            if buildType.improvement() == nil &&
                buildType.canRemove(feature: feature) &&
                buildType.productionFromRemoval(of: feature) > 0 &&
                unit.canBuild(build: buildType, at: pPlot.point, testVisible: true, testGold: true, in: gameModel) {

                chopBuild = buildType
                break
            }
        }

        if chopBuild == .none {
            // we couldn't find a build that removed the feature without a production benefit
            return BuilderDirectiveWeightedList()
        }

        let production = pPlot.productionFromFeatureRemoval(by: chopBuild)

        if !self.doesBuildHelpRush(unit: unit, pPlot: pPlot, build: chopBuild) {
            return BuilderDirectiveWeightedList()
        }

        var weight = 200 /* BUILDER_TASKING_BASELINE_REPAIR */
        let turnsAway = self.findTurnsAway(unit: unit, on: pPlot, in: gameModel)
        weight = weight / (turnsAway + 1)
        // iWeight = GetBuildCostWeight(iWeight, pPlot, eChopBuild);
        let buildTimeWeight = 100 / chopBuild.buildTime(on: pPlot) // GetBuildTimeWeight(pUnit, pPlot, eChopBuild, false, iMoveTurnsAway);
        weight += buildTimeWeight
        weight *= production // times the amount that the plot produces from the chopping

        var yieldDifferenceWeight = 0.0
        let directiveList: BuilderDirectiveWeightedList = BuilderDirectiveWeightedList()

        for yieldType in YieldType.all {

            // calculate natural yields
            let previousYield = pPlot.yieldsWith(buildType: chopBuild, for: player, ignoreFeature: false)
            let newYield = pPlot.yieldsWith(buildType: chopBuild, for: player, ignoreFeature: true)
            let deltaYield = newYield - previousYield

            if deltaYield.value(of: yieldType) == 0 {
                continue
            }

            switch yieldType {
            case .food:
                yieldDifferenceWeight += deltaYield.value(of: yieldType) * Double(player.valueOfPersonalityFlavor(of: .growth)) * 2.0 /*BUILDER_TASKING_PLOT_EVAL_MULTIPLIER_FOOD**/

            case .production:
                yieldDifferenceWeight += deltaYield.value(of: yieldType) * Double(player.valueOfPersonalityFlavor(of: .production)) * 2.0 /* BUILDER_TASKING_PLOT_EVAL_MULTIPLIER_PRODUCTION*/

            case .gold:
                yieldDifferenceWeight += deltaYield.value(of: yieldType) * Double(player.valueOfPersonalityFlavor(of: .gold)) * 1.0 /* BUILDER_TASKING_PLOT_EVAL_MULTIPLIER_GOLD */

            case .science:
                yieldDifferenceWeight += deltaYield.value(of: yieldType) * Double(player.valueOfPersonalityFlavor(of: .science)) * 1.0 /* BUILDER_TASKING_PLOT_EVAL_MULTIPLIER_SCIENCE */

            case .culture:
                yieldDifferenceWeight += deltaYield.value(of: yieldType) * Double(player.valueOfPersonalityFlavor(of: .culture)) * 1.0 /* BUILDER_TASKING_PLOT_EVAL_MULTIPLIER_CULTURE */

            case .faith:
                yieldDifferenceWeight += deltaYield.value(of: yieldType) * Double(player.valueOfPersonalityFlavor(of: .religion)) * 1.0 /* BUILDER_TASKING_PLOT_EVAL_MULTIPLIER_CULTURE */

            case .tourism:
                // NOOP
                break

            case .none:
                // NOOP
                break
            }
        }

        // if we are going backwards, bail
        if yieldDifferenceWeight < 0.0 {
            return BuilderDirectiveWeightedList()
        }

        weight += Int(yieldDifferenceWeight)
        // weight = CorrectWeight(iWeight);

        if weight > 0 {

            let directive = BuilderDirective(type: .chop, build: chopBuild, resource: .none, target: pPlot.point, moveTurnsAway: dist)
            directiveList.add(weight: Double(weight), for: directive)
        }

        return directiveList
    }

    /// Evaluating a plot to see if we can build resources there
    func addImprovingResourcesDirectives(unit: AbstractUnit?, on pPlot: AbstractTile?, dist: Int, in gameModel: GameModel?) -> BuilderDirectiveWeightedList {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let pPlot = pPlot else {
            fatalError("cant get pPlot")
        }

        // if we have a great improvement in a plot that's not pillaged, DON'T DO NOTHIN'
        /*if let existingPlotImprovement = pPlot.improvement() {
            if existingPlotImprovement != .none &&/* GC.getImprovementInfo(existingPlotImprovement)->IsCreatedByGreatPerson() &&*/ !pPlot.isImprovementPillaged() {
                
                return BuilderDirectiveWeightedList()
            }
        }*/

        // check to see if a resource is here. If not, bail out!
        if !pPlot.hasAnyResource(for: player) {
            return BuilderDirectiveWeightedList()
        }

        var resource: ResourceType = .none
        for resourceType in ResourceType.all {
            if pPlot.has(resource: resourceType, for: player) {
                resource = resourceType
            }
        }

        // evaluate bonus resources as normal improvements
        if resource == .none || resource.usage() == .bonus {
            return BuilderDirectiveWeightedList()
        }

        // loop through the build types to find one that we can use
        // var originalBuild: BuildType = .none
        var doBuild: BuildType = .none

        let directiveList = BuilderDirectiveWeightedList()

        for buildType in BuildType.all {

            // originalBuild = buildType
            doBuild = buildType

            guard let improvement = buildType.improvement() else {
                continue
            }

            let existingPlotImprovement = pPlot.improvement()

            if improvement == existingPlotImprovement {
                if pPlot.isImprovementPillaged() {
                    doBuild = .repair
                } else {
                    // this plot already has the appropriate improvement to use the resource
                    break
                }
            } else {
                // if the plot has an unpillaged great person's creation on it, DO NOT DESTROY
                if existingPlotImprovement != ImprovementType.none {

                    // CvImprovementEntry* pkExistingPlotImprovementInfo = GC.getImprovementInfo(eExistingPlotImprovement);
                    /*if(pkExistingPlotImprovementInfo && pkExistingPlotImprovementInfo->IsCreatedByGreatPerson())
                    {
                        continue
                    }*/
                }
            }

            if !unit.canBuild(build: doBuild, at: pPlot.point, testVisible: true, testGold: false, in: gameModel) {
                break
            }

            var directiveType = BuilderDirectiveType.buildImprovementOnResource
            var weight = 10 /* BUILDER_TASKING_BASELINE_BUILD_RESOURCE_IMPROVEMENTS */
            if doBuild == .repair {
                directiveType = .repair
                weight = 200 /* BUILDER_TASKING_BASELINE_REPAIR */
            }

            // this is to deal with when the plot is already improved with another improvement that doesn't enable the resource
            var investedImprovementTime = 0
            if existingPlotImprovement != ImprovementType.none {

                var existingBuild: BuildType = .none

                for buildType in BuildType.all {

                    if buildType.improvement() == existingPlotImprovement {
                        existingBuild = buildType
                        break
                    }
                }

                if existingPlotImprovement != ImprovementType.none {
                    investedImprovementTime = existingBuild.buildTime(on: pPlot)
                }
            }

            let buildtime = min(1, doBuild.buildTime(on: pPlot) + investedImprovementTime + dist)
            let buildTimeWeight = 100 / buildtime
            weight += buildTimeWeight
            // weight = CorrectWeight(iWeight);

            weight += self.resourceWeight(for: resource, improvement: improvement, quantity: pPlot.resourceQuantity())
            // weight = CorrectWeight(iWeight);

            // UpdateProjectedPlotYields(pPlot, eBuild);
            let score = self.scorePlot(for: pPlot, on: buildType)
            if score > 0 {
                weight *= score
                // weight = CorrectWeight(iWeight);
            }

            // CvCity* pLogCity = NULL;
            let production = pPlot.productionFromFeatureRemoval(by: buildType)
            if self.doesBuildHelpRush(unit: unit, pPlot: pPlot, build: buildType) {
                weight += production // a nominal benefit for choosing this production
            }

            if weight <= 0 {
                continue
            }

            let directive = BuilderDirective(type: directiveType, build: buildType, resource: resource, target: pPlot.point, moveTurnsAway: dist)
            directiveList.add(weight: Double(weight), for: directive)
        }

        return directiveList
    }

    /// Does this city want to rush a unit?
    func doesBuildHelpRush(unit: AbstractUnit?, pPlot: AbstractTile?, build: BuildType) -> Bool {

        /* FIXME
        CvCity* pCity = NULL;
        int iProduction = pPlot->getFeatureProduction(eBuild, pUnit->getOwner(), &pCity);
        if (iProduction <= 0)
        {
            return false;
        }

        if !pCity {
            // this chop does not benefit any city
            return false
        }

        if (pCity->getOrderQueueLength() <= 0) {
            // nothing in the build queue
            return false
        }

        if !(pCity->getOrderFromQueue(0)->bRush) {
            // this order should not be rushed
            return false
        }

        return true*/
        return false
    }

    func scorePlot(for targetPlot: AbstractTile?, on buildType: BuildType) -> Int {

        guard let pTargetPlot = targetPlot else {
            return -1
        }

        guard let city = pTargetPlot.workingCity() else {
            return -1
        }

        guard let cityStrategy = city.cityStrategy else {
            return -1
        }

        // preparation
        let currentYields = pTargetPlot.yields(for: player, ignoreFeature: false)
        let projectedYields = pTargetPlot.yieldsWith(buildType: buildType, for: player, ignoreFeature: false)

        var score = 0.0
        var anyNegativeMultiplier = false
        let focusYield = cityStrategy.focusYield

        for yieldType in YieldType.all {

            let multiplier = cityStrategy.yieldDelta(for: yieldType)
            let absMultiplier = abs(multiplier)
            let yieldDelta = projectedYields.value(of: yieldType) - currentYields.value(of: yieldType)

            // the multiplier being lower than zero means that we need more of this resource
            if multiplier < 0 {

                anyNegativeMultiplier = true
                // this would be an improvement to the yield
                if yieldDelta > 0 {
                    score += projectedYields.value(of: yieldType) * absMultiplier
                } else if yieldDelta < 0 {
                    // the yield would go down
                    score += yieldDelta * absMultiplier
                }
            } else {
                if yieldDelta >= 0 {
                    score += projectedYields.value(of: yieldType) // provide a nominal score to plots that improve anything
                } else if yieldDelta < 0 {
                    score += yieldDelta * absMultiplier
                }
            }
        }

        if !anyNegativeMultiplier && focusYield != .none {

            let yieldDelta = projectedYields.value(of: focusYield) - currentYields.value(of: focusYield)
            if yieldDelta > 0 {
                score += projectedYields.value(of: focusYield) * 100
            }
        }

        return Int(score)
    }

    /// Adds a directive if the unit can construct a road in the plot
    func addRouteDirectives(unit: AbstractUnit?, on pPlot: AbstractTile?, dist: Int, in gameModel: GameModel?) -> BuilderDirectiveWeightedList {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let unitPlayer = unit.player else {
            fatalError("cant get unitPlayer")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let pPlot = pPlot else {
            fatalError("cant get plot")
        }

        let bestRouteType: RouteType = player.bestRoute()

        // if the player can't build a route, bail out!
        if bestRouteType == .none {
            return BuilderDirectiveWeightedList()
        }

        if pPlot.has(route: bestRouteType) && !pPlot.isRoutePillaged() {
            return BuilderDirectiveWeightedList()
        }

        // the plot was not flagged this turn, so ignore
        if pPlot.builderAIScratchPad().turn != gameModel.currentTurn || pPlot.builderAIScratchPad().leader != unitPlayer.leader {
            return BuilderDirectiveWeightedList()
        }

        // find the route build
        var routeBuild: BuildType = .none
        if pPlot.isRoutePillaged() {
            routeBuild = .repair
        } else {
            let routeType: RouteType = pPlot.builderAIScratchPad().routeType

            for buildType in BuildType.all {
                if buildType.route() == routeType {
                    routeBuild = buildType
                    break
                }
            }
        }

        if routeBuild == .none {
            return BuilderDirectiveWeightedList()
        }

        if !unit.canBuild(build: routeBuild, at: pPlot.point, testVisible: false, testGold: true, in: gameModel) {
            return BuilderDirectiveWeightedList()
        }

        var weight = 100 /* BUILDER_TASKING_BASELINE_BUILD_ROUTES */
        var builderDirectiveType: BuilderDirectiveType = .buildRoute
        if routeBuild == .repair {
            weight = 200 /* BUILDER_TASKING_BASELINE_REPAIR */
            builderDirectiveType = .repair
        }

        let turnsAway = self.findTurnsAway(unit: unit, on: pPlot, in: gameModel)
        let buildtime = min(1, routeBuild.buildTime(on: pPlot))

        weight = weight / (turnsAway + 1)
        weight *= weight
        weight += 100 / buildtime // GetBuildTimeWeight(pUnit, pPlot, eRouteBuild, false, iMoveTurnsAway);
        weight *= pPlot.builderAIScratchPad().value
        // FIXME weight = CorrectWeight(iWeight);

        let items = BuilderDirectiveWeightedList()
        let directive = BuilderDirective(type: builderDirectiveType, build: routeBuild, resource: .none, target: pPlot.point, moveTurnsAway: turnsAway)

        items.add(weight: Double(weight), for: directive)
        return items
    }

    /// Return the weight of this resource
    func resourceWeight(for resource: ResourceType, improvement: ImprovementType, quantity: Int ) -> Int {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var weight = 0

        for flavorType in FlavorType.all {

            let resourceFlavor = resource.flavor(for: flavorType)
            let personalityFlavor = player.valueOfPersonalityFlavor(of: flavorType)
            let result = resourceFlavor * personalityFlavor

            if result > 0 {
                weight += result
            }

            var improvementFlavor = 1
            if improvement != .none {
                improvementFlavor = improvement.flavor(for: flavorType)
            }

            let usableByCityWeight = personalityFlavor * improvementFlavor
            if usableByCityWeight > 0 {
                weight += usableByCityWeight
            }
        }

        // if the empire is unhappy (or close to it) and this is a luxury resource the player doesn't have, provide a super bonus to getting it
        if resource.usage() == .luxury {

            var modifier = 500 /* GC.getBUILDER_TASKING_PLOT_EVAL_MULTIPLIER_LUXURY_RESOURCE()*/ * resource.amenities()

            if player.numAvailable(resource: resource) == 0 {
                // full bonus
            } else {
                modifier /= 2 // half the awesome bonus, so that we pick up extra resources
            }

            weight *= modifier

        } else if resource.usage() == .strategic && resource.techCityTrade() != nil {

            let hasTech = player.has(tech: resource.techCityTrade()!)
            if hasTech {
                // measure quantity
                var multiplyingAmount = quantity * 2

                // if we don't have any currently available
                if player.numAvailable(resource: resource) == 0 {

                    // if we have some of the strategic resource, but all is used
                    if player.numAvailable(resource: resource) > 0 {
                        multiplyingAmount *= 4
                    } else {
                        // if we don't have any of it
                        multiplyingAmount *= 4
                    }
                }

                weight *= multiplyingAmount
            }
        }

        return weight
    }

    /// Determines if the builder can get to the plot. Returns -1 if no path can be found, otherwise it returns the # of turns to get there
    func findTurnsAway(unit: AbstractUnit?, on tile: AbstractTile?, in gameModel: GameModel?) -> Int {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let targetTile = gameModel.tile(at: unit.location) else {
            fatalError("cant get target tile")
        }

        if unit.location == tile.point {
            return 0
        }

        // If this plot is far away, we'll just use its distance as an estimate of the time to get there (to avoid hitting the path finder)
        // We'll be sure to check later to make sure we have a real path before we execute this
        if unit.domain() == .land && !tile.sameContinent(as: targetTile) && !unit.canEverEmbark() {
            return -1
        }

        let plotDistance = unit.location.distance(to: tile.point)
        if plotDistance >= 8 { // AI_HOMELAND_ESTIMATE_TURNS_DISTANCE
            return plotDistance
        } else {

            let pathFinderDataSource = gameModel.ignoreUnitsPathfinderDataSource(
                for: unit.movementType(),
                for: unit.player,
                unitMapType: .combat,
                canEmbark: unit.player!.canEmbark(),
                canEnterOcean: unit.player!.canEnterOcean()
            )
            let pathFinder = AStarPathfinder(with: pathFinderDataSource)

            // let path = astar.shortestPath(fromTileCoord: unit.location, toTileCoord: tile.point)
            let result = pathFinder.turnsToReachTarget(for: unit, to: tile.point, in: gameModel)
            if result == Int.max {
                return -1
            }

            return result // path?.count ?? -1
        }
    }

    /// Evaluates all the circumstances to determine if the builder can and should evaluate the given plot
    func shouldBuilderConsiderPlot(tile: AbstractTile?, for unit: AbstractUnit?, in gameModel: GameModel?) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let tile = tile else {
            fatalError("cant get tile")
        }

        guard let player = self.player else {
            fatalError("cant get player")
        }

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let dangerPlotsAI = player.dangerPlotsAI else {
            fatalError("cant get dangerPlotsAI")
        }

        // if plot is impassable, bail!
        if tile.isImpassable(for: .walk) {
            return false
        }

        // can't build on plots others own (unless inside a minor)
        if !player.isEqual(to: tile.owner()) {
            return false
        }

        // workers should not be able to work in plots that do not match their default domain
        switch unit.domain() {

        case .land:
            if tile.terrain().isWater() {
                return false
            }

        case .sea:
            if !tile.terrain().isWater() {
                return false
            }

        default:
            // NOOP
            break
        }

        // need more planning for amphibious units
        // we should include here the ability for work boats to cross to other areas with cities
        guard let targetTile = gameModel.tile(at: unit.location) else {
            return false
        }

        if !tile.sameContinent(as: targetTile) {

            var canCrossToNewArea = false

            if unit.domain() == .sea {
                /*if (pPlot->isAdjacentToArea(pUnit->area()))
                {
                    canCrossToNewArea = true
                }*/
            } else {
                if unit.canEverEmbark() {
                    canCrossToNewArea = true
                }
            }

            if !canCrossToNewArea {
                return false
            }
        }

        // check to see if someone already has a mission here
        /*if (pUnit->GetMissionAIPlot() != pPlot)
        {
            if (m_pPlayer->AI_plotTargetMissionAIs(pPlot, MISSIONAI_BUILD) > 0)
            {
                return false;
            }
        }*/

        if dangerPlotsAI.danger(at: tile.point) > 0 {
            return false
        }

        // other unit at target
        if unit.location != tile.point && gameModel.unit(at: tile.point, of: .civilian) != nil {

            return false
        }

        return true
    }
}
