//
//  HexCoordLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class HexCoordLayer: SKNode {
    
    static let kName: String = "HexCoordLayer"
    
    var player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
    // MARK: constructor
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        
        super.init()
        self.zPosition = Globals.ZLevels.water
        self.name = HexCoordLayer.kName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func populate(with gameModel: GameModel?) {
        
        self.gameModel = gameModel

        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        self.textureUtils = TextureUtils(with: gameModel)
        
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                let pt = HexPoint(x: x, y: y)
                if let tile = gameModel.tile(at: pt) {
                    let screenPoint = HexPoint.toScreen(hex: pt) * 3.0
                    
                    if tile.isVisible(to: self.player) || true {
                        self.placeCoordHex(for: pt, at: screenPoint)
                    }
                }
            }
        }
    }
    
    func placeCoordHex(for point: HexPoint, at position: CGPoint) {

        let hexCoordSprite = SKLabelNode(text: "\(point.x), \(point.y)")
        hexCoordSprite.position = position + CGPoint(x: 72, y: 42)
        hexCoordSprite.zPosition = Globals.ZLevels.hexCoords
        hexCoordSprite.color = .black
        hexCoordSprite.colorBlendFactor = 0.0
        self.addChild(hexCoordSprite)
    }
    
    func update(tile: AbstractTile?) {
        
        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        // NOOP
    }
}
