//
//  BaseMapHandler.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 19.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class Utils {

    static let isRunningUnitTests: Bool = {
        let environment = ProcessInfo().environment
        return (environment["XCTestConfigurationFilePath"] != nil)
    }()
}

public class BaseMapHandler {

    public init() {

    }

    public func placeResources(on grid: MapModel?) {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        let resources = ResourceType.all
            .filter { $0.usage() != .artifact }
            .sorted(by: { $0.placementOrder() < $1.placementOrder() })

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

        var resourceCount = self.numberOfResourcesToAdd(for: resource, on: grid)

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

                if tile.canHave(resource: resource, ignoreLatitude: true, in: grid) {

                    var resourceNum = 1

                    if resource == .horses || resource == .iron || resource == .niter || resource == .aluminum {
                        resourceNum = 2
                    } else if resource == .oil || resource == .coal || resource == .uranium {
                        resourceNum = 3
                    }

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

    struct ResourcesInfo {

        let resource: ResourceType
        let numPossible: Int
        let alreadyPlaced: Int
    }

    internal func numberOfResources(for resource: ResourceType, on grid: MapModel?) -> ResourcesInfo {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        // Calculate numPossible, the number of plots that are eligible to have this resource:
        var numPossible = 0
        var alreadyPlaced = 0

        // iterate all points
        for gridPoint in grid.points() {

            if let tile = grid.tile(at: gridPoint) {

                /*if tile.terrain() == .desert || tile.terrain() == .tundra {
                    print("debug")
                }*/

                if tile.canHave(resource: resource, ignoreLatitude: true, in: grid) {
                    numPossible += 1
                } else if tile.resource(for: nil) == resource {
                    numPossible += 1
                    alreadyPlaced += 1
                }
            }
        }

        return ResourcesInfo(resource: resource, numPossible: numPossible, alreadyPlaced: alreadyPlaced)
    }

    // https://github.com/Gedemon/Civ5-YnAEMP/blob/db7cd1bc6a0684411aba700838184bcc6272b166/Override/WorldBuilderRandomItems.lua
    internal func numberOfResourcesToAdd(for resource: ResourceType, on grid: MapModel?) -> Int {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        // get info about current resource in map
        let info = self.numberOfResources(for: resource, on: grid)

        let mapFactor = grid.size.numberOfTiles() * 100 / MapSize.standard.numberOfTiles()

        var absoluteAmount = max(1, resource.baseAmount() * mapFactor / 100)

        // skip random altering for tests
        if !Utils.isRunningUnitTests {
            if resource.absoluteVarPercent() > 0 {
                let rand1 = absoluteAmount - (absoluteAmount * resource.absoluteVarPercent() / 100)
                let rand2 = absoluteAmount + (absoluteAmount * resource.absoluteVarPercent() / 100)
                absoluteAmount = Int.random(minimum: rand1, maximum: rand2)
            }
        }

        absoluteAmount -= info.alreadyPlaced

        // limit to possible
        absoluteAmount = max(0, min(absoluteAmount, info.numPossible))

        print("try to place \(absoluteAmount) of \(resource.name()) on \(info.numPossible) possible (\(info.alreadyPlaced) already placed)")
        return absoluteAmount
    }

    // CvMapGenerator::addGoodies()
    func addGoodyHuts(on grid: MapModel?) {

        guard let grid = grid else {
            fatalError("cant get grid")
        }

        grid.analyze()

        var points: [HexPoint] = grid.points().shuffled

        let tilesPerGoody = 40
        var goodyHutsAdded: Int = 0
        let goodyRange: Int = 3

        for point in points {

            if let tile = grid.tile(at: point) {

                if !tile.isWater() {

                    if let area = tile.area {
                        if area.number(of: ImprovementType.goodyHut) < ((area.points.count + tilesPerGoody / 2) / tilesPerGoody) {

                            if ImprovementType.goodyHut.isGoodyHutPossible(on: tile) {
                                tile.set(improvement: ImprovementType.goodyHut)
                                goodyHutsAdded += 1

                                // goodyhuts should not be to near to each other
                                points.removeAll(where: { $0.distance(to: tile.point, wrapX: grid.wrapX ? grid.size.width() : -1) <= goodyRange })
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
