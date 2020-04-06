//
//  SiteEvaluator.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 11.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol SiteEvaluator {
    
    func value(of point: HexPoint, for player: AbstractPlayer?) -> Double
    func value(of area: HexArea, for player: AbstractPlayer?) -> Double
}

public class BaseSiteEvaluator: SiteEvaluator {
   
    public func value(of point: HexPoint, for player: AbstractPlayer?) -> Double {
        
        fatalError("must be overloaded by sub class")
    }
    
    public func value(of area: HexArea, for player: AbstractPlayer?) -> Double {
        
        var sum = 0.0
        
        for point in area {
            sum += self.value(of: point, for: player)
        }
        
        return sum
    }
    
    public func bestPoint(of area: HexArea, for player: AbstractPlayer?) -> (HexPoint, Double) {
        
        var bestValue = Double.leastNormalMagnitude
        var bestPoint: HexPoint = area.first
        
        for point in area {
            let value = self.value(of: point, for: player)
            
            if value > bestValue {
                bestValue = value
                bestPoint = point
            }
        }
        
        return (bestPoint, bestValue)
    }
}
