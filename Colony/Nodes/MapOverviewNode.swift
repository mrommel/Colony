//
//  MapOverviewNode.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class MapOverviewNode: SKSpriteNode {

    private var map: HexagonTileMap?
    private var buffer: PixelBuffer

    init(with map: HexagonTileMap?, size: CGSize) {
        
        self.map = map

        guard let map = map else {
            fatalError("no map")
        }
        
        self.buffer = PixelBuffer(width: map.width, height: map.height, color: .black)

        guard let image = self.buffer.toUIImage() else {
            fatalError("can't create image from buffer")
        }

        let texture = SKTexture(image: image)

        super.init(texture: texture, color: UIColor.blue, size: size)

        for y in 0..<map.height {
            for x in 0..<map.width {

                self.updateBufferAt(x: x, y: y)
            }
        }

        self.updateTextureFromBuffer()

        self.map?.fogManager?.delegates.addDelegate(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateBufferAt(x: Int, y: Int) {

        guard let map = map else {
            fatalError("no map")
        }

        let index = y * map.width + x

        if map.fogManager?.neverVisitedAt(x: x, y: y) ?? false {
            self.buffer.set(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5), at: index)
        } else {

            if let tile = map.tile(x: x, y: y) {

                let color = tile.terrain.overviewColor
                self.buffer.set(color: color, at: index)
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
}

extension MapOverviewNode: FogStateChangedDelegate {

    func changed(to newState: FogState, at pt: HexPoint) {

        self.updateBufferAt(x: pt.x, y: pt.y)

        self.updateTextureFromBuffer()
    }
}
