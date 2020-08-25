//
//  UnitTradeRoute.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.08.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class UnitTradeRouteData {
    
    let tradeRoute: TradeRoute
    var direction: UnitTradeRouteDirection
    
    init(from tradeRoute: TradeRoute) {
        
        self.tradeRoute = tradeRoute
        self.direction = .forward
    }
    
    func doTurn(for unit: AbstractUnit?, in gameModel: GameModel?) {
        
        //print("--- trader")
        guard let unit = unit else {
            fatalError("cant get unit")
        }
        
        var isFollowingMission = false
        if let mission = unit.peekMission() {
            if mission.type == .routeTo {
                isFollowingMission = true
            }
        }
        
        if !isFollowingMission {
            if let target = self.nextTarget(current: unit.location, in: gameModel) {
                let mission = UnitMission(type: .routeTo, at: target)
                unit.push(mission: mission, in: gameModel)
            }
        }
    }
    
    func nextTarget(current: HexPoint, in gameModel: GameModel?) -> HexPoint? {
        
        // check if unit directly at one of the points
        if self.direction == .forward {

            if current == self.tradeRoute.start {
                
                if let firstPost = self.tradeRoute.posts.first {
                    return firstPost
                } else {
                    return self.tradeRoute.end
                }
            }
            
            for (index, post) in self.tradeRoute.posts.enumerated() {
                if post == current {
                    if index + 1 < self.tradeRoute.posts.count {
                        return self.tradeRoute.posts[index + 1]
                    } else {
                        return self.tradeRoute.end
                    }
                }
            }
            
            if current == self.tradeRoute.end {
                self.direction = .backward
                return self.nextTarget(current: current, in: gameModel)
            }
        } else {
            if current == self.tradeRoute.end {
                if let lastPost = self.tradeRoute.posts.last {
                    return lastPost
                } else {
                    return self.tradeRoute.start
                }
            }
            
            for (index, post) in self.tradeRoute.posts.reversed().enumerated() {
                if post == current {
                    if index > 0 {
                        return self.tradeRoute.posts[index - 1]
                    } else {
                        return self.tradeRoute.start
                    }
                }
            }
            
            if current == self.tradeRoute.start {
                self.direction = .forward
                return self.nextTarget(current: current, in: gameModel)
            }
        }
        
        // find next city and go there
        var bestDistance = Int.max
        var bestLocation: HexPoint? = nil
        
        var points: [HexPoint] = [self.tradeRoute.start, self.tradeRoute.end]
        points.append(contentsOf: self.tradeRoute.posts)
        
        for point in points {
            
            let distance = current.distance(to: point)
            
            if distance < bestDistance {
                bestDistance = distance
                bestLocation = point
            }
        }
        
        return bestLocation
    }
}
