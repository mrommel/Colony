//
//  FogManager.swift
//  Colony
//
//  Created by Michael Rommel on 03.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

protocol FogUnit {

    var civilization: Civilization { get }
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

    func changed(for civilization: Civilization, to newState: FogState, at pt: HexPoint)
}

class FogArray2D: Array2D<FogState> {

    func addSight(at point: HexPoint, with radius: Int, on map: HexagonTileMap?) {

        guard let map = map else {
            return
        }

        let area = point.areaWith(radius: radius)

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

    var fogDict: [Civilization: FogArray2D] = [:]
    weak var map: HexagonTileMap?
    var units: [FogUnit] = []
    var cities: [FogUnit] = []
    var delegates = MulticastDelegate<FogStateChangedDelegate>()

    enum CodingKeys: String, CodingKey {
        case fogDict
    }

    init(map: HexagonTileMap?) {

        self.map = map

        for civilization in Civilization.all {

            let fog = FogArray2D(columns: self.map?.width ?? 1, rows: self.map?.height ?? 1)
            fog.fill(with: .never)
            self.fogDict[civilization] = fog
        }
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)
    
        self.fogDict = try values.decode([Civilization: FogArray2D].self, forKey: .fogDict)
    }

    func add(unit: FogUnit) {

        self.units.append(unit)

        self.fogDict[unit.civilization]?.addSight(at: unit.position, with: unit.sight, on: self.map)
    }

    func add(city: FogUnit) {

        self.cities.append(city)

        self.fogDict[city.civilization]?.addSight(at: city.position, with: 2, on: self.map)
    }

    func update() {

        for civilization in Civilization.all {

            // create tmp fog map
            let tmpFog = FogArray2D(columns: self.map?.width ?? 1, rows: self.map?.height ?? 1)
            tmpFog.fill(with: .never)

            guard let currentFog = self.fogDict[civilization] else {
                fatalError("can't get fog for \(civilization)")
            }

            // copy already discovered
            for x in 0..<currentFog.columns {
                for y in 0..<currentFog.rows {
                    if currentFog[x, y] == .discovered || currentFog[x, y] == .sighted {
                        tmpFog[x, y] = .discovered
                    }
                }
            }

            // add unit sight
            for unit in self.units {
                tmpFog.addSight(at: unit.position, with: unit.sight, on: self.map)
            }

            // add unit sight
            for city in self.cities {
                tmpFog.addSight(at: city.position, with: city.sight, on: self.map)
            }

            // handle changes
            for x in 0..<currentFog.columns {
                for y in 0..<currentFog.rows {

                    let oldState = self.fogAt(x: x, y: y, for: civilization)

                    if let newState = tmpFog[x, y] {

                        if newState == .sighted {
                            self.fogDict[civilization]?[x, y] = .sighted
                        }

                        if newState == .discovered {
                            self.fogDict[civilization]?[x, y] = .discovered
                        }

                        if oldState == .sighted && newState != .sighted {
                            notifyDelegatesTo(for: civilization, changedState: newState, at: HexPoint(x: x, y: y))
                        }

                        if oldState != .sighted && newState == .sighted {
                            notifyDelegatesTo(for: civilization, changedState: newState, at: HexPoint(x: x, y: y))
                        }
                    }
                }
            }
        }
    }

    func notifyDelegatesTo(for civilization: Civilization, changedState: FogState, at pt: HexPoint) {
        self.delegates |> { delegate in
            delegate.changed(for: civilization, to: changedState, at: pt)
        }
    }

    func fogAt(x: Int, y: Int, for civilization: Civilization) -> FogState {

        guard let map = self.map else {
            return .never
        }

        guard map.valid(x: x, y: y) else {
            return .never
        }

        if let state = self.fogDict[civilization]?[x, y] {
            return state
        }

        return .never
    }

    func fog(at point: HexPoint, by civilization: Civilization) -> FogState {

        guard let map = self.map else {
            return .never
        }

        guard map.valid(x: point.x, y: point.y) else {
            return .never
        }

        if let state = self.fogDict[civilization]?[point] {
            return state
        }

        return .never
    }

    func neverVisited(at point: HexPoint, by civilization: Civilization) -> Bool {

        return self.fog(at: point, by: civilization) == .never
    }

    func neverVisitedAt(x: Int, y: Int, by civilization: Civilization) -> Bool {

        return self.fogAt(x: x, y: y, for: civilization) == .never
    }

    func discovered(at point: HexPoint, by civilization: Civilization) -> Bool {

        return self.fog(at: point, by: civilization) == .discovered
    }

    func discoveredAt(x: Int, y: Int, by civilization: Civilization) -> Bool {

        return self.fogAt(x: x, y: y, for: civilization) == .discovered
    }

    func currentlyVisible(at point: HexPoint, by civilization: Civilization) -> Bool {

        return self.fog(at: point, by: civilization) == .sighted
    }

    func currentlyVisibleAt(x: Int, y: Int, by civilization: Civilization) -> Bool {

        return self.fogAt(x: x, y: y, for: civilization) == .sighted
    }

    func numberOfDiscoveredTiles(by civilization: Civilization) -> Int {

        return self.fogDict[civilization]?.count(where: { $0 == .discovered || $0 == .sighted }) ?? 0
    }
}

extension KeyedDecodingContainer {
    
    func decode(_ type: Dictionary<Civilization, FogArray2D>.Type, forKey key: K) throws -> Dictionary<Civilization, FogArray2D> {

        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    func decode(_ type: Dictionary<Civilization, FogArray2D>.Type) throws -> Dictionary<Civilization, FogArray2D> {
    
        var dictionary = Dictionary<Civilization, FogArray2D>()
        
        for key in allKeys {
            let civilization = Civilization(rawValue: key.stringValue)!
            
            if let arrayValue = try? decode(FogArray2D.self, forKey: key) {
                dictionary[civilization] = arrayValue
            }
        }
        
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: Array<FogArray2D>.Type) throws -> Array<FogArray2D> {
        var array: [FogArray2D] = []
        while isAtEnd == false {
            if let value = try? decode(FogArray2D.self) {
                array.append(value)
            }
        }
        return array
    }
}
