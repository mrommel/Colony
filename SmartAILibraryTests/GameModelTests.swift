//
//  GameModelTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 04.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import XCTest
@testable import SmartAILibrary

class GameModelTests: XCTestCase {

    func testWorldEraMedieval() {
        // GIVEN
        
        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.set(era: .classical)
        
        // player 2
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        playerAugustus.set(era: .medieval)
        
        // player 3
        let playerElizabeth = Player(leader: .elizabeth)
        playerElizabeth.initialize()
        playerElizabeth.set(era: .medieval)
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerElizabeth, playerAugustus, playerAlexander],
                                  on: mapModel)
        
        
        // WHEN
        let worldEra = gameModel.worldEra()
        
        // THEN
        XCTAssertEqual(worldEra, .medieval)
    }
    
    func testWorldEraMedieval2() {
        // GIVEN
        
        // player 1
        let playerAlexander = Player(leader: .alexander, isHuman: true)
        playerAlexander.initialize()
        playerAlexander.set(era: .classical)
        
        // player 2
        let playerAugustus = Player(leader: .augustus)
        playerAugustus.initialize()
        playerAugustus.set(era: .medieval)
        
        // player 3
        let playerElizabeth = Player(leader: .elizabeth)
        playerElizabeth.initialize()
        playerElizabeth.set(era: .renaissance)
        
        // map
        let mapModel = MapModelHelper.mapFilled(with: .grass, sized: .duel)

        // game
        let gameModel = GameModel(victoryTypes: [.domination, .cultural, .diplomatic],
                                  handicap: .chieftain,
                                  turnsElapsed: 0,
                                  players: [playerElizabeth, playerAugustus, playerAlexander],
                                  on: mapModel)
        
        
        // WHEN
        let worldEra = gameModel.worldEra()
        
        // THEN
        XCTAssertEqual(worldEra, .medieval)
    }
}
