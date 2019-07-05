//
//  UserRepository.swift
//  Colony
//
//  Created by Michael Rommel on 02.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class UserRepository {
    
    let userDao: UserDao
    
    init() {
        self.userDao = UserDao()
        
        // FIXME
        if let users = self.userDao.fetch() {
            
            if users.count == 0 {
                _ = self.userDao.create(named: "Micha", current: true)
            }
        } else {
            fatalError()
        }
    }
    
    func getCurrentUser() -> User? {
        return self.getUsers()?.first(where: { $0.current == true })
    }
    
    func getUsers() -> [User]? {
        return self.userDao.fetch()
    }
}
