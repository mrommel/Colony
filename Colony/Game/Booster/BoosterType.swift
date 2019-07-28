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
    
    // costs, duration, texture/icon
    
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
    
    var timeInterval: TimeInterval {
        
        switch self {
        case .telescope:
            return 10 // s
        case .time:
            return 20 // s 
            //case .wind:
        }
    }
}
