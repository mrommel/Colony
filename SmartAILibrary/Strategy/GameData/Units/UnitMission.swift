//
//  UnitMission.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 08.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class UnitMission {

    weak var unit: AbstractUnit?
    let type: UnitMissionType
    var buildType: BuildType?
    var target: HexPoint?
    var path: HexPath?
    var options: MoveOptions

    var startedInTurn: Int = -1

    public init(
        type: UnitMissionType,
        buildType: BuildType? = nil,
        at target: HexPoint? = nil,
        follow path: HexPath? = nil,
        options: MoveOptions = .none
    ) {

        self.type = type
        self.buildType = buildType
        self.target = target
        self.path = path
        self.options = options

        if type.needsTarget() && (target == nil && path == nil) {
            fatalError("need target")
        }
    }

    /// Initiate a mission
    func start(in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("gameModel not set")
        }

        guard let unit = self.unit else {
            fatalError("unit not set")
        }

        guard let player = unit.player else {
            fatalError("player not set")
        }

        self.startedInTurn = gameModel.currentTurn

        var delete = false
        var notify = false
        var action = false

        if unit.canMove() {
            unit.set(activityType: .mission, in: gameModel)
        } else {
            unit.set(activityType: .hold, in: gameModel)
        }

        if !unit.canStart(mission: self, in: gameModel) {
            delete = true

        } else {

            if self.type == .skip {
                unit.set(activityType: .hold, in: gameModel)
                delete = true
            } else if self.type == .sleep {
                unit.set(activityType: .sleep, in: gameModel)
                delete = true
                notify = true
            } else if self.type == .fortify {
                unit.set(activityType: .sleep, in: gameModel)
                delete = true
                notify = true
            } else if self.type == .heal {
                unit.set(activityType: .heal, in: gameModel)
                delete = true
                notify = true
            }

            if unit.canMove() {

                if self.type == .fortify || self.type == .heal || self.type == .alert || self.type == .skip {
                    unit.set(fortifiedThisTurn: true, in: gameModel)

                    //start the animation right now to give feedback to the player
                    if !unit.isFortified() && !unit.hasMoved(in: gameModel) && unit.canFortify(at: unit.location, in: gameModel) {
                        gameModel.userInterface?.refresh(unit: unit)
                    }
                } else if unit.isFortified() {
                    // unfortify for any other mission
                    gameModel.userInterface?.refresh(unit: unit)
                }

                // ---------- now the real missions with action -----------------------

                if self.type == .embark || self.type == .disembark {
                    action = true
                }
                // FIXME nuke, paradrop, airlift
                else if self.type == .rebase {

                        guard let target = self.target else {
                            fatalError("type requires a target")
                        }

                        if unit.doRebase(to: target) {
                            action = true
                        }
                } else if self.type == .rangedAttack {

                        guard let target = self.target else {
                            fatalError("type requires a target")
                        }

                    if !unit.canRangeStrike(at: target, needWar: false, noncombatAllowed: false, in: gameModel) {
                            // Invalid, delete the mission
                            delete = true
                        }
                } else if self.type == .pillage {

                        if unit.doPillage(in: gameModel) {
                            action = true
                        }
                } else if self.type == .found {

                        if unit.doFound(with: nil, in: gameModel) {
                            action = true
                        }
                }
            }
        }

        if action && player.isHuman() {

            let timer = self.calculateMissionTimer(for: unit)
            unit.setMissionTimer(to: timer)
        }

        if delete {
            unit.popMission()
        } else if unit.activityType() == .mission {
            self.continueMission(steps: 0, in: gameModel)
        }
    }

    //    ---------------------------------------------------------------------------
    //    Update the mission timer to a new value based on the mission (or lack thereof) in the queue
    //    KWG: The mission timer controls when the next time the unit's mission will be checked, not
    //         in absolute time, but in passes through the Game Core update loop.  Previously,
    //       this was used to delay processing so that the user could see the visualization of
    //         units.  The Game Core no longer deals with visualization timing, but this system is
    //         still used to keep the units sequencing their missions with each other.
    //         i.e. each unit will get a chance to complete a mission segment, rather than a unit
    //         exhausting its mission queue all in one go.
    func calculateMissionTimer(for unit: AbstractUnit?, steps: Int = 0) -> Int {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        guard let unitPlayer = unit.player else {
            fatalError("cant get unitPlayer")
        }

        var time = 0

        if !unitPlayer.isHuman() {
            time = 0
        } else if let peekMission = unit.peekMission() {

            time = 1

            if peekMission.type == .moveTo /* || peekMission.type == .routeTo || peekMission.type == .moveToUnit*/ {

                var targetPlot: HexPoint?
                /*if peekMission.type == .moveToUnit {
                    pTargetUnit = GET_PLAYER((PlayerTypes)kMissionData.iData1).getUnit(kMissionData.iData2);
                    if (pTargetUnit) {
                        pTargetPlot = pTargetUnit->plot();
                    } else {
                        pTargetPlot = NULL;
                    }
                } else {*/
                targetPlot = peekMission.target
                //}

                if let targetPlot = targetPlot, unit.location == targetPlot {
                    time += steps
                } else {
                    time = min(time, 2)
                }
            }

            if unitPlayer.isHuman() && unit.isAutomated() {
                time = min(time, 1)
            }
        } else {
            time = 0
        }

        return time
    }

    /*func update() {
        
    }*/

    func continueMission(steps: Int, in gameModel: GameModel?) {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let unit = self.unit else {
            fatalError("cant get unit")
        }

        /*guard let unitPlot = gameModel.tile(at: unit.location) else {
            fatalError("cant get unitPlot")
        }*/

        guard let unitPlayer = unit.player else {
            fatalError("cant get unit")
        }

        var continueMissionRestart = true // to make this function no longer recursive
        while continueMissionRestart {

            continueMissionRestart = false
            var done = false // are we done with mission?
            var action = false // are we taking an action this turn?

            if self.startedInTurn == gameModel.currentTurn {

                if self.type == .moveTo && unit.canMove() {

                    if let target = self.target, let tile = gameModel.tile(at: target) {

                        /*if unit.isAutomated() && tile.isDiscovered(by: unitPlayer) && unit.canMove(into: target, options: MoveOptions.attack, in: gameModel) {

                            // if we're automated and try to attack, consider this move OVAH
                            done = true
                        } else {

                            // configs
                            let cityAttackInterrupt = false // gDLL->GetAdvisorCityAttackInterrupt();
                            let badAttackInterrupt = true // gDLL->GetAdvisorBadAttackInterrupt();

                            if unitPlayer.isHuman() && badAttackInterrupt {

                                if unit.canMove(into: target, options: .attack, in: gameModel) && tile.isDiscovered(by: unitPlayer) {

                                    if tile.isCity() {

                                        if cityAttackInterrupt {

                                            // GC.GetEngineUserInterface()->SetDontShowPopups(false);

                                            // FIXME: show tutorial
                                            /*if(!GC.getGame().isOption(GAMEOPTION_NO_TUTORIAL))
                                            {
                                                // do city alert
                                                CvPopupInfo kPopup(BUTTONPOPUP_ADVISOR_MODAL);
                                                kPopup.iData1 = ADVISOR_MILITARY;
                                                kPopup.iData2 = pPlot->GetPlotIndex();
                                                kPopup.iData3 = unit.plot()->GetPlotIndex();
                                                strcpy_s(kPopup.szText, "TXT_KEY_ADVISOR_CITY_ATTACK_BODY");
                                                kPopup.bOption1 = true;
                                                GC.GetEngineUserInterface()->AddPopup(kPopup);
                                                goto ContinueMissionExit;
                                            }*/
                                        }
                                    } else if badAttackInterrupt {

                                        if let defender = gameModel.visibleEnemy(at: target, for: unitPlayer) {

                                            //CombatPredictionTypes ePrediction = GC.getGame().GetCombatPrediction(hUnit.pointer(), pDefender);
                                            let result = Combat.predictMeleeAttack(between: unit, and: defender, in: gameModel)
                                            if result.value == .totalDefeat || result.value == .majorDefeat {
                                                // FIXME: show tutorial
                                                /*if(!GC.getGame().isOption(GAMEOPTION_NO_TUTORIAL))
                                                {
                                                    GC.GetEngineUserInterface()->SetDontShowPopups(false);
                                                    CvPopupInfo kPopup(BUTTONPOPUP_ADVISOR_MODAL);
                                                    kPopup.iData1 = ADVISOR_MILITARY;
                                                    kPopup.iData2 = pPlot->GetPlotIndex();
                                                    kPopup.iData3 = unit.plot()->GetPlotIndex();
                                                    strcpy_s(kPopup.szText, "TXT_KEY_ADVISOR_BAD_ATTACK_BODY");
                                                    kPopup.bOption1 = false;
                                                    GC.GetEngineUserInterface()->AddPopup(kPopup);
                                                    goto ContinueMissionExit;
                                                }*/
                                            }
                                        }
                                    }
                                }
                            }

                            if unit.doAttack(into: target, steps: steps, in: gameModel) {
                                done = true
                            }
                        }*/
                    }
                }
            }

            // If there are units in the selection group, they can all move, and we're not done
            //   then try to follow the mission
            if !done && unit.canMove() /*&& !unit.isDoingPartialMove()*/ {

                if self.type == .moveTo || self.type == .embark || self.type == .disembark {

                    if unit.domain() == .air {
                        if unit.doMoveOnPath(towards: self.target!, previousETA: 0, buildingRoute: false, in: gameModel) > 0 {
                            done = true
                        }
                    } else {
                        let cost = unit.doMoveOnPath(towards: self.target!, previousETA: 0, buildingRoute: false, in: gameModel)

                        if cost > unit.movesLeft() {
                            action = true
                        } else {
                            done = true
                        }
                    }
                } else if self.type == .routeTo {

                    let oldLocation = unit.location
                    let movesToDo = unit.doMoveOnPath(towards: self.target!, previousETA: 0, buildingRoute: false, in: gameModel)

                    if movesToDo > 0 {
                        action = true
                    } else {
                        action = oldLocation != self.target!
                        done = true
                    }
                } else if self.type == .followPath {

                    guard let path = self.path else {
                        fatalError("we need a path to follow")
                    }

                    if let currentIndexInPath: Int = path.points().firstIndex(of: unit.location) {

                        let nextPoint: HexPoint = path.points()[currentIndexInPath + 1]

                        let movesToDo = unit.doMoveOnPath(towards: nextPoint, previousETA: 0, buildingRoute: false, in: gameModel)

                        if movesToDo > 0 {
                            action = true
                        }

                        done = path.points().last == unit.location

                    } else {
                        print("cant find current position in path - move to start")

                        guard let startPoint = path.points().first else {
                            fatalError("cant get start location")
                        }

                        let movesToDo = unit.doMoveOnPath(towards: startPoint, previousETA: 0, buildingRoute: false, in: gameModel)

                        if movesToDo > 0 {
                            action = true
                        }

                        done = path.points().last == startPoint
                    }

                } else if self.type == .swapUnits {

                    // Get target plot
                    if let targetPoint = self.target {

                        //pOriginationPlot = unit.plot();

                        if let unit2 = gameModel.unit(at: targetPoint, of: .combat) {

                            if unit2.hasSameType(as: unit) && unit2.readyToMove() {
                                // Start the swap
                                unit.doMoveOnPath(towards: unit2.location, previousETA: 0, buildingRoute: false, in: gameModel)

                                // Move the other unit back out
                                unit2.doMoveOnPath(towards: unit.location, previousETA: 0, buildingRoute: false, in: gameModel)
                                done = true
                            }

                        } else {
                            action = false
                            done = true
                            break
                        }
                    }
                } else if self.type == .moveToUnit {

                    if let targetUnit = gameModel.unit(at: self.target!, of: .combat) {

                        if unit.has(task: .shadow) && self.type != .group {

                            // FIXME
                            /*if (!unit.plot()->isOwned() || unit.plot()->getOwner() == unit.getOwner())
                            {
                                CvPlot* pMissionPlot = pTargetUnit->GetMissionAIPlot();
                                if (pMissionPlot != NULL && NO_TEAM != pMissionPlot->getTeam())
                                {
                                    if (pMissionPlot->isOwned() && pTargetUnit->isPotentialEnemy(pMissionPlot->getTeam(), pMissionPlot))
                                    {
                                        action = false;
                                        done = true;
                                        break;
                                    }
                                }
                            }*/
                        }

                        if unit.doMoveOnPath(towards: targetUnit.location, previousETA: 0, buildingRoute: false, in: gameModel) > 0 {
                            action = true
                        } else {
                            done = true
                        }
                    } else {
                        done = true
                    }
                } else if self.type == .garrison {

                    //let targetLocation: HexPoint? = self.target ?? self.unit?.location
                    if let targetPoint = self.target, let targetCity = gameModel.city(at: targetPoint) {

                        // check to see if the city exists, is on our team, and does not have a garrisoned unit
                        if targetCity.player?.leader != unitPlayer.leader || gameModel.unit(at: targetPoint, of: .combat) != nil {
                            action = false
                            done = true
                            break
                        }

                        // are we there yet
                        if unit.location != targetPoint {
                            if unit.doMoveOnPath(towards: targetPoint, previousETA: 0, buildingRoute: false, in: gameModel) > 0 {
                                action = true
                            } else {
                                done = true
                            }
                        }
                    }
                } else if self.type == .rangedAttack {

                    if let targetPoint = self.target {
                        if unit.doRangeAttack(at: targetPoint, in: gameModel) {
                            done = true
                        }
                    }
                } else if self.type == .build {
                    if let buildType = self.buildType {
                        if !unit.continueBuilding(build: buildType, in: gameModel) {
                            done = true
                        }
                    }
                }
            }

            // slewis - I added this because garrison should not consume any moves, and the logic above checks to see if there are any moves available
            if !done {

                if self.type == .garrison {

                    var targetPoint = self.target
                    if targetPoint == nil {
                        targetPoint = unit.location
                    }

                    if let targetPoint = targetPoint, let city = gameModel.city(at: targetPoint) {

                        // check to see if the city exists, is on our team, and does not have a garrisoned unit
                        if city.player?.leader != unitPlayer.leader /*|| gameModel.unit(at: targetPoint) != nil*/ {
                            action = false
                            done = true
                            break
                        }

                        // are we there yet?
                        if unit.location == targetPoint {
                            unit.doGarrison(in: gameModel)
                            unit.set(activityType: .sleep, in: gameModel) // sleep here after we complete the mission
                            action = true
                        }
                    }
                }
            }

            // check to see if mission is done
            if !done {

                if self.type == .moveTo || self.type == .swapUnits || self.type == .embark || self.type == .disembark {
                    if unit.location == target {
                        done = true
                    }
                } else if self.type == .routeTo {
                    if unit.location == target {
                        done = true
                    }
                } else if self.type == .moveToUnit {

                    let oppositeType: UnitMapType = unit.unitClassType() == .civilian ? UnitMapType.combat : UnitMapType.civilian
                    if let targetUnit = gameModel.unit(at: target!, of: oppositeType) {
                        if targetUnit.location == unit.location {
                            done = true
                        }
                    }

                } else if self.type == .garrison {
                    // if the garrison is called from a stationary unit (one just built in a city) then the locations will be -1. If the garrison action is directed from outside the city, then it will be the plot of the city.

                    if self.target == nil && unit.isGarrisoned() {
                        done = true
                    }

                    if let targetPoint = self.target {
                        if unit.location == targetPoint && unit.isGarrisoned() {
                            done = true
                        }
                    }
                } else if /*self.type == CvTypes::getMISSION_SET_UP_FOR_RANGED_ATTACK() ||
                        self.type == CvTypes::getMISSION_AIRLIFT() ||
                        self.type == CvTypes::getMISSION_NUKE() ||
                        self.type == CvTypes::getMISSION_PARADROP() ||
                        self.type == CvTypes::getMISSION_AIR_SWEEP() ||*/
                    self.type == .rebase ||
                    self.type == .rangedAttack ||
                    self.type == .pillage ||
                    self.type == .found /*||
                self.type == .join ||
                        self.type == CvTypes::getMISSION_CONSTRUCT() ||
                        self.type == CvTypes::getMISSION_DISCOVER() ||
                        self.type == CvTypes::getMISSION_HURRY() ||
                        self.type == CvTypes::getMISSION_TRADE() ||
                        self.type == CvTypes::getMISSION_SPACESHIP() ||
                        self.type == CvTypes::getMISSION_CULTURE_BOMB() ||
                        self.type == CvTypes::getMISSION_GOLDEN_AGE() ||
                        self.type == CvTypes::getMISSION_LEAD() ||
                self.type == .die CvTypes::getMISSION_DIE_ANIMATION())*/ {
                    done = true
                } /*else if self.type == .waitFor {
                    CvUnit* pkWaitingFor = GET_PLAYER((PlayerTypes)kMissionData.iData1).getUnit(kMissionData.iData2);
                    if (!pkWaitingFor || !pkWaitingFor->IsBusy())
                    {
                        done = true;
                    } else {
                        // Set the mission timer to 1 so we will get another UpdateMission call
                         unit.changeMissionTimer(1)
                    }
                }*/
            }

            //if (HeadMissionQueueNode(kMissionQueue) != NULL)

            // if there is an action, if it's done or there are not moves left, and a player is watching, watch the movement
            if action && (done || !unit.canMove()) /*&& unit.plot()->isVisibleToWatchingHuman())*/ {
                //self.updateMissionTimer(hUnit, steps)

                /*if (unit.ShowMoves() && GC.getGame().getActivePlayer() != NO_PLAYER && unit.getOwner() != GC.getGame().getActivePlayer() && unit.plot()->isActiveVisible(false))
                    {
                        auto_ptr<ICvPlot1> pDllPlot = GC.WrapPlotPointer(unit.plot());
                        GC.GetEngineUserInterface()->lookAt(pDllPlot.get(), CAMERALOOKAT_NORMAL);
                    }*/
            }

            if done {
                /*if (unit.IsWork())
                    {
                        auto_ptr<ICvUnit1> pDllUnit(new CvDllUnit(hUnit.pointer()));
                        gDLL->GameplayUnitWork(pDllUnit.get(), -1);
                    }*/

                // Was unit.IsBusy(), but its ok to clear the mission if the unit is just completing a move visualization
                if unit.missionTimer() == 0 /*&& !unit.isInCombat()*/ {
                    /*if unit.owner() == GC.getGame().getActivePlayer() && unit.IsSelected()) {
                            
                            if self.type == .moveTo || self.type == .routeTo || self.type == .moveToUnit {
                                // How long does the camera wait before jumping to the next item?
                                / *var cameraTime

                                if (GET_PLAYER(unit.getOwner()).isOption(PLAYEROPTION_QUICK_MOVES))
                                {
                                    iCameraTime = 1;
                                }
                                // If our move revealed a Plot, camera jumps slower
                                else if (GC.GetEngineUserInterface()->IsSelectedUnitRevealingNewPlots())
                                {
                                    iCameraTime = 10;
                                }
                                // No plots revealed by this move, go quicker
                                else
                                {
                                    iCameraTime = 5;
                                }

                                GC.GetEngineUserInterface()->changeCycleSelectionCounter(iCameraTime);* /
                            }
                        }*/

                    unit.publishQueuedVisualizationMoves(in: gameModel)

                    unit.popMission()
                }

                // trader has reached a target but has moves left
                if unit.isTrading() && unit.movesLeft() > 0 {
                    //unit.continueTrading(in: gameModel)
                    unit.finishMoves()
                }
            } else {
                // if we can still act, process the mission again
                if unit.canMove() /*&& !unit.IsDoingPartialMove()*/ {
                    //steps *= 1
                    continueMissionRestart = true // keep looping
                } else if !unit.isBusy() /*&& unit.getOwner() == GC.getGame().getActivePlayer() && unit.IsSelected())*/ {
                    //GC.GetEngineUserInterface()->changeCycleSelectionCounter(1);
                }
            }
        }
    }
}
