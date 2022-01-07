//
//  TextureUtils.swift
//  SmartColony
//
//  Created by Michael Rommel on 05.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

private class TextureItem: Codable, Equatable {

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
    var mainBorderSprite: SKSpriteNode?
    var accentBorderSprite: SKSpriteNode?
    var foodSprite: SKSpriteNode?
    var productionSprite: SKSpriteNode?
    var goldSprite: SKSpriteNode?
    var waterSprite: SKSpriteNode?
    var riverSprite: SKSpriteNode?
    var improvementSprite: SKSpriteNode?
    var routeSprite: SKSpriteNode?
    var hexLabel: SKLabelNode?
    var districtSprite: SKSpriteNode?
    var districtBuildingSprite: SKSpriteNode?
    var wonderSprite: SKSpriteNode?
    var wonderBuildingSprite: SKSpriteNode?
    var lensSprite: SKSpriteNode?

    init(point: HexPoint) {

        self.point = point
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.point = try container.decode(HexPoint.self, forKey: .point)
    }

    static func == (lhs: TextureItem, rhs: TextureItem) -> Bool {
        return lhs.point == rhs.point
    }
}

public class TextureUtils {

    weak var gameModel: GameModel?
    private var tileTextures: Array2D<TextureItem>?

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

    public func set(mainBorderSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.mainBorderSprite = mainBorderSprite
    }

    public func mainBorderSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.mainBorderSprite
    }

    public func set(accentBorderSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.accentBorderSprite = accentBorderSprite
    }

    public func accentBorderSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.accentBorderSprite
    }

    public func set(iceSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.iceSprite = iceSprite
    }

    public func iceSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.iceSprite
    }

    public func set(foodSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.foodSprite = foodSprite
    }

    public func foodSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.foodSprite
    }

    public func set(productionSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.productionSprite = productionSprite
    }

    public func productionSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.productionSprite
    }

    public func set(goldSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.goldSprite = goldSprite
    }

    public func goldSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.goldSprite
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

    public func set(districtSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.districtSprite = districtSprite
    }

    public func districtSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.districtSprite
    }

    public func set(districtBuildingSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.districtBuildingSprite = districtBuildingSprite
    }

    public func districtBuildingSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.districtBuildingSprite
    }

    public func set(wonderSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.wonderSprite = wonderSprite
    }

    public func wonderSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.wonderSprite
    }

    public func set(wonderBuildingSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.wonderBuildingSprite = wonderBuildingSprite
    }

    public func wonderBuildingSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.wonderBuildingSprite
    }

    public func set(lensSprite: SKSpriteNode?, at point: HexPoint) {

        self.tileTextures?[point.x, point.y]?.lensSprite = lensSprite
    }

    public func lensSprite(at point: HexPoint) -> SKSpriteNode? {

        return self.tileTextures?[point.x, point.y]?.lensSprite
    }
}
