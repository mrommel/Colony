//
//  GameObject.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

enum GameObjectState: String, Codable {
    case idle
    case walking
}

enum GameObjectTribe: String, Codable {
    
    case player
    case enemy
    
    case reward
    case decoration
}

enum GameObjectType: String, Codable {
    case ship
    case axeman
    
    case monster
    case village
    case coin
    case obstacle // tile cannot be accessed, can't be moved
    case pirates
    
    case animal
}

/*struct MovementCosts {
    let plain: Float
    let grass: Float
    let desert: Float
    let tundra: Float
    let snow: Float
    let ocean: Float
    let shore: Float
}*/

enum GameObjectMoveType {
    
    static let impassible: Float = -1.0
    
    /// possible values
    case immobile // such as villages, coins etc
    //case swimShore
    case swimOcean
    case walk
    //case ride
    //case fly
}

class GameObject: Decodable {
    
    let idleActionKey: String = "idleActionKey"
    
    let identifier: String
    let type: GameObjectType
    
    var position: HexPoint {
        didSet {
            self.delegate?.moved(object: self)
        }
    }
    var state: GameObjectState = .idle
    var tribe: GameObjectTribe
    
    var canMoveByUserInput: Bool = false
    var movementType: GameObjectMoveType = .immobile
    
    var spriteName: String
    var sprite: SKSpriteNode
    
    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?
    
    var delegate: GameObjectDelegate?
    
    var lastTime: CFTimeInterval = 0
    var animationSpeed = 2.0
    
    let sight: Int
    
    private var pathSpriteBuffer: [SKSpriteNode] = []
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case type
        case position
        case state
        case tribe
    }
    
    init(with identifier: String, type: GameObjectType, at point: HexPoint, spriteName: String, tribe: GameObjectTribe, sight: Int) {
        self.identifier = identifier
        self.type = type
        self.position = point
        self.tribe = tribe
        
        self.spriteName = spriteName
        self.sprite = SKSpriteNode(imageNamed: spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: self.position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.50)
        
        self.sight = sight
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.identifier = try values.decode(String.self, forKey: .identifier)
        self.type = try values.decode(GameObjectType.self, forKey: .type)
        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.state = try values.decode(GameObjectState.self, forKey: .state)
        self.tribe = try values.decode(GameObjectTribe.self, forKey: .tribe)
        
        self.spriteName = ""
        self.sprite = SKSpriteNode()
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: self.position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.50)
        
        self.sight = 0
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
        
        // FIXME move to path class
        // print("path.count: \(path.count)")
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
        
        for i in 1..<path.count-1 {
            let previousItem = path[i-1]
            let currentItem = path[i]
            let nextItem = path[i+1]
            
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
        
        let secondlastItem = path[path.count-2]
        let lastItem = path[path.count-1]
        
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
    
    func walk(on path: HexPath) {
        
        guard !path.isEmpty else {
            self.idle()
            return
        }
        
        self.sprite.removeAction(forKey: idleActionKey)
        self.state = .walking
        
        if self.tribe == .player {
            self.show(path: HexPath(point: self.position, path: path))
        }
            
        if let point = path.first {
            let pathWithoutFirst = path.pathWithoutFirst()
            
            self.walk(from: self.position, to: point, completion: {
                self.walk(on: pathWithoutFirst)
            })
        }
    }
    
    func idle() {
        
        self.clearPathSpriteBuffer()
        self.state = .idle
        
        if let atlas = self.atlasIdle {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let idleFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: (animationSpeed / 4.0) / Double(idleFrames.count)))
            
            self.sprite.run(idleAnimation, withKey: idleActionKey, completion: {})
        }
    }
    
    // MARK: game logic
    
    func setup() {
    }
    
    func update(in game: Game?) {
    }
    
    func dismiss() {
    }
}

extension GameObject: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.tribe, forKey: .tribe)
    }
}

extension GameObject: FogUnit {
    
    func location() -> HexPoint {
        return position
    }
}
