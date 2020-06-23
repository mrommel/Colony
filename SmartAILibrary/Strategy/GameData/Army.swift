//
//  Army.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ArmyState: Int, Codable {

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
public class Army: Codable {
    
    enum CodingKeys: CodingKey {

        case identifier
        case operation
        // case owner
        case formation
        case domain
        case state
        
        case goal
        case muster
        case position
        
        case area
    }

    let identifier: String
    let operation: Operation?
    let owner: AbstractPlayer? // not stored
    let formation: UnitFormationType
    let domain: UnitDomainType
    var state: ArmyState

    var goal: HexPoint = HexPoint.invalid
    var muster: HexPoint = HexPoint.invalid
    var position: HexPoint = HexPoint.invalid

    var area: HexArea? = nil

    private var unitsArray: [AbstractUnit?] = []

    init(of owner: AbstractPlayer?, for operation: Operation?, with formation: UnitFormationType) {

        self.identifier = UUID().uuidString
        self.owner = owner
        self.operation = operation
        self.formation = formation
        self.domain = .land
        self.state = .waitingForUnitsToReinforce

        self.unitsArray = Array.init(repeating: nil, count: formation.slots().count)
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.operation = try container.decodeIfPresent(Operation.self, forKey: .operation)
        self.owner = nil
        self.formation = try container.decode(UnitFormationType.self, forKey: .formation)
        self.domain = try container.decode(UnitDomainType.self, forKey: .domain)
        self.state = try container.decode(ArmyState.self, forKey: .state)
        
        self.goal = try container.decode(HexPoint.self, forKey: .goal)
        self.muster = try container.decode(HexPoint.self, forKey: .muster)
        self.position = try container.decode(HexPoint.self, forKey: .position)
        
        self.area = try container.decodeIfPresent(HexArea.self, forKey: .area)
        
        self.unitsArray = Array.init(repeating: nil, count: formation.slots().count)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.identifier, forKey: .identifier)
        try container.encodeIfPresent(self.operation, forKey: .operation)
        try container.encode(self.formation, forKey: .formation)
        try container.encode(self.domain, forKey: .domain)
        try container.encode(self.state, forKey: .state)
        
        try container.encode(self.goal, forKey: .goal)
        try container.encode(self.muster, forKey: .muster)
        try container.encode(self.position, forKey: .position)
        
        try container.encodeIfPresent(self.area, forKey: .area)
    }
    
    /// Delete the army
    func kill() {

        for unitRef in self.unitsArray {
            
            unitRef?.assign(to: nil)
        }
    }

    /// Process another turn for the army
    func turn(in gameMode: GameModel?) {

        self.doDelayedDeath()
    }
    
    /// Kill off the army if waiting to die (returns true if army was killed)
    @discardableResult func doDelayedDeath() -> Bool {
        
        if self.numOfSlotsFilled() == 0 && self.state != .waitingForUnitsToReinforce {
            self.kill()
            return true
        }

        return false
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
                /* FIXME if unit.isImpassable(terrain: .ocean) {
                    return false
                }*/
                
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

extension Army: Equatable {
    
    public static func == (lhs: Army, rhs: Army) -> Bool {
        
        return lhs.identifier == rhs.identifier
    }
}
