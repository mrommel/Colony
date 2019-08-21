//
//  GameObjectType.swift
//  Colony
//
//  Created by Michael Rommel on 13.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

// taken from https://www.matrixgames.com/forums/tm.asp?m=2994803
// ground or close defense => Terrain
// max initiative => Terrain + Feature
enum UnitTargetType {
    
    case soft
    case hard
    case air
    case naval
}

struct UnitProperties {
    
    // vvvv -- extend flags in constructor, when adding new bits
    private static let kBitFlying = 0
    private static let kBitSwimming = 1
    private static let kBitEntrenchmentIgnore = 2
    private static let kBitInfantery = 3
    
    let initiative: Int
    let sight: Int
    let range: Int
    let strength: Int //
    let targetType: UnitTargetType
    let flags: BitArray
    
    // attack values
    let softAttack: Int
    let hardAttack: Int
    let airAttack: Int
    let navalAttack: Int
    
    // defense values
    let groundDefense: Int
    let closeDefense: Int
    let airDefense: Int
    
    init(initiative: Int, sight: Int, range: Int, strength: Int, targetType: UnitTargetType, softAttack: Int, hardAttack: Int, airAttack: Int, navalAttack: Int, groundDefense: Int, closeDefense: Int, airDefense: Int) {
        
        self.initiative = initiative
        self.sight = sight
        self.range = range
        self.strength = strength
        self.targetType = targetType
        self.flags = BitArray(count: 4) // <-- extend, when adding new bits
        
        self.softAttack = softAttack
        self.hardAttack = hardAttack
        self.airAttack = airAttack
        self.navalAttack = navalAttack
        
        self.groundDefense = groundDefense
        self.closeDefense = closeDefense
        self.airDefense = airDefense
    }
    
    func attackValue(for targetType: UnitTargetType) -> Int {
        
        switch targetType {
        case .soft:
            return self.softAttack
        case .hard:
            return self.hardAttack
        case .air:
            return self.airAttack
        case .naval:
            return self.navalAttack
        }
    }
    
    // computed properties
    
    var isFlying: Bool {
        get {
            return self.flags.valueOfBit(at: UnitProperties.kBitFlying)
        }
        set {
            self.flags.setValueOfBit(value: newValue, at: UnitProperties.kBitFlying)
        }
    }
    
    var isSwimming: Bool {
        get {
            return self.flags.valueOfBit(at: UnitProperties.kBitSwimming)
        }
        set {
            self.flags.setValueOfBit(value: newValue, at: UnitProperties.kBitSwimming)
        }
    }
    
    var isEntrenchmentIgnore: Bool {
        get {
            return self.flags.valueOfBit(at: UnitProperties.kBitEntrenchmentIgnore)
        }
        set {
            self.flags.setValueOfBit(value: newValue, at: UnitProperties.kBitEntrenchmentIgnore)
        }
    }
    
    var isInfantery: Bool {
        get {
            return self.flags.valueOfBit(at: UnitProperties.kBitInfantery)
        }
        set {
            self.flags.setValueOfBit(value: newValue, at: UnitProperties.kBitInfantery)
        }
    }
}

enum GameObjectType: String, Codable {
    
    // real units
    case ship
    case axeman
    case archer
    
    // can't be moved
    case city
    
    // collectives
    case coin
    case booster
    
    // tile cannot be accessed, can't be moved
    case obstacle
    
    // simple reactive AI
    case monster
    case pirates
    case tradeShip
    
    // just wonder around
    case animal
    
    var textureName: String {
        
        switch self {
        case .ship:
            return "unit_indicator_ship"
        case .axeman:
            return "unit_indicator_axeman"
        case .archer:
            return "unit_indicator_archer"
        case .pirates:
            return "unit_indicator_pirates"
        case .tradeShip:
            return "unit_indicator_tradeShip"
            
        default:
            return "unit_indicator_unknown"
        }
    }
    
    var isNaval: Bool {
        
        switch self {
            
        // sea units
            
        case .ship:
            return true
        case .pirates:
            return true
        case .tradeShip:
            return true
        case .monster:
            return true
            
        // land units
            
        case .axeman:
            return false
        case .archer:
            return false
        
        // misc units
            
        case .city:
            return false
        case .coin:
            return false
        case .booster:
            return false
        case .obstacle:
            return false
        
        case .animal:
            return false
        }
    }
    
    var properties: UnitProperties? {
        
        switch self {
            
        // sea units
            
        case .ship:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 1, strength: 10, targetType: .hard, softAttack: 2, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 2, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
            
        case .monster:
            var unitProperties = UnitProperties(initiative: 2, sight: 2, range: 0, strength: 10, targetType: .soft, softAttack: 1, hardAttack: 1, airAttack: 0, navalAttack: 1, groundDefense: 2, closeDefense: 1, airDefense: 0)
            
            unitProperties.isSwimming = true
            
            return unitProperties
            
        case .pirates:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 1, strength: 10, targetType: .hard, softAttack: 2, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 3, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
            
        case .tradeShip:
            var unitProperties = UnitProperties(initiative: 1, sight: 2, range: 1, strength: 10, targetType: .hard, softAttack: 1, hardAttack: 1, airAttack: 0, navalAttack: 2, groundDefense: 2, closeDefense: 2, airDefense: 1)
            
            unitProperties.isSwimming = true
            
            return unitProperties
        
        // land units
            
        case .axeman:
            var unitProperties = UnitProperties(initiative: 3, sight: 2, range: 0, strength: 10, targetType: .soft, softAttack: 3, hardAttack: 0, airAttack: 0, navalAttack: 0, groundDefense: 1, closeDefense: 2, airDefense: 0)
            
            unitProperties.isSwimming = true
            unitProperties.isInfantery = true
            
            return unitProperties
            
        default:
            return nil
        }
    }
}
