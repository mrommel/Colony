//
//  AStarPathfinder.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 23.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public protocol PathfinderDataSource {

    func walkableAdjacentTilesCoords(forTileCoord tileCoord: HexPoint) -> [HexPoint]
    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double

    func wrapX() -> Int
    func useCache() -> Bool
}

/** A single step on the computed path; used by the A* pathfinding algorithm */
private class AStarPathStep {

    let position: HexPoint
    var parent: AStarPathStep?

    var gScore: Double = 0.0
    var hScore: Double = 0.0
    var fScore: Double {
        return gScore + hScore
    }
    var rScore: Double = 0.0 // real score

    init(position: HexPoint) {
        self.position = position
    }

    func setParent(parent: AStarPathStep, withMoveCost moveCost: Double) {
        // The G score is equal to the parent G score + the cost to move from the parent to it
        self.parent = parent
        self.gScore = parent.gScore + moveCost
        self.rScore = moveCost
    }
}

extension AStarPathStep: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.position)
    }
}

private func == (lhs: AStarPathStep, rhs: AStarPathStep) -> Bool {
    return lhs.position == rhs.position
}

extension AStarPathStep: CustomDebugStringConvertible {
    var debugDescription: String {
        return "AStarPathStep pos=\(position) g=\(gScore) h=\(hScore) f=\(fScore)"
    }
}

struct AStarPathfinderCacheIdentifier {

    let start: HexPoint
    let end: HexPoint

    init(start: HexPoint, end: HexPoint) {

        self.start = start
        self.end = end
    }
}

extension AStarPathfinderCacheIdentifier: Hashable {

    func hash(into hasher: inout Hasher) {

        hasher.combine(self.start)
        hasher.combine(self.end)
    }

    static func == (lhs: AStarPathfinderCacheIdentifier, rhs: AStarPathfinderCacheIdentifier) -> Bool {

        return lhs.start == rhs.start && lhs.end == rhs.end
    }
}

// https://dzenanhamzic.com/2016/12/19/a-star-a-algorithm-with-caching-java-implementation/
class AStarPathfinderCache {

    private var cache: [AStarPathfinderCacheIdentifier: HexPath]
    private let serialQueue = DispatchQueue(label: "AStarPathfinderCache")

    static let shared = AStarPathfinderCache()

    private init() {

        self.cache = [AStarPathfinderCacheIdentifier: HexPath]()
    }

    public func hasCached(for identifier: AStarPathfinderCacheIdentifier) -> Bool {

        return self.serialQueue.sync {
            self.cache[identifier] != nil
        }
    }

    public func hasCached(start: HexPoint, end: HexPoint) -> Bool {

        let identifier = AStarPathfinderCacheIdentifier(start: start, end: end)
        return self.serialQueue.sync {
            self.cache[identifier] != nil
        }
    }

    public func path(for identifier: AStarPathfinderCacheIdentifier) -> HexPath {

        return self.serialQueue.sync {
            self.cache[identifier]!
        }
    }

    public func path(start: HexPoint, end: HexPoint) -> HexPath {

        let identifier = AStarPathfinderCacheIdentifier(start: start, end: end)
        return self.serialQueue.sync {
            self.cache[identifier]!
        }
    }

    public func put(path: HexPath, for identifier: AStarPathfinderCacheIdentifier) {

        self.serialQueue.sync {
            self.cache[identifier] = path
        }
    }

    public func put(path: HexPath, start: HexPoint, end: HexPoint) {

        let identifier = AStarPathfinderCacheIdentifier(start: start, end: end)
        self.serialQueue.sync {
            self.cache[identifier] = path
        }
    }

    internal func reset() {

        self.serialQueue.sync {
            self.cache.removeAll()
        }
    }
}

/** A pathfinder based on the A* algorithm to find the shortest path between two locations */
public class AStarPathfinder {

    public var dataSource: PathfinderDataSource

    public init(with dataSource: PathfinderDataSource) {

        self.dataSource = dataSource
    }

    private func insertStep(step: AStarPathStep, inOpenSteps openSteps: inout [AStarPathStep]) {

        openSteps.append(step)
        openSteps = openSteps.sorted { return $0.fScore <= $1.fScore }
    }

    func hScoreFromCoord(fromCoord: HexPoint, toCoord: HexPoint) -> Double {

        return Double(fromCoord.distance(to: toCoord, wrapX: dataSource.wrapX()))
    }

    /**
     * Concatenate new part of the route with pre-cached route
     * @return Full route (new and cached one combined)
     */
    private func mergePathWithCache(fromTileCoord: HexPoint, toTileCoord: HexPoint, currentStep: AStarPathStep) -> HexPath? {

        // print("this part of the path:["+ startNode.getLocation()+", to:"+ goal +"]is already in cache.");
        var newPath = convertStepsToShortestPath(lastStep: currentStep)
        let cachedSubRoute = AStarPathfinderCache.shared.path(start: currentStep.position, end: toTileCoord)

        for index in 0..<cachedSubRoute.pathWithoutFirst().count {
            let point = cachedSubRoute[index].0
            let cost = cachedSubRoute[index].1
            newPath.append(point: point, cost: cost)
        }

        // cache the whole route
        AStarPathfinderCache.shared.put(path: newPath, start: fromTileCoord, end: toTileCoord)

        // return result
        return newPath
    }

    public func shortestPath(fromTileCoord: HexPoint, toTileCoord: HexPoint) -> HexPath? {

        if fromTileCoord == toTileCoord {
            return nil
        }

        // check if route has already once been found and return it from cache
        if dataSource.useCache() {
            if AStarPathfinderCache.shared.hasCached(start: fromTileCoord, end: toTileCoord) {
                return AStarPathfinderCache.shared.path(start: fromTileCoord, end: toTileCoord)
            }
        }

        // print("shortestPath( (x: \(fromTileCoord.x), y: \(fromTileCoord.y)) x (x: \(toTileCoord.x), y: \(toTileCoord.y)))")

        var closedSteps = Set<AStarPathStep>()

        // The open steps list is initialised with the from position
        var openSteps = [AStarPathStep(position: fromTileCoord)]

        while !openSteps.isEmpty {
            // remove the lowest F cost step from the open list and add it to the closed list
            // Because the list is ordered, the first step is always the one with the lowest F cost
            let currentStep = openSteps.remove(at: 0)
            closedSteps.insert(currentStep)

            // check if there is cached route from this node to the end
            if dataSource.useCache() {
                if AStarPathfinderCache.shared.hasCached(start: currentStep.position, end: toTileCoord) {
                    return mergePathWithCache(fromTileCoord: fromTileCoord, toTileCoord: toTileCoord, currentStep: currentStep)
                }
            }

            // If the current step is the desired tile coordinate, we are done!
            if currentStep.position == toTileCoord {

                let path = convertStepsToShortestPath(lastStep: currentStep)

                // feed into cache
                if dataSource.useCache() {
                    AStarPathfinderCache.shared.put(path: path, start: fromTileCoord, end: toTileCoord)
                }

                return path
            }

            // Get the adjacent tiles coords of the current step
            let adjacentTiles = dataSource.walkableAdjacentTilesCoords(forTileCoord: currentStep.position)
            for tile in adjacentTiles {
                let step = AStarPathStep(position: tile)

                // check if the step isn't already in the closed list
                if closedSteps.contains(step) {
                    continue // ignore it
                }

                // Compute the cost from the current step to that step
                let moveCost = dataSource.costToMove(fromTileCoord: currentStep.position, toAdjacentTileCoord: step.position)
                // print("=== cost from \(currentStep.position) to \(step.position) is \(moveCost)")

                // Check if the step is already in the open list
                if let existingIndex = openSteps.firstIndex(of: step) {
                    // already in the open list

                    // retrieve the old one (which has its scores already computed)
                    let step = openSteps[existingIndex]

                    // check to see if the G score for that step is lower if we use the current step to get there
                    if currentStep.gScore + moveCost < step.gScore {
                        // replace the step's existing parent with the current step
                        step.setParent(parent: currentStep, withMoveCost: moveCost)

                        // Because the G score has changed, the F score may have changed too
                        // So to keep the open list ordered we have to remove the step, and re-insert it with
                        // the insert function which is preserving the list ordered by F score
                        openSteps.remove(at: existingIndex)
                        insertStep(step: step, inOpenSteps: &openSteps)
                    }

                } else { // not in the open list, so add it
                    // Set the current step as the parent
                    step.setParent(parent: currentStep, withMoveCost: moveCost)

                    // Compute the H score which is the estimated movement cost to move from that step to the desired tile coordinate
                    step.hScore = hScoreFromCoord(fromCoord: step.position, toCoord: toTileCoord)

                    // Add it with the function which preserves the list ordered by F score
                    insertStep(step: step, inOpenSteps: &openSteps)
                }
            }
        }

        // no path found
        return nil
    }

    func doesPathExist(fromTileCoord: HexPoint, toTileCoord: HexPoint) -> Bool {

        if fromTileCoord == toTileCoord {
            return false
        }

        return self.shortestPath(fromTileCoord: fromTileCoord, toTileCoord: toTileCoord) != nil
    }

    /// How many turns will it take a unit to get to a target plot (returns MAX_INT if can't reach at all; returns 0 if makes it in 1 turn and has movement left)
    // Should call it with bIgnoreStacking true if want foolproof way to see if can make it in 0 turns (since that way doesn't open
    // open the 2nd layer of the pathfinder)
    func turnsToReachTarget(for unit: AbstractUnit?, to target: HexPoint) -> Int {

        guard let unit = unit else {
            fatalError("cant get unit")
        }

        if let path = self.shortestPath(fromTileCoord: unit.location, toTileCoord: target) {
            let cost = path.cost
            return Int(cost) / unit.moves()
        }

        return Int.max
    }

    private func convertStepsToShortestPath(lastStep: AStarPathStep) -> HexPath {

        var shortestPath = HexPath()
        var currentStep = lastStep

        // if parent is nil, then it is our starting step, so don't include it
        while let parent = currentStep.parent {
            shortestPath.prepend(point: currentStep.position, cost: currentStep.rScore)
            currentStep = parent
        }

        return shortestPath
    }
}
