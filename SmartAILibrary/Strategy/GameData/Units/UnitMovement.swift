//
//  UnitMovement.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 13.06.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

// A static class containing movement operations for a unit
// based on https://github.com/LoneGazebo/Community-Patch-DLL/blob/093f58a27b98a1fe9502fbe6762f977dd9deb5f4/CvGameCoreDLL_Expansion2/CvUnitMovement.h
class UnitMovement {

    static func costsForMove(
        unit unitRef: AbstractUnit?,
        fromPlot fromPlotRef: AbstractTile?,
        toPlot toPlotRef: AbstractTile?,
        movesRemaining: Int,
        maxMoves: Int,
        in gameModel: GameModel?
    ) -> Double {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let unit = unitRef, let fromPlot = fromPlotRef, let toPlot = toPlotRef else {
            return Double(Int.max)
        }

        var regularCost: Double = 1.0
        var routeCost: Double = Double(Int.max) // assume no route

        // some easy checks first
        if unit.isHuman() && !toPlot.isDiscovered(by: unit.player) {
            // moving into unknown tiles ends the turn for humans (to prevent information leakage from the displayed path)
            return Double(Int.max)
        } else if unit.domain() == .air {
            return 1.0 // moveDenominator
        }

        guard let player = unit.player else {
            fatalError("cant get unit player")
        }

        let traits = player.leader.traits()
        let fasterAlongRiver: Bool = false // traits.isRiverMovementBonus();
        let fasterInHills: Bool = false // traits.isFasterInHills();
        let woodlandMovement: Bool = false // traits.isWoodlandMovementBonus()
        // ignore terrain cost also ignores feature cost, but units may get bonuses from terrain
        // difference to flat movement cost is that flat movement units don't get any bonuses
        var ignoreTerrainCost: Bool = false // pUnit->ignoreTerrainCost();
        let amphibious: Bool = false // pUnit ? pUnit->isRiverCrossingNoPenalty() : false;
        let hover: Bool = unit.isHoveringUnit()

        // try to avoid calling directionXY too often
        let wrapX: Int = gameModel.wrappedX() ? gameModel.mapSize().width() : -1
        let riverCrossing = fromPlot.isRiver() && toPlot.isRiver() && fromPlot.isRiverToCross(towards: toPlot, wrapX: wrapX)
        let toFeature: FeatureType = toPlot.feature()
        let toTerrain: TerrainType = toPlot.terrain()

        // route preparation
        let routeTo = toPlot.isValidRoute(for: unit)
        let routeFrom = fromPlot.isValidRoute(for: unit)

        // balance patch does not require plot ownership
        var fakeRouteTo: Bool = woodlandMovement &&
            (toFeature == .forest || toFeature == .rainforest) &&
            player.isEqual(to: toPlot.owner())
        var fakeRouteFrom: Bool = woodlandMovement &&
            (fromPlot.feature() == .forest || fromPlot.feature() == .rainforest) &&
            player.isEqual(to: toPlot.owner())

        // ideally there'd be a check of the river direction to make sure it's the same river
        let movingAlongRiver = toPlot.isRiver() && fromPlot.isRiver() && !riverCrossing
        fakeRouteTo = fakeRouteTo || (fasterAlongRiver && movingAlongRiver)
        fakeRouteFrom = fakeRouteFrom || (fasterAlongRiver && movingAlongRiver)

        // check routes
        if !hover &&
            (routeFrom || fakeRouteFrom) &&
            (routeTo || fakeRouteTo) &&
            (!riverCrossing || player.isBridgeBuilding() || amphibious) {

            let fromRoute: RouteType = fakeRouteFrom ? .classicalRoad : fromPlot.route()
            let fromMovementCost: Double = fromRoute.movementCost()
            let fromFlatMovementCost: Double = 1.0 // fromRoute.flatMovementCost()

            let toRoute: RouteType = fakeRouteTo ? .classicalRoad : toPlot.route()
            let toMovementCost: Double = toRoute.movementCost()
            let toFlatMovementCost: Double = 1.0 // toRoute.flatMovementCost()

            // routes only on land
            let baseMoves: Double = Double(unit.baseMoves(into: toPlot.domain(), in: gameModel))

            let routeVariableCost = max(fromMovementCost, toMovementCost)
            let routeFlatCost = max(fromFlatMovementCost * baseMoves, toFlatMovementCost * baseMoves)

            routeCost = min(routeVariableCost, routeFlatCost)

            if toPlot.isCity() {
                // don't consider terrain/feature effects for cities
                return routeCost
            }
        }

        // check embarkation
        var fullCostEmbarkStateChange = false
        var cheapEmbarkStateChange = false
        var freeEmbarkStateChange = false

        if unit.canEverEmbark() {
            let fromEmbark = fromPlot.needsEmbarkation(by: unit)
            let toEmbark = toPlot.needsEmbarkation(by: unit)

            if !toEmbark && fromEmbark {
                // Is the unit from a civ that can disembark for just 1 MP?
                // Does it have a promotion to do so?
                if false /* unit.isDisembarkFlatCost()*/ {
                    cheapEmbarkStateChange = true
                }

                // If city, and player has disembark to city at reduced cost...
                if toPlot.isCity() && gameModel.isCoastal(at: toPlot.point) {
                    freeEmbarkStateChange = true
                }

                fullCostEmbarkStateChange = !(freeEmbarkStateChange || cheapEmbarkStateChange)
            }

            if toEmbark && !fromEmbark {
                // Is the unit from a civ that can embark for just 1 MP?
                // Does it have a promotion to do so?
                if false /* unit.isEmbarkFlatCost() */ {
                    cheapEmbarkStateChange = true
                }

                // If city, and player has embark from city at reduced cost...
                if fromPlot.isCity() && gameModel.isCoastal(at: fromPlot.point) {
                    freeEmbarkStateChange = true
                }

                fullCostEmbarkStateChange = !(freeEmbarkStateChange || cheapEmbarkStateChange)
            }

            if fullCostEmbarkStateChange {
                // normal embark/disembark ends turn
                return Double(Int.max)
            } else if freeEmbarkStateChange /*&& !pUnit->isCargo())*/ {
                // a cover charge still applies :)
                return 0.1
            } else if cheapEmbarkStateChange /*&& !pUnit->isCargo())*/ {
                return 1.0
            }
        }

        // flat cost only after embarkation/disembarkation
        /*if unit.flatMovementCost() {
            return 1.0
        }*/

        // in some cases we ignore terrain / feature cost
        if hover {
            ignoreTerrainCost = true
        }

        if amphibious && riverCrossing {
            ignoreTerrainCost = true
        }

        if !riverCrossing || amphibious {
            if fasterInHills && toPlot.hasHills() {
                ignoreTerrainCost = true
            }

            /*if (pTraits->IsMountainPass() && pToPlot->isMountain())
                ignoreTerrainCost = true
             */
        }

        // check border obstacle - great wall ends the turn
        /*TeamTypes eToTeam = pToPlot->getTeam();
        TeamTypes eFromTeam = pFromPlot->getTeam();
        if (eToTeam != NO_TEAM && eUnitTeam != eToTeam && eToTeam != eFromTeam)
        {
            CvTeam& kToPlotTeam = GET_TEAM(eToTeam);
            CvPlayer& kToPlotPlayer = GET_PLAYER(pToPlot->getOwner());

            if (!kToPlotTeam.IsAllowsOpenBordersToTeam(eUnitTeam))
            {
                //only applies on land
                if (kToPlotTeam.isBorderObstacle() || kToPlotPlayer.isBorderObstacle())
                {
                    if (!pToPlot->isWater() && pUnit->getDomainType() == DOMAIN_LAND)
                    {
                        return INT_MAX;
                    }
                }
                //city might have special defense buildings
                CvCity* pCity = pToPlot->getOwningCity();
                if (pCity)
                {
                    if (!pToPlot->isWater() && pUnit->getDomainType() == DOMAIN_LAND && pCity->GetBorderObstacleLand() > 0)
                    {
                        return INT_MAX;
                    }
                    if (pToPlot->isWater() && pCity->GetBorderObstacleWater() > 0 && (pUnit->getDomainType() == DOMAIN_SEA || pToPlot->needsEmbarkation(pUnit)))
                    {
                        return INT_MAX;
                    }
                }
            }
        }*/

        if toPlot.isRoughGround() && unit.isRoughTerrainEndsTurn() && !(routeFrom && routeTo) {
            // Is a unit's movement consumed for entering rough terrain?
            return Double(Int.max)
        }

        // This is a special Domain unit that can disembark and becomes a land unit. End Turn like normal disembarkation.
        else if (unit.domain() == .sea && unit.isConvertUnit() && !toPlot.isWater() && fromPlot.isWater()) ||
            (unit.domain() == .land && unit.isConvertUnit() && toPlot.isWater() && !fromPlot.isWater()) {
            return Double(Int.max)
        }
        // case with route is already handled above
        else if toPlot.isCity() && !player.isAtWar(with: toPlot.owner()) && (!riverCrossing || player.isBridgeBuilding()) {
            return 1.0
        } else {
            // if the unit ignores terrain cost, it can still profit from feature bonuses
            if ignoreTerrainCost {
                regularCost = 1
            } else {
                regularCost = toFeature == .none ?
                    toTerrain.movementCost(for: unit.movementType()) :
                    toFeature.movementCost(for: unit.movementType())

                // Hill cost is hardcoded
                if toPlot.hasHills() || toPlot.feature() == .mountains {
                    regularCost += 1.0 /* HILLS_EXTRA_MOVEMENT */
                }

                if riverCrossing && !amphibious {
                    regularCost += 10.0 /* RIVER_EXTRA_MOVEMENT */
                }
            }

            if regularCost > 0.0 {
                regularCost = max(1.0, regularCost /* - unit.extraMoveDiscount()*/)
            }

            // multiplicative change
            let terrainFeatureCostMultiplierFromPromotions = movementCostMultiplierFromPromotions(for: unit, on: toPlot)
            regularCost *= Double(terrainFeatureCostMultiplierFromPromotions)

            // additive change
            let terrainFeatureCostAdderFromPromotions = movementCostAdderFromPromotions(for: unit, on: toPlot)
            regularCost += terrainFeatureCostAdderFromPromotions

            // extra movement cost in some instances
            var slowDown: Bool = false
            if !player.isEqual(to: toPlot.owner()) {

                if !toPlot.isFriendlyTerritory(for: player, in: gameModel) {
                    // unit itself may have a negative trait ...
                    slowDown = unit.isSlowInEnemyLand()
                }
            }

            if slowDown {
                regularCost += 1.0
            }
        }

        // sometimes the route cost can be higher than what we get with promotions
        return min(regularCost, routeCost)
    }

    //    ---------------------------------------------------------------------------
    static func movementCost(
        unit unitRef: AbstractUnit?,
        fromPlot fromPlotRef: AbstractTile?,
        toPlot toPlotRef: AbstractTile?,
        movesRemaining: Int,
        maxMoves: Int,
        in gameModel: GameModel?
    ) -> Double {

        if isSlowedByZoneOfControl(unit: unitRef, fromPlot: fromPlotRef, toPlot: toPlotRef, in: gameModel) {
            return Double(movesRemaining)
        }

        return movementCostNoZoneOfControl(
            unit: unitRef,
            fromPlot: fromPlotRef,
            toPlot: toPlotRef,
            movesRemaining: movesRemaining,
            maxMoves: maxMoves,
            in: gameModel
        )
    }

    //    ---------------------------------------------------------------------------
    static func movementCostSelectiveZoneOfControl(
        unit unitRef: AbstractUnit?,
        fromPlot fromPlotRef: AbstractTile?,
        toPlot toPlotRef: AbstractTile?,
        movesRemaining: Int,
        maxMoves: Int,
        in gameModel: GameModel?
    ) -> Double {

        if isSlowedByZoneOfControl(unit: unitRef, fromPlot: fromPlotRef, toPlot: toPlotRef, in: gameModel) {
            return Double(movesRemaining)
        }

        return movementCostNoZoneOfControl(
            unit: unitRef,
            fromPlot: fromPlotRef,
            toPlot: toPlotRef,
            movesRemaining: movesRemaining,
            maxMoves: maxMoves,
            in: gameModel
        )
    }

    //    ---------------------------------------------------------------------------
    static func movementCostNoZoneOfControl(
        unit unitRef: AbstractUnit?,
        fromPlot fromPlotRef: AbstractTile?,
        toPlot toPlotRef: AbstractTile?,
        movesRemaining: Int,
        maxMoves: Int,
        in gameModel: GameModel?
    ) -> Double {

        var cost = costsForMove(
            unit: unitRef,
            fromPlot: fromPlotRef,
            toPlot: toPlotRef,
            movesRemaining: -1,
            maxMoves: -1,
            in: gameModel
        )

        // now, if there was a domain change, our base moves might change
        // make sure that the movement cost is always so high that we never end up with more than the base moves for the new domain
        let leftOverMoves = Double(movesRemaining) - cost
        if leftOverMoves > Double(maxMoves) {
            cost += (leftOverMoves - Double(maxMoves))
        }

        return min(cost, Double(movesRemaining))
    }

    //    --------------------------------------------------------------------------------
    static func isSlowedByZoneOfControl(
        unit unitRef: AbstractUnit?,
        fromPlot fromPlotRef: AbstractTile?,
        toPlot toPlotRef: AbstractTile?,
        in gameModel: GameModel?
    ) -> Bool {

        guard let gameModel = gameModel else {
            fatalError("cant get game model")
        }

        guard let unit = unitRef, let fromPlot = fromPlotRef, let toPlot = toPlotRef else {
            return false
        }

        if unit.isIgnoreZoneOfControl() {
            return false
        }

        guard let player = unit.player else {
            return false
        }

        let unitDomain = unit.domain()

        // there are only two plots we need to check
        guard let moveDir = fromPlot.point.direction(towards: toPlot.point) else {
            fatalError("cant get direction")
        }

        let toRightDir = moveDir.clockwiseNeighbor
        let toLeftDir = moveDir.counterClockwiseNeighbor

        let plotsToCheckRight: AbstractTile? = gameModel.tile(at: fromPlot.point.neighbor(in: toRightDir))
        let plotsToCheckLeft: AbstractTile? = gameModel.tile(at: fromPlot.point.neighbor(in: toLeftDir))

        for adjPlotRef in [plotsToCheckRight, plotsToCheckLeft] {

            guard let adjPlot = adjPlotRef else {
                continue
            }

            // check city zone of control
            if adjPlot.isEnemyTerritory(for: player, in: gameModel) && adjPlot.isCity() {
                return true
            }

            // Loop through all units to see if there's an enemy unit here
            for loopUnitRef in gameModel.units(at: adjPlot.point) {

                guard let loopUnit = loopUnitRef else {
                    continue
                }

                if loopUnit.isDelayedDeath() {
                    continue
                }

                if !adjPlot.isVisible(to: player) {
                    continue
                }

                // Combat unit?
                if !loopUnit.isExertingZoneOfControl() {
                    continue
                }

                // Embarked units don't have Zone Of Control
                if loopUnit.isEmbarked() {
                    continue
                }

                // At war with this unit's team?
                if player.isAtWar(with: loopUnit.player) /*|| loopUnit.isAlwaysHostile(*pAdjPlot))*/ {

                    // Same Domain?
                    if loopUnit.domain() != unitDomain {
                        // hovering units always exert a Zone of control
                        if loopUnit.isHoveringUnit() {
                            return true
                        }

                        // water unit can exert zone of control towards embarked land unit
                        if loopUnit.domain() == .sea &&
                            (toPlot.needsEmbarkation(by: unit) || fromPlot.needsEmbarkation(by: unit)) {
                            return true
                        }

                        // ignore this unit
                        continue
                    } else {
                        // land units don't exert zone of control towards embarked units (if they stay embarked)
                        if loopUnit.domain() == .land &&
                            toPlot.needsEmbarkation(by: unit) &&
                            fromPlot.needsEmbarkation(by: unit) {
                            continue
                        }
                    }

                    // ok, all conditions fulfilled
                    return true
                }
            }
        }

        return false
    }

    // base value is 1. so < 1 actually means easier movement
    static func movementCostMultiplierFromPromotions(for unitRef: AbstractUnit?, on tileRef: AbstractTile?) -> Double {

        guard let tile = tileRef else {
            return 1.0
        }

        var modifier = 1.0
        let toTerrain = tile.terrain()
        let toFeature = tile.feature()

        /*if tile.hasHills() && pUnit->isHillsDoubleMove() {
            modifier *= 0.5
        } else if (pPlot->isHills() && pUnit->isTerrainHalfMove(TERRAIN_HILL)) {
            modifier *= 2.0
        } else if (pPlot->isMountain() && pUnit->isMountainsDoubleMove()) {
            modifier *= 0.5
        } else if (pUnit->isTerrainDoubleMove(eToTerrain) || pUnit->isFeatureDoubleMove(eToFeature)) {
            modifier *= 0.5
        } else if (pUnit->isTerrainHalfMove(eToTerrain) || pUnit->isFeatureHalfMove(eToFeature)) {
            modifier *= 2.0
        }*/

        return modifier
    }

    // base value is 0, any value >0 means movement is harder
    static func movementCostAdderFromPromotions(for unitRef: AbstractUnit?, on tileRef: AbstractTile?) -> Double {

        guard let tile = tileRef, let unit = unitRef else {
            return 1.0
        }

        var modifier = 0.0
        // let toTerrain = tile.terrain()
        let toFeature = tile.feature()

        if unit.has(promotion: .ranger) && toFeature == .forest {
            // ranger - Faster Movement in Woods and Jungle terrain.
            modifier -= 1.0 // 2 - FeatureType.forest.movementCosts()
        } else if unit.has(promotion: .ranger) && toFeature == .rainforest {
            // ranger - Faster Movement in Woods and Jungle terrain.
            modifier -= 1.0 // 2 - FeatureType.rainforest.movementCosts()
        } else if unit.has(promotion: .alpine) && tile.hasHills() {
            // alpine - Faster Movement on Hill terrain.
            modifier -= 1.0 /* HILLS_EXTRA_MOVEMENT */
        }

        return modifier
    }
}
