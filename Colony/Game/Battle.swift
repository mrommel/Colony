//
//  Battle.swift
//  Colony
//
//  Created by Michael Rommel on 16.08.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

struct BattleResult {
    
    let defenderDamage: Int
    let defenderSuppression: Int
    let attackerDamage: Int
    let attackerSuppression: Int
    
    let options: BattleOptions
}

struct BattleOptions: OptionSet {
    
    let rawValue: Int
    
    static let attackBrokenUp  = BattleOptions(rawValue: 1 << 0)
    static let attackerKilled = BattleOptions(rawValue: 1 << 1)
    static let attackerSuppressed  = BattleOptions(rawValue: 1 << 2)
    
    static let defenderKilled = BattleOptions(rawValue: 1 << 3)
    static let defenderSuppressed = BattleOptions(rawValue: 1 << 4)
    
    static let ruggedDefense = BattleOptions(rawValue: 1 << 5)
}

enum BattleStrikeOrder {
    
    case bothStrike
    case attackerStrikesFirst
    case defenderStrikesFirst
}

enum AttackType {
    
    case passive
    case active
    case defensive
}

class Battle {
    
    let attackerUnit: GameObject
    let attackerProperties: UnitProperties
    
    let defenderUnit: GameObject
    let defenderProperties: UnitProperties
    
    let mainAttackType: AttackType
    
    weak var game: Game?
    
    init(between attacker: GameObject?, and defender: GameObject?, attackType: AttackType, in game: Game?) {
        
        guard game != nil else {
            fatalError("game is nil")
        }
        
        self.game = game
        
        guard let attackerInstance = attacker else {
            fatalError("attacker is nil")
        }
        
        self.attackerUnit = attackerInstance
        
        guard let attackerPropertiesInstance = self.attackerUnit.type.properties else {
            fatalError("attacker properties are nil")
        }
        
        self.attackerProperties = attackerPropertiesInstance
        
        guard let defenderInstance = defender else {
            fatalError("defender is nil")
        }
        
        self.defenderUnit = defenderInstance
        
        guard let defenderPropertiesInstance = self.defenderUnit.type.properties else {
            fatalError("defender properties are nil")
        }
        
        self.defenderProperties = defenderPropertiesInstance
        
        self.mainAttackType = attackType
    }
    
    // MARK: public methods
    
    func predict() -> BattleResult {
        
        // backup
        let attackerStrength = self.attackerUnit.strength
        let attackerSuppression = self.attackerUnit.suppression
        let defenderStrength = self.defenderUnit.strength
        let defenderSuppression = self.defenderUnit.suppression
        
        // run the battle
        let result = self.attack(real: false)
        
        // restore
        self.attackerUnit.strength = attackerStrength
        self.attackerUnit.suppression = attackerSuppression
        self.defenderUnit.strength = defenderStrength
        self.defenderUnit.suppression = defenderSuppression
        
        return result
    }
    
    func fight() -> BattleResult {
        
        return self.attack(real: true)
    }
    
    // MARK: private methods
    
    /// Execute a single fight (no defensive fire check) with random
    /// values. (only if 'luck' is set)
    /// If 'force_rugged is set'. Rugged defense will be forced.
    private func attack(real: Bool, forceRugged: Bool = false) -> BattleResult {
    
        guard let game = self.game else {
            fatalError("can't get game")
        }

        guard let attackerTerrain = game.terrain(at: attackerUnit.position) else {
            fatalError("Can't get attacker terrain")
        }
        
        guard let defenderTerrain = game.terrain(at: defenderUnit.position) else {
            fatalError("Can't get defender terrain")
        }
        
        var ruggedDefence = false
        
        /* check if rugged defense occurs */
        if real && self.mainAttackType == .active {
            if Battle.checkRuggedDefense(attacker: self.attackerUnit, defender: self.defenderUnit) ||
                (forceRugged && Battle.areClose(attacker: self.attackerUnit, defender: self.defenderUnit)) {
                
                let ruggedChance = Battle.ruggedDefenceChance(attacker: self.attackerUnit, defender: self.defenderUnit)
                
                if Int.random(number: 100) <= ruggedChance || forceRugged {
                    ruggedDefence = true
                }
            }
        }
        
        var attackerInitiative = min(attackerProperties.initiative, attackerTerrain.maxInitiative)
        var defenderInitiative = min(defenderProperties.initiative, defenderTerrain.maxInitiative)
        
        attackerInitiative += (attackerUnit.experience + 1) / 2
        defenderInitiative += (defenderUnit.experience + 1) / 2
        
        if real {
            attackerInitiative += Int.random(number: 3)
            defenderInitiative += Int.random(number: 3)
        }
        
        let attackerStrengthOld = attackerUnit.strength
        
        print("[GameObject]: attackerInitiative=\(attackerInitiative), defenderInitiative=\(defenderInitiative)")
        
        var strikeOrder: BattleStrikeOrder = .bothStrike
        if attackerInitiative > defenderInitiative {
            strikeOrder = .attackerStrikesFirst
        } else if attackerInitiative < defenderInitiative {
            strikeOrder = .defenderStrikesFirst
        }
        
        // combat results
        var options: BattleOptions = []
        var defenderDamage: Int = 0
        var defenderSuppression: Int = 0
        var attackerDamage: Int = 0
        var attackerSuppression: Int = 0
        
        /* the one with the highest initiative begins first if not defensive fire or artillery */
        switch strikeOrder {
            
        case .bothStrike:
            /* both strike at the same time */
            (defenderDamage, defenderSuppression) = Battle.getDamageForAttack(from: self.attackerUnit, and: self.defenderUnit, attackType: mainAttackType, real: real, ruggedDefense: ruggedDefence, in: self.game)
            
            if Battle.checkAttack(from: self.defenderUnit, and: self.attackerUnit, attackType: .passive, in: self.game) {
                (attackerDamage, attackerSuppression) = Battle.getDamageForAttack(from: self.defenderUnit, and: self.attackerUnit, attackType: .passive, real: real, ruggedDefense: ruggedDefence, in: self.game)
            }
            
            attackerUnit.apply(damage: attackerDamage, suppression: attackerSuppression)
            defenderUnit.apply(damage: defenderDamage, suppression: defenderSuppression)
            break
        case .attackerStrikesFirst:
            /* unit strikes first */
            (defenderDamage, defenderSuppression) = Battle.getDamageForAttack(from: self.attackerUnit, and: self.defenderUnit, attackType: self.mainAttackType, real: real, ruggedDefense: ruggedDefence, in: self.game)
            defenderUnit.apply(damage: defenderDamage, suppression: defenderSuppression)
            
            if Battle.checkAttack(from: self.defenderUnit, and: self.attackerUnit, attackType: .passive, in: self.game) && self.mainAttackType != .defensive {
                (attackerDamage, attackerSuppression) = Battle.getDamageForAttack(from: self.defenderUnit, and: self.attackerUnit, attackType: .passive, real: real, ruggedDefense: ruggedDefence, in: self.game)
                attackerUnit.apply(damage: attackerDamage, suppression: attackerSuppression)
            }
        case .defenderStrikesFirst:
            /* target strikes first */
            if Battle.checkAttack(from: self.defenderUnit, and: self.attackerUnit, attackType: .passive, in: self.game) {
                (attackerDamage, attackerSuppression) = Battle.getDamageForAttack(from: self.defenderUnit, and: self.attackerUnit, attackType: .passive, real: real, ruggedDefense: ruggedDefence, in: self.game)
                attackerUnit.apply(damage: attackerDamage, suppression: attackerSuppression)
                
                if attackerUnit.strength <= 0 {
                    options.insert(BattleOptions.attackBrokenUp)
                }
            }
            
            if attackerUnit.strength > 0 {
                (defenderDamage, defenderSuppression) = Battle.getDamageForAttack(from: self.attackerUnit, and: self.defenderUnit, attackType: self.mainAttackType, real: real, ruggedDefense: ruggedDefence, in: self.game)
                defenderUnit.apply(damage: defenderDamage, suppression: defenderSuppression)
            }
        }
        
        /* check return value */
        if attackerUnit.strength <= 0 {
            options.insert(BattleOptions.attackerKilled)
        } else if attackerUnit.currentStrength <= 0 {
            options.insert(BattleOptions.attackerSuppressed)
        }
        
        if defenderUnit.strength <= 0 {
            options.insert(BattleOptions.defenderKilled)
        } else if defenderUnit.currentStrength <= 0 {
            options.insert(BattleOptions.defenderSuppressed)
        }
        
        if ruggedDefence {
            options.insert(BattleOptions.ruggedDefense)
        }
        
        if real {
            /* cost ammo */
            
            /* costs attack */
            
            /* target: loose entrenchment if damage was taken or with a unit->str*10% chance */
            if defenderUnit.entrenchment > 0 && (defenderDamage > 0 || Int.random(number: 10) < attackerStrengthOld ) {
                defenderUnit.entrenchment -= 1
            }
            
            /* attacker looses entrenchment if it got hurt */
            if attackerUnit.entrenchment > 0 && attackerDamage > 0 {
                attackerUnit.entrenchment -= 1
            }
            
            /* gain experience */
            let experienceModifierAttacker = max(defenderUnit.experience - attackerUnit.experience, 1)
            attackerUnit.experience += experienceModifierAttacker * defenderDamage + attackerDamage
            
            let experienceModifierDefender = max(attackerUnit.experience - defenderUnit.experience, 1)
            defenderUnit.experience += experienceModifierDefender * attackerDamage + defenderDamage
            
            if Battle.areClose(attacker: attackerUnit, defender: defenderUnit) {
                attackerUnit.experience += 10
                defenderUnit.experience += 10
            }
        }
        
        print("[GameObject]: attackerDamage=\(attackerDamage), defenderDamage=\(defenderDamage)")

        return BattleResult(defenderDamage: defenderDamage, defenderSuppression: defenderSuppression, attackerDamage: attackerDamage, attackerSuppression: attackerSuppression, options: options)
    }
    
    /// Compute the targets rugged defense chance.
    static func ruggedDefenceChance(attacker: GameObject, defender: GameObject) -> Int {
        
        /* PG's formula is
         5% * def_entr *
         ( (def_exp_level + 2) / (atk_exp_level + 2) ) *
         ( (def_entr_rate + 1) / (atk_entr_rate + 1) ) */
        return Int( 5.0 * CGFloat(defender.entrenchment) *
            ( CGFloat(defender.experience + 2) / CGFloat(attacker.experience + 2) ) )
    }
    
    static func areClose(attacker: GameObject, defender: GameObject) -> Bool {
        return attacker.position.distance(to: defender.position) == 0
    }
    
    /// Check if target may do rugged defense
    static func checkRuggedDefense(attacker: GameObject?, defender: GameObject?) -> Bool {
        
        guard let attackerProperties = attacker?.properties else {
            return false
        }
        
        guard let defenderProperties = defender?.properties else {
            return false
        }
        
        if attackerProperties.isFlying {
            return false
        }
        
        if attackerProperties.isSwimming || defenderProperties.isSwimming {
            return false
        }
        
        /* no rugged def for pioneers and such */
        if attackerProperties.isEntrenchmentIgnore {
            return false
        }
        
        //if
        
        /*
        if (unit->sel_prop->flags & ARTILLERY ) return 0; /* no rugged def against range attack */
        if ( !unit_is_close( unit, target ) ) return 0;
        if ( target->entr == 0 ) return 0;
        
        return  true*/
        return false
    }
    
    /// Check if unit may activly attack (unit initiated attack) or
    /// passivly attack (target initated attack, unit defenses) the target.
    static func checkAttack(from attacker: GameObject?, and defender: GameObject?, attackType: AttackType, in game: Game?) -> Bool {
        
        /*guard let game = game else {
            fatalError("can't get game")
        }*/
        
        guard let attackerUnit = attacker, let attackerProperties = attackerUnit.type.properties else {
            return false
        }
        
        guard let defenderUnit = defender, let defenderProperties = defenderUnit.type.properties else {
            return false
        }
        
        /* range 0 means above unit for an aircraft */
        if attackerProperties.isFlying && !defenderProperties.isFlying {
            if attackerProperties.range == 0 && attackerUnit.position != defenderUnit.position {
                return false
            }
        }
        
        /* if the target flys and the unit is ground with a range of 0 the aircraft
         may only be harmed when above unit */
        if !attackerProperties.isFlying && defenderProperties.isFlying {
            if attackerProperties.range == 0 && attackerUnit.position != defenderUnit.position {
                return false
            }
        }
        
        /* only destroyers may harm submarines */
        /*if ( target->sel_prop->flags & DIVING && !( unit->sel_prop->flags & DESTROYER ) ) return 0;
         if ( weather_types[cur_weather].flags & NO_AIR_ATTACK ) {
         if ( unit->sel_prop->flags & FLYING ) return 0;
         if ( target->sel_prop->flags & FLYING ) return 0;
         }*/
        
        if attackType == .active {
            /* agressor */
            //if ( unit->cur_ammo <= 0 ) return 0;
            if attackerProperties.attackValue(for: defenderProperties.targetType) <= 0 {
                return false
            }
            // if ( unit->cur_atk_count == 0 ) return 0;
            if attackerUnit.position.distance(to: defenderUnit.position) > attackerProperties.range {
                return false
            }
        }
        else if attackType == .defensive {
            /* defensive fire */
            if attackerProperties.attackValue(for: defenderProperties.targetType) <= 0 {
                return false
            }
            //if ( unit->cur_ammo <= 0 ) return 0;
            //if ( ( unit->sel_prop->flags & ( INTERCEPTOR | ARTILLERY | AIR_DEFENSE ) ) == 0 ) return 0;
            //if ( target->sel_prop->flags & ( ARTILLERY | AIR_DEFENSE | SWIMMING ) ) return 0;
            if defenderProperties.isSwimming {
                return false
            }
            /*if ( unit->sel_prop->flags & INTERCEPTOR ) {
             /* the interceptor is propably not beside the attacker so the range check is different
             * can't be done here because the unit the target attacks isn't passed so
             *  unit_get_df_units() must have a look itself
             */
             }*/
            if attackerUnit.position.distance(to: defenderUnit.position) > attackerProperties.range {
                return false
            }
        } else {
            /* counter-attack */
            //if ( unit->cur_ammo <= 0 ) return 0;
            if attackerUnit.position.distance(to: defenderUnit.position) > attackerProperties.range {
                return false
            }
            if attackerProperties.attackValue(for: defenderProperties.targetType) <= 0 {
                return false
            }
            
            /* artillery may only defend against close units */
            //if ( unit->sel_prop->flags & ARTILLERY && !unit_is_close( unit, target ) ) return 0;
            
            /* you may defend against artillery only when close */
            //if ( target->sel_prop->flags & ARTILLERY && !unit_is_close( unit, target ) ) return 0;
        }
        
        return true
    }

    
    /// Compute damage/supression the target takes when unit attacks
    /// the target. No properties will be changed. If 'real' is set
    /// the dices are rolled else it's a stochastical prediction.
    /// 'aggressor' is the unit that initiated the attack, either 'unit'
    /// or 'target'. It is not always 'unit' as 'unit' and 'target are
    /// switched for get_damage depending on whether there is a striking
    /// back and who had the highest initiative.
    ///
    /// see also https://panzercorps.gamepedia.com/Combat#Suppression
    ///
    /// no close defense handled yet
    ///
    private static func getDamageForAttack(from attacker: GameObject?, and defender: GameObject?, attackType: AttackType, real: Bool, ruggedDefense: Bool, in game: Game?) -> (Int, Int) {
        
        guard let game = game else {
            fatalError("can't get game")
        }
        
        guard let attackerUnit = attacker, let attackerProperties = attackerUnit.type.properties else {
            fatalError("Can't get attacker")
        }
        
        guard let defenderUnit = defender, let defenderProperties = defenderUnit.type.properties else {
            fatalError("Can't get defender")
        }
        
        /*guard let attackerTerrain = game.terrain(at: attackerUnit.position) else {
         fatalError("Can't get attacker terrain")
         }*/
        
        guard let attackerFeatures = game.features(at: attackerUnit.position) else {
            fatalError("Can't get attacker features")
        }
        
        /*guard let defenderTerrain = game.terrain(at: defenderUnit.position) else {
         fatalError("Can't get defender terrain")
         }*/
        
        /* use PG's formula to compute the attack/defense grade*/
        /* basic attack */
        var atk_grade: Int = attackerProperties.attackValue(for: defenderProperties.targetType)
        
        /* experience */
        atk_grade += attackerUnit.experience
        
        /* counterattack of rugged defense unit? */
        if attackType == .passive && ruggedDefense {
            atk_grade += 4
        }
        
        /* basic defense */
        var def_grade: Int
        if attackerProperties.isFlying {
            def_grade = defenderProperties.airDefense
        } else {
            def_grade = defenderProperties.groundDefense
            
            /* apply close defense? */
            /*if ( unit->sel_prop->flags & INFANTRY )
             if ( !( target->sel_prop->flags & INFANTRY ) )
             if ( !( target->sel_prop->flags & FLYING ) )
             if ( !( target->sel_prop->flags & SWIMMING ) )
             {
             if ( target == aggressor )
             if ( unit->terrain->flags[cur_weather]&INF_CLOSE_DEF ) <<- city
             def_grade = target->sel_prop->def_cls;
             if ( unit == aggressor )
             if ( target->terrain->flags[cur_weather]&INF_CLOSE_DEF ) <<- city
             def_grade = target->sel_prop->def_cls;
             }*/
        }
        
        /* experience */
        def_grade += defenderUnit.experience
        
        /* attacker on a river or swamp? */
        if !attackerProperties.isFlying && !attackerProperties.isSwimming && !defenderProperties.isFlying {
            if attackerFeatures.contains(.marsh) {
                def_grade += 4
            } /*else if (unit -> terrain -> flags[cur_weather] & RIVER) { <== attack across river
             def_grade += 4
             }*/
        }
        
        /* rugged defense? */
        if attackType == .active && ruggedDefense {
            def_grade += 4
        }
        
        /* entrenchment */
        if attackerProperties.isEntrenchmentIgnore {
            def_grade += 0
        } else {
            if attackerProperties.isInfantery {
                def_grade += defenderUnit.entrenchment / 2
            } else {
                def_grade += defenderUnit.entrenchment
            }
        }
        
        /* ground => naval unit */
        if !attackerProperties.isFlying && !attackerProperties.isSwimming && defenderProperties.isSwimming {
            def_grade += 8
        }
        
        /* bad weather? */
        /*if ( unit->sel_prop->rng > 0 )
         if ( weather_types[cur_weather].flags & BAD_SIGHT ) {
         def_grade += 3;
         }*/
        
        /* initiating attack by passive artillery? */
        /*if attackType == .passive && attackerProperties.isArtillery {
         def_grade += 3;
         }*/
        
        /* infantry versus anti_tank? */
        /*if ( target->sel_prop->flags & INFANTRY )
         if ( unit->sel_prop->flags & ANTI_TANK ) {
         def_grade += 2;
         }*/
        
        /* no fuel makes attacker less effective */
        /*if ( unit_check_fuel_usage( unit ) && unit->cur_fuel == 0 ) {
         def_grade += 4;
         }*/
        
        /* attacker strength */
        var atk_strength = attackerUnit.currentStrength
        
        /*  PG's formula:
         get difference between attack and defense
         strike for each strength point with
         if ( diff <= 4 )
         D20 + diff
         else
         D20 + 4 + 0.4 * ( diff - 4 )
         suppr_fire flag set: 1-10 miss, 11-18 suppr, 19+ kill
         normal: 1-10 miss, 11-12 suppr, 13+ kill */
        let diff = max(atk_grade - def_grade, -7)
        var damage = 0
        var suppression = 0
        
        /* get the chances for suppression and kills (computed here
         to use also for debug info */
        var suppressionChance: CGFloat = 0
        var killChance: CGFloat = 0
        
        let dieModifier: CGFloat = (diff <= 4 ? CGFloat(diff) : 4.0 + 2.0 * (CGFloat(diff) - 4.0) / 5.0)
        let minRoll: CGFloat = 1.0 + dieModifier
        let maxRoll: CGFloat = 20.0 + dieModifier
        
        /* get chances for suppression and kills */
        /*if ( unit->sel_prop->flags & SUPPR_FIRE ) {
         let limit = type == .defensiveAttack ? 20 : 18
         if (limit-min_roll>=0)
         suppr_chance = 0.05*(min(limit,max_roll)-max(11,min_roll)+1);
         if (max_roll>limit)
         kill_chance = 0.05*(max_roll-max(limit+1,min_roll)+1);
         } else {*/
        
        if 12 - minRoll >= 0 {
            suppressionChance = 0.05 * (min(12, maxRoll) - max(11, minRoll) + 1)
        }
        if maxRoll > 12 {
            killChance = 0.05 * (maxRoll - max(13, minRoll) + 1)
        }
        //}
        
        suppressionChance = max(0, suppressionChance)
        killChance = max(0, killChance)
        var result: Int = 0
        
        if real {
            
            while atk_strength > 0 {
                
                atk_strength -= 1
                
                if diff <= 4 {
                    result = Int.random(number: 20) + diff
                } else {
                    result = Int.random(number: 20) + 4 + 2 * (diff - 4) / 5
                }
                
                /*if unit->sel_prop->flags & SUPPR_FIRE {
                 int limit = (type==UNIT_DEFENSIVE_ATTACK)?20:18;
                 if ( result >= 11 && result <= limit )
                 (*suppr)++;
                 else
                 if ( result >= limit+1 )
                 (*damage)++;
                 }
                 else {*/
                if result >= 11 && result <= 12 {
                    suppression += 1
                } else {
                    if result >= 13 {
                        damage += 1
                    }
                }
                //}
            }
            
        } else {
            suppression = Int(suppressionChance * CGFloat(atk_strength))
            damage = Int(killChance * CGFloat(atk_strength))
        }
        
        return (damage, suppression)
    }

}
