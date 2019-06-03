//
//  GameObject.swift
//  Colony
//
//  Created by Michael Rommel on 30.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

enum GameObjectState {
    case idle
    case walking
}

class GameObject {
    
    let idleActionKey: String = "idleActionKey"
    
    let identifier: String
    
    var position: HexPoint
    var state: GameObjectState = .idle
    
    var sprite: SKSpriteNode
    let mapDisplay: HexMapDisplay
    
    var atlasIdle: GameObjectAtlas?
    var atlasDown: GameObjectAtlas?
    var atlasUp: GameObjectAtlas?
    var atlasRight: GameObjectAtlas?
    var atlasLeft: GameObjectAtlas?
    
    weak var fogManager: FogManager? {
        didSet {
            fogManager?.add(unit: self)
        }
    }
    
    var lastTime: CFTimeInterval = 0
    
    init(with identifier: String, at point: HexPoint, sprite: String, mapDisplay: HexMapDisplay) {
        self.identifier = identifier
        self.mapDisplay = mapDisplay
        self.position = point
        self.sprite = SKSpriteNode(imageNamed: sprite)
        self.sprite.position = mapDisplay.toScreen(hex: self.position)
        self.sprite.zPosition = GameScene.Constants.ZLevels.sprite
        self.sprite.anchorPoint = CGPoint(x: -0.25, y: -0.25)
    }
    
    private func animate(to hex: HexPoint, on atlas: GameObjectAtlas?, completion block: @escaping () -> Swift.Void) {
        
        if let atlas = atlas {
            let textureAtlasWalk = SKTextureAtlas(named: atlas.atlasName)
            let walkFrames = atlas.textures.map { textureAtlasWalk.textureNamed($0) }
            let walk = SKAction.animate(with: [walkFrames, walkFrames, walkFrames].flatMap { $0 }, timePerFrame: 2.0 / Double(walkFrames.count * 3))
            
            let move = SKAction.move(to: self.mapDisplay.toScreen(hex: hex), duration: walk.duration)
            
            let animate = SKAction.group([walk, move])
            self.sprite.run(animate, completion: {
                self.position = hex
                block()
            })
        }
    }
    
    private func walk(from: HexPoint, to: HexPoint, completion block: @escaping () -> Swift.Void) {
        
        let direction = self.mapDisplay.screenDirection(from: from, towards: to)
        
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
                self.fogManager?.move(unit: self)
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

extension GameObject: FogUnit {
    
    func location() -> HexPoint {
        return position
    }
    
    func sight() -> Int {
        //fatalError("must be overwritten")
        return 2
    }
}
