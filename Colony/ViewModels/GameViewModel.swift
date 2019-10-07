//
//  GameViewModel.swift
//  Colony
//
//  Created by Michael Rommel on 24.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum GameViewModelType {
    case level
    //case generator
    case map
    case game
}

class GameViewModel {
    
    let type: GameViewModelType
    let levelMeta: LevelMeta?
    let game: Game?
    let map: HexagonTileMap?
    
    init(with map: HexagonTileMap?) {
        self.type = .map
        self.levelMeta = nil
        self.game = nil
        self.map = map
    }
    
    init(with levelMeta: LevelMeta?) {
        self.type = .level
        self.levelMeta = levelMeta
        self.game = nil
        self.map = nil
    }
    
    init(with game: Game?) {
        self.type = .game
        self.levelMeta = nil
        self.game = game
        self.map = nil
    }
}
