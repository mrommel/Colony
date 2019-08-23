//
//  UnitProperties.swift
//  Colony
//
//  Created by Michael Rommel on 23.08.19.
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
