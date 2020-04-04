//
//  MapModel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation


public class MapModel: Codable {
    
    enum CodingKeys: CodingKey {
        
        case size
        case cities
        case units
        case tiles
        
        case continents
        case oceans
        case areas
        case rivers
    }
    
    public let size: MapSize
    private var cities: [AbstractCity?]
    private var units: [AbstractUnit?]
    private var tiles: TileArray2D
    
    // prepared values
    internal var continents: [Continent] = []
    internal var oceans: [Ocean] = []
    internal var areas: [HexArea]
    internal var rivers: [River]
    
    
    public init(size: MapSize) {
        
        self.size = size
        self.cities = []
        self.units = []
        self.tiles = TileArray2D(size: size)
        self.areas = []
        self.rivers = []
        
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                let point = HexPoint(x: x, y: y)
                self.set(tile: Tile(point: point, terrain: .ocean), at: point)
            }
        }
    }
    
    public convenience init(width: Int, height: Int) {
        
        self.init(size: MapSize.custom(width: width, height: height))
    }
    
    public required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.size = try container.decode(MapSize.self, forKey: .size)
        self.cities = try container.decode([City?].self, forKey: .cities)
        self.units = try container.decode([Unit?].self, forKey: .units)
        self.tiles = try container.decode(TileArray2D.self, forKey: .tiles)
        
        self.continents = try container.decode([Continent].self, forKey: .continents)
        self.oceans = try container.decode([Ocean].self, forKey: .oceans)
        self.areas = try container.decode([HexArea].self, forKey: .areas)
        self.rivers = try container.decode([River].self, forKey: .rivers)
        
        // post processing
        for ocean in self.oceans {
            ocean.map = self
        }
        
        for continent in self.continents {
            continent.map = self
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.size, forKey: .size)
        let wrappedCities: [City?] = self.cities.map { $0 as? City }
        try container.encode(wrappedCities, forKey: .cities)
        let wrappedUnits: [Unit?] = self.units.map { $0 as? Unit }
        try container.encode(wrappedUnits, forKey: .units)
        try container.encode(self.tiles, forKey: .tiles)
        
        try container.encode(self.continents, forKey: .continents)
        try container.encode(self.oceans, forKey: .oceans)
        try container.encode(self.areas, forKey: .areas)
        try container.encode(self.rivers, forKey: .rivers)
    }
    
    func analyze() {
        
        let oceanFinder = OceanFinder(size: self.size)
        self.oceans = oceanFinder.execute(on: self)
        
        let continentFinder = ContinentFinder(size: self.size)
        self.continents = continentFinder.execute(on: self)
        
        // map is divided into regions
        let fertilityEvaluator = CitySiteEvaluator(map: self)
        let finder = RegionFinder(map: self, evaluator: fertilityEvaluator, for: nil)
        self.areas = finder.divideInto(regions: 2) // <- FIXME
        
        // set area to tile
        for area in self.areas {
            
            for pt in area {
                if var tile = self.tile(at: pt) {
                    tile.area = area
                }
            }
        }
    }
    
    public func valid(point: HexPoint) -> Bool {
        
        return 0 <= point.x && point.x < self.size.width() && 0 <= point.y && point.y < self.size.height()
    }
    
    public func valid(x: Int, y: Int) -> Bool {
        
        return 0 <= x && x < self.size.width() && 0 <= y && y < self.size.height()
    }
    
    func area(of location: HexPoint) -> HexArea? {
        
        if let tile = self.tile(at: location) {
            
            return tile.area
        }
        
        return nil
    }
    
    // MARK: city methods
    
    func add(city: AbstractCity?) {
        
        if let city = city {
            
            self.cities.append(city)
            
            if let tile = tile(at: city.location) {
                do {
                    try tile.build(city: city)
                } catch {
                    fatalError("cant build city - no tile")
                }
            }
        }
    }
    
    func cities(for player: AbstractPlayer) -> [AbstractCity?] {
        
        return self.cities.filter({ $0?.player?.leader == player.leader })
    }
    
    func city(at location: HexPoint) -> AbstractCity? {
        
        if let city = self.cities.first(where: { $0?.location == location }) {
            return city
        }
        
        return nil
    }
    
    // MARK: unit methods
    
    func add(unit: AbstractUnit?) {
        
        self.units.append(unit)
    }
    
    func units(for player: AbstractPlayer) -> [AbstractUnit?] {
        
        return self.units.filter({ $0?.player?.leader == player.leader })
    }
    
    func unit(at point: HexPoint) -> AbstractUnit? {
        
        if let unit = self.units.first(where: { $0?.location == point }) {
            return unit
        }
        
        return nil
    }
    
    func remove(unit: AbstractUnit?) {
    
        self.units.removeAll(where: { $0?.location == unit?.location && $0?.player?.leader == unit?.player?.leader })
    }
    
    // MARK: tile methods
    
    public func tile(at point: HexPoint) -> AbstractTile? {
        
        if self.valid(point: point) {
            return self.tiles[point]
        }
        
        return nil
    }
    
    public func tile(x: Int, y: Int) -> AbstractTile? {
        
        if self.valid(x: x, y: y) {
            return self.tiles[x, y]
        }
        
        return nil
    }
    
    func set(tile: AbstractTile, at hex: HexPoint) {
        
        if self.valid(point: tile.point) {
            self.tiles[hex.x, hex.y] = tile
        }
    }
    
    func discover(by player: AbstractPlayer?, at point: HexPoint) {

        if let tile = self.tile(at: point) {
            tile.discover(by: player)
        }
    }
    
    func owner(at point: HexPoint) -> AbstractPlayer? {
        
        if let tile = self.tile(at: point) {
            return tile.owner()
        }
        
        return nil
    }
    
    func set(owner player: AbstractPlayer?, at point: HexPoint) throws {
        
        try self.tile(at: point)?.set(owner: player)
    }
    
    func set(terrain terrainType: TerrainType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(terrain: terrainType)
        }
    }
    
    func set(hills: Bool, at point: HexPoint) {
        
        if self.valid(point: point) {
            self.tiles[point.x, point.y]?.set(hills: hills)
        }
    }
    
    func set(feature featureType: FeatureType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(feature: featureType)
        }
    }
    
    func set(improvement: TileImprovementType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(improvement: improvement)
        }
    }
    
    func setWorking(city: AbstractCity?, at point: HexPoint) throws {
        
        if let tile = self.tile(at: point) {
            try tile.setWorkingCity(to: city)
        }
    }
    
    // MARK: ocean / continent methods
    
    public func set(oceans: [Ocean]) {
        
        self.oceans = oceans
    }
    
    func set(ocean: Ocean?, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(ocean: ocean)
        }
    }
    
    public func set(continents: [Continent]) {
        
        self.continents = continents
    }
    
    func set(continent: Continent?, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(continent: continent)
        }
    }
    
    // MARK: river hangling
    
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
}
