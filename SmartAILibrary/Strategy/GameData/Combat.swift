//
//  Combat.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 29.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum CombatResultType {

    case totalDefeat
    case majorDefeat
    case minorDefeat
    case stalemate
    case minorVictory
    case majorVictory
    case totalVictory
}

public struct CombatResult {

    public let defenderDamage: Int
    public let attackerDamage: Int

    public let value: CombatResultType
}

// https://civilization.fandom.com/wiki/Combat_(Civ6)
// https://civilization.fandom.com/wiki/City_Combat_(Civ6)
// swiftlint:disable type_body_length
public class Combat {

    private static func evaluateResult(
        defenderHealth: Int,
        defenderDamage: Int,
        attackerHealth: Int,
        attackerDamage: Int) -> CombatResultType {

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
    public static func predictRangedAttack(between attacker: AbstractUnit?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

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

        let attackerStrength = attacker.rangedCombatStrength(against: defender, or: nil, on: defenderTile, attacking: true, in: gameModel)
        let defenderStrength = defender.defensiveStrength(against: attacker, or: nil, on: defenderTile, ranged: true, in: gameModel)
        let strengthDifference = attackerStrength - defenderStrength

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* Double.random(in: 0.8..<1.2)*/))

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker
        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: damage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: 0
        )
        return CombatResult(defenderDamage: damage, attackerDamage: 0, value: value)
    }

    /// attack against city - no fire back
    public static func predictRangedAttack(between attacker: AbstractUnit?, and city: AbstractCity?, in gameModel: GameModel?) -> CombatResult {

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

        let attackerStrength = attacker.rangedCombatStrength(against: nil, or: city, on: defenderTile, attacking: true, in: gameModel)
        let defenderStrength = city.defensiveStrength(against: attacker, on: defenderTile, ranged: true, in: gameModel)
        let strengthDifference = attackerStrength - defenderStrength

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(
            defenderHealth: city.healthPoints(),
            defenderDamage: damage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: 0
        )
        return CombatResult(defenderDamage: damage, attackerDamage: 0, value: value)
    }

    public static func predictRangedAttack(between attacker: AbstractCity?, and unit: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

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

        let attackerStrength = attacker.rangedCombatStrength(against: defender, on: defenderTile)
        let defenderStrength = defender.defensiveStrength(against: nil, or: nil, on: defenderTile, ranged: true, in: gameModel) // FIXME
        let strengthDifference = attackerStrength - defenderStrength

        var damage: Int = Int(30.0 * pow(M_E, 0.04 * Double(strengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if damage < 0 {
            damage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: damage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: 0
        )
        return CombatResult(defenderDamage: damage, attackerDamage: 0, value: value)
    }

    public static func predictMeleeAttack(between attacker: AbstractUnit?, and city: AbstractCity?, in gameModel: GameModel?) -> CombatResult {

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
        let attackerStrength = attacker.attackStrength(against: nil, or: city, on: defenderTile, in: gameModel)
        let defenderStrength = city.defensiveStrength(against: attacker, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        // defender strikes back
        let attackerStrength2 = city.rangedCombatStrength(against: attacker, on: attackerTile)
        let defenderStrength2 = attacker.defensiveStrength(against: nil, or: city, on: attackerTile, ranged: true, in: gameModel)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2

        var attackerDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if attackerDamage < 0 {
            attackerDamage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(
            defenderHealth: city.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: attackerDamage
        )
        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }

    public static func predictMeleeAttack(
        between attacker: AbstractUnit?,
        and defender: AbstractUnit?,
        in gameModel: GameModel?) -> CombatResult {

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
        let attackerStrength = attacker.attackStrength(against: defender, or: nil, on: defenderTile, in: gameModel)
            let defenderStrength = defender.defensiveStrength(against: attacker, or: nil, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        // defender strikes back
        let attackerStrength2 = defender.attackStrength(against: attacker, or: nil, on: attackerTile, in: gameModel)
            let defenderStrength2 = attacker.defensiveStrength(against: defender, or: nil, on: attackerTile, ranged: true, in: gameModel)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2

        var attackerDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) /* * Double.random(in: 0.8..<1.2)*/))

        if attackerDamage < 0 {
            attackerDamage = 0
        }

        // no damage for attacker, no suppression to cities
        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: attackerDamage
        )
        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }

    // MARK: melee attackes

    // CvUnitCombat::Attack
    @discardableResult static func doMeleeAttack(between attacker: AbstractUnit?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let activePlayer = gameModel.activePlayer() else {
            fatalError("cant get activePlayer")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker unit")
        }

        guard let defender = defender else {
            fatalError("cant get defender unit")
        }

        guard let attackerTile = gameModel.tile(at: attacker.location) else {
            fatalError("cant get attackerTile")
        }

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        guard let attackerPlayer = attacker.player else {
            fatalError("cant get attacker player")
        }

        guard let defenderPlayer = defender.player else {
            fatalError("cant get defender player")
        }

        // Unit that attacks loses his Fort bonus
        attacker.doMobilize(in: gameModel)

        attacker.automate(with: .none, in: gameModel)
        defender.automate(with: .none, in: gameModel)

        attacker.setMadeAttack(to: true)

        guard !attacker.isDelayedDeath() && !defender.isDelayedDeath() else {
            fatalError("Trying to battle and one of the units is already dead!")
        }

        // attacker strikes
        let attackerStrength = attacker.attackStrength(against: defender, or: nil, on: defenderTile, in: gameModel)
        let defenderStrength = defender.defensiveStrength(against: attacker, or: nil, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        var attackerDamage: Int = 0

        if defender.canDefend() {

            // defender strikes back
            let attackerStrength2 = defender.attackStrength(against: attacker, or: nil, on: attackerTile, in: gameModel)
            let defenderStrength2 = attacker.defensiveStrength(against: defender, or: nil, on: attackerTile, ranged: true, in: gameModel)

            let defenderStrengthDifference = attackerStrength2 - defenderStrength2

            attackerDamage = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) * Double.random(in: 0.8..<1.2)))

            if attackerDamage < 0 {
                attackerDamage = 0
            }
        } else {
            // kill the unit (civilian?)
            defender.doKill(delayed: false, by: attackerPlayer, in: gameModel)

            if let notification = defenderPlayer.notifications() {
                notification.add(notification: .unitDied(location: defender.location))
            }

            // Move forward
            if attacker.canMove(into: defenderTile.point, options: MoveOptions.none, in: gameModel) {
                // attacker.doMove(on: defenderTile.point, in: gameModel)
                attacker.queueMoveForVisualization(from: attacker.location, to: defenderTile.point, in: gameModel)
                attacker.doMoveOnPath(towards: defenderTile.point, previousETA: 0, buildingRoute: false, in: gameModel)
            }
        }

        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: attackerDamage
        )

        // apply damage
        attacker.add(damage: attackerDamage)
        defender.add(damage: defenderDamage)

        // experience
        let attackerBaseExperience: Double = 5.0 /* EXPERIENCE_ATTACKING_UNIT_MELEE */
        var attackerExperienceModifier: Double = 1.0

        // kabul suzerain bonus
        if attackerPlayer.isSuzerain(of: .kabul, in: gameModel) {
            // Your units receive double experience from battles they initiate.
            attackerExperienceModifier += 1.0
        }
        attackerExperienceModifier += attacker.experienceModifier()

        attacker.changeExperience(by: Int(attackerBaseExperience * attackerExperienceModifier), in: gameModel)

        let defenderBaseExperience: Double = 4.0/* EXPERIENCE_DEFENDING_UNIT_MELEE */
        var defenderExperienceModifier: Double = 1.0
        defenderExperienceModifier += defender.experienceModifier()
        defender.changeExperience(by: Int(defenderBaseExperience * defenderExperienceModifier), in: gameModel)

        // add archaeological record (only melee combat)
        defenderTile.addArchaeologicalRecord(with: .battleMelee, era: gameModel.worldEra(), leader1: attacker.leader, leader2: defender.leader)

        // Attacker died
        if attacker.healthPoints() <= 0 {

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: attackerTile.point,
                    type: .unitDiedAttacking(
                        attackerName: attacker.name(),
                        defenderName: defender.name(),
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .enemyUnitDiedAttacking(
                        attackerName: attacker.name(),
                        attackerPlayer: attacker.player,
                        defenderName: defender.name(),
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            attacker.doKill(delayed: false, by: nil, in: gameModel)
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: true, in: gameModel)

        } else if defender.healthPoints() <= 0 { // Defender died

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitDestroyedEnemyUnit(
                        attackerName: attacker.name(),
                        attackerDamage: attackerDamage,
                        defenderName: defender.name()
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitDiedDefending(
                        attackerName: attacker.name(),
                        attackerPlayer: attacker.player,
                        attackerDamage: attackerDamage,
                        defenderName: defender.name()),
                    delay: 3
                )
            }

            if let notifications = defender.player?.notifications() {
                notifications.add(notification: .unitDied(location: defenderTile.point))
            }

            // Wolin - suzerain bonus:
            // Receive [GreatGeneral] Great General points when a land unit defeats a major or minor civilization's unit and
            // receive [GreatAdmiral] Great Admiral points when a naval unit defeats a major or minor civilization's unit equal
            // to 25% of the opposing unit's strength (Standard Speed).
            if !defenderPlayer.isBarbarian() {
                if attackerPlayer.isSuzerain(of: .wolin, in: gameModel) {
                    if attacker.domain() == .land {
                        attackerPlayer.greatPeople?.add(points: GreatPersonPoints(greatGeneral: defenderDamage / 4))
                    } else if attacker.domain() == .sea {
                        attackerPlayer.greatPeople?.add(points: GreatPersonPoints(greatAdmiral: defenderDamage / 4))
                    }
                }
            }

            if attacker.type == .slinger {
                guard let attackerTechs = attackerPlayer.techs else {
                    fatalError("cant get attacker player techs")
                }

                if !attackerTechs.eurekaTriggered(for: .archery) {
                    attackerTechs.triggerEureka(for: .archery, in: gameModel)
                }
            }

            defender.doKill(delayed: false, by: attacker.player, in: gameModel)
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: true, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)

            // Move forward
            if attacker.canMove(into: defenderTile.point, options: MoveOptions.none, in: gameModel) {
                attacker.queueMoveForVisualization(from: attacker.location, to: defenderTile.point, in: gameModel)
                attacker.doMoveOnPath(towards: defenderTile.point, previousETA: 0, buildingRoute: false, in: gameModel)
            }

        } else {

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitAttackingWithdraw(
                        attackerName: attacker.name(),
                        attackerDamage: attackerDamage,
                        defenderName: defender.name(),
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .enemyAttackingWithdraw(
                        attackerName: attacker.name(),
                        attackerDamage: attackerDamage,
                        defenderName: defender.name(),
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)
        }

        // If a Unit loses his moves after attacking, do so
        if !attacker.canMoveAfterAttacking() {
            attacker.finishMoves()
            // GC.GetEngineUserInterface()->changeCycleSelectionCounter(1);
        }

        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }

    @discardableResult static func doMeleeAttack(between attacker: AbstractUnit?, and defender: AbstractCity?, in gameModel: GameModel?) -> CombatResult {

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

        guard let attackerPlayer = attacker.player else {
            fatalError("cant get attacker player")
        }

        guard let attackerTile = gameModel.tile(at: attacker.location) else {
            fatalError("cant get attackerTile")
        }

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        // Unit that attacks loses his Fort bonus
        attacker.doMobilize(in: gameModel)

        attacker.automate(with: .none, in: gameModel)

        attacker.setMadeAttack(to: true)

        guard !attacker.isDelayedDeath() else {
            fatalError("Trying to battle and the attacker unit is already dead!")
        }

        // attacker strikes
        let attackerStrength = attacker.attackStrength(against: nil, or: defender, on: defenderTile, in: gameModel)
        let defenderStrength = defender.defensiveStrength(against: attacker, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        var attackerDamage: Int = 0

        // defender strikes back
        let attackerStrength2 = defender.combatStrength(against: attacker, in: gameModel)
        let defenderStrength2 = attacker.defensiveStrength(against: nil, or: defender, on: attackerTile, ranged: true, in: gameModel)

        let defenderStrengthDifference = attackerStrength2 - defenderStrength2

        attackerDamage = Int(30.0 * pow(M_E, 0.04 * Double(defenderStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if attackerDamage < 0 {
            attackerDamage = 0
        }

        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: attackerDamage
        )

        // apply damage
        attacker.add(damage: attackerDamage)
        defender.add(damage: defenderDamage)

        // experience
        let attackerBaseExperience: Double = 6.0 /* EXPERIENCE_ATTACKING_CITY_MELEE */
        var attackerExperienceModifier: Double = 1.0

        // kabul suzerain bonus
        if attackerPlayer.isSuzerain(of: .kabul, in: gameModel) {
            // Your units receive double experience from battles they initiate.
            attackerExperienceModifier += 1.0
        }
        attackerExperienceModifier += attacker.experienceModifier()

        attacker.changeExperience(by: Int(attackerBaseExperience * attackerExperienceModifier), in: gameModel)

        // Attacker died
        if attacker.healthPoints() <= 0 {

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: attackerTile.point,
                    type: .unitDiedAttacking(
                        attackerName: attacker.name(),
                        defenderName: defender.name,
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .enemyUnitDiedAttacking(
                        attackerName: attacker.name(),
                        attackerPlayer: attacker.player,
                        defenderName: defender.name,
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            attacker.doKill(delayed: false, by: nil, in: gameModel)
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: true, in: gameModel)

        } else if defender.healthPoints() <= 0 { // city has been conquered

            // handle conquest of city
            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .conqueredEnemyCity(
                        attackerName: attacker.name(),
                        attackerDamage: attackerDamage,
                        cityName: defender.name
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .cityCapturedByEnemy(
                        attackerName: attacker.name(),
                        attackerPlayer: attackerPlayer,
                        attackerDamage: attackerDamage,
                        cityName: defender.name
                    ),
                    delay: 3
                )
            }

            if let notifications = defender.player?.notifications() {
                notifications.add(notification: .cityLost(location: defenderTile.point))
            }

            attacker.player?.acquire(city: defender, conquest: true, gift: false, in: gameModel)
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)

            // Move forward
            if attacker.canMove(into: defenderTile.point, options: MoveOptions.none, in: gameModel) {
                attacker.queueMoveForVisualization(from: attacker.location, to: defenderTile.point, in: gameModel)
                attacker.doMoveOnPath(towards: defenderTile.point, previousETA: 0, buildingRoute: false, in: gameModel)
            }

            // new owner can now decide what to do with this city
            if attackerPlayer.isHuman() {
                attackerPlayer.notifications()?.add(notification: .cityAcquired(cityName: defender.name, location: defenderTile.point))
            } else {
                // ai players always keep conquered city for now
            }

        } else {

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitAttackingWithdraw(
                        attackerName: attacker.name(),
                        attackerDamage: attackerDamage,
                        defenderName: defender.name,
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .enemyAttackingWithdraw(
                        attackerName: attacker.name(),
                        attackerDamage: attackerDamage,
                        defenderName: defender.name,
                        defenderDamage: defenderDamage
                    ),
                    delay: 3
                )
            }

            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)
        }

        // If a Unit loses his moves after attacking, do so
        if !attacker.canMoveAfterAttacking() {
            attacker.finishMoves()
            // GC.GetEngineUserInterface()->changeCycleSelectionCounter(1);
        }

        return CombatResult(defenderDamage: defenderDamage, attackerDamage: attackerDamage, value: value)
    }

    // MARK: ranged attackes

    @discardableResult static func doRangedAttack(between attacker: AbstractCity?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

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

        guard let attackerPlayer = attacker.player else {
            fatalError("cant get attacker player")
        }

        /*guard let attackerTile = gameModel.tile(at: attacker.location) else {
            fatalError("cant get attackerTile")
        }*/

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        defender.automate(with: .none, in: gameModel)

        attacker.setMadeAttack(to: true)

        // attacker strikes
        let attackerStrength = attacker.rangedCombatStrength(against: defender, on: defenderTile)
        let defenderStrength = defender.defensiveStrength(against: nil, or: attacker, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: 0
        )

        // apply damage
        defender.add(damage: defenderDamage)

        if defender.healthPoints() <= 0 { // Defender died

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitDestroyedEnemyUnit(
                        attackerName: attacker.name,
                        attackerDamage: 0,
                        defenderName: defender.name()
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitDiedDefending(
                        attackerName: attacker.name,
                        attackerPlayer: attackerPlayer,
                        attackerDamage: 0,
                        defenderName: defender.name()
                    ),
                    delay: 3
                )
            }

            if let notifications = defender.player?.notifications() {
                notifications.add(notification: .unitDied(location: defenderTile.point))
            }

            defender.doKill(delayed: false, by: attacker.player, in: gameModel)
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: true, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)
        } else {
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)
        }

        return CombatResult(defenderDamage: defenderDamage, attackerDamage: 0, value: value)
    }

    @discardableResult static func doRangedAttack(between attacker: AbstractUnit?, and defender: AbstractUnit?, in gameModel: GameModel?) -> CombatResult {

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
            fatalError("cant get defender unit")
        }

        guard let attackerPlayer = attacker.player else {
            fatalError("cant get attacker player")
        }

        guard let defenderPlayer = defender.player else {
            fatalError("cant get defender player")
        }

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        defender.automate(with: .none, in: gameModel)

        attacker.setMadeAttack(to: true)

        // attacker strikes
        let attackerStrength = attacker.rangedCombatStrength(against: defender, or: nil, on: defenderTile, attacking: true, in: gameModel)
        let defenderStrength = defender.defensiveStrength(against: attacker, or: nil, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: 0
        )

        // apply damage
        defender.add(damage: defenderDamage)

        if defender.healthPoints() <= 0 { // Defender died

            if activePlayer.isEqual(to: attacker.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitDestroyedEnemyUnit(
                        attackerName: attacker.name(),
                        attackerDamage: 0,
                        defenderName: defender.name()
                    ),
                    delay: 3
                )
            }

            if activePlayer.isEqual(to: defender.player) {
                gameModel.userInterface?.showTooltip(
                    at: defenderTile.point,
                    type: .unitDiedDefending(
                        attackerName: attacker.name(),
                        attackerPlayer: attacker.player,
                        attackerDamage: 0,
                        defenderName: defender.name()
                    ),
                    delay: 3
                )
            }

            if let notifications = defender.player?.notifications() {
                notifications.add(notification: .unitDied(location: defenderTile.point))
            }

            // Wolin - suzerain bonus:
            // Receive [GreatGeneral] Great General points when a land unit defeats a major or minor civilization's unit and
            // receive [GreatAdmiral] Great Admiral points when a naval unit defeats a major or minor civilization's unit equal
            // to 25% of the opposing unit's strength (Standard Speed).
            if !defenderPlayer.isBarbarian() {
                if attackerPlayer.isSuzerain(of: .wolin, in: gameModel) {
                    if attacker.domain() == .land {
                        attackerPlayer.greatPeople?.add(points: GreatPersonPoints(greatGeneral: defenderDamage / 4))
                    } else if attacker.domain() == .sea {
                        attackerPlayer.greatPeople?.add(points: GreatPersonPoints(greatAdmiral: defenderDamage / 4))
                    }
                }
            }

            defender.doKill(delayed: false, by: attacker.player, in: gameModel)
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: true, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)
        } else {
            defender.player?.updateWarWeariness(against: attacker.player, at: defender.location, killed: false, in: gameModel)
            attacker.player?.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)
        }

        // experience
        let attackerBaseExperience: Double = 2.0 /* EXPERIENCE_ATTACKING_UNIT_RANGED */
        var attackerExperienceModifier: Double = 1.0

        // kabul suzerain bonus
        if attackerPlayer.isSuzerain(of: .kabul, in: gameModel) {
            // Your units receive double experience from battles they initiate.
            attackerExperienceModifier += 1.0
        }
        attackerExperienceModifier += attacker.experienceModifier()

        attacker.changeExperience(by: Int(attackerBaseExperience * attackerExperienceModifier), in: gameModel)

        if !attacker.canMoveAfterAttacking() {
            attacker.finishMoves()
        }

        return CombatResult(defenderDamage: defenderDamage, attackerDamage: 0, value: value)
    }

    @discardableResult static func doRangedAttack(between attacker: AbstractUnit?, and defender: AbstractCity?, in gameModel: GameModel?) -> CombatResult {

        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }

        guard let attacker = attacker else {
            fatalError("cant get attacker")
        }

        guard let defender = defender else {
            fatalError("cant get city")
        }

        guard let attackerPlayer = attacker.player else {
            fatalError("cant get attacker player")
        }

        guard let defenderTile = gameModel.tile(at: defender.location) else {
            fatalError("cant get defenderTile")
        }

        attacker.setMadeAttack(to: true)

        // attacker strikes
        let attackerStrength = attacker.rangedCombatStrength(against: nil, or: defender, on: defenderTile, attacking: true, in: gameModel)
        let defenderStrength = defender.defensiveStrength(against: nil, on: defenderTile, ranged: false, in: gameModel)
        let attackerStrengthDifference = attackerStrength - defenderStrength

        var defenderDamage: Int = Int(30.0 * pow(M_E, 0.04 * Double(attackerStrengthDifference) * Double.random(in: 0.8..<1.2)))

        if defenderDamage < 0 {
            defenderDamage = 0
        }

        let value = Combat.evaluateResult(
            defenderHealth: defender.healthPoints(),
            defenderDamage: defenderDamage,
            attackerHealth: attacker.healthPoints(),
            attackerDamage: 0
        )

        // apply damage
        defender.add(damage: defenderDamage)

        // experience
        let attackerBaseExperience: Double = 2.0 /* EXPERIENCE_ATTACKING_CITY_RANGED */
        var attackerExperienceModifier: Double = 1.0

        // kabul suzerain bonus
        if attackerPlayer.isSuzerain(of: .kabul, in: gameModel) {
            // Your units receive double experience from battles they initiate.
            attackerExperienceModifier += 1.0
        }
        attackerExperienceModifier += attacker.experienceModifier()

        attacker.changeExperience(by: Int(attackerBaseExperience * attackerExperienceModifier), in: gameModel)

        // special handling: city cannot be destroyed by bombarding
        if defender.healthPoints() <= 0 {
            defender.set(healthPoints: 10)
        }

        defender.player?.updateWarWeariness(against: attackerPlayer, at: defender.location, killed: false, in: gameModel)
        attackerPlayer.updateWarWeariness(against: defender.player, at: defender.location, killed: false, in: gameModel)

        if !attacker.canMoveAfterAttacking() {
            attacker.finishMoves()
        }

        return CombatResult(defenderDamage: defenderDamage, attackerDamage: 0, value: value)
    }
}
