//
//  GameUsecase.swift
//  Colony
//
//  Created by Michael Rommel on 04.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameUsecase {
    
    let scoreRepository: ScoreRepository
    let userRepository: UserRepository
    
    init() {
        self.scoreRepository = ScoreRepository()
        self.userRepository = UserRepository()
    }
    
    func set(score: Int32, levelScore: LevelScore, for level: Int32) {
        
        guard let user = self.userRepository.getCurrentUser() else {
            fatalError("can't find current user")
        }
        
        let scoreEntry = self.scoreRepository.getScoreFor(level: level, and: user)
        
        if scoreEntry != nil {
            scoreEntry?.score = score
            scoreEntry?.levelScore = levelScore.rawValue
            self.scoreRepository.save(score: scoreEntry)
        } else {
            self.scoreRepository.create(with: level, score: score, levelScore: levelScore, user: user)
        }
    }
    
    func levelScore(for level: Int32) -> LevelScore? {
        
        guard let user = self.userRepository.getCurrentUser() else {
            fatalError("can't find current user")
        }
        
        let scoreEntry = self.scoreRepository.getScoreFor(level: level, and: user)
        
        if let levelScore = scoreEntry?.levelScore {
            return LevelScore(rawValue: levelScore)
        }
        
        return nil
    }
}
