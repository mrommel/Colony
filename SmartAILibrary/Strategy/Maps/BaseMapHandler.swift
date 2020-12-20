//
//  BaseMapHandler.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class BaseMapHandler {

    public init() {
        
    }
    
    public func placeResources(on grid: MapModel?) {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        let resources = ResourceType.all.sorted(by: { $0.placementOrder() > $1.placementOrder() })

        // Add resources
        for resource in resources {
            self.addNonUnique(resource: resource, on: grid)
        }

        print("-------------------------------")

        // Show number of resources placed
        for resource in resources {

            var resourcePlaced = 0
            for x in 0..<grid.size.width() {
                for y in 0..<grid.size.height() {

                    if let tile = grid.tile(x: x, y: y) {
                        if tile.resource(for: nil) == resource {
                            resourcePlaced += 1
                        }
                    }
                }
            }

            print("Counted \(resourcePlaced) of \(resource.name()) placed on map")
        }
    }

    func addNonUnique(resource: ResourceType, on grid: MapModel?) {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        var resourceCount = self.numOfResourcesToAdd(for: resource, on: grid)

        if resourceCount == 0 {
            return
        }

        var points: [HexPoint] = []

        for x in 0..<grid.size.width() {
            for y in 0..<grid.size.height() {
                points.append(HexPoint(x: x, y: y))
            }
        }

        points.shuffle()

        for point in points {

            if let tile = grid.tile(at: point) {

                if self.canPlace(resource: resource, at: tile, on: grid) {

                    let resourceNum = 50 + Int.random(maximum: 20) // FIXME

                    tile.set(resourceQuantity: resourceNum)
                    tile.set(resource: resource)

                    resourceCount -= 1

                    // FIXME: groups
                }

                if resourceCount == 0 {
                    return
                }
            }
        }
    }

    // https://github.com/Gedemon/Civ5-YnAEMP/blob/db7cd1bc6a0684411aba700838184bcc6272b166/Override/WorldBuilderRandomItems.lua
    private func numOfResourcesToAdd(for resource: ResourceType, on grid: MapModel?) -> Int {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        // Calculate resourceCount, the amount of this resource to be placed:
        let rand1 = Int.random(maximum: resource.propability())
        let rand2 = Int.random(maximum: resource.propability())
        let baseCount = resource.basePropability() + rand1 + rand2

        // Calculate numPossible, the number of plots that are eligible to have this resource:
        var numPossible = 0
        var alreadyPlaced = 0
        var landTiles = 0

        for x in 0..<grid.size.width() {
            for y in 0..<grid.size.height() {
                let gridPoint = HexPoint(x: x, y: y)

                if let tile = grid.tile(at: gridPoint) {
                    if tile.canHave(resource: resource, ignoreLatitude: false, in: grid) {
                        numPossible += 1
                    } else if tile.resource(for: nil) == resource {
                        numPossible += 1
                        alreadyPlaced += 1
                    }
                }
            }
        }

        if resource.tilesPerPossible() > 0 {
            landTiles = (numPossible / resource.tilesPerPossible())
        }

        let realNumCivAlive = 4 //self.options.numberOfPlayers
        let players = Int((realNumCivAlive * resource.playerScale()) / 100)
        var resourceCount = (baseCount * (landTiles + players)) / 100
        resourceCount = max(1, resourceCount)

        if resourceCount < alreadyPlaced {
            resourceCount = 0
        } else {
            resourceCount = resourceCount - alreadyPlaced
        }

        print("try to place \(resourceCount) \(resource.name()) (\(alreadyPlaced) already placed)")

        return resourceCount
    }

    func canPlace(resource: ResourceType, at tile: AbstractTile?, on grid: MapModel?) -> Bool {

        if let tile = tile {
            return tile.canHave(resource: resource, ignoreLatitude: true, in: grid)
        }

        return false
    }

    // CvMapGenerator::addGoodies()
    func addGoodies(on grid: MapModel?) {

        guard let grid = grid else {
            fatalError("cant get grid")
        }
        
        grid.analyze()
        
        var points: [HexPoint] = []

        for x in 0..<grid.size.width() {
            for y in 0..<grid.size.height() {
                points.append(HexPoint(x: x, y: y))
            }
        }

        points.shuffle()
        
        let tilesPerGoody = 40
        var goodyHutsAdded: Int = 0
        // <GoodyRange>3</GoodyRange>
        
        for point in points {
            
            if let tile = grid.tile(at: point) {
                
                if !tile.isWater() {
                    
                    if let area = tile.area {
                        if area.number(of: ImprovementType.goodyHut) < ((area.points.count + tilesPerGoody / 2) / tilesPerGoody) {
                            if ImprovementType.goodyHut.isGoodyHutPossible(on: tile) {
                                tile.set(improvement: ImprovementType.goodyHut)
                                goodyHutsAdded += 1
                            }
                        }
                    }
                }
            }
        }
        
        print("-------------------------------")
        print("\(goodyHutsAdded) goody huts added")
    }
}
