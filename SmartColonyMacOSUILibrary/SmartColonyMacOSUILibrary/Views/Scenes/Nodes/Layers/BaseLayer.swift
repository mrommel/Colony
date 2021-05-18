//
//  BaseLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 28.04.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class BaseLayer: SKNode {
    
    static let kTextureWidth: Int = 48
    static let kTextureSize: CGSize = CGSize(width: kTextureWidth, height: kTextureWidth)
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    var textures: Textures?
    
    var showCompleteMap: Bool = false
    
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

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                if let tile = gameModel.tile(at: HexPoint(x: x, y: y)) {
                    self.update(tile: tile)
                }
            }
        }
    }
    
    func update(tile: AbstractTile?) {
        
        fatalError("must be over written by all sub classes")
    }
}
