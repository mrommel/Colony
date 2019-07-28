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
    case generator
    case game
}

class GameViewModel {
    
    let type: GameViewModelType
    let resource: URL?
    let game: Game?
    
    init() {
        self.type = .generator
        self.resource = nil
        self.game = nil
    }
    
    init(with resource: URL?) {
        self.type = .level
        self.resource = resource
        self.game = nil
    }
    
    init(with game: Game?) {
        self.type = .game
        self.resource = nil
        self.game = game
    }
}
