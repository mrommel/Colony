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
    
    var game: GameModel?
    
    init(with game: GameModel?) {
        
        self.game = game
        
        // keep backup
        self.storeBackup()
    }
    
    init(with map: MapModel?, handicap: HandicapType) {
        
        guard var map = map else {
            fatalError("cant get map")
        }
        
        var players: [AbstractPlayer] = []
        var units: [AbstractUnit] = []
        
        for startLocation in map.startLocations {
            
            //print("startLocation: \(startLocation.leader) (\(startLocation.isHuman ? "human" : "AI")) => \(startLocation.point)")
            
            // player
            let player = Player(leader: startLocation.leader, isHuman: startLocation.isHuman)
            player.initialize()
            
            // free techs
            if startLocation.isHuman {
                for tech in handicap.freeHumanTechs() {
                    do {
                        try player.techs?.discover(tech: tech)
                    } catch { }
                }
                
                for civic in handicap.freeHumanCivics() {
                    do {
                        try player.civics?.discover(civic: civic)
                    } catch { }
                }
            } else {
                for tech in handicap.freeAITechs() {
                    do {
                        try player.techs?.discover(tech: tech)
                    } catch { }
                }
                
                for civic in handicap.freeAICivics() {
                    do {
                        try player.civics?.discover(civic: civic)
                    } catch { }
                }
            }
            
            // set first government
            player.government?.set(governmentType: .chiefdom)
            
            players.append(player)
            
            // units
            if startLocation.isHuman {
                let settlerUnit = Unit(at: startLocation.point, type: .settler, owner: player)
                units.append(settlerUnit)

                let warriorUnit = Unit(at: startLocation.point, type: .warrior, owner: player)
                units.append(warriorUnit)
                
                let builderUnit = Unit(at: startLocation.point, type: .builder, owner: player)
                units.append(builderUnit)
            } else {
                for unitType in handicap.freeAIStartingUnitTypes() {
                    let unit = Unit(at: startLocation.point, type: unitType, owner: player)
                    units.append(unit)
                }
            }
            
            // debug - FIXME - TODO
            if startLocation.isHuman {
                // print("remove me - this is cheating")
                // GameViewModel.discover(mapModel: &map, by: player)
            }
        }
        
        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        
        players.prepend(playerBarbar)

        // game
        self.game = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic, .science],
            handicap: handicap,
            turnsElapsed: 0,
            players: players,
            on: map
        )
        
        // add units
        var lastLeader: LeaderType? = LeaderType.none
        for unit in units {

            if lastLeader == unit.player?.leader {
                let jumped = unit.jumpToNearestValidPlotWithin(range: 2, in: self.game)
                print("--- jumped: \(jumped)")
            }
            
            self.game?.add(unit: unit)
            
            lastLeader = unit.player?.leader
        }
        
        // cheat
        GameViewModel.discover(mapModel: &map, by: playerBarbar, in: self.game)
        
        // keep backup
        self.storeBackup()
    }
    
    func storeBackup() {
        
        GameStorage.storeRestart(game: self.game)
    }
    
    static func discover(mapModel: inout MapModel, by player: AbstractPlayer?, in gameModel: GameModel?) {
        
        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {
            
            for y in 0..<mapSize.height() {
                
                let tile = mapModel.tile(at: HexPoint(x: x, y: y))
                tile?.discover(by: player, in: gameModel)
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
