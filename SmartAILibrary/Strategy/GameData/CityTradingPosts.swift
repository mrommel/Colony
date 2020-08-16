//
//  CityTradingPosts.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol AbstractCityTradingPosts {
    
    func buildTradingPost(for leaderType: LeaderType)
    func hasTradingPost(for leaderType: LeaderType) -> Bool
}

// each leader / civ can have a trading post in the city
// https://civilization.fandom.com/wiki/Trading_Post_(Civ6)
public class CityTradingPosts: AbstractCityTradingPosts, Codable {

    enum CodingKeys: String, CodingKey {
    
        case posts
    }
    
    var city: AbstractCity?
    let posts: LeaderWeightList

    init(city: AbstractCity?) {

        self.city = city
        
        self.posts = LeaderWeightList()
        self.posts.fill()
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.city = nil
        self.posts = try container.decode(LeaderWeightList.self, forKey: .posts)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.posts, forKey: .posts)
    }

    public func buildTradingPost(for leaderType: LeaderType) {

        self.posts.set(weight: 1.0, for: leaderType)
    }
    
    public func hasTradingPost(for leaderType: LeaderType) -> Bool {
        
        return self.posts.weight(of: leaderType) > 0.0
    }
}
