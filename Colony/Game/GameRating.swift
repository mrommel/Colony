//
//  GameRating.swift
//  Colony
//
//  Created by Michael Rommel on 13.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol GameRatingProtocol {
    
    func value(for civilization: Civilization) -> Double
}

class GameRating: GameRatingProtocol {
    
    weak var game: Game? = nil
    
    required init(game: Game?) {
        
        self.game = game
    }

    func calculateDiscoveredTiles(of civilization: Civilization) -> Int {

        if let discoveredTiles = self.game?.numberOfDiscoveredTiles(for: civilization) {

            return discoveredTiles
        }
        
        return 0
    }
    
    func value(for civilization: Civilization) -> Double {
        
        fatalError("Must be implemented by subclass")
    }
}

class GameRatingLevel0001: GameRating {
    
    let positionOfLondon = HexPoint(x: 20, y: 13)
    
    override func value(for civilization: Civilization) -> Double {
        
        //let discoveredTiles = Double(self.calculateDiscoveredTiles(of: civilization))
        
        //return discoveredTiles * 2.0
        
        var combinedDistanceOfUnits = 0.0
        
        guard let units = self.game?.getUnitsOf(civilization: civilization) else {
            fatalError("can't get units of \(civilization)")
        }
        
        for unit in units {
            if let unit = unit {
                combinedDistanceOfUnits = combinedDistanceOfUnits + 1.0 / Double(unit.position.distance(to: self.positionOfLondon))
            }
        }
        
        return combinedDistanceOfUnits // avg distance to target
    }
}
