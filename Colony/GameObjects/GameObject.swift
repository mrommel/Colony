//
//  GameObject.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

enum GameObjectType {

    // player
    case unit

    // can't be moved
    case city
    case field
    case castle

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
}

class GameObject {

    static let idleActionKey: String = "idleActionKey"
    static let focusActionKey: String = "focusActionKey"
    static let alphaVisible: CGFloat = 1.0
    static let alphaInvisible: CGFloat = 0.0

    let identifier: String
    let type: GameObjectType

    private var _connectedUnit: Unit? = nil
    private var _connectedAnimal: Animal? = nil
    private var _connectedCity: City? = nil
    private var _connectedMapItem: MapItem? = nil

    var spriteName: String

    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?

    var delegate: GameObjectDelegate?

    var lastTime: CFTimeInterval = 0
    var animationSpeed = 2.0

    // objecct animation
    var atlasExplosion: GameObjectAtlas?
    var atlasFocus: GameObjectAtlas?

    // usecases
    let userUsecase: UserUsecase?

    // internal UI elements
    private var sprite: SKSpriteNode
    private var pathSpriteBuffer: [SKSpriteNode] = []
    private var nameLabel: SKLabelNode?
    private var nameBackground: SKSpriteNode?
    private var unitTypeIndicator: UnitTypeIndicator?
    private var unitStrengthIndicator: UnitStrengthIndicator?
    private var focusNode: SKSpriteNode?

    init(with identifier: String, unit connectedUnit: Unit?, spriteName: String, anchorPoint: CGPoint) {

        self.identifier = identifier
        self.type = .unit

        self._connectedUnit = connectedUnit

        guard let position = self._connectedUnit?.position else {
            fatalError("can't get inital position")
        }

        self.spriteName = spriteName
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = anchorPoint

        self.userUsecase = UserUsecase()

        self.setupAtlases()
    }

    init(with identifier: String, animal connectedAnimal: Animal?, spriteName: String, anchorPoint: CGPoint) {

        self.identifier = identifier
        self.type = .animal

        self._connectedAnimal = connectedAnimal

        guard let position = self._connectedAnimal?.position else {
            fatalError("can't get inital position")
        }

        self.spriteName = spriteName
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = anchorPoint

        self.userUsecase = UserUsecase()

        self.setupAtlases()
    }

    init(with identifier: String, city connectedCity: City?, spriteName: String, anchorPoint: CGPoint) {

        self.identifier = identifier
        self.type = .city

        self._connectedCity = connectedCity

        guard let position = self._connectedCity?.position else {
            fatalError("can't get inital position")
        }

        self.spriteName = spriteName
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = anchorPoint

        self.userUsecase = UserUsecase()

        self.setupAtlases()
    }

    init(with identifier: String, mapItem connectedMapItem: MapItem?, spriteName: String, anchorPoint: CGPoint) {

        self.identifier = identifier
        self.type = .city

        self._connectedMapItem = connectedMapItem

        guard let position = self._connectedMapItem?.position else {
            fatalError("can't get inital position")
        }

        self.spriteName = spriteName
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = anchorPoint

        self.userUsecase = UserUsecase()

        self.setupAtlases()
    }

    // MARK: methods

    func setupAtlases() {

        self.atlasExplosion = GameObjectAtlas(atlasName: "explosion", textures: ["explosion000", "explosion001", "explosion002", "explosion003", "explosion004", "explosion005", "explosion006", "explosion007", "explosion008", "explosion009", "explosion010", "explosion011", "explosion012", "explosion013", "explosion014", "explosion015", "explosion016", "explosion017", "explosion018", "explosion019", "explosion020", "explosion021", "explosion022", "explosion023", "explosion024", "explosion025", "explosion026", "explosion027", "explosion028", "explosion029", "explosion030", "explosion031", "explosion032", "explosion033", "explosion034", "explosion035", "explosion036", "explosion037", "explosion037", "explosion039", "explosion040", "explosion041", "explosion042", "explosion043", "explosion044", "explosion045", "explosion046", "explosion047", "explosion048", "explosion049", "explosion050", "explosion051", "explosion052", "explosion053", "explosion054", "explosion055", "explosion056", "explosion057", "explosion058", "explosion059", "explosion060", "explosion061", "explosion062", "explosion063"])
        
        self.atlasFocus = GameObjectAtlas(atlasName: "focus", textures: ["focus1", "focus2", "focus3", "focus4", "focus5", "focus6", "focus6", "focus5", "focus4", "focus3", "focus2", "focus1"])
    }

    func updatePosition(to position: HexPoint) {

        if let unit = self.connectedUnit() {
            unit.position = position
            self.delegate?.moved(unit: unit)
            return
        }

        if let animal = self.connectedAnimal() {
            animal.position = position
            return
        }

        fatalError("can't move map item or city")
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

    // used to change the zPosition - default is GameScene.Constants.ZLevels.sprite
    func set(zPosition: CGFloat) {

        self.sprite.zPosition = zPosition
    }

    // MARK - connect unit

    func connectedUnit() -> Unit? {

        return self._connectedUnit
    }

    func connectedCity() -> City? {

        return self._connectedCity
    }

    func connectedAnimal() -> Animal? {

        return self._connectedAnimal
    }

    func showUnitTypeIndicator() {

        self.hideUnitTypeIndicator()

        if let unit = self.connectedUnit() {

            self.unitTypeIndicator = UnitTypeIndicator(civilization: unit.civilization, unitType: unit.unitType)
            self.unitTypeIndicator?.anchorPoint = CGPoint(x: 0.0, y: 0.1)
            self.unitTypeIndicator?.zPosition = GameScene.Constants.ZLevels.unitType
            if let unitTypeIndicator = self.unitTypeIndicator {
                self.sprite.addChild(unitTypeIndicator)
            }
        }
    }

    func hideUnitTypeIndicator() {

        if self.unitTypeIndicator != nil {
            self.unitTypeIndicator?.removeFromParent()
        }
    }

    func showUnitStrengthIndicator() {

        self.hideUnitStrengthIndicator()

        if let unit = self.connectedUnit() {
            self.unitStrengthIndicator = UnitStrengthIndicator(strength: unit.strength)
            self.unitStrengthIndicator?.position = CGPoint(x: 38, y: 5)
            self.unitStrengthIndicator?.zPosition = GameScene.Constants.ZLevels.unitStrength
            if let unitStrengthIndicator = self.unitStrengthIndicator {
                self.sprite.addChild(unitStrengthIndicator)
            }
        }
    }

    func updateUnitStrengthIndicator() {

        if let unit = self.connectedUnit() {
            self.unitStrengthIndicator?.set(strength: unit.strength)
        }
    }

    func hideUnitStrengthIndicator() {

        if self.unitStrengthIndicator != nil {
            self.unitStrengthIndicator?.removeFromParent()
        }
    }

    func showCity(named name: String) {

        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameLabel = nil
            self.nameBackground?.removeFromParent()
            self.nameBackground = nil
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
        self.nameLabel?.fontName = Formatters.Fonts.customFontBoldFamilyname

        if let nameLabel = self.nameLabel {
            self.sprite.addChild(nameLabel)
        }
    }

    func hideCityName() {

        if self.nameLabel != nil {
            self.nameLabel?.removeFromParent()
            self.nameBackground?.removeFromParent()
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
                self.updatePosition(to: hex)
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

        var costSum: Float = 0.0
        let movementInCurrentTurn = self.connectedUnit()?.movementInCurrentTurn ?? 0
        self.clearPathSpriteBuffer()

        guard path.count > 1 else {
            return
        }

        let (firstPoint, _) = path[0]
        let (secondPoint, secondCost) = path[1]
        
        let isMovementLeft = movementInCurrentTurn >= secondCost

        if let dir = firstPoint.direction(towards: secondPoint) {
            var textureName = "path-start-\(dir.short)"
            
            if !isMovementLeft {
                textureName = textureName + "-out"
            }

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexMapDisplay.shared.toScreen(hex: firstPoint)
            pathSprite.zPosition = GameScene.Constants.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.sprite.parent?.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }

        for i in 1..<path.count - 1 {
            let (previousPoint, _) = path[i - 1]
            let (currentPoint, currentCost) = path[i]
            let (nextPoint, _) = path[i + 1]

            costSum = costSum + currentCost
            let isMovementLeft = movementInCurrentTurn > costSum
            
            if let dir = currentPoint.direction(towards: previousPoint),
                let dir2 = currentPoint.direction(towards: nextPoint) {

                var textureName = "path-\(dir.short)-\(dir2.short)"
                if dir.rawValue > dir2.rawValue {
                    textureName = "path-\(dir2.short)-\(dir.short)"
                }
                
                if !isMovementLeft {
                    textureName = textureName + "-out"
                }

                let pathSprite = SKSpriteNode(imageNamed: textureName)
                pathSprite.position = HexMapDisplay.shared.toScreen(hex: currentPoint)
                pathSprite.zPosition = GameScene.Constants.ZLevels.path
                pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
                self.sprite.parent?.addChild(pathSprite)

                self.pathSpriteBuffer.append(pathSprite)
            }
        }

        let (secondlastItem, _) = path[path.count - 2]
        let (lastPoint, lastCost) = path[path.count - 1]
        
        costSum = costSum + lastCost
        let isMovementLeftLast = movementInCurrentTurn > costSum

        if let dir = lastPoint.direction(towards: secondlastItem) {
            var textureName = "path-start-\(dir.short)"
            
            if !isMovementLeftLast {
                textureName = textureName + "-out"
            }

            let pathSprite = SKSpriteNode(imageNamed: textureName)
            pathSprite.position = HexMapDisplay.shared.toScreen(hex: lastPoint)
            pathSprite.zPosition = GameScene.Constants.ZLevels.path
            pathSprite.anchorPoint = CGPoint(x: 0.0, y: 0.0)
            self.sprite.parent?.addChild(pathSprite)

            self.pathSpriteBuffer.append(pathSprite)
        }
    }

    func showTexture(named spriteName: String) {

        self.spriteName = spriteName
        let newTexture = SKTexture(imageNamed: self.spriteName)

        self.sprite.texture = newTexture
    }

    func showIdle() {

        self.clearPathSpriteBuffer()

        if let atlas = self.atlasIdle {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let idleFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: (animationSpeed / 4.0) / Double(idleFrames.count)))

            self.sprite.run(idleAnimation, withKey: GameObject.idleActionKey, completion: { })
        }
    }

    func showWalk(on path: HexPath, completion block: @escaping () -> Swift.Void) {

        guard !path.isEmpty else {
            self.clearPathSpriteBuffer()
            block()
            return
        }

        if let unit = self.connectedUnit(), let (_, cost) = path.first {
            if unit.movementInCurrentTurn < cost {
                print("movement limited")
                self.clearPathSpriteBuffer()
                return
            }
        }
        
        self.sprite.removeAction(forKey: GameObject.idleActionKey)

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        if let civilization = self.connectedUnit()?.civilization {
            if civilization == currentUserCivilization {
                self.show(path: HexPath(point: self.position, cost: 0.0, path: path))
            }
        }

        if let (point, cost) = path.first {
            let pathWithoutFirst = path.pathWithoutFirst()

            // reduce the movementInCurrentTurn
            self.connectedUnit()?.move(by: cost)
            
            self.walk(from: self.position, to: point, completion: {
                self.showWalk(on: pathWithoutFirst, completion: block)
            })
        }
    }

    func delta(in dir: HexDirection) -> CGPoint {
        
        let size = HexMapDisplay.shared.size * 2.0
        
        switch dir {
            
        case .north:
            return CGPoint(x: size.halfWidth, y: size.height - 2)
        case .northeast:
            return CGPoint(x: size.width * 0.8, y: size.height * 0.7)
        case .southeast:
            return CGPoint(x: size.width * 0.8, y: size.height * 0.3)
        case .south:
            return CGPoint(x: size.halfWidth, y: 2)
        case .southwest:
            return CGPoint(x: size.width * 0.2, y: size.height * 0.3)
        case .northwest:
            return CGPoint(x: size.width * 0.2, y: size.height * 0.7)
        }
    }
    
    func show(losses: Int) {
        
        let lossLabel = SKLabelNode(text: "-\(losses)")
        lossLabel.fontColor = .red
        lossLabel.fontSize = 12
        lossLabel.position = HexMapDisplay.shared.toScreen(hex: self.position) + self.delta(in: .northeast)
        lossLabel.zPosition = GameScene.Constants.ZLevels.cityName
        lossLabel.fontName = Formatters.Fonts.customFontBoldFamilyname
        self.sprite.parent?.addChild(lossLabel)
        
        let fadeAnimation = SKAction.fadeAlpha(to: 0.1, duration: 1)
        let moveAnimation = SKAction.moveBy(x: 0.0, y: 10, duration: 1)
        
        let removeAnimation = SKAction.run({
            lossLabel.removeFromParent()
            print("loss node removed")
        })
        
        let sequence = SKAction.sequence([SKAction.group([fadeAnimation, moveAnimation]), removeAnimation])
        
        lossLabel.run(sequence)
    }
    
    func showExplosion(in dir: HexDirection) {

        if let atlas = self.atlasExplosion {
             
            let explosionNode = SKSpriteNode(imageNamed: atlas.textures[0])
            let explosionPosition = HexMapDisplay.shared.toScreen(hex: self.position) + self.delta(in: dir)

            explosionNode.setScale(0.5)
            explosionNode.position = explosionPosition
            explosionNode.anchorPoint = .middleCenter
            explosionNode.zPosition = GameScene.Constants.ZLevels.sprite + 0.2
            self.sprite.parent?.addChild(explosionNode)
            
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let explosionFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let explosionAnimation = SKAction.animate(with: explosionFrames, timePerFrame: 3.0 / Double(explosionFrames.count))

            let removeAnimation = SKAction.run({
                explosionNode.removeFromParent()
                print("explosion node removed")
            })
            
            let sequence = SKAction.sequence([explosionAnimation, removeAnimation])
            
            explosionNode.run(sequence)
        }
    }
    
    func showExplosionDelayed(in dir: HexDirection) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
           self.showExplosion(in: dir)
        }
    }
    
    func showFocus() {
        
        if self.focusNode != nil {
            self.focusNode?.removeAction(forKey: GameObject.focusActionKey)
            self.focusNode?.removeFromParent()
            self.focusNode = nil
        }
        
        let texture = SKTexture(imageNamed: "focus1")
        self.focusNode = SKSpriteNode(texture: texture)
        self.focusNode?.position = HexMapDisplay.shared.toScreen(hex: self.position)
        self.focusNode?.zPosition = GameScene.Constants.ZLevels.focus
        self.focusNode?.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
        if let atlas = self.atlasFocus {
            
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let focusFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let focusAnimation = SKAction.repeatForever(SKAction.animate(with: focusFrames, timePerFrame: 2.0 / Double(focusFrames.count)))

            self.focusNode?.run(focusAnimation, withKey: GameObject.focusActionKey, completion: { })
        }
        
        if let focusNode = self.focusNode {
            self.sprite.parent?.addChild(focusNode)
        }
    }
    
    func hideFocus() {
        
        if self.focusNode != nil {
            self.focusNode?.removeAction(forKey: GameObject.focusActionKey)
            self.focusNode?.removeFromParent()
            self.focusNode = nil
        }
    }

    func run(_ action: SKAction!, withKey key: String!, completion block: (() -> Void)?) {

        self.sprite.run(action, withKey: key, completion: block)
    }

    func dismiss() {
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

extension GameObject: FogUnit {

    var civilization: Civilization {

        if let unit = self._connectedUnit {
            return unit.civilization
        }

        if let city = self._connectedCity {
            return city.civilization
        }

        return .none
    }

    var position: HexPoint {

        if let unit = self._connectedUnit {
            return unit.position
        }

        if let animal = self._connectedAnimal {
            return animal.position
        }

        if let city = self._connectedCity {
            return city.position
        }

        if let mapItem = self._connectedMapItem {
            return mapItem.position
        }

        fatalError("no position defined")
    }

    var sight: Int {

        if let unit = self.connectedUnit() {
            return unit.sight
        }

        if let _ = self.connectedCity() {
            return 2
        }

        /*if let animal = self.connectedAnimal() {
            return animal.sight
        }*/

        fatalError("no sight defined")
    }

    /*func location() -> HexPoint {

        if let unit = self.connectedUnit() {
            return unit.position
        }
        
        fatalError("no position defined")
    }*/
}
