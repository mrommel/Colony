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

    static private func evaluateResult(defenderHealth: Int, defenderDamage: Int, attackerHealth: Int, attackerDamage: Int) -> CombatResultType {

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
        let value = Combat.evaluateResult(defenderHealth: defender.healthPoints(), defenderDamage: damage, attackerHealth: attacker.healthPoints(), attackerDamage: 0)
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

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(defenderHealth: city.healthPoints(), defenderDamage: damage, attackerHealth: attacker.healthPoints(), attackerDamage: 0)
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

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(defenderHealth: defender.healthPoints(), defenderDamage: damage, attackerHealth: attacker.healthPoints(), attackerDamage: 0)
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

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        // defender strikes back
        let attackerStrength2 = city.rangedCombatStrength(against: attacker, on: attackerTile, attacking: true)
        let defenderStrength2 = attacker.defensiveStrength(against: nil, on: attackerTile, ranged: true)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2

        var attackerDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if attackerDamage < 0 {
            attackerDamage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(defenderHealth: city.healthPoints(), defenderDamage: defenderDamage, attackerHealth: attacker.healthPoints(), attackerDamage: attackerDamage)
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

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        // defender strikes back
        let attackerStrength2 = defender.attackStrength(against: attacker, or: nil, on: attackerTile)
        let defenderStrength2 = attacker.defensiveStrength(against: defender, on: attackerTile, ranged: true)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2

        var attackerDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if attackerDamage < 0 {
            attackerDamage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(defenderHealth: defender.healthPoints(), defenderDamage: defenderDamage, attackerHealth: attacker.healthPoints(), attackerDamage: attackerDamage)
        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }

    // CvUnitCombat::Attack
    @discardableResult static func doMeleeAttack(between attacker: AbstractUnit?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let activePlayer = gameModel.activePlayer() else {
            fatalError("cant get activePlayer")
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
        
        // Unit that attacks loses his Fort bonus
        attacker.doMobilize(in: gameModel)
        
        attacker.automate(with: .none)
        defender.automate(with: .none)
        
        guard !attacker.isDelayedDeath() && !defender.isDelayedDeath() else {
            fatalError("Trying to battle and one of the units is already dead!")
        }
        
        // attacker strikes
        let attackerStrength = attacker.attackStrength(against: defender, or: nil, on: defenderTile)
        let defenderStrength = defender.defensiveStrength(against: attacker, on: defenderTile, ranged: false)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        var attackerDamage: Int = 0
        
        if defender.canDefend() {
            
            // defender strikes back
            let attackerStrength2 = defender.attackStrength(against: attacker, or: nil, on: attackerTile)
            let defenderStrength2 = attacker.defensiveStrength(against: defender, on: attackerTile, ranged: true)

            let defenderStrengthDifference = attackerStrength2 - defenderStrength2

            attackerDamage = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) * Double.random(in: 0.8..<1.2)))

            if attackerDamage < 0 {
                attackerDamage = 0
            }
        } else {
            // kill the unit (civilian?)
            defender.doKill(delayed: false, by: attacker.player, in: gameModel)
            
            var strMessage: String = ""
            var strSummary: String = ""
            
            // Some units can't capture civilians. Embarked units are also not captured, they're simply killed. And some aren't a type that gets captured.
            if attacker.canCapture() && !defender.isEmbarked() && defender.captureUnitType().baseType() != nil {
                
                // defender.setCapturingPlayer(attacker.player)

                if attacker.isBarbarian() {
                    strMessage = "TXT_KEY_UNIT_CAPTURED_BARBS_DETAILED"
                    //strMessage << pDefender->getUnitInfo().GetTextKey() << GET_PLAYER(kAttacker.getOwner()).getNameKey();
                    strSummary = "TXT_KEY_UNIT_CAPTURED_BARBS"
                } else {
                    strMessage = "TXT_KEY_UNIT_CAPTURED_DETAILED"
                    //strMessage << pDefender->getUnitInfo().GetTextKey();
                    strSummary = "TXT_KEY_UNIT_CAPTURED"
                }
            } else {
                // Unit was killed instead
                strMessage = "TXT_KEY_UNIT_LOST"
                strSummary = strMessage
            }
            
            if let notification = defender.player?.notifications() {
                notification.addNotification(of: .unitDied, for: defender.player, message: strMessage, summary: strSummary, at: defender.location, other: attacker.player)
            }

            // Move forward
            if attacker.canMove(into: defenderTile.point, options: MoveOptions.none, in: gameModel) {
                attacker.doMove(on: defenderTile.point, in: gameModel)
            }
        }
        
        let value = Combat.evaluateResult(defenderHealth: defender.healthPoints(), defenderDamage: defenderDamage, attackerHealth: attacker.healthPoints(), attackerDamage: attackerDamage)
        
        // apply damage
        attacker.add(damage: attackerDamage)
        defender.add(damage: defenderDamage)
        
        // experience
        attacker.changeExperience(by: 6 /* EXPERIENCE_ATTACKING_UNIT_MELEE */, in: gameModel)
        defender.changeExperience(by: 4 /* EXPERIENCE_DEFENDING_UNIT_MELEE */, in: gameModel)
        
        // add archaeological record (only melee combat)
        // defenderTile.addArchaeologicalRecord
        
        // Attacker died
        if attacker.healthPoints() <= 0 {
            
            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(at: attackerTile.point, text: "TXT_KEY_MISC_YOU_UNIT_DIED_ATTACKING", delay: 3)
            }
            
            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(at: defenderTile.point, text: "TXT_KEY_MISC_YOU_KILLED_ENEMY_UNIT", delay: 3)
            }
            
            // pkDefender->testPromotionReady();
            
        } else if defender.healthPoints() <= 0 { // Defender died
            
            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(at: defenderTile.point, text: "TXT_KEY_MISC_YOU_UNIT_DESTROYED_ENEMY", delay: 3)
            }
            
            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(at: defenderTile.point, text: "TXT_KEY_MISC_YOU_UNIT_WAS_DESTROYED", delay: 3)
            }
            
            if let notifications = defender.player?.notifications() {
                notifications.addNotification(of: .unitDied, for: defender.player, message: "TXT_KEY_UNIT_LOST", summary: "TXT_KEY_UNIT_LOST", at: defenderTile.point, other: attacker.player)
            }
            
            // pkAttacker->testPromotionReady();
            
        } else {
            
            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(at: defenderTile.point, text: "TXT_KEY_MISC_YOU_UNIT_WITHDRAW", delay: 3)
            }
            
            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(at: defenderTile.point, text: "TXT_KEY_MISC_ENEMY_UNIT_WITHDRAW", delay: 3)
            }
            
            // pkDefender->testPromotionReady();
            // pkAttacker->testPromotionReady();
        }
        
        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }
}
