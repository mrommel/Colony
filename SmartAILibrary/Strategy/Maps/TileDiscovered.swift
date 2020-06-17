//
//  TileDiscovered.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TileDiscovered: Codable {
    
    enum CodingKeys: CodingKey {
        
        case items
    }
    
    // MARK: private properties
    
    private var items: [TileDiscoveredItem]
 
    // MARK: internal classes
    
    class TileDiscoveredItem: Codable {
        
        enum CodingKeys: CodingKey {
            
            case leader
            case discovered
            case sighted
        }
        
        let leader: LeaderType
        var discovered: Bool
        var sighted: Int // number of units / cities seeing this tile
        
        init(by leader: LeaderType, discovered: Bool = true, sighted: Bool = true) {
            
            self.leader = leader
            self.discovered = discovered
            self.sighted = sighted ? 1 : 0
        }
        
        required init(from decoder: Decoder) throws {
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.leader = try container.decode(LeaderType.self, forKey: .leader)
            self.discovered = try container.decode(Bool.self, forKey: .discovered)
            self.sighted = try container.decode(Int.self, forKey: .sighted)
        }
        
        func encode(to encoder: Encoder) throws {
            
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(self.leader, forKey: .leader)
            try container.encode(self.discovered, forKey: .discovered)
            try container.encode(self.sighted, forKey: .sighted)
        }
    }
    
    // MARK: constructor
    
    init() {
        
        self.items = []
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decode([TileDiscoveredItem].self, forKey: .items)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.items, forKey: .items)
    }
    
    func isEmpty() -> Bool {
        
        return self.items.count == 0
    }
    
    func isDiscovered(by player: AbstractPlayer?) -> Bool {
        
        if let item = self.items.first(where: { $0.leader == player?.leader }) {
            
            return item.discovered
        }
        
        return false
    }
    
    func discover(by player: AbstractPlayer?) {
        
        if let item = self.items.first(where: { $0.leader == player?.leader }) {
            item.discovered = true
        } else {
            self.items.append(TileDiscoveredItem(by: player!.leader, discovered: true))
        }
    }
    
    func isVisible(to player: AbstractPlayer?) -> Bool {
        
        if let item = self.items.first(where: { $0.leader == player?.leader }) {
            
            return item.sighted > 0
        }
        
        return false
    }
    
    func sight(by player: AbstractPlayer?) {
        
        if let item = self.items.first(where: { $0.leader == player?.leader }) {
            item.sighted += 1
        } else {
            self.items.append(TileDiscoveredItem(by: player!.leader, discovered: true, sighted: true))
        }
    }
    
    func conceal(to player: AbstractPlayer?) {
        
        if let item = self.items.first(where: { $0.leader == player?.leader }) {
            item.sighted = max(0, item.sighted - 1)
        } else {
            self.items.append(TileDiscoveredItem(by: player!.leader, discovered: false, sighted: false))
        }
    }
}
