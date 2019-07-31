//
//  ScoreRepository.swift
//  Colony
//
//  Created by Michael Rommel on 04.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class ScoreRepository {
    
    private let scoreDao: ScoreDao
    
    init() {
        self.scoreDao = ScoreDao()
    }
    
    func getScoreFor(level: Int32, and user: UserEntity) -> ScoreEntity? {
        return self.scoreDao.fetch()?.first(where: { $0.level == level && $0.user?.name == user.name })
    }
    
    func save(score: ScoreEntity?) {
        self.scoreDao.save(score: score)
    }
    
    func create(with level: Int32, score: Int32, levelScore: LevelScore, user: UserEntity?) {
        self.scoreDao.create(with: level, score: score, levelScore: levelScore.rawValue, user: user)
    }
    
    func resetScores() {
        self.scoreDao.deleteAll()
    }
}
