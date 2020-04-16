//
//  MapOverviewNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

extension CivilizationType {
    
    func overviewColor() -> UIColor {
        
        switch self {
            
        case .barbarian: return UIColor(hex: "#000000")
            
        case .greek: return UIColor(hex: "#ffffff")
        case .roman: return UIColor(hex: "#460076")
        case .english: return UIColor(hex: "#ff92fd")
        }
    }
}

extension TerrainType {
    
    func overviewColor() -> UIColor {
        
        switch self {
        case .ocean: return UIColor(red: 79, green: 112, blue: 141)
        case .shore: return UIColor(red: 91, green: 129, blue: 166)
        case .plains: return UIColor(red: 98, green: 122, blue: 32)
        case .grass: return UIColor(red: 75, green: 113, blue: 21)
        case .desert: return UIColor(red: 197, green: 174, blue: 108)
        case .tundra: return UIColor(red: 140, green: 106, blue: 68)
        case .snow: return UIColor(red: 237, green: 240, blue: 240)
        }
    }
}

class MapOverviewNode: SKSpriteNode {

    private var buffer: PixelBuffer
    
    private weak var game: GameModel?
    private weak var player: AbstractPlayer?

    init(with game: GameModel?, size: CGSize) {
        
        /*self.userUsecase = UserUsecase()
        
        guard let currentUser = self.userUsecase.currentUser() else {
            fatalError("can't get current user")
        }*/
        
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

        //self.map?.fogManager?.delegates.addDelegate(self)
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
                    let color = owner.leader.civilization().overviewColor()
                    self.buffer.set(color: color, at: index)
                } else {
                    var color = tile.terrain().overviewColor()
                    
                    if tile.hasHills() {
                        color = UIColor(red: 237, green: 240, blue: 240)
                    }
                    
                    if tile.has(feature: .mountains) || tile.has(feature: .mountEverest) || tile.has(feature: .mountKilimanjaro) {
                        color = UIColor(red: 237, green: 240, blue: 240)
                    }
                    
                    self.buffer.set(color: color, at: index)
                }
                
            } else {
                self.buffer.set(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5), at: index)
            }
        }
        
        /*if map.fogManager?.neverVisitedAt(x: x, y: y, by: self.civilization) ?? false {
            self.buffer.set(color: UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5), at: index)
        } else {

            if let tile = map.tile(x: x, y: y) {

                if let player = tile.owner() {
                    let color = city.civilization.overviewColor
                    self.buffer.set(color: color, at: index)
                } else {
                    let color = tile.terrain.overviewColor
                    self.buffer.set(color: color, at: index)
                }
            }
        }*/
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

/*extension MapOverviewNode: FogStateChangedDelegate {

    func changed(for civilization: Civilization, to newState: FogState, at pt: HexPoint) {

        self.updateBufferAt(x: pt.x, y: pt.y)

        self.updateTextureFromBuffer()
    }
}*/