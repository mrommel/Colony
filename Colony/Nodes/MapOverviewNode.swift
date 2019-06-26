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
    private var buffer: [PixelData]

    init(with map: HexagonTileMap?, size: CGSize) {
        self.map = map

        self.buffer = [PixelData]()

        guard let map = map else {
            fatalError("no map")
        }

        for _ in 0..<(map.width * map.height) {
            self.buffer.append(PixelData(color: .black))
        }

        let image = UIImageExtension.imageFromARGB32Bitmap(pixels: self.buffer, width: map.width, height: map.height)

        let texture = SKTexture(image: image)

        super.init(texture: texture, color: UIColor.blue, size: size)

        for y in 0..<map.width {
            for x in 0..<map.height {

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
            self.buffer[index] = PixelData(color: .black)
        } else {

            if let tile = map.tile(x: x, y: y) {

                let color = tile.terrain.overviewColor
                self.buffer[index] = PixelData(color: color)
            }
        }
    }

    private func updateTextureFromBuffer() {

        guard let map = self.map else {
            return
        }

        let image = UIImageExtension.imageFromARGB32Bitmap(pixels: self.buffer, width: map.width, height: map.height)

        self.texture = SKTexture(image: image)
    }
}

extension MapOverviewNode: FogStateChangedDelegate {

    func changed(to newState: FogState, at pt: HexPoint) {

        self.updateBufferAt(x: pt.x, y: pt.y)

        self.updateTextureFromBuffer()
    }
}
