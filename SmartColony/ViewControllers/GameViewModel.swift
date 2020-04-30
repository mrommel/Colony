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
        
        guard let map = map else {
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
        }

        /*let player = Player(leader: .alexander)
        player.initialize()
        
        // find good starting locations
        let citySiteEvaluator = CitySiteEvaluator(map: map)
        let finder: RegionFinder = RegionFinder(map: map, evaluator: citySiteEvaluator, for: player)

        let regions = finder.divideInto(regions: 2)*/
        
        
        /*
        // ---- Alexander
        let playerAlexander = Player(leader: .alexander, isHuman: false)
        playerAlexander.initialize()
        
        let (startingPointAlexander, _) = citySiteEvaluator.bestPoint(of: regions[0], for: playerAlexander)
        let warriorLocationAlexander = startingPointAlexander.neighbor(in: .southeast) // FIXME check that no ocean / impassable
        
        let warriorAlexander = Unit(at: warriorLocationAlexander, type: .warrior, owner: playerAlexander)
        let settlerAlexander = Unit(at: startingPointAlexander, type: .settler, owner: playerAlexander)
        
        // ---- Augustus
        let playerAugustus = Player(leader: .augustus, isHuman: true)
        playerAugustus.initialize()
        
        
        let (startingPointAugustus, _) = citySiteEvaluator.bestPoint(of: regions[1], for: playerAugustus)
        let warriorLocationAugustus = startingPointAugustus.neighbor(in: .southeast) // FIXME check that no ocean / impassable
        
        let warriorAugustus = Unit(at: warriorLocationAugustus, type: .warrior, owner: playerAugustus)
        let settlerAugustus = Unit(at: startingPointAugustus, type: .settler, owner: playerAugustus)*/
        
        // ---- Barbar
        let playerBarbar = Player(leader: .barbar, isHuman: false)
        playerBarbar.initialize()
        
        players.prepend(playerBarbar)
        
        // debug - FIXME - TODO
        //GameViewModel.discover(mapModel: &map, by: playerAugustus)
        
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
