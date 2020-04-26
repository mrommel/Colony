//
//  RankingData.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 25.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class RankingData {
    
    public class RankingLeaderData {
        
        public let leader: LeaderType
        public var data: [Int] // one value per turn
        
        init(leader: LeaderType) {
            
            self.leader = leader
            self.data = []
        }
        
        func add(score: Int) {
            self.data.append(score)
        }
    }
    
    public var data: [RankingLeaderData]
    
    public init(players: [AbstractPlayer]) {
        
        self.data = []
        
        for player in players {
            
            self.data.append(RankingLeaderData(leader: player.leader))
        }
    }
    
    public func add(score: Int, for leader: LeaderType) {
        
        if let leaderData = self.data.first(where: { $0.leader == leader }) {
            leaderData.add(score: score)
        } else {
            fatalError("cannot happen")
        }
    }
}
