//
//  CityLayer.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class CityLayer: SKNode {
    
    let player: AbstractPlayer?
    weak var gameModel: GameModel?
    var textureUtils: TextureUtils?
    
    var cityObjects: [CityObject]
    
    init(player: AbstractPlayer?) {
        
        self.player = player
        self.cityObjects = []
        
        super.init()
        self.zPosition = Globals.ZLevels.feature
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
        
        for player in gameModel.players {
            
            for city in gameModel.cities(of: player) {
                
                self.show(city: city)
            }
        }
    }
    
    func show(city: AbstractCity?) {
        
        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        guard let city = city else {
            fatalError("cant get city")
        }
        
        guard let tile = gameModel.tile(at: city.location) else {
            fatalError("cant get tile")
        }
        
        if tile.isVisible(to: player) {
            let cityObject = CityObject(city: city, in: self.gameModel)
        
            // add to canvas
            cityObject.addTo(node: self)
            
            cityObject.showCityBanner()
        
            // keep reference
            cityObjects.append(cityObject)
            
        } else if tile.isDiscovered(by: player) {
            let cityObject = CityObject(city: city, in: self.gameModel)
            
            // add to canvas
            cityObject.addTo(node: self)
            
            // keep reference
            cityObjects.append(cityObject)
        }
    }
    
    func update(city: AbstractCity?) {
        
        guard let gameModel = self.gameModel else {
            fatalError("gameModel not set")
        }
        
        guard let city = city else {
            fatalError("no city provided")
        }
        
        for cityLoopObject in self.cityObjects {
            
            if city.location == cityLoopObject.city?.location {
                
                guard let tile = gameModel.tile(at: city.location) else {
                    fatalError("cant get tile")
                }
                
                if tile.isDiscovered(by: player) {
                
                    cityLoopObject.showCityBanner()
                
                    // FIXME update city size / buildings
                }
            }
        }
    }
}
