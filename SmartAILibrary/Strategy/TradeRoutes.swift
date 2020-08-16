//
//  TradeRoutes.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class TradeRoute: Codable {
    
    public static let range = 15
    
    enum CodingKeys: String, CodingKey {
    
        case start
        case posts
        case end
    }
    
    let start: HexPoint
    let posts: [HexPoint]
    let end: HexPoint
    
    init(start: HexPoint, posts: [HexPoint], end: HexPoint) {
        
        self.start = start
        self.posts = posts
        self.end = end
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.start = try container.decode(HexPoint.self, forKey: .start)
        self.posts = try container.decode([HexPoint].self, forKey: .posts)
        self.end = try container.decode(HexPoint.self, forKey: .end)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.start, forKey: .start)
        try container.encode(self.posts, forKey: .posts)
        try container.encode(self.end, forKey: .end)
    }
    
    func isDomestic(in gameModel: GameModel?) -> Bool {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let startLeader = gameModel.city(at: self.start)?.player?.leader else {
            return false
        }
        
        guard let endLeader = gameModel.city(at: self.end)?.player?.leader else {
            return false
        }
        
        return startLeader != endLeader
    }
    
    func isInternational(in gameModel: GameModel?) -> Bool {
        
        return !self.isDomestic(in: gameModel)
    }
    
    func yields(in gameModel: GameModel?) -> Yields {
        
        guard let gameModel = gameModel else {
            fatalError("cant get gameModel")
        }
        
        guard let startPlayer = gameModel.city(at: self.start)?.player else {
            fatalError("cant get start player")
        }
        
        guard let startPlayerGovernment = startPlayer.government else {
            fatalError("cant get start player government")
        }
        
        guard let endCity = gameModel.city(at: self.end) else {
            fatalError("cant get end city")
        }
        
        guard let endDistricts = endCity.districts else {
            fatalError("cant get end city districts")
        }
        
        let yields: Yields = Yields(food: 0.0, production: 0.0, gold: 0.0)
        
        if self.isDomestic(in: gameModel) {
            yields.food += 1.0
            yields.production += 1.0
            
            if startPlayer.leader.civilization().ability() == .satrapies {
                // Domestic TradeRoute6 Trade Routes provide +2 Civ6Gold Gold and +1 Civ6Culture Culture.
                yields.gold += 2.0
                yields.culture += 1.0
            }
        } else {
            yields.gold += 3.0
    
            if endDistricts.has(district: .campus) {
                yields.science += 1.0
            }
            
            if endDistricts.has(district: .holySite) {
                yields.faith += 1.0
            }
            
            if endDistricts.has(district: .industrial) {
                yields.production += 1.0
            }
            
            if endDistricts.has(district: .commercialHub) {
                yields.gold += 1.0
            }
            
            if endDistricts.has(district: .harbor) {
                yields.gold += 1.0
            }
        }
        
        if startPlayerGovernment.has(card: .caravansaries) {
            yields.gold += 2.0
        }
        
        // posts - currently no implemented
        yields.gold += Double(self.posts.count)
        
        if startPlayer.leader.civilization().ability() == .allRoadsLeadToRome {
            //  TradeRoute6 Trade Routes generate +1 additional Civ6Gold Gold from Roman Trading Posts they pass through.
            yields.gold += Double(self.posts.count)
        }
        
        return yields
    }
}

public class TradeRoutes: Codable {
    
    enum CodingKeys: String, CodingKey {
    
        case routes
    }
    
    var player: Player?
    private var routes: [TradeRoute]
    
    // MARK: constructors

    init(player: Player?) {

        self.player = player
        self.routes = []
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.routes = try container.decode([TradeRoute].self, forKey: .routes)
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.routes, forKey: .routes)
    }
    
    public var count: Int {
        
        return self.routes.count
    }
    
    // FIXME - take trading posts into account
    // FIXME - sea trading routes
    public func establishTradeRoute(from originCity: AbstractCity?, to targetCity: AbstractCity?, with trader: AbstractUnit?, in gameModel: GameModel?) -> Bool {
        
        guard let originCityLocation = originCity?.location else {
            fatalError("cant get origin city location")
        }
        
        guard let targetCityLocation = targetCity?.location else {
            fatalError("cant get target city location")
        }
        
        guard let path = trader?.path(towards: targetCityLocation, in: gameModel) else {
            print("no path")
            return false
        }
        
        guard path.count <= TradeRoute.range else {
            print("trading posts not handled")
            return false
        }
        
        self.routes.append(TradeRoute(start: originCityLocation, posts: [], end: targetCityLocation))
        return true
    }
}
