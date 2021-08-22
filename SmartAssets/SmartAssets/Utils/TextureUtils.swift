//
//  TextureUtils.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

public class TextureUtils {
    
    weak var gameModel: GameModel?
    var tileTextures: Array2D<TextureItem>?
    
    class TextureItem: Codable, Equatable {
        
        enum CodingKeys: CodingKey {
            case point
        }
        
        let point: HexPoint
        var terrainSprite: SKSpriteNode?
        var featureSprite: SKSpriteNode?
        var resourceSprite: SKSpriteNode?
        var resourceMarkerSprite: SKSpriteNode?
        var snowSprite: SKSpriteNode?
        var boardSprite: SKSpriteNode?
        var iceSprite: SKSpriteNode?
        var borderSprite: SKSpriteNode?
        var yieldsSprite: SKSpriteNode?
        var waterSprite: SKSpriteNode?
        var riverSprite: SKSpriteNode?
        var improvementSprite: SKSpriteNode?
        var routeSprite: SKSpriteNode?
        var hexLabel: SKLabelNode?
        
        init(point: HexPoint) {
            
            self.point = point
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.point = try container.decode(HexPoint.self, forKey: .point)
        }
        
        static func == (lhs: TextureUtils.TextureItem, rhs: TextureUtils.TextureItem) -> Bool {
            return lhs.point == rhs.point
        }
    }
    
    public init(with gameModel: GameModel?) {
        
        self.gameModel = gameModel
        
        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }
        
        let mapSize = gameModel.mapSize()
        
        self.tileTextures = Array2D<TextureItem>(width: mapSize.width(), height: mapSize.height())
        
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                self.tileTextures?[x, y] = TextureItem(point: HexPoint(x: x, y: y))
            }
        }
    }
    
    public func set(terrainSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.terrainSprite = terrainSprite
    }
    
    public func terrainSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.terrainSprite
    }
    
    public func set(snowSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.snowSprite = snowSprite
    }
    
    public func snowSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.snowSprite
    }
    
    public func set(boardSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.boardSprite = boardSprite
    }
    
    public func boardSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.boardSprite
    }
    
    public func set(featureSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.featureSprite = featureSprite
    }
    
    public func featureSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.featureSprite
    }
    
    public func set(resourceSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.resourceSprite = resourceSprite
    }
    
    public func resourceSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.resourceSprite
    }
    
    public func set(resourceMarkerSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.resourceMarkerSprite = resourceMarkerSprite
    }
    
    public func resourceMarkerSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.resourceMarkerSprite
    }
    
    public func set(borderSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.borderSprite = borderSprite
    }
    
    public func borderSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.borderSprite
    }
    
    public func set(iceSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.iceSprite = iceSprite
    }
    
    public func iceSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.iceSprite
    }
    
    public func set(yieldsSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.yieldsSprite = yieldsSprite
    }
    
    public func yieldsSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.yieldsSprite
    }
    
    public func set(waterSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.waterSprite = waterSprite
    }
    
    public func waterSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.waterSprite
    }
    
    public func set(riverSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.riverSprite = riverSprite
    }
    
    public func riverSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.riverSprite
    }
    
    public func set(improvementSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.improvementSprite = improvementSprite
    }
    
    public func improvementSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.improvementSprite
    }
    
    public func set(routeSprite: SKSpriteNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.routeSprite = routeSprite
    }
    
    public func routeSprite(at point: HexPoint) -> SKSpriteNode? {
        
        return self.tileTextures?[point.x, point.y]?.routeSprite
    }
    
    public func set(hexLabel: SKLabelNode?, at point: HexPoint) {
        
        self.tileTextures?[point.x, point.y]?.hexLabel = hexLabel
    }
    
    public func hexLabel(at point: HexPoint) -> SKLabelNode? {
        
        return self.tileTextures?[point.x, point.y]?.hexLabel
    }
}
