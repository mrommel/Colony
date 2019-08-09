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
    let resource: URL?
    let game: Game?
    let map: HexagonTileMap?
    
    init(with map: HexagonTileMap?) {
        self.type = .map
        self.resource = nil
        self.game = nil
        self.map = map
    }
    
    init(with resource: URL?) {
        self.type = .level
        self.resource = resource
        self.game = nil
        self.map = nil
    }
    
    init(with game: Game?) {
        self.type = .game
        self.resource = nil
        self.game = game
        self.map = nil
    }
}
