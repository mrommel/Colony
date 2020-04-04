//
//  GameViewModel.swift
//  SmartColony
//
//  Created by Michael Rommel on 03.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class GameViewModel {
    
    var game: GameModel? = nil
    
    init(with map: MapModel?) {
        
        guard var map = map else {
            fatalError("cant get map")
        }
        
        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        let playerAugustus = Player(leader: .augustus, isHuman: true)
        playerAugustus.initialize()
        
        // debug - FIXME - TODO
        GameViewModel.discover(mapModel: &map, by: playerAugustus)
        
        self.game = GameModel(victoryTypes: [.domination], turnsElapsed: 0, players: [playerAlexander, playerBarbar, playerAugustus], on: map)
    }
    
    static func discover(mapModel: inout MapModel, by player: AbstractPlayer?) {
        
        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {
            
            for y in 0..<mapSize.height() {
                
                let tile = mapModel.tile(at: HexPoint(x: x, y: y))
                tile?.discover(by: player)
            }
        }
    }
}
