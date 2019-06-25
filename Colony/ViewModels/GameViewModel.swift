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
}

class GameViewModel {
    
    let type: GameViewModelType
    let resource: URL?
    
    init() {
        self.type = .generator
        self.resource = nil
    }
    
    init(with resource: URL?) {
        self.type = .level
        self.resource = resource
    }
}
