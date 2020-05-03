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
    
    init(with map: MapModel?, handicap: HandicapType) {
        
        guard var map = map else {
            fatalError("cant get map")
        }
        
        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []
        
        for startLocation in map.startLocations {
            
            print("startLocation: \(startLocation.leader) (\(startLocation.isHuman ? "human" : "AI")) => \(startLocation.point)")
            
            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()
            
            // free techs
            if startLocation.isHuman {
                for tech in handicap.freeHumanTechs() {
                    try! player.techs?.discover(tech: tech)
                }
            } else {
                for tech in handicap.freeAITechs() {
                    try! player.techs?.discover(tech: tech)
                }
            }
            
            players.append(player)
            
            // units
            let settlerUnit = Unit(at: startLocation.point, type: .settler, owner: player)
            units.append(settlerUnit)
            
            // debug - FIXME - TODO
            if startLocation.isHuman {
                print("remove me - this is cheating")
                GameViewModel.discover(mapModel: &map, by: player)
            }
        }
        
        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        
        players.prepend(playerBarbar)

        // game
        self.game = GameModel(victoryTypes: [.domination], handicap: handicap, turnsElapsed: 0, players: players, on: map)
        
        // add units
        for unit in units {

            self.game?.add(unit: unit)
        }
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
    
    /*static func discover(area: HexArea, mapModel: inout MapModel, by player: AbstractPlayer?) {
            
        for pt in area {
                
            let tile = mapModel.tile(at: pt)
            tile?.discover(by: player)
        }
        
    }*/
}
