//
//  GameRepository.swift
//  Colony
//
//  Created by Michael Rommel on 28.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class GameRepository {
    
    let gameDao: GameDao
    
    init() {
        self.gameDao = GameDao()
    }
    
    func getOnlyBackup(for user: UserEntity?) -> GameEntity? {
        return self.gameDao.fetch()?.first(where: { $0.user?.name == user?.name })
    }
    
    private func save(game: GameEntity?) {
        self.gameDao.save(game: game)
    }
    
    func create(with data: Data, user: UserEntity?) {
        
        // high lander concept - only one can exist
        self.deleteBackup(for: user)
        
        // now create it
        self.gameDao.create(data: data, user: user)
    }
    
    func deleteBackup(for user: UserEntity?) {
        
        if let onlyBackup = self.getOnlyBackup(for: user) {
        
            self.gameDao.delete(game: onlyBackup)
        }
    }
    
    private func resetGames() {
        self.gameDao.deleteAll()
    }
}
