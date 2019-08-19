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
}

extension GameObject: FogUnit {

    func location() -> HexPoint {
        return position
    }
}
