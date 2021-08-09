//
//  Wonders.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum WonderError: Error {
    case alreadyBuild
}

public protocol AbstractWonders: AnyObject, Codable {
    
    var city: AbstractCity? { get set }
    
    // wonders
    func has(wonder: WonderType) -> Bool
    func build(wonder: WonderType) throws
    
    func numberOfBuiltWonders() -> Int
}

class Wonders: AbstractWonders {
    
    enum CodingKeys: CodingKey {

        case wonders
    }
    
    private var wonders: [WonderType]
    internal var city: AbstractCity?
    
    init(city: AbstractCity?) {
        
        self.city = city
        self.wonders = []
    }
    
    public required init(from decoder: Decoder) throws {
    
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.city = nil
        self.wonders = try container.decode([WonderType].self, forKey: .wonders)
    }
    
    public func encode(to encoder: Encoder) throws {
    
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.wonders, forKey: .wonders)
    }
    
    func has(wonder: WonderType) -> Bool {
        
        return self.wonders.contains(wonder)
    }
    
    func build(wonder: WonderType) throws {
        
        if self.wonders.contains(wonder) {
            throw WonderError.alreadyBuild
        }

        self.wonders.append(wonder)
    }

    func numberOfBuiltWonders() -> Int {
        
        var number = 0

        for wonderType in WonderType.all {
            if self.has(wonder: wonderType) {
                number += 1
            }
        }
        
        return number
    }
}
