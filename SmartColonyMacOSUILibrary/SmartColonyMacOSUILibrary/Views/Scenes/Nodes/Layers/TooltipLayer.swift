//
//  TooltipLayer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.06.21.
//

import SpriteKit
import SmartAILibrary
import SmartAssets

class TooltipLayer: SKNode {

    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
    // nodes
    //var tooltipNodes: [TooltipNode] = []

    init(player: AbstractPlayer?) {

        self.player = player

        super.init()
        self.zPosition = Globals.ZLevels.tooltips
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
    }
    
    func show(text: String, at location: HexPoint, for seconds: Double) {
        
        var screenPoint = HexPoint.toScreen(hex: location)
        
        screenPoint.x += 12 // 24 / 2
        
        let tooltipNode = TooltipNode(text: text)
        tooltipNode.position = screenPoint
        tooltipNode.zPosition = Globals.ZLevels.tooltips
        self.addChild(tooltipNode)
        
        // remove after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            tooltipNode.removeFromParent()
        })
    }
}
