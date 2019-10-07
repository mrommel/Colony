//
//  GameSceneViewModel.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum GameSceneViewModelType {
    case level
    case game
    case generator
}

class GameSceneViewModel {
    
    let type: GameSceneViewModelType
    let map: HexagonTileMap?
    let game: Game?
    let levelMeta: LevelMeta?
    
    init(with map: HexagonTileMap?) {
        self.type = .generator
        self.map = map
        self.game = nil
        self.levelMeta = nil
    }
    
    init(with game: Game?) {
        self.type = .game
        self.map = nil
        self.game = game
        self.levelMeta = nil
    }
    
    init(with levelMeta: LevelMeta?) {
        self.type = .level
        self.map = nil
        self.game = nil
        self.levelMeta = levelMeta
    }
}
