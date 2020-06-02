//
//  MapOverviewNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class MapOverviewNode: SKSpriteNode {

    private var buffer: PixelBuffer
    
    private weak var game: GameModel?
    private weak var player: AbstractPlayer?

    init(with game: GameModel?, size: CGSize) {
        
        self.game = game
        
        guard let game = self.game else {
            fatalError("no game given")
        }
        
        self.player = game.humanPlayer()
        
        let mapSize = game.mapSize()
        self.buffer = PixelBuffer(width: mapSize.width(), height: mapSize.height(), color: .black)

        guard let image = self.buffer.toUIImage() else {
            fatalError("can't create image from buffer")
        }

        let texture = SKTexture(image: image)

        super.init(texture: texture, color: UIColor.blue, size: size)

        for y in 0..<mapSize.height() {
            for x in 0..<mapSize.width() {

                self.updateBufferAt(x: x, y: y)
            }
        }

        self.updateTextureFromBuffer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBufferAt(x: Int, y: Int) {

        guard let game = self.game else {
            fatalError("no map")
        }

        let index = y * game.mapSize().width() + x

        if let tile = game.tile(x: x, y: y) {
            
            if tile.isDiscovered(by: self.player) {
                
                if let owner = tile.owner() {
                    if tile.isCity() {
                        let color = owner.leader.civilization().iconColor()
                        self.buffer.set(color: color, at: index)
                    } else {
                        let color = owner.leader.civilization().backgroundColor()
                        self.buffer.set(color: color, at: index)
                    }
                } else {
                    var color = tile.terrain().overviewColor()
                    
                    /*if tile.hasHills() {
                        color = UIColor(red: 237, green: 240, blue: 240)
                    }*/
                    
                    if tile.has(feature: .mountains) || tile.has(feature: .mountEverest) || tile.has(feature: .mountKilimanjaro) {
                        color = UIColor(red: 237, green: 240, blue: 240)
                    }
                    
                    self.buffer.set(color: color, at: index)
                }
                
            } else {
                self.buffer.set(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5), at: index)
            }
        }
    }

    private func updateTextureFromBuffer() {

        guard var image = self.buffer.toUIImage() else {
            fatalError("can't create image from buffer")
        }
        
        if image.size.width < self.size.width {
            if let tmpImage = image.resizeRasterizedTo(targetSize: CGSize(width: self.size.width, height: self.size.height)) {
                image = tmpImage
            }
        }
        
        let deltaHeight = self.size.height - image.size.height
        if deltaHeight > 0 {
            let insets = UIEdgeInsets(top: deltaHeight / 2, left: 0, bottom: deltaHeight / 2, right: 0)
            if let tmpImage = image.imageWithInsets(insets: insets){
                image = tmpImage
            }
        }

        self.texture = SKTexture(image: image)
    }
    
    func changed(at pt: HexPoint) {

        self.updateBufferAt(x: pt.x, y: pt.y)
        self.updateTextureFromBuffer()
    }
}
