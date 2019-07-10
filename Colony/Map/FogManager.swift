//
//  FogManager.swift
//  Colony
//
//  Created by Michael Rommel on 03.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol FogUnit {

    var position: HexPoint { get }
    var sight: Int { get }
}

enum FogState: String, Codable {

    case never
    case discovered
    case sighted
}

// to notify the layers
protocol FogStateChangedDelegate: class {

    func changed(to newState: FogState, at pt: HexPoint)
}

class FogArray2D: Array2D<FogState> {

    func addSight(at point: HexPoint, with radius: Int, on map: HexagonTileMap?) {

        guard let map = map else {
            return
        }

        let area = HexArea(center: point, radius: radius)

        for pt in area.points {

            // skip points outside the map
            if !map.valid(point: pt) {
                continue
            }

            self[pt] = .sighted
        }
    }
}

class FogManager: Codable {

    var fog: FogArray2D
    weak var map: HexagonTileMap?
    var units: [FogUnit] = []
    var delegates = MulticastDelegate<FogStateChangedDelegate>()

    enum CodingKeys: String, CodingKey {
        case fog
    }
    
    init(map: HexagonTileMap?) {

        self.map = map
        self.fog = FogArray2D(columns: self.map?.width ?? 1, rows: self.map?.height ?? 1)
        self.fog.fill(with: .never)
    }

    func add(unit: FogUnit) {
        self.units.append(unit)
        
        self.fog.addSight(at: unit.position, with: unit.sight, on: self.map)
    }

    func update() {

        // create tmp fog map
        let tmpFog = FogArray2D(columns: self.map?.width ?? 1, rows: self.map?.height ?? 1)
        tmpFog.fill(with: .never)
        // tmpFog.fill(with: .discovered)

        // copy already discovered
        for x in 0..<self.fog.columns {
            for y in 0..<self.fog.rows {
                if self.fog[x, y] == .discovered || self.fog[x, y] == .sighted {
                    tmpFog[x, y] = .discovered
                }
            }
        }

        // add unit sight
        for unit in self.units {
            // FIXME: only player units?
            tmpFog.addSight(at: unit.position, with: unit.sight, on: self.map)
        }

        // handle changes
        for x in 0..<self.fog.columns {
            for y in 0..<self.fog.rows {

                let oldState = self.fogAt(x: x, y: y)
                
                if let newState = tmpFog[x, y] {
                    
                    if newState == .sighted {
                        self.fog[x, y] = .sighted
                    }
                    
                    if newState == .discovered {
                        self.fog[x, y] = .discovered
                    }
                    
                    if oldState == .sighted && newState != .sighted {
                        notifyDelegatesTo(changedState: newState, at: HexPoint(x: x, y: y))
                    }
                    
                    if oldState != .sighted && newState == .sighted {
                        notifyDelegatesTo(changedState: newState, at: HexPoint(x: x, y: y))
                    }
                }
            }
        }
    }
    
    func notifyDelegatesTo(changedState: FogState, at pt: HexPoint) {
        self.delegates |> { delegate in
            delegate.changed(to: changedState, at: pt)
        }
    }

    func fogAt(x: Int, y: Int) -> FogState {

        guard let map = self.map else {
            return .never
        }

        guard map.valid(x: x, y: y) else {
            return .never
        }

        if let state = self.fog[x, y] {
            return state
        }

        return .never
    }

    func fog(at point: HexPoint) -> FogState {

        guard let map = self.map else {
            return .never
        }

        guard map.valid(x: point.x, y: point.y) else {
            return .never
        }

        if let state = self.fog[point] {
            return state
        }

        return .never
    }

    func neverVisited(at point: HexPoint) -> Bool {

        return self.fog(at: point) == .never
    }
    
    func neverVisitedAt(x: Int, y: Int) -> Bool {
        
        return self.fogAt(x: x, y: y) == .never
    }

    func discovered(at point: HexPoint) -> Bool {

        return self.fog(at: point) == .discovered
    }
    
    func discoveredAt(x: Int, y: Int) -> Bool {
        
        return self.fogAt(x: x, y: y) == .discovered
    }

    func currentlyVisible(at point: HexPoint) -> Bool {

        return self.fog(at: point) == .sighted
    }
    
    func currentlyVisibleAt(x: Int, y: Int) -> Bool {
        
        return self.fogAt(x: x, y: y) == .sighted
    }
    
    func numberOfDiscoveredTiles() -> Int {
        
        var result = 0
        
        for x in 0..<self.fog.columns {
            for y in 0..<self.fog.rows {
                
                let state = self.fogAt(x: x, y: y)
                if state == .discovered || state == .sighted {
                    result += 1
                }
            }
        }
        
        return result
    }
}
