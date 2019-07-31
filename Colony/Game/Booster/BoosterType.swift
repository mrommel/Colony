//
//  BoosterType.swift
//  Colony
//
//  Created by Michael Rommel on 28.07.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

enum BoosterType: String, Codable {
    
    case telescope = "telescope"
    case time = "time"
    //case wind = "wind"
    
    static let all: [BoosterType] = [.telescope, .time]
    
    // costs
    
    // effect ???? how to implement this
    
    var textureName: String {
        
        switch self {
        case .telescope:
            return "booster_telescope"
        case .time:
            return "booster_time"
            //case .wind:
        }
    }
    
    var title: String {
        
        switch self {
        case .telescope:
            return "Telescope"
        case .time:
            return "Timer stops"
            //case .wind:
        }
    }
    
    var summary: String {
        
        switch self {
        case .telescope:
            return "Increases sight by 1"
        case .time:
            return "Gives extra time (30 seconds)"
            //case .wind:
        }
    }
    
    var timeInterval: TimeInterval {
        
        switch self {
        case .telescope:
            return 30 // s
        case .time:
            return 30 // s
            //case .wind:
        }
    }
    
    /// coins to spend to buy this in the shop
    var coins: Int {
        
        switch self {
        case .telescope:
            return 10
        case .time:
            return 20
            //case .wind:
        }
    }
}
