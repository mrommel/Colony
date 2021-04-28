//
//  HexCoordLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class HexCoordLayer: BaseLayer {
    
    static let kName: String = "HexCoordLayer"
    
    // MARK: constructor
    
    override init(player: AbstractPlayer?) {

        super.init(player: player)
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
        
        self.rebuild()
    }
    
    func placeCoordHex(for point: HexPoint, at position: CGPoint) {

        let hexCoordSprite = SKLabelNode(text: "\(point.x), \(point.y)")
        hexCoordSprite.fontSize = 18.0  
        hexCoordSprite.position = position + CGPoint(x: 72, y: 42)
        hexCoordSprite.zPosition = Globals.ZLevels.hexCoords
        hexCoordSprite.color = .black
        hexCoordSprite.colorBlendFactor = 0.0
        self.addChild(hexCoordSprite)
        
        self.textureUtils?.set(hexLabel: hexCoordSprite, at: point)
    }
    
    func clear(tile: AbstractTile?) {
        
        if let tile = tile {
            if let hexLabel = self.textureUtils?.hexLabel(at: tile.point) {
                self.removeChildren(in: [hexLabel])
            }
        }
    }
    
    override func update(tile: AbstractTile?) {
        
        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        let mapSize = gameModel.mapSize()

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                
                let pt = HexPoint(x: x, y: y)
                
                if let tile = gameModel.tile(at: pt) {
                    
                    self.clear(tile: tile)
                    
                    let screenPoint = HexPoint.toScreen(hex: pt) * 3.0
                    
                    if tile.isVisible(to: self.player) || self.showCompleteMap {
                        self.placeCoordHex(for: pt, at: screenPoint)
                    }
                }
            }
        }
    }
}
