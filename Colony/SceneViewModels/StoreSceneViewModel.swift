//
//  StoreSceneViewModel.swift
//  Colony
//
//  Created by Michael Rommel on 31.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class StoreSceneViewModel {
    
    private let boosterStock: BoosterStock
    private let cartBoosterStock: BoosterStock
    private let coins: Int
    
    init(boosterStock: BoosterStock, coins: Int) {
        self.boosterStock = boosterStock
        self.cartBoosterStock = boosterStock.copy() as! BoosterStock
        self.coins = coins
    }
    
    func initialAmount(of boosterType: BoosterType) -> Int {
        
        return self.boosterStock.amount(of: boosterType)
    }
    
    func updateCart(for boosterType: BoosterType, amount: Int) {
        
        self.cartBoosterStock.update(amount: amount, of: boosterType)
    }
    
    func itemsInCart() -> Int {
        
        var numberOfItems = 0
        for boosterType in BoosterType.all {
            let delta = max(self.cartBoosterStock.amount(of: boosterType) - self.boosterStock.amount(of: boosterType), 0)
            numberOfItems += delta
        }
        
        return numberOfItems
    }
    
    func currentCoins() -> Int {
        
        return self.coins
    }
    
    func calculateCosts() -> Int {
        
        var costs = 0
        for boosterType in BoosterType.all {
            let delta = self.cartBoosterStock.amount(of: boosterType) - self.boosterStock.amount(of: boosterType)
            let cost = delta * boosterType.coins
            costs += cost
        }
        
        return costs
    }
    
    func remainingCoins() -> Int {
    
        return self.coins - self.calculateCosts()
    }
    
    func valid() -> Bool {
        
        return self.coins >= self.calculateCosts()
    }
    
    func execute() {
        
        print("purchase")
    }
}
