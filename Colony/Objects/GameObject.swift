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
}

class GameObject: Decodable {
    
    let idleActionKey: String = "idleActionKey"
    
    let identifier: String
    
    var position: HexPoint {
        didSet {
            self.delegate?.moved(object: self)
        }
    }
    var state: GameObjectState = .idle
    var tribe: GameObjectTribe
    
    var spriteName: String
    var sprite: SKSpriteNode
    
    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?
    
    var delegate: GameObjectDelegate?
    
    var lastTime: CFTimeInterval = 0
    
    let sight: Int
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case position
        case state
        case tribe
        
        case spriteName
        case atlasIdle, atlasDown, atlasUp, atlasRight, atlasLeft
        
        case sight
    }
    
    init(with identifier: String, at point: HexPoint, spriteName: String, tribe: GameObjectTribe, sight: Int) {
        self.identifier = identifier
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
        self.position = try values.decode(HexPoint.self, forKey: .position)
        self.state = try values.decode(GameObjectState.self, forKey: .state)
        self.tribe = try values.decode(GameObjectTribe.self, forKey: .tribe)
        
        self.spriteName = try values.decode(String.self, forKey: .spriteName)
        self.sprite = SKSpriteNode(imageNamed: self.spriteName)
        self.sprite.position = HexMapDisplay.shared.toScreen(hex: self.position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.50)
        
        self.atlasIdle = try values.decode(GameObjectAtlas.self, forKey: .atlasIdle)
        self.atlasDown = try values.decode(GameObjectAtlas.self, forKey: .atlasDown)
        self.atlasUp = try values.decode(GameObjectAtlas.self, forKey: .atlasUp)
        self.atlasRight = try values.decode(GameObjectAtlas.self, forKey: .atlasRight)
        self.atlasLeft = try values.decode(GameObjectAtlas.self, forKey: .atlasLeft)
        
        self.sight = try values.decode(Int.self, forKey: .sight)
    }
    
    private func animate(to hex: HexPoint, on atlas: GameObjectAtlas?, completion block: @escaping () -> Swift.Void) {
        
        if let atlas = atlas {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let walkFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: 2.0 / Double(walkFrames.count * 3))
            
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
    
    func walk(on path: [HexPoint]) {
        
        guard !path.isEmpty else {
            self.idle()
            return
        }
        
        self.sprite.removeAction(forKey: idleActionKey)
        self.state = .walking
        
        if let point = path.first {
            let pathWithoutFirst = Array(path.suffix(from: 1))
            
            self.walk(from: self.position, to: point, completion: {
                self.walk(on: pathWithoutFirst)
            })
        }
    }
    
    func idle() {
        
        self.state = .idle
        
        if let atlas = self.atlasIdle {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let idleFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let idleAnimation = SKAction.repeatForever(SKAction.animate(with: idleFrames, timePerFrame: 0.5 / Double(idleFrames.count)))
            
            self.sprite.run(idleAnimation, withKey: idleActionKey, completion: {})
        }
    }
}

extension GameObject: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.identifier, forKey: .identifier)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.state, forKey: .state)
        try container.encode(self.tribe, forKey: .tribe)

        try container.encode(self.spriteName, forKey: .spriteName)
        
        try container.encode(self.atlasIdle, forKey: .atlasIdle)
        try container.encode(self.atlasDown, forKey: .atlasDown)
        try container.encode(self.atlasUp, forKey: .atlasUp)
        try container.encode(self.atlasRight, forKey: .atlasRight)
        try container.encode(self.atlasLeft, forKey: .atlasLeft)
        
        try container.encode(self.sight, forKey: .sight)
    }
}

extension GameObject: FogUnit {
    
    func location() -> HexPoint {
        return position
    }
}
