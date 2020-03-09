//
//  MapModel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation


class MapModel {
    
    let size: MapSize
    private var cities: [AbstractCity?]
    private var units: [AbstractUnit?]
    private var tiles: TileArray2D
    
    // prepared
    internal var continents: [Continent] = []
    internal var oceans: [Ocean] = []
    internal var areas: [HexArea]
    
    init(size: MapSize) {
        
        self.size = size
        self.cities = []
        self.units = []
        self.tiles = TileArray2D(size: size)
        self.areas = []
        
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                let point = HexPoint(x: x, y: y)
                self.set(tile: Tile(point: point, terrain: .ocean), at: point)
            }
        }
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
    
    func valid(point: HexPoint) -> Bool {
        
        return 0 <= point.x && point.x < self.size.width() && 0 <= point.y && point.y < self.size.height()
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
                    fatalError("cant build city")
                }
            }
            
            // discover the surrounding area
            for pointToDiscover in city.location.areaWith(radius: 2) {
             
                if self.valid(point: pointToDiscover) {
                    self.discover(by: city.player, at: pointToDiscover)
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
    
    func tile(at point: HexPoint) -> AbstractTile? {
        
        if self.valid(point: point) {
            return self.tiles[point]
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
    
    func set(owner player: AbstractPlayer?, at point: HexPoint) throws {
        
        if let tile = self.tile(at: point) {
            try tile.set(owner: player)
        }
    }
    
    func set(terrain terrainType: TerrainType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(terrain: terrainType)
        }
    }
    
    func build(improvement: TileImprovementType, at point: HexPoint) throws {
        
        if let tile = self.tile(at: point) {
            try tile.build(improvement: improvement)
        }
    }
    
    func setWorked(by city: AbstractCity?, at point: HexPoint) throws {
        
        if let tile = self.tile(at: point) {
            try tile.setWorked(by: city)
        }
    }
    
    // MARK: ocean / continent methods
    
    func set(ocean: Ocean?, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(ocean: ocean)
        }
    }
    
    func set(continent: Continent?, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(continent: continent)
        }
    }
}
