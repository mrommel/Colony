//
//  UserRepository.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class UserRepository {
    
    private let userDao: UserDao
    
    init() {
        self.userDao = UserDao()
    }
    
    func getCurrentUser() -> UserEntity? {
        return self.getUsers()?.first(where: { $0.current == true })
    }
    
    func getUsers() -> [UserEntity]? {
        return self.userDao.fetch()
    }
    
    func createCurrentUser(named name: String, civilization: String) {
        self.userDao.create(named: name, civilization: civilization, current: true)
    }

    func resetUsers() {
        self.userDao.deleteAll()
    }
}
