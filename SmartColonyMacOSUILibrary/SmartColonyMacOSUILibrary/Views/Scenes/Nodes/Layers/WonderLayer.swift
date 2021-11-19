//
//  WonderLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 19.11.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class WonderLayer: BaseLayer {

    static let kName: String = "WonderLayer"

    // MARK: constructor

    override init(player: AbstractPlayer?) {

        super.init(player: player)
        self.zPosition = Globals.ZLevels.wonder
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
        self.textures = Textures(game: gameModel)

        self.rebuild()
    }
}
