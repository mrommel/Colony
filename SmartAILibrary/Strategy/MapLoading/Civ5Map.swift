//
//  Civ5Map.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.08.19.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public class Civ5Map {

    let header: Civ5MapHeader
    let plots: Array2D<Civ5MapPlot>

    init(header: Civ5MapHeader, plots: Array2D<Civ5MapPlot>) {
        self.header = header
        self.plots = plots
    }

    func riverFlowsNorthAt(x: Int, y: Int) -> Bool {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)

        // FLOWDIRECTION_NORTH == 1,
        return riverValue & (1 << 0) > 0
    }

    func riverFlowsNorthEastAt(x: Int, y: Int) -> Bool {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)

        // FLOWDIRECTION_NORTHEAST == 2,
        return riverValue & (1 << 1) > 0
    }

    func riverFlowsSouthEastAt(x: Int, y: Int) -> Bool {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)

        // FLOWDIRECTION_SOUTHEAST == 4,
        return riverValue & (1 << 2) > 0
    }

    func riverFlowsSouthAt(x: Int, y: Int) -> Bool {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)

        // FLOWDIRECTION_SOUTH = 8,
        return riverValue & (1 << 1) > 0
    }

    func riverFlowsSouthWestAt(x: Int, y: Int) -> Bool {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)

        // FLOWDIRECTION_SOUTHWEST == 16,
        return riverValue & (1 << 1) > 0
    }

    func riverFlowsNorthWestAt(x: Int, y: Int) -> Bool {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)

        // FLOWDIRECTION_NORTHWEST == 32
        return riverValue & (1 << 1) > 0
    }

    func riverFlowsAt(x: Int, y: Int) -> [FlowDirection] {

        guard let plot = self.plots[x, y] else {
            fatalError("Can't get plot")
        }

        let riverValue: Int = Int(plot.river)
        if riverValue != 0 {
            //print("river value: \(riverValue)")
            var flows: [FlowDirection] = []

            // civ5 map is pointy, colony map is flat - problem

            if self.riverFlowsNorthAt(x: x, y: y) {
                // NOOP
            }

            if self.riverFlowsNorthEastAt(x: x, y: y) {
                // same as civ5
                flows.append(FlowDirection.northEast)
            }

            if self.riverFlowsSouthEastAt(x: x, y: y) {
                // same as civ5 but different tile
                flows.append(FlowDirection.southEast)
            }

            if self.riverFlowsSouthAt(x: x, y: y) {
                // NOOP
            }

            if self.riverFlowsSouthWestAt(x: x, y: y) {
                // same as civ5
                flows.append(FlowDirection.southWest)
            }

            if self.riverFlowsNorthWestAt(x: x, y: y) {
                // same as civ5 but different tile
                flows.append(FlowDirection.northWest)
            }

            if self.riverFlowsSouthEastAt(x: x, y: y) && self.riverFlowsNorthEastAt(x: x, y: y) {
                flows.append(FlowDirection.east)
            }

            if self.riverFlowsNorthWestAt(x: x, y: y) && self.riverFlowsSouthWestAt(x: x, y: y) {
                flows.append(FlowDirection.west)
            }

            return flows
        }

        return []
    }

    public func toMap() -> MapModel? {

        let map = MapModel(width: Int(header.width), height: Int(header.height))

        map.name = self.header.mapName
        map.summary = self.header.summary

        for y in 0..<Int(header.height) {
            for x in 0..<Int(header.width) {

                guard let plot = self.plots[x, y] else {
                    fatalError("Can't get plot")
                }

                let point = HexPoint(x: x, y: y)
                guard let tile = map.tile(at: point) else {
                    fatalError("Can't get tile")
                }

                tile.set(terrain: plot.terrain)

                tile.set(hills: plot.hills)

                // base features
                if let feature1st = plot.feature1stType {
                    tile.set(feature: feature1st)
                }

                // natural wonders
                if let feature2nd = plot.feature2ndType {
                    tile.set(feature: feature2nd)
                }

                if let resourceType = plot.ressourceType {
                    tile.set(resource: resourceType)
                    tile.set(resourceQuantity: Int(plot.resourceQuantity))
                }

                let flows: [FlowDirection] = self.riverFlowsAt(x: x, y: y)
                for flow in flows {
                    do {
                        let river = River(with: "Misc", and: [])
                        if flow == FlowDirection.southEast || flow == FlowDirection.northWest {
                            let neighborInSouthWest = point.neighbor(in: .southwest)
                            if map.valid(point: neighborInSouthWest) {
                                if let tileInSouthWest = map.tile(at: neighborInSouthWest) {
                                    try tileInSouthWest.set(river: river, with: flow)
                                }
                            }
                        } else if flow == FlowDirection.east || flow == FlowDirection.west {
                            let neighborInNorth = point.neighbor(in: .north)
                            if map.valid(point: neighborInNorth) {
                                if let tileInNorth = map.tile(at: neighborInNorth) {
                                    try tileInNorth.set(river: river, with: flow)
                                }
                            }
                        } else {
                            try tile.set(river: river, with: flow)
                        }
                    } catch {
                        fatalError("Can't set flow")
                    }
                }

                map.set(tile: tile, at: point)
            }
        }

        return map
    }
}
