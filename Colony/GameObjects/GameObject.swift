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

    // usecases
    let userUsecase: UserUsecase?

    // internal UI elements
    private var sprite: SKSpriteNode
    private var pathSpriteBuffer: [SKSpriteNode] = []
    private var nameLabel: SKLabelNode?
    private var nameBackground: SKSpriteNode?
    private var unitTypeIndicator: UnitTypeIndicator?
    private var unitStrengthIndicator: UnitStrengthIndicator?

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
    }
    
    // MARK: methods
    
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
    
    func connectedAnimal() -> Animal? {
        
        return self._connectedAnimal
    }

    func showUnitTypeIndicator() {

        self.hideUnitTypeIndicator()
        
        if let unit = self.connectedUnit() {

            self.unitTypeIndicator = UnitTypeIndicator(civilization: unit.civilization, unitType: unit.unitType)
            self.unitTypeIndicator?.anchorPoint = CGPoint(x: 0.0, y: 0.1)
            self.unitTypeIndicator?.zPosition = GameScene.Constants.ZLevels.sprite + 0.1
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
            self.unitStrengthIndicator?.zPosition = GameScene.Constants.ZLevels.sprite + 0.1
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

        self.sprite.removeAction(forKey: GameObject.idleActionKey)

        guard let currentUserCivilization = self.userUsecase?.currentUser()?.civilization else {
            fatalError("Can't get current users civilization")
        }

        if let civilization = self.connectedUnit()?.civilization {
            if civilization == currentUserCivilization {
                self.show(path: HexPath(point: self.position, path: path))
            }
        }

        if let point = path.first {
            let pathWithoutFirst = path.pathWithoutFirst()

            self.walk(from: self.position, to: point, completion: {
                self.showWalk(on: pathWithoutFirst, completion: block)
            })
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
