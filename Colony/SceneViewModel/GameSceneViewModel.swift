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
    case generator
}

class GameSceneViewModel {
    
    let type: GameSceneViewModelType
    let map: HexagonTileMap?
    let levelURL: URL?
    
    init(with map: HexagonTileMap?) {
        self.type = .generator
        self.map = map
        self.levelURL = nil
    }
    
    init(with levelURL: URL?) {
        self.type = .level
        self.map = nil
        self.levelURL = levelURL
    }
}
