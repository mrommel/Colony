//
//  TileDiscovered.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TileDiscovered {
    
    // MARK: private properties
    
    private var items: [TileDiscoveredItem]
 
    // MARK: internal classes
    
    class TileDiscoveredItem {
        
        let player: AbstractPlayer?
        var discovered: Bool
        var sighted: Bool
        
        init(by player: AbstractPlayer?, discovered: Bool = true, sighted: Bool = true) {
            
            self.player = player
            self.discovered = discovered
            self.sighted = sighted
        }
    }
    
    // MARK: constructor
    
    init() {
        
        self.items = []
    }
    
    func isDiscovered(by player: AbstractPlayer?) -> Bool {
        
        if let item = self.items.first(where: { $0.player?.leader == player?.leader }) {
            
            return item.discovered
        }
        
        return false
    }
    
    func discover(by player: AbstractPlayer?) {
        
        if let item = self.items.first(where: { $0.player?.leader == player?.leader }) {
            item.discovered = true
        } else {
            self.items.append(TileDiscoveredItem(by: player, discovered: true))
        }
    }
    
    func isVisible(to player: AbstractPlayer?) -> Bool {
        
        if let item = self.items.first(where: { $0.player?.leader == player?.leader }) {
            
            return item.sighted
        }
        
        return false
    }
    
    func sight(by player: AbstractPlayer?) {
        
        if let item = self.items.first(where: { $0.player?.leader == player?.leader }) {
            item.sighted = true
        } else {
            self.items.append(TileDiscoveredItem(by: player, discovered: true, sighted: true))
        }
    }
    
    func conceal(to player: AbstractPlayer?) {
        
        if let item = self.items.first(where: { $0.player?.leader == player?.leader }) {
            item.sighted = false
        } else {
            self.items.append(TileDiscoveredItem(by: player, discovered: false, sighted: false))
        }
    }
}
