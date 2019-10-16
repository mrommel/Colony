//
//  TacticalAI.swift
//  Colony
//
//  Created by Michael Rommel on 04.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol TacticalAIProtocol {

    func update(for game: Game?)

    // mission methods
    func missionFinished(with result: MissionResult)
    func order(mission: Mission?)
    
    func isWaitingForOrders() -> Bool
    func isAttacked() -> Bool
    func isEnemySpotted() -> Bool
}

/**
* Provides decision on what to do at each frame, for each unit.
*
* This AI algorithm is working as a final state machine, stacking states to
* get the job done and react to its environment at the same time.
*
* the different states are defined by a unique method describing the behavior.
* Each behavior may :
*  - stack a new behavior over itself
*  - pop itself
*
* When a behavior is no more needed and pop itself, the previous stacked behavior
* begin again.
*
* It may also receive direct orders from the player. In this special case, all stacked
* states are pop and the state machine is emptied before desired behaviors are stacked.
*
* For example, if the player order to move, the AI stacks the state "wait orders" and
* the state "move" over it. When move is done, the AI fall to the "wait orders" state.
*
*/
// inspired by: https://github.com/PowerMobileWeb/OpenRTS/blob/193dedc4c9edd8fb61b9f824f73c44dc85d69cd9/core/src/model/battlefield/army/tacticalAI/TacticalAI.java
class TacticalAI {

    // MARK: constants

    private static let kFREE_MOVE_RADIUS: Int = 1 // unit moves within this radius around the post
    private static let kDISTURB_DURATION: Int = 2 // seconds
    private static let kPURSUE_RADIUS: Int = 5 // unit follows units within this radius around the post
    private static let kTAUNT_DURATION: TimeInterval = 5.0 // seconds

    // MARK: properties

    private let unit: Unit?
    private var game: Game? = nil
    private var stateMachine: TacticalStateMachine? = nil

    // general properties
    private var disturbTime: TimeInterval = 0.0

    // ai
    //private var mission: Mission? = nil
    
    // movement properties
    private var post: HexPoint? = nil // target for the unit to go to
    //private var path: HexPath? = nil // path towards the post

    // battle properties
    private var aggressionPlace: HexPoint? = nil // location the latest attack came from
    private var aggressions: [AttackEvent] = [] // units that have attacked us

    private var neighbors: [Unit?] = [] // friendly units that may support us
    private var enemies: [Unit?] = [] // hostile units in sight

    // MARK: constructors

    init(unit: Unit?) {
        self.unit = unit

        self.stateMachine = TacticalStateMachine(ai: self)
        self.stateMachine?.push(state: .waitingForOrders)
    }

    // MARK: handlers

    func doWaitOrders() {

        if self.post == nil {
            self.post = self.unit?.position
        }

        // attack back an attacker
        // note that attackers are also registered on nearby allies for support
        if self.isAttacked() {
            self.stateMachine?.push(state: .returnToPost)
            //self.stateMachine?.push(state: .ATTACK_BACK)
            return
        }

        // return to post, if disturbed
        if self.post != nil && self.getPostDistance() > TacticalAI.kFREE_MOVE_RADIUS {
            self.stateMachine?.push(state: .returnToPost)
            self.stateMachine?.push(state: .wait, arg: TacticalAI.kDISTURB_DURATION)
        }
    }

    func doWait(for duration: TimeInterval) {

        if self.disturbTime == 0 {
            self.disturbTime = Date().timeIntervalSince1970
        } else if self.disturbTime + duration < Date().timeIntervalSince1970 {
            self.disturbTime = 0
            self.stateMachine?.popState()
        }
    }

    func doFindPath(towards target: HexPoint) {

        self.post = target

        guard let unitPosition = self.unit?.position else {
            fatalError("can't find position of unit")
        }

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = self.game?.pathfinderDataSource(for: self.unit, ignoreSight: true)

        if let path = pathFinder.shortestPath(fromTileCoord: unitPosition, toTileCoord: target) {
            self.stateMachine?.popState()
            self.order(mission: ScoutingMission(unit: self.unit, path: path))
            self.stateMachine?.push(state: .followMission)
        } else {
            // fallback
            self.stateMachine?.popState()
            self.stateMachine?.push(state: .wait, arg: TacticalAI.kDISTURB_DURATION)
        }
    }

    func doFollow(mission: Mission?) {

        if mission == nil {
            fatalError("can't follow mission - no mission")
        }

        if self.game == nil {
            // we need to skip
            return
        }
        
        mission?.follow(in: self.game)
    }

    func doReturnToPost() {

        if self.post == nil {
            self.stateMachine?.popState()
        }
    }

    // MARK: private methods

    private func getPostDistance() -> Int {

        guard let post = self.post else {
            return 0
        }

        return post.distance(to: self.unit!.position)
    }

    private func getAttackers() -> [Unit?] {

        var res: [Unit?] = []

        for ae in self.aggressions {
            if !(ae.unit?.isDestroyed() ?? true) {
                res.append(ae.unit)
            }
        }

        return res
    }

    private func getValidNearest(from units: [Unit?]) -> Unit? {

        var res: Unit? = nil
        var dist = Int.max

        for rearUnitRef in units {

            guard let rearUnit = rearUnitRef else {
                continue
            }

            // skip destroyed units
            if rearUnit.isDestroyed() {
                continue
            }

            if res == nil {
                res = rearUnitRef
                dist = self.unit?.position.distance(to: rearUnit.position) ?? Int.max
            } else {
                let tmpDist = self.unit?.position.distance(to: rearUnit.position) ?? Int.max
                if dist > tmpDist {
                    res = rearUnitRef
                    dist = tmpDist
                }
            }
        }

        return res
    }

    private func updateHostileUnits() {

        var forgottenAttackers: [AttackEvent] = []
        for ae in self.aggressions {
            if let unit = ae.unit {
                if unit.isDestroyed() || ae.time + TacticalAI.kTAUNT_DURATION < Date().timeIntervalSince1970 {
                    forgottenAttackers.append(ae)
                }
            }
        }

        let forgottenAttackersSet = Set(forgottenAttackers)
        self.aggressions = aggressions.filter { !forgottenAttackersSet.contains($0) }
    }

    // get all friendly units in their support distance
    private func updateAlliedUnits() {

        self.neighbors = []

        guard let unit = self.unit else {
            // fatal
            return
        }

        guard let alliedUnits = self.game?.alliedUnits(for: unit.civilization) else {
            fatalError("Can't get friendly units")
        }

        for rearUnitRef in alliedUnits {
            if let rearUnit = rearUnitRef {
                let distance = rearUnit.position.distance(to: unit.position)

                if distance <= rearUnit.supportDistance {
                    self.neighbors.append(rearUnit)
                }
            }
        }
    }

    private func abandonAll() {

        //self.post = nil
        self.aggressionPlace = nil
        self.aggressions = []
        self.stateMachine?.popAll()
    }
}

extension TacticalAI: TacticalAIProtocol {

    func update(for game: Game?) {

        self.game = game

        self.updateAlliedUnits()
        self.updateHostileUnits()
        self.stateMachine?.update()
    }

    // MARK: orders

    func order(mission: Mission?) {
        
        // remove all orders
        self.stateMachine?.popAll()

        self.stateMachine?.push(state: .followMission, arg: mission)
    }
    
    // MARK: mission methods
    
    func missionFinished(with result: MissionResult) {
        
        self.stateMachine?.popState()
        
        if self.stateMachine?.isEmpty ?? false {
            
            self.stateMachine?.push(state: .waitingForOrders)
        }
    }

    // MARK: properties

    func isAttacked() -> Bool {

        return !self.aggressions.isEmpty
    }

    func isEnemySpotted() -> Bool {

        return false // FIXME
    }
    
    func isWaitingForOrders() -> Bool {
        
        guard let (state, _) = self.stateMachine?.peek() else {
            fatalError("no state")
        }
        
        return state == .waitingForOrders
    }
}
