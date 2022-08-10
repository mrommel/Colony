//
//  BaseLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class BaseLayerHasher<T: Hashable & Codable> {

    weak var gameModel: GameModel?
    private var tileHashes: Array2D<Int>

    init(with gameModel: GameModel?) {

        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("cant get gameModel")
        }

        let mapSize = gameModel.mapSize()

        self.tileHashes = Array2D<Int>(width: mapSize.width(), height: mapSize.height())

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                self.tileHashes[x, y] = -1
            }
        }
    }

    func update(hash: T, at point: HexPoint) {

        self.tileHashes[point.x, point.y] = hash.hashValue
    }

    func has(hash: T, at point: HexPoint) -> Bool {

        return self.tileHashes[point.x, point.y] == hash.hashValue
    }

    func hash(at point: HexPoint) -> Int {

        return self.tileHashes[point.x, point.y]!
    }
}

class BaseLayerTile: Hashable, Codable {

    enum CodingKeys: CodingKey {
        case point
    }

    let point: HexPoint

    init(point: HexPoint) {

        self.point = point
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.point = try container.decode(HexPoint.self, forKey: .point)
    }

    static func == (lhs: BaseLayerTile, rhs: BaseLayerTile) -> Bool {

        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {

        fatalError("should have been overriden")
    }
}

class BaseLayer: SKNode {

    static let kTextureWidth: Int = 48
    static let kTextureSize: CGSize = CGSize(width: kTextureWidth, height: kTextureWidth)

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    var textures: Textures?

    var showCompleteMap: Bool = false
    var wrapOverlap: Int = 0

    // MARK: constructor

    init(player: AbstractPlayer?) {

        self.player = player

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rebuild() {

        guard let gameModel = self.gameModel else {
            return
        }

        let mapSize = gameModel.mapSize()

        self.wrapOverlap = mapSize.width() / 2

        // try wrapping
        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                let point: HexPoint = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: point) {
                    self.update(tile: tile)
                }
            }
        }
    }

    func alternatePoint(for point: HexPoint) -> HexPoint {

        if point.x >= self.wrapOverlap {
            return HexPoint(x: point.x - 2 * self.wrapOverlap, y: point.y)
        }

        if point.x < self.wrapOverlap {
            return HexPoint(x: point.x + 2 * self.wrapOverlap, y: point.y)
        }

        return point
    }

    func update(tile: AbstractTile?) {

        fatalError("must be over written by all sub classes")
    }

    func clear(at point: HexPoint) {

        fatalError("must be over written by all sub classes")
    }
}
