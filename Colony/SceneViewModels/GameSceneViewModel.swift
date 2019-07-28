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
    let levelURL: URL?
    
    init(with map: HexagonTileMap?) {
        self.type = .generator
        self.map = map
        self.game = nil
        self.levelURL = nil
    }
    
    init(with game: Game?) {
        self.type = .game
        self.map = nil
        self.game = game
        self.levelURL = nil
    }
    
    init(with levelURL: URL?) {
        self.type = .level
        self.map = nil
        self.game = nil
        self.levelURL = levelURL
    }
}
