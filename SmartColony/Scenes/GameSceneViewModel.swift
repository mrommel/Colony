//
//  GameSceneViewModel.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class GameSceneViewModel {
    
    var game: GameModel?
    
    init(with game: GameModel?) {
        
        self.game = game
    }
}
