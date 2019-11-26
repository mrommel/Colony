//
//  ScoutingMission.swift
//  Colony
//
//  Created by Michael Rommel on 26.11.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

/// mission for going to target or following a path
class ScoutingMission: Mission {
    
    let target: HexPoint?
    var path: HexPath?
    var onWalk: Bool = false
    
    init(unit: Unit?, target: HexPoint) {
        
        self.target = target
        self.path = nil
        super.init(unit: unit)
    }
    
    init(unit: Unit?, path: HexPath) {
        
        self.target = nil
        self.path = path
        super.init(unit: unit)
    }
    
    override func follow(in game: Game?) {

        // mutex to prevent showing walk multiple times
        if self.onWalk {
            return
        }
        
        if let path = self.path {
            self.onWalk = true
            self.unit?.gameObject?.showWalk(on: path, completion: {
                self.unit?.gameObject?.showIdle()
                self.onWalk = false
                self.unit?.missionFinished(with: .success)
            })
            return
        }
        
        if let target = self.target {
            
            guard let unitPosition = self.unit?.position else {
                fatalError("can't find position of unit")
            }
            
            let pathFinder = AStarPathfinder()
            pathFinder.dataSource = game?.pathfinderDataSource(for: self.unit, ignoreSight: true)

            if let path = pathFinder.shortestPath(fromTileCoord: unitPosition, toTileCoord: target) {
                self.path = path
            } else {
                // no path towards target can be found - nevertheless we can go in the general direction
                let neighbors = pathFinder.dataSource.walkableAdjacentTilesCoords(forTileCoord: unitPosition)
                
                if neighbors.isEmpty {
                    self.unit?.missionFinished(with: .failed)
                    return
                }
                
                var bestNeighbor = neighbors.first!
                var bestDistance = Int.max
                
                for neighbor in neighbors {
                    let dist = unitPosition.distance(to: neighbor)
                    
                    if dist < bestDistance {
                        bestNeighbor = neighbor
                        bestDistance = dist
                    }
                }
                
                let neighborMission = ScoutingMission(unit: self.unit, target: bestNeighbor)
                self.unit?.order(mission: neighborMission)
            }

            return
        }
        
        fatalError("neighter target nor path set")
    }
}
