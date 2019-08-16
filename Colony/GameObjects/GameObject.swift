//
//  GameObject.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class GameObject: Decodable {

    static let idleActionKey: String = "idleActionKey"
    static let keyDictName: String = "name"
    static let alphaVisible: CGFloat = 1.0
    static let alphaInvisible: CGFloat = 0.0

    let identifier: String
    let type: GameObjectType

    var position: HexPoint {
        didSet {
            self.delegate?.moved(object: self)
        }
    }
    var state: GameObjectAIState = GameObjectAIState.idleState()
    var civilization: Civilization?

    var canMoveByUserInput: Bool = false
    var movementType: GameObjectMoveType = .immobile

    var spriteName: String

    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?

    var delegate: GameObjectDelegate?

    var lastTime: CFTimeInterval = 0
    var animationSpeed = 2.0

    var sight: Int
    var strength: Int = 10 // FIXME: from unit type
    var suppression: Int = 0
    var experience: Int = 0 // untrained
    var entrenchment: Int = 0

    var dict: [String: Any] = [:]

    // usecases
    let userUsecase: UserUsecase?

    // internal UI elements
    private var sprite: SKSpriteNode
    private var pathSpriteBuffer: [SKSpriteNode] = []
    private var nameLabel: SKLabelNode?
    private var nameBackground: SKSpriteNode?
    private var unitIndicator: UnitIndicator?

    enum CodingKeys: String, CodingKey {
        case identifier
        case type
        case position
        case state
        case civilization

        case dict // for extra properties
    }

    init(with identifier: String, type: GameObjectType, at point: HexPoint, spriteName: String, anchorPoint: CGPoint, civilization: Civilization?, sight: Int) {

        self.identifier = identifier
        self.type = type
        self.position = point
        self.civilization = civilization

        self.spriteName = spriteName
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: self.position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = anchorPoint

        self.sight = sight

        self.userUsecase = UserUsecase()
    }

    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.identifier = try values.decode(String.self, forKey: .identifier)
        self.type = try values.decode(GameObjectType.self, forKey: .type)
        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.state = try values.decode(GameObjectAIState.self, forKey: .state)
        self.civilization = try values.decodeIfPresent(Civilization.self, forKey: .civilization)

        self.spriteName = ""
        let emptyTexture = SKTexture()
        self.sprite = SKSpriteNode(texture: emptyTexture, size: CGSize(width: 48, height: 48))
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: self.position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.50)

        self.sight = 0

        self.dict = try values.decodeIfPresent([String: Any].self, forKey: .dict) ?? [:]

        self.userUsecase = UserUsecase()
    }

    // MARK: methods

    func show() {

        self.sprite.alpha = GameObject.alphaVisible
    }

    func hide() {

        self.sprite.alpha = GameObject.alphaInvisible
    }

    func addTo(node parent: SKNode) {

        parent.addChild(self.sprite)
    }

    func removeFromParent() {

        self.sprite.removeFromParent()
    }

    /// used to change the zPosition - default is GameScene.Constants.ZLevels.sprite
    func set(zPosition: CGFloat) {

        self.sprite.zPosition = zPosition
    }

    func showUnitIndicator() {

        if self.unitIndicator != nil {
            self.unitIndicator?.removeFromParent()
        }

        guard let civilization = self.civilization else {
            fatalError("can't show unit indicator for non civilization units")
        }

        self.unitIndicator = UnitIndicator(civilization: civilization, unitType: self.type)
        self.unitIndicator?.anchorPoint = CGPoint(x: 0.0, y: 0.1)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite + 0.1
        if let unitIndicator = self.unitIndicator {
            self.sprite.addChild(unitIndicator)
        }
    }

    func showCity(named name: String) {

        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameBackground?.removeFromParent()
        }

        let texture = SKTexture(imageNamed: "city_label_background")
        self.nameBackground = SKSpriteNode(texture: texture, size: CGSize(width: 48, height: 48))
        self.nameBackground?.zPosition = GameScene.Constants.ZLevels.cityName - 0.1
        self.nameBackground?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        if let nameBackground = self.nameBackground {
            self.sprite.addChild(nameBackground)
        }

        self.nameLabel = SKLabelNode(text: name)
        self.nameLabel?.fontSize = 8
        self.nameLabel?.position = CGPoint(x: 24, y: 0)
        self.nameLabel?.zPosition = GameScene.Constants.ZLevels.cityName
        self.nameLabel?.fontName = Formatters.Fonts.systemFontBoldFamilyname

        if let nameLabel = self.nameLabel {
            self.sprite.addChild(nameLabel)
        }
    }

    private func animate(to hex: HexPoint, on atlas: GameObjectAtlas?, completion block: @escaping () -> Swift.Void) {

        if let atlas = atlas {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let walkFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: animationSpeed / Double(walkFrames.count * 3))

            let move = SKAction.move(to: HexMapDisplay.shared.toScreen(hex: hex), duration: walk.duration)

            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                self.position = hex
                block()
            })
        }
    }

    private func walk(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {

        let direction = HexMapDisplay.shared.screenDirection(from: from, towards: to)

        switch direction {
        case .north:
            self.animate(to: to, on: self.atlasUp, completion: block)
        case .northeast, .southeast:
            self.animate(to: to, on: self.atlasRight, completion: block)
        case .south:
            self.animate(to: to, on: self.atlasDown, completion: block)
        case .southwest, .northwest:
            self.animate(to: to, on: self.atlasLeft, completion: block)
        }
    }

    func clearPathSpriteBuffer() {

        for sprite in self.pathSpriteBuffer {
            sprite.removeFromParent()
        }
    }

    func show(path: HexPath) {

        self.clearPathSpriteBuffer()

        guard path.count > 1 else {
            return
        }

        let firstItem = path[0]
        let secondItem = path[1]

        if let dir = firstItem.direction(towards: secondItem) {
            let textureName = "path-start-\(dir.short)"

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexMapDisplay.shared.toScreen(hex: firstItem)
            pathSprite.zPosition = GameScene.Constants.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.sprite.parent?.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }

        for i in 1..<path.count - 1 {
            let previousItem = path[i - 1]
            let currentItem = path[i]
            let nextItem = path[i + 1]

            if let dir = currentItem.direction(towards: previousItem), let dir2 = currentItem.direction(towards: nextItem) {

                var textureName = "path-\(dir.short)-\(dir2.short)"
                if dir.rawValue > dir2.rawValue {
                    textureName = "path-\(dir2.short)-\(dir.short)"
                }

                let pathSprite = SKSpriteNode(imageNamed: textureName)
                pathSprite.position = HexMapDisplay.shared.toScreen(hex: currentItem)
                pathSprite.zPosition = GameScene.Constants.ZLevels.path
                pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                self.sprite.parent?.addChild(pathSprite)

                self.pathSpriteBuffer.append(pathSprite)
            }
        }

        let secondlastItem = path[path.count - 2]
        let lastItem = path[path.count - 1]

        if let dir = lastItem.direction(towards: secondlastItem) {
            let textureName = "path-start-\(dir.short)"

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexMapDisplay.shared.toScreen(hex: lastItem)
            pathSprite.zPosition = GameScene.Constants.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.sprite.parent?.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }
    }

    func idle() {

        self.clearPathSpriteBuffer()
        self.state = GameObjectAIState.idleState()

        if let atlas = self.atlasIdle {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let idleFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: (animationSpeed / 4.0) / Double(idleFrames.count)))

            self.sprite.run(idleAnimation, withKey: GameObject.idleActionKey, completion: { })
        }
    }

    func walk(on path: HexPath) {

        guard !path.isEmpty else {
            self.state.transitioning = .ended
            self.clearPathSpriteBuffer()
            return
        }

        self.state.transitioning = .running

        self.sprite.removeAction(forKey: GameObject.idleActionKey)

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        if let civilization = self.civilization {
            if civilization == currentUserCivilization {
                self.show(path: HexPath(point: self.position, path: path))
            }
        }

        if let point = path.first {
            let pathWithoutFirst = path.pathWithoutFirst()

            self.walk(from: self.position, to: point, completion: {
                self.walk(on: pathWithoutFirst)
            })
        }
    }

    func stepOnWater(towards point: HexPoint, in game: Game?) {

        guard let waterNeighbors = game?.neighborsInWater(of: point) else {
            return
        }

        var bestWaterNeighbor = waterNeighbors.first!
        var bestDistance: Int = Int.max

        for waterNeighbor in waterNeighbors {
            let neighborDistance = waterNeighbor.distance(to: point) + Int.random(number: 1)
            if neighborDistance < bestDistance {
                bestWaterNeighbor = waterNeighbor
                bestDistance = neighborDistance
            }
        }

        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = game?.pathfinderDataSource(for: self.movementType, ignoreSight: true)

        if let path = pathFinder.shortestPath(fromTileCoord: self.position, toTileCoord: bestWaterNeighbor) {
            self.walk(on: path)
        }
    }

    func run(_ action: SKAction!, withKey key: String!, completion block: (() -> Void)?) {

        self.sprite.run(action, withKey: key, completion: block)
    }

    func tilesInSight() -> HexArea {

        return HexArea(center: self.position, radius: self.sight)
    }

    // MARK: game logic

    func update(in game: Game?) {

        switch self.state.transitioning {

        case .began:
            self.handleBeganState(in: game)
        case .running:
            break
        case .ended:
            self.handleEndedState(in: game)
        }
    }

    func handleBeganState(in game: Game?) { }
    func handleEndedState(in game: Game?) { }

    func dismiss() {
    }
}

extension GameObject: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.type, forKey: .type)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.civilization, forKey: .civilization)
        try container.encode(self.dict, forKey: .dict)
    }
}

extension GameObject: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
        hasher.combine(self.type)
    }
}

extension GameObject: Equatable {

    static func == (lhs: GameObject, rhs: GameObject) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct BattleResult: OptionSet {

    let rawValue: Int
    
    static let attackBrokenUp  = BattleResult(rawValue: 1 << 0)
    static let attackerKilled = BattleResult(rawValue: 1 << 1)
    static let attackerSuppressed  = BattleResult(rawValue: 1 << 2)
    
    static let defenderKilled = BattleResult(rawValue: 1 << 3)
    static let defenderSuppressed = BattleResult(rawValue: 1 << 4)
    
    static let ruggedDefense = BattleResult(rawValue: 1 << 5)
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

extension GameObject {

    var currentStrength: Int {

        return self.strength - self.suppression
    }
    
    func apply(damage: Int, suppression: Int) {
        
        self.strength -= damage
        self.suppression += suppression
        
        if self.strength <= 0 {
            self.strength = 0
            self.delegate?.killed(object: self)
        }
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
    static func getDamageForAttack(from attacker: GameObject?, and defender: GameObject?, attackType: AttackType, real: Bool, ruggedDefense: Bool, in game: Game?) -> (Int, Int) {

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
    
    /// Check if unit may activly attack (unit initiated attack) or
    /// passivly attack (target initated attack, unit defenses) the target.
    static func checkAttack(from attacker: GameObject?, and defender: GameObject?, attackType: AttackType, in game: Game?) -> Bool {
        
        guard let game = game else {
            fatalError("can't get game")
        }
        
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

    static func applyDamage() {

    }

    static func battle(between attacker: GameObject?, and defender: GameObject?, attackType: AttackType, real: Bool = true, in game: Game?) -> BattleResult {

        guard let game = game else {
            fatalError("can't get game")
        }

        guard let attackerUnit = attacker, let attackerProperties = attackerUnit.type.properties else {
            fatalError("Can't get attacker")
        }

        guard let defenderUnit = defender, let defenderProperties = defenderUnit.type.properties else {
            fatalError("Can't get defender")
        }

        guard let attackerTerrain = game.terrain(at: attackerUnit.position) else {
            fatalError("Can't get attacker terrain")
        }

        guard let defenderTerrain = game.terrain(at: defenderUnit.position) else {
            fatalError("Can't get defender terrain")
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
        var result: BattleResult = []
        var defenderDamage: Int = 0
        var defenderSuppression: Int = 0
        var attackerDamage: Int = 0
        var attackerSuppression: Int = 0

        /* the one with the highest initiative begins first if not defensive fire or artillery */
        switch strikeOrder {

        case .bothStrike:
            /* both strike at the same time */
            (defenderDamage, defenderSuppression) = GameObject.getDamageForAttack(from: attacker, and: defender, attackType: attackType, real: real, ruggedDefense: false, in: game)

            if GameObject.checkAttack(from: defender, and: attacker, attackType: .passive, in: game) {
                (attackerDamage, attackerSuppression) = GameObject.getDamageForAttack(from: attacker, and: defender, attackType: .passive, real: real, ruggedDefense: false, in: game)
            }
            
            attackerUnit.apply(damage: attackerDamage, suppression: attackerSuppression)
            defenderUnit.apply(damage: defenderDamage, suppression: defenderSuppression)
            break
        case .attackerStrikesFirst:
            /* unit strikes first */
            (defenderDamage, defenderSuppression) = GameObject.getDamageForAttack(from: attacker, and: defender, attackType: attackType, real: real, ruggedDefense: false, in: game)
            defenderUnit.apply(damage: defenderDamage, suppression: defenderSuppression)
            
            if GameObject.checkAttack(from: defender, and: attacker, attackType: .passive, in: game) && attackType != .defensive {
                (attackerDamage, attackerSuppression) = GameObject.getDamageForAttack(from: attacker, and: defender, attackType: .passive, real: real, ruggedDefense: false, in: game)
                attackerUnit.apply(damage: attackerDamage, suppression: attackerSuppression)
            }
        case .defenderStrikesFirst:
            /* target strikes first */
            if GameObject.checkAttack(from: defender, and: attacker, attackType: .passive, in: game) {
                (attackerDamage, attackerSuppression) = GameObject.getDamageForAttack(from: defender, and: attacker, attackType: .passive, real: real, ruggedDefense: false, in: game)
                attackerUnit.apply(damage: attackerDamage, suppression: attackerSuppression)
                
                if attackerUnit.strength <= 0 {
                    result.insert(BattleResult.attackBrokenUp)
                }
            }
            
            if attackerUnit.strength > 0 {
                (defenderDamage, defenderSuppression) = GameObject.getDamageForAttack(from: attacker, and: defender, attackType: attackType, real: real, ruggedDefense: false, in: game)
                defenderUnit.apply(damage: defenderDamage, suppression: defenderSuppression)
            }
        }

        /* check return value */
        if attackerUnit.strength <= 0 {
            result.insert(BattleResult.attackerKilled)
        } else if attackerUnit.currentStrength <= 0 {
            result.insert(BattleResult.attackerSuppressed)
        }
        
        if defenderUnit.strength <= 0 {
            result.insert(BattleResult.defenderKilled)
        } else if defenderUnit.currentStrength <= 0 {
            result.insert(BattleResult.defenderSuppressed)
        }
        
        /*if ruggedDefense {
            result.insert(BattleResult.ruggedDefense)
        }*/
        
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
            
            if attackerUnit.position.distance(to: defenderUnit.position) == 0 {
                attackerUnit.experience += 10
                defenderUnit.experience += 10
            }

        }
        
        return result
    }
}

extension GameObject: FogUnit {

    func location() -> HexPoint {
        return position
    }
}
