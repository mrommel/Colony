//
//  SettingsUsecase.swift
//  Colony
//
//  Created by Michael Rommel on 30.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class SettingsUsecase {
    
    let scoreRepository: ScoreRepository
    let userRepository: UserRepository
    let gameRepository: GameRepository
    
    init() {
        self.scoreRepository = ScoreRepository()
        self.userRepository = UserRepository()
        self.gameRepository = GameRepository()
    }
    
    func resetData() {
        
        self.scoreRepository.resetScores()
        self.userRepository.resetUsers()
        self.gameRepository.resetBackups()
    }
}
