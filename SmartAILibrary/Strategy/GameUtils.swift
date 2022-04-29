//
//  GameUtils.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 09.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public class GameUtils {

    public static func setupSmallGrass(
        human humanLeader: LeaderType = .trajan,
        ai aiLeader: LeaderType = .alexander,
        discover: Bool = false) -> GameModel {

        let barbarianPlayer = Player(leader: .barbar, isHuman: false)
        barbarianPlayer.initialize()

        let aiPlayer = Player(leader: aiLeader, isHuman: false)
        aiPlayer.initialize()

        let humanPlayer = Player(leader: humanLeader, isHuman: true)
        humanPlayer.initialize()

        var mapModel = MapUtils.mapFilled(with: .grass, sized: .small, seed: 42)

        let mapOptions = MapOptions(
            withSize: .duel,
            type: .continents,
            leader: humanLeader,
            aiLeaders: [aiLeader],
            handicap: .chieftain,
            seed: 42
        )

        let mapGenerator = MapGenerator(with: mapOptions)
        mapGenerator.identifyContinents(on: mapModel)
        mapGenerator.identifyOceans(on: mapModel)
        mapGenerator.identifyStartPositions(on: mapModel)

        let gameModel = GameModel(
            victoryTypes: [.domination, .cultural, .diplomatic],
            handicap: .chieftain,
            turnsElapsed: 0,
            players: [barbarianPlayer, aiPlayer, humanPlayer],
            on: mapModel
        )

        if discover {
            MapUtils.discover(mapModel: &mapModel, by: humanPlayer, in: gameModel)
        }

        return gameModel
    }
}
