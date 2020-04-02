//
//  Combat.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum CombatResultType {
    
    case totalDefeat
    case majorDefeat
    case minorDefeat
    case stalemate
    case minorVictory
    case majorVictory
    case totalVictory
}

struct CombatResult {

    let defenderDamage: Int
    let attackerDamage: Int
    
    let value: CombatResultType
}

// https://civilization.fandom.com/wiki/Combat_(Civ6)
// https://civilization.fandom.com/wiki/City_Combat_(Civ6)
class Combat {

    static private func evaluteResult(defenderHealth: Int, defenderDamage: Int, attackerHealth: Int, attackerDamage: Int) -> CombatResultType {
    
        if defenderDamage > defenderHealth && attackerHealth - attackerDamage > 10 {
            return .totalVictory
        }
        
        if attackerDamage > attackerHealth && defenderHealth - defenderDamage > 10 {
            return .totalDefeat
        }
        
        if defenderDamage > attackerDamage && defenderHealth - defenderDamage < attackerHealth - attackerDamage {
            return .majorVictory
        }
        
        if defenderDamage < attackerDamage && defenderHealth - defenderDamage > attackerHealth - attackerDamage {
            return .majorDefeat
        }
        
        if defenderDamage > attackerDamage {
            return .minorVictory
        }
        
        if defenderDamage < attackerDamage {
            return .minorDefeat
        }
        
        return .stalemate
    }
    
    /// attack against unit - no fire back
    static func predictRangedAttack(between attacker: AbstractUnit?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker")
        }

        guard let defender = defender else {
            fatalError("cant get defender")
        }

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        let attackerStrength = attacker.rangedCombatStrength(against: defender, or: nil, on: defenderTile, attacking: true)
        let defenderStrength = defender.defensiveStrength(against: attacker, on: defenderTile, ranged: true)
        let strengthDifference = attackerStrength - defenderStrength

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* Double.random(in: 0.8..<1.2)*/))

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker
        let value = Combat.evaluteResult(defenderHealth: defender.healthPoints(), defenderDamage: damage, attackerHealth: attacker.healthPoints(), attackerDamage: 0)
        return CombatResult(defenderDamage: damage, attackerDamage: 0, value: value)
    }

    /// attack against city - no fire back
    static func predictRangedAttack(between attacker: AbstractUnit?, and city: AbstractCity?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let defenderTile = gameModel.tile(at: city.location) else {
            fatalError("cant get defenderTile")
        }

        let attackerStrength = attacker.rangedCombatStrength(against: nil, or: city, on: defenderTile, attacking: true)
        let defenderStrength = city.defensiveStrength(against: attacker, on: defenderTile, ranged: true)
        let strengthDifference = attackerStrength - defenderStrength

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* * Double.random(in: 0.8..<1.2)*/) )

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluteResult(defenderHealth: city.healthPoints(), defenderDamage: damage, attackerHealth: attacker.healthPoints(), attackerDamage: 0)
        return CombatResult(defenderDamage: damage, attackerDamage: 0, value: value)
    }
    
    static func predictRangedAttack(between attacker: AbstractCity?, and unit: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker")
        }

        guard let defender = unit else {
            fatalError("cant get city")
        }

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        let attackerStrength = attacker.rangedCombatStrength(against: defender, on: defenderTile, attacking: true)
        let defenderStrength = defender.defensiveStrength(against: nil, on: defenderTile, ranged: true) // FIXME
        let strengthDifference = attackerStrength - defenderStrength

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* * Double.random(in: 0.8..<1.2)*/) )

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluteResult(defenderHealth: defender.healthPoints(), defenderDamage: damage, attackerHealth: attacker.healthPoints(), attackerDamage: 0)
        return CombatResult(defenderDamage: damage, attackerDamage: 0, value: value)
    }

    static func predictMeleeAttack(between attacker: AbstractUnit?, and city: AbstractCity?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker")
        }

        guard let city = city else {
            fatalError("cant get city")
        }

        guard let attackerTile = gameModel.tile(at: attacker.location) else {
            fatalError("cant get attackerTile")
        }
        
        guard let defenderTile = gameModel.tile(at: city.location) else {
            fatalError("cant get defenderTile")
        }

        // attacker strikes
        let attackerStrength = attacker.attackStrength(against: nil, or: city, on: defenderTile)
        let defenderStrength = city.defensiveStrength(against: attacker, on: defenderTile, ranged: false)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/) )

        if defenderDamage < 0 {
            defenderDamage = 0
        }
        
        // defender strikes back
        let attackerStrength2 = city.rangedCombatStrength(against: attacker, on: attackerTile, attacking: true)
        let defenderStrength2 = attacker.defensiveStrength(against: nil, on: attackerTile, ranged: true)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2
        
        var attackerDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/) )

        if attackerDamage < 0 {
            attackerDamage = 0
        }
        
        // no damage for attacker, no suppression to cities
        let value = Combat.evaluteResult(defenderHealth: city.healthPoints(), defenderDamage: defenderDamage, attackerHealth: attacker.healthPoints(), attackerDamage: attackerDamage)
        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }

    static func predictMeleeAttack(between attacker: AbstractUnit?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker")
        }

        guard let defender = defender else {
            fatalError("cant get city")
        }

        guard let attackerTile = gameModel.tile(at: attacker.location) else {
            fatalError("cant get attackerTile")
        }
        
        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        // attacker strikes
        let attackerStrength = attacker.attackStrength(against: defender, or: nil, on: defenderTile)
        let defenderStrength = defender.defensiveStrength(against: attacker, on: defenderTile, ranged: false)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/) )

        if defenderDamage < 0 {
            defenderDamage = 0
        }
        
        // defender strikes back
        let attackerStrength2 = defender.attackStrength(against: attacker, or: nil, on: attackerTile)
        let defenderStrength2 = attacker.defensiveStrength(against: defender, on: attackerTile, ranged: true)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2
        
        var attackerDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/) )

        if attackerDamage < 0 {
            attackerDamage = 0
        }
        
        // no damage for attacker, no suppression to cities
        let value = Combat.evaluteResult(defenderHealth: defender.healthPoints(), defenderDamage: defenderDamage, attackerHealth: attacker.healthPoints(), attackerDamage: attackerDamage)
        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }
}
