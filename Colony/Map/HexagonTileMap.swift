//
//  HexagonTileMap.swift
//  Colony
//
//  Created by Michael Rommel on 29.05.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation
import CoreGraphics

class HexagonTileMap: HexagonMap<Tile> {
    
    // MARK: properties
    
    var rivers: [River] = []
    var fogManager: FogManager? = nil
    
    private var units: [Unit] = []
    var cities: [City] = []
    var animals: [Animal] = []
    
    // properties that are not stored
    var continents: [Continent] = []
    var oceans: [Ocean] = []
    
    enum CodingKeys: String, CodingKey {
        
        case rivers
        case fogManager
        
        case units
        case cities
        case animals
    }
    
    // MARK: constructors
    
    override init(with size: CGSize) {
        super.init(width: Int(size.width), height: Int(size.height))
        
        for x in 0..<self.width {
            for y in 0..<self.height {
                let point = HexPoint(x: x, y: y)
                self.set(tile: Tile(at: point, with: .ocean), at: point)
            }
        }
        
        self.fogManager = FogManager(map: self)
    }
    
    override init(width: Int, height: Int) {
        super.init(width: width, height: height)
        
        for x in 0..<width {
            for y in 0..<height {
                let point = HexPoint(x: x, y: y)
                self.set(tile: Tile(at: point, with: .ocean), at: point)
            }
        }
        
        self.fogManager = FogManager(map: self)
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.rivers = try values.decode([River].self, forKey: .rivers)
        self.fogManager = try values.decode(FogManager.self, forKey: .fogManager)
        self.units = try values.decode([Unit].self, forKey: .units)
        self.replaceUnits()
        self.cities = try values.decode([City].self, forKey: .cities)
        self.replaceItems()
        
        // find continents and oceans
        let continentFinder = ContinentFinder(width: self.width, height: self.height)
        self.continents = continentFinder.execute(on: self)
        
        let oceanFinder = OceanFinder(width: self.width, height: self.height)
        self.oceans = oceanFinder.execute(on: self)
        
        // assign city to its tiles
        let cities = self.getCities()
        for city in cities {
            
            if let cityTile = self.tile(at: city.position) {
                cityTile.city = city
            }
        }
    }
    
    override func encode(to encoder: Encoder) throws {
        
        try super.encode(to: encoder)
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rivers, forKey: .rivers)
        try container.encode(self.fogManager, forKey: .fogManager)
        try container.encode(self.animals, forKey: .animals)
        try container.encode(self.units, forKey: .units)
        try container.encode(self.cities, forKey: .cities)
    }
    
    func replaceUnits() {
        
        var customUnits: [Unit] = []
        for unit in self.units {
            
            switch unit.unitType {
                
            /*case .trader:
                <#code#>
            case .pirates:
                <#code#>
            case .settler:
                <#code#>
            case .builder:
                <#code#>
            case .galley:
                <#code#>
            case .trireme:
                <#code#>
            case .galleass:
                <#code#>*/
            case .caravel:
                let caravel = Caravel(position: unit.position, civilization: unit.civilization)
                caravel.copy(from: unit)
                customUnits.append(caravel)
                break
            /*case .frigate:
                <#code#>
            case .ironclad:
                <#code#>
            case .destroyer:
                <#code#>
                */
            case .axeman:
                let axeman = Axeman(position: unit.position, civilization: unit.civilization)
                axeman.copy(from: unit)
                customUnits.append(axeman)
                break
            case .archer:
                let archer = Archer(position: unit.position, civilization: unit.civilization)
                archer.copy(from: unit)
                customUnits.append(archer)
            default:
                fatalError("cant load unit")
                break
            }
        }
        
        self.units = []
        self.units.append(contentsOf: customUnits)
    }
    
    func replaceItems() {
        
        /*var customItems: [MapItem] = []
        for city in self.cities {
            
            switch item.type {
            case .city:
                let city = City(at: item.position)
                city.copy(from: item)
                city.loadFromDict()
                customItems.append(city)
            case .castle:
                let castle = Castle(at: item.position)
                castle.copy(from: item)
                castle.loadFromDict()
                customItems.append(castle)
            case .field:
                let field = Field(at: item.position)
                field.copy(from: item)
                field.loadFromDict()
                customItems.append(field)
            case .hut:
                let hut = Hut(at: item.position)
                //field.copy(from: item)
                customItems.append(hut)
            }
        }
        
        self.cities = []
        self.cities.append(contentsOf: customItems)*/
    }
    
    // MARK: caldera
    
    func calderaSouth(at hex: HexPoint) -> Bool {
        return hex.y == self.height - 1
    }
    
    func calderaEast(at hex: HexPoint) -> Bool {
        return hex.x == self.width - 1
    }
    
    func caldera(at hex: HexPoint) -> String? {
        let calderaIsSouth = self.calderaSouth(at: hex)
        let calderaIsEast = self.calderaEast(at: hex)
        
        if calderaIsSouth || calderaIsEast {
            return calderaIsSouth && calderaIsEast ? "hex_board" : calderaIsSouth ? "hex_board_south" : hex.y % 2 == 1 ? "hex_board_east" : "hex_board_southeast"
        }
        
        if hex.x == 0 && hex.y % 2 == 1 {
            return "hex_board_west"
        }
        
        return nil
    }
    
    // MARK: terrain
    
    func terrain(at hex: HexPoint) -> Terrain? {
        return self.tile(at: hex)?.terrain
    }
    
    func set(terrain: Terrain, at hex: HexPoint) {
        if let tile = self.tile(at: hex) {
            tile.terrain = terrain
        }
    }
    
    // MARK: convenience
    
    func isWater(at point: HexPoint) -> Bool {
        if let tile = self.tile(at: point) {
            return tile.isWater
        }
        
        return false
    }
    
    func isGround(at point: HexPoint) -> Bool {
        if let tile = self.tile(at: point) {
            return !tile.isWater
        }
        
        return false
    }
    
    var oceanTiles: [Tile?] {
        return self.filter { $0?.isWater ?? false }
    }
    
    var forestTiles: [Tile?] {
        return self.filter { ( $0?.features.contains(.forestMixed) ?? false || $0?.features.contains(.forestPine) ?? false || $0?.features.contains(.forestRain) ?? false ) }
    }
    
    // MARK: coast
    
    func isCoast(at point: HexPoint) -> Bool {
        
        if let tile = self.tile(at: point) {
            if !tile.isWater {
                return false
            }
        }
        
        for neighbor in point.neighbors() {
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.isGround {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isCoastAt(x: Int, y: Int) -> Bool {
        return self.isCoast(at: HexPoint(x: x, y: y))
    }
    
    func isAdjacentToOcean(at point: HexPoint) -> Bool {
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.isWater {
                    return true
                }
            }
        }
        
        return false
    }
    
    func adjacentOcean(at point: HexPoint) -> Ocean? {
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.isWater {
                    return neighborTile.ocean
                }
            }
        }
        
        return nil
    }
    
    func coastTexture(at point: HexPoint) -> String? {
        
        if let tile = self.tile(at: point) {
            if !tile.isWater {
                return nil
            }
        }
        
        var texture = "beach" // "beach-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.isGround {
                    texture += ("-" + direction.short)
                }
            }
        }
        
        if texture == "beach" {
            return nil
        }
        
        return texture
    }
    
    func snowTexture(at point: HexPoint) -> String? {
        
        var texture = "snow" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = self.tile(at: point) {
            if tile.isWater {
                texture = "snow-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.terrain == .snow {
                    texture += ("-" + direction.short)
                }
            }
        }
        
        if texture == "snow" || texture == "snow-to-water" {
            return nil
        }
        
        return texture
    }
    
    func mountainTexture(at point: HexPoint) -> String? {
        
        var texture = "mountains" // "mountains-n-ne-se-s-sw-nw"
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.terrain == .mountain {
                    texture += ("-" + direction.short)
                }
            }
        }
        
        if texture == "mountains" {
            return nil
        }
        
        // limit to only some existing textures
        if texture != "mountains-n-ne" &&
            texture != "mountains-n" &&
            texture != "mountains-ne" &&
            texture != "mountains-n-nw" &&
            texture != "mountains-nw" {
            
            return nil
        }
        
        return texture
    }
    
    func iceTexture(at point: HexPoint) -> String? {
        
        var texture = "ice" // "snow-n-ne-se-s-sw-nw"
        
        if let tile = self.tile(at: point) {
            if tile.isWater {
                texture = "ice-to-water"
            }
        }
        
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                for feature in neighborTile.features {
                    if feature == .ice {
                        texture += ("-" + direction.short)
                    }
                }
            }
        }
        
        if texture == "ice" || texture == "ice-to-water" {
            return nil
        }
        
        return texture
    }
    
    // river
    
    func isAdjacentToRiver(at point: HexPoint) -> Bool {
        
        guard let tile = self.tile(at: point) else {
            return false
        }
        
        if tile.isRiver() {
            return true
        }
        
        let neighborNW = point.neighbor(in: .northwest)
        if let tileNW = self.tile(at: neighborNW) {
            if tileNW.isRiverInSouthEast() {
                return true
            }
        }
        
        let neighborSW = point.neighbor(in: .southwest)
        if let tileSW = self.tile(at: neighborSW) {
            if tileSW.isRiverInNorthEast() {
                return true
            }
        }
        
        let neighborS = point.neighbor(in: .south)
        if let tileS = self.tile(at: neighborS) {
            if tileS.isRiverInNorth() {
                return true
            }
        }
        
        return  false
    }
    
    func riverTexture(at point: HexPoint) -> String? {
        
        guard let tile = self.tile(at: point) else {
            return nil
        }
        
        if !tile.isRiver() {
            
            // river deltas can be at ocean only
            if tile.terrain == .shore || tile.terrain == .ocean {
                
                let southwestNeightbor = point.neighbor(in: .southwest)
                if let southwestTile = self.tile(at: southwestNeightbor) {
                    
                    // 1. river end west
                    if southwestTile.isRiverInNorth() {
                        return "river-mouth-w"
                    }
                    
                    // 2. river end south west
                    if southwestTile.isRiverInSouthEast(){
                        return "river-mouth-sw"
                    }
                }
                
                let northwestNeightbor = point.neighbor(in: .northwest)
                if let northwestTile = self.tile(at: northwestNeightbor) {
                    
                    // 3
                    if northwestTile.isRiverInNorthEast() {
                        return "river-mouth-nw"
                    }
                }
                
                let northNeightbor = point.neighbor(in: .north)
                if let northTile = self.tile(at: northNeightbor) {
                    
                    // 4
                    if northTile.isRiverInSouthEast() {
                        return "river-mouth-ne"
                    }
                }
                
                let southeastNeightbor = point.neighbor(in: .southeast)
                if let southeastTile = self.tile(at: southeastNeightbor) {
                    
                    // 5
                    if southeastTile.isRiverInNorth() {
                        return "river-mouth-e"
                    }
                }
                
                let southNeightbor = point.neighbor(in: .south)
                if let southTile = self.tile(at: southNeightbor) {
                    
                    // 6
                    if southTile.isRiverInNorthEast() {
                        return "river-mouth-se"
                    }
                }
            }
            
            return nil
        }
        
        
        var texture = "river" // "river-n-ne-se-s-sw-nw"
        for flow in FlowDirection.all {
            
            if tile.isRiverIn(flow: flow) {
                texture += ("-" + flow.short)
            }
        }
        
        if texture == "river" {
            return nil
        }
        
        return texture
    }
    
    /// MARK: roads
    
    func roadTexture(at point: HexPoint) -> String? {
        
        if let tile = self.tile(at: point) {
            if !tile.road {
                return nil
            }
        }
        
        var texture = "hex_road" // "road-n-ne-se-s-sw-nw"
        for direction in HexDirection.all {
            let neighbor = point.neighbor(in: direction)
            
            if let neighborTile = self.tile(at: neighbor) {
                
                if neighborTile.road {
                    texture += ("_" + direction.short)
                }
            }
        }
        
        if texture == "hex_road" {
            return "hex_road_none"
        }
        
        return texture
    }
    
    /// MARK: features
    
    func set(feature: Feature, at hex: HexPoint) {
        if let tile = self.tile(at: hex) {
            tile.set(feature: feature)
        }
    }
    
    func remove(feature: Feature, at hex: HexPoint) {
        if let tile = self.tile(at: hex) {
            tile.remove(feature: feature)
        }
    }
    
    func features(at hex: HexPoint) -> [Feature]? {
        if let tile = self.tile(at: hex) {
            return tile.features
        }
        
        return nil
    }
    
    // MARK: continents & oceans
    
    func set(continent: Continent?, at hex: HexPoint) {
        if let tile = self.tile(at: hex) {
            tile.continent = continent
        }
    }
    
    func continent(at point: HexPoint) -> Continent? {
        
        if let tile = self.tile(at: point) {
            return tile.continent
        }
        
        return nil
    }
    
    func set(ocean: Ocean?, at hex: HexPoint) {
        if let tile = self.tile(at: hex) {
            tile.ocean = ocean
        }
    }
    
    func ocean(at point: HexPoint) -> Ocean? {
        
        if let tile = self.tile(at: point) {
            return tile.ocean
        }
        
        return nil
    }
    
    // MARK: pathfinding
    
    func path(from: HexPoint, to: HexPoint, movementType: MovementType, civilization: Civilization) -> HexPath? {
        
        let pathFinder = AStarPathfinder()
        pathFinder.dataSource = pathfinderDataSource(with: nil, movementType: movementType, civilization: civilization, ignoreSight: true)
        return pathFinder.shortestPath(fromTileCoord: from, toTileCoord: to)
    }
    
    // MARK: river
    
    func flows(at position: HexPoint) -> [FlowDirection] {
        
        // check bounds
        guard self.valid(point: position) else {
            return []
        }
        
        let tile = self.tile(at: position)
        if let flows = tile?.flows {
            return flows
        }
        
        return []
    }
    
    public func add(river: River) {
        
        self.rivers.append(river)
        
        for riverPoint in river.points {
            
            // check bounds
            guard self.valid(point: riverPoint.point) else {
                continue
            }
            
            let tile = self.tile(at: riverPoint.point)
            do {
                try tile?.set(river: river, with: riverPoint.flowDirection)
            } catch {
                print("something weird happend")
            }
        }
    }
    
    func pathfinderDataSource(with gameObjectManager: GameObjectManager?, movementType: MovementType, civilization: Civilization, ignoreSight: Bool) -> PathfinderDataSource {
        
        return MoveTypePathfinderDataSource(map: self, gameObjectManager: gameObjectManager, movementType: movementType, civilization: civilization, ignoreSight: ignoreSight)
    }
    
    // MARK: city methods
    
    func getCities() -> [City] {
        
        return self.cities
    }
    
    func set(city cityRef: City?) {
        
        if let city = cityRef {
            self.cities.append(city)
            
            if let tile = self.tile(at: city.position) {
                tile.city = city
            }
        }
    }
    
    func remove(city cityRef: City?) {
        
        if let city = cityRef {
            self.cities.remove(object: city)
                
                if let tile = self.tile(at: city.position) {
                    tile.city = nil
                }
            }
        }
    
    func city(at point: HexPoint) -> City? {
        
        let tile = self.tile(at: point)
        return tile?.city
    }
    
    func getCoastalCities(at ocean: Ocean) -> [City] {

        let cities = self.getCities()
        return cities.filter({ ocean.isAdjacent(to: $0.position) })
    }
    
    func citiesOf(civilization: Civilization) -> [City?] {

        let cities = self.getCities()
        return cities.filter { $0.civilization == civilization }
    }
    
    // MARK: unit methods
    
    func add(unit unitRef: Unit?) {
        
        if let unit = unitRef {
            self.units.append(unit)
        }
    }
    
    func remove(unit unitRef: Unit?) {
        
        if let unit = unitRef {
            self.units.remove(object: unit)
        }
    }
    
    func unitsOf(type: UnitType) -> [Unit?] {
        
        return self.units.filter { $0.unitType == type }
    }

    func unitsOf(civilization: Civilization) -> [Unit?] {

        return self.units.filter { $0.civilization == civilization }
    }
    
    func unitsWithout(civilization: Civilization) -> [Unit?] {

        return self.units.filter { $0.civilization != civilization }
    }
    
    func unitsExcept(civilization: Civilization) -> [Unit?] {
        
        return self.units.filter { $0.civilization != civilization } // also nil
    }
    
    func units(at position: HexPoint) -> [Unit?] {
    
        return self.units.filter { $0.position == position }
    }
    
    func navalUnits(in area: HexArea) -> [Unit] {

        var navalUnits: [Unit] = []
        for unit in self.units {

            if unit.unitType.isNaval {
                if area.contains(unit.position) {
                    navalUnits.append(unit)
                }
            }
        }

        return navalUnits
    }
    
    func forEachUnit(_ body: (Unit) throws -> Void) rethrows {
        
        return try self.units.forEach(body)
    }

    // MARK: zone of control methods
    
    /*func setZoneOfControl(for civilization: Civilization, at hex: HexPoint) {
    
        let tile = self.tile(at: hex)
        //let oldOwner = tile?.owned
        tile?.owned = civilization
        
        // FIXME inform delegates
    }*/
}

