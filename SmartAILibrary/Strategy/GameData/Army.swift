//
//  Army.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum ArmyState {

    case waitingForUnitsToReinforce
    case movingToDestination
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//  CLASS:      CvArmyAI
//!  \brief        One army in an operational maneuver
//
//!  Key Attributes:
//!  - Manages the turn-by-turn movement of an army
//!  - Created and owned by one AI operation
//!  - Uses step path finder to find muster points before it has units
//!  - Uses main path finder to plot route once it has units
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
class Army {

    let operation: Operation?
    let owner: AbstractPlayer?
    let formation: UnitFormationType
    let domain: UnitDomainType
    var state: ArmyState

    var goal: HexPoint = HexPoint(x: -1, y: -1)
    var muster: HexPoint = HexPoint(x: -1, y: -1)
    var position: HexPoint = HexPoint(x: -1, y: -1)

    var area: HexArea? = nil

    private var unitsArray: [AbstractUnit?] = []

    init(of owner: AbstractPlayer?, for operation: Operation?, with formation: UnitFormationType) {

        self.owner = owner
        self.operation = operation
        self.formation = formation
        self.domain = .land
        self.state = .waitingForUnitsToReinforce

        self.unitsArray = Array.init(repeating: nil, count: formation.slots().count)
    }

    func turn(in gameMode: GameModel?) {

        fatalError("not implemented yet")
    }

    // all units without order or slot relation
    func units() -> [AbstractUnit?] {

        var returnArray: [AbstractUnit?] = []

        for unitRef in self.unitsArray {

            if unitRef != nil {
                returnArray.append(unitRef)
            }
        }

        return returnArray
    }

    func unit(at slotIndex: Int) -> AbstractUnit? {

        return self.unitsArray[slotIndex]
    }

    /// Get center of mass of units in army (account for world wrap!)
    func centerOfMass(in gameModel: GameModel?) -> HexPoint? {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        var totalX = 0
        var totalY = 0

        let worldWidth = gameModel.mapSize().width()
        var referenceUnitX = -1
        var numUnits = 0

        for unitRef in self.units() {

            if let unit = unitRef {

                // first unit will set the ref
                if referenceUnitX == -1 {
                    referenceUnitX = unit.location.x
                }
                
                var worldWrapAdjust = false
                let diff = unit.location.x - referenceUnitX
                if abs(diff) > worldWidth / 2 {
                    worldWrapAdjust = true
                }
                
                if worldWrapAdjust {
                    totalX += unit.location.x + worldWidth
                } else {
                    totalX += unit.location.x;
                }
                totalY += unit.location.y
                numUnits += 1
            }
        }
        
        if numUnits > 0 {
            var averageX = (totalX + (numUnits / 2)) / numUnits
            if averageX >= worldWidth {
                averageX = averageX - worldWidth
            }
            let averageY = (totalY + (numUnits / 2)) / numUnits
            
            return HexPoint(x: averageX, y: averageY)
        }

        return nil
    }

    /// Return distance from this plot of unit in army farthest away
    func furthestUnitDistance(towards point: HexPoint) -> Int {

        var largestDistance = 0

        for unitRef in self.units() {

            if let unit = unitRef {
                
                let distance = point.distance(to: unit.location)
                
                if distance > largestDistance {
                    
                    largestDistance = distance
                }
            }
        }
        
        return largestDistance
    }
    
    /// Can all units in this army move on ocean?
    func isAllOceanGoing(in gameModel: GameModel?) -> Bool {
        
        for unitRef in self.units() {
            
            if let unit = unitRef {
                
                if unit.domain() != .sea && !unit.canEmbark(into: nil, in: gameModel) {
                    
                    return false
                }
                
                // If can move over ocean, not a coastal vessel
                if unit.isImpassable(terrain: .ocean) {
                    return false
                }
                
            }
        }
        
        return true
    }
    
    // UNIT STRENGTH ACCESSORS
    /// Total unit power
    func totalPower() -> Int {
        
        var sumOfPower = 0
        
        for unitRef in self.units() {
        
            if let unit = unitRef {
                sumOfPower += unit.power()
            }
        }
        
        return sumOfPower
    }

    func numOfSlotsFilled() -> Int {

        return self.unitsArray.count(where: { $0 != nil })
    }

    func add(unit: AbstractUnit?, to slotIndex: Int) {

        self.unitsArray[slotIndex] = unit
        unit?.assign(to: self)
    }

    func disable(slot: UnitFormationSlot) {

        fatalError("not implemented yet")
    }
}
