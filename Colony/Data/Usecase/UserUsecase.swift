//
//  UserUsecase.swift
//  Colony
//
//  Created by Michael Rommel on 29.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class User {
    let name: String
    let civilization: Civilization
    let coins: Int
    let boosterStock: BoosterStock
    
    init(userEntity: UserEntity) {
        self.name = userEntity.name ?? "none"
        
        guard let civilizationValue = userEntity.civilization else {
            fatalError("civilization no set")
        }
        
        guard let civilizationEnum = Civilization(rawValue: civilizationValue) else {
            fatalError("can't parse civilization")
        }
        
        self.civilization = civilizationEnum
        self.coins = Int(userEntity.coins)
        
        self.boosterStock = BoosterStock()
        
        if let boosterEntities = userEntity.boosters?.allObjects as? [BoosterStockEntity] {
            for boosterStockEntity in boosterEntities {
                
                let boosterAmount = Int(boosterStockEntity.amount)
                guard let boosterType = BoosterType(rawValue: boosterStockEntity.boosterType ?? "") else {
                    fatalError("can't parse booster type")
                }
                
                self.boosterStock.update(amount: boosterAmount, of: boosterType)
            }
        }
    }

}

class UserUsecase {
    
    let userRepository: UserRepository
    
    init() {
        self.userRepository = UserRepository()
    }
    
    func isCurrentUserExisting() -> Bool {
        
        if let userEntity = self.userRepository.getCurrentUser() {
            return userEntity.current
        }
        
        return false
    }
    
    func currentUser() -> User? {
        
        if let userEntity = self.userRepository.getCurrentUser() {
            return User(userEntity: userEntity)
        }
        
        return nil
    }
    
    @discardableResult
    func createCurrentUser(named name: String, civilization: Civilization) -> Bool {
        
        if UserUsecase.isValid(name: name) {
            self.userRepository.createCurrentUser(named: name, civilization: civilization.rawValue)
            return true
        }
        
        return false
    }
    
    static func isValid(name: String) -> Bool {
        
        let nameRegEx =  "^[A-Za-z]{3}[A-Za-z0-9]*$"  // {3} -> at least 3 alphabet are compulsory - then alpha numerical.
        
        do {
            let regex = try NSRegularExpression(pattern: nameRegEx)
            let results = regex.matches(in: name, range: NSRange(location: 0, length: name.count))
            
            if results.count == 0 {
                return false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}
