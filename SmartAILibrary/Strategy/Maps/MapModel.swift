//
//  MapModel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum UnitMapType {

    case combat
    case civilian
}

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
    
    public var startLocations: [StartLocation] = []
    
    // statistcs
    private var numberOfLandPlotsValue: Int = 0
    private var numberOfWaterPlotsValue: Int = 0
    
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
        
        if self.oceans.count == 0 || self.continents.count == 0 {
            
            let continentFinder = ContinentFinder(size: self.size)
            let continents = continentFinder.execute(on: self)
            self.set(continents: continents)
            
            let oceanFinder = OceanFinder(size: self.size)
            let oceans = oceanFinder.execute(on: self)
            self.set(oceans: oceans)
        }
        
        // post processing
        for ocean in self.oceans {
            ocean.map = self
        }
        
        for continent in self.continents {
            continent.map = self
        }
        
        for cityRef in self.cities {
            
            guard let city = cityRef else {
                fatalError("cant get city")
            }
            
            try! self.tile(at: city.location)?.set(city: cityRef)
            
            guard self.city(at: city.location) != nil else {
                fatalError("city not set")
            }
        }
        
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                if let tile = self.tile(x: x, y: y) {
                    if let cityName = tile.workingCityName() {
                        guard let city = self.city(named: cityName) else {
                            fatalError("cant get city named: '\(cityName)'")
                        }
                        
                        try! tile.setWorkingCity(to: city)
                    }
                }
            }
        }
        
        self.updateStatistics()
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
    
    public func analyze() {
        
        let oceanFinder = OceanFinder(size: self.size)
        self.oceans = oceanFinder.execute(on: self)
        
        let continentFinder = ContinentFinder(size: self.size)
        self.continents = continentFinder.execute(on: self)
        
        // dummy player
        let player = Player(leader: .alexander)
        player.initialize()
        
        // map is divided into regions
        let fertilityEvaluator = CitySiteEvaluator(map: self)
        let finder = RegionFinder(map: self, evaluator: fertilityEvaluator, for: player)
        self.areas = finder.divideInto(regions: 2) // <- FIXME
        
        // set area to tile
        for area in self.areas {
            
            for pt in area {
                if var tile = self.tile(at: pt) {
                    tile.area = area
                }
            }
        }
        
        self.updateStatistics()
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
    
    public func points() -> [HexPoint] {
        
        var pointList: [HexPoint] = []
        let mapWidth = self.size.width()
        let mapHeight = self.size.height()
        
        pointList.reserveCapacity(mapWidth * mapHeight)
        
        for x in 0..<mapWidth {
            for y in 0..<mapHeight {
                pointList.append(HexPoint(x: x, y: y))
            }
        }
        
        return pointList
    }
    
    // MARK: city methods
    
    public func nearestCity(at pt: HexPoint, of player: AbstractPlayer?) -> AbstractCity? {
        
        var bestCity: AbstractCity? = nil
        var bestDistance: Int = Int.max
        
        for cityRef in self.cities {
            
            guard let city = cityRef else {
                continue
            }
            
            // need to check the owner?
            if let playerToCheck = player {
                
                // if owner does not match, skip this city
                if !playerToCheck.isEqual(to: city.player) {
                    continue
                }
            }
            
            let distance = city.location.distance(to: pt)
            
            if distance < bestDistance {
                bestDistance = distance
                bestCity = cityRef
            }
        }
        
        return bestCity
    }
    
    public func add(city: AbstractCity?, in gameModel: GameModel?) {
        
        if let city = city {
            
            self.cities.append(city)
            
            if let tile = tile(at: city.location) {
                do {
                    try tile.set(city: city)
                } catch {
                    fatalError("cant build city - no tile")
                }
            }
            
            for pt in city.location.areaWith(radius: 3) {
                    
                let tile = self.tile(at: pt)
                tile?.discover(by: city.player, in: gameModel)
                tile?.sight(by: city.player)
            }
        }
    }
    
    func cities(of player: AbstractPlayer) -> [AbstractCity?] {
        
        return self.cities.filter({ $0?.leader == player.leader })
    }
    
    func cities(of leader: LeaderType) -> [AbstractCity?] {
        
        return self.cities.filter({ $0?.leader == leader })
    }
    
    func cities(of player: AbstractPlayer, in area: HexArea) -> [AbstractCity?] {
        
        return self.cities.filter({ $0?.leader == player.leader && area.contains($0?.location ?? HexPoint.invalid) })
    }
    
    func city(at location: HexPoint) -> AbstractCity? {
        
        if let city = self.cities.first(where: { $0?.location == location }) {
            return city
        }
        
        return nil
    }
    
    func city(named name: String) -> AbstractCity? {
        
        if let city = self.cities.first(where: { $0?.name == name }) {
            return city
        }
        
        return nil
    }
    
    // MARK: unit methods
    
    func add(unit: AbstractUnit?, in gameModel: GameModel?) {
        
        if let unit = unit {
        
            self.units.append(unit)
            
            for pt in unit.location.areaWith(radius: unit.sight()) {
                    
                let tile = self.tile(at: pt)
                tile?.discover(by: unit.player, in: gameModel)
                tile?.sight(by: unit.player)
            }
        }
    }
    
    func units(for player: AbstractPlayer) -> [AbstractUnit?] {
        
        return self.units.filter({ $0?.leader == player.leader })
    }
    
    func units(for leader: LeaderType) -> [AbstractUnit?] {
        
        return self.units.filter({ $0?.leader == leader })
    }
    
    func unit(at point: HexPoint, of mapType: UnitMapType) -> AbstractUnit? {
        
        if let unit = self.units.first(where: { $0?.location == point && ((mapType == .civilian && $0?.unitClassType() == .civilian) || (mapType == .combat && $0?.unitClassType() != .civilian)) }) {
            return unit
        }
        
        return nil
    }
    
    func units(at point: HexPoint) -> [AbstractUnit?] {

        return self.units.filter({ $0?.location == point })
    }
    
    func remove(unit: AbstractUnit?) {
    
        self.units.removeAll(where: { $0?.location == unit?.location && $0?.unitMapType() == unit?.unitMapType() && $0?.player?.leader == unit?.player?.leader })
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
    
    func discover(by player: AbstractPlayer?, at point: HexPoint, in gameModel: GameModel?) {

        if let tile = self.tile(at: point) {
            tile.discover(by: player, in: gameModel)
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
    
    public func terrain(at point: HexPoint) -> TerrainType {
        
        if let tile = self.tile(at: point) {
            return tile.terrain()
        }
        
        return .ocean
    }
    
    public func set(terrain terrainType: TerrainType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(terrain: terrainType)
        }
    }
    
    public func set(hills: Bool, at point: HexPoint) {
        
        if self.valid(point: point) {
            self.tiles[point.x, point.y]?.set(hills: hills)
        }
    }
    
    public func feature(at point: HexPoint) -> FeatureType {
        
        if let tile = self.tile(at: point) {
            return tile.feature()
        }
        
        return .none
    }
    
    public func set(feature featureType: FeatureType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(feature: featureType)
        }
    }
    
    public func canHave(feature featureType: FeatureType, at point: HexPoint) -> Bool {
        
        if let tile = self.tile(at: point) {
            
            // check tile itself (no suroundings)
            if featureType.isPossible(on: tile) {
                
                // additional check for marsh
                if featureType == .floodplains {
                    return self.river(at: tile.point)
                }
                
                return true
            }
        }
        
        return false
    }
    
    public func set(resource resourceType: ResourceType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(resource: resourceType)
        }
    }
    
    public func set(improvement: ImprovementType, at point: HexPoint) {
        
        if let tile = self.tile(at: point) {
            tile.set(improvement: improvement)
        }
    }
    
    public func improvement(at point: HexPoint) -> ImprovementType {
        
        if let tile = self.tile(at: point) {
            return tile.improvement()
        }
        
        return .none
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
    
    func river(at point: HexPoint) -> Bool {

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

        return false
    }
    
    public func isFreshWater(at point: HexPoint) -> Bool {
        
        if let tile = self.tile(at: point) {
            
            if tile.terrain().isWater() || tile.isImpassable(for: .walk) {
                return false
            }
            
            if self.river(at: point) {
                return true
            }
            
            for neighbors in point.neighbors() {
                
                if let loopTile = self.tile(at: neighbors) {
                    if loopTile.feature() == .lake {
                        return true
                    }
                    
                    if loopTile.feature() == .oasis {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func isCoastal(at point: HexPoint) -> Bool {

        guard let terrain = self.tile(at: point)?.terrain else {
            fatalError("cant get terrain")
        }

        // we are only coastal if we are on land
        if terrain().isWater() {
            return false
        }

        for neighbor in point.neighbors() {

            if let neighborTerrain = self.tile(at: neighbor)?.terrain {

                if neighborTerrain().isWater() {
                    return true
                }
            }
        }

        return false
    }
    
    /// returns wether this ocean or shore tile is adjacent to land
    ///
    public func isAdjacentToLand(at point: HexPoint) -> Bool {
        
        guard let terrain = self.tile(at: point)?.terrain else {
            fatalError("cant get terrain")
        }

        // we are only coastal if we are on water
        if terrain().isLand() {
            return false
        }
        
        for neighbor in point.neighbors() {

            if let neighborTerrain = self.tile(at: neighbor)?.terrain {

                if neighborTerrain().isLand() {
                    return true
                }
            }
        }

        return false
    }
    
    // MARK: continents
    
    func continent(by identifier: String) -> Continent? {
        
        for continent in self.continents {
            if "\(continent.identifier)" == identifier {
                return continent
            }
        }
        
        return nil
    }
    
    // MARK: statistics
    
    func updateStatistics() {
        
        // reset
        self.numberOfLandPlotsValue = 0
        self.numberOfWaterPlotsValue = 0
        
        for x in 0..<size.width() {
            for y in 0..<size.height() {
                if let tile = self.tile(x: x, y: y) {
                    
                    if tile.isWater() {
                        self.numberOfWaterPlotsValue += 1
                    } else {
                        self.numberOfLandPlotsValue += 1
                    }
                }
            }
        }
    }
    
    func numberOfLandPlots() -> Int {
        
        return self.numberOfLandPlotsValue
    }
    
    func numberOfWaterPlots() -> Int {
        
        return self.numberOfWaterPlotsValue
    }
    
    public func contentSize() -> CGSize {

        let mapSize = self.size

        var tmpPoint: CGPoint = CGPoint.zero
        var minX: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
        var maxX: CGFloat = CGFloat(Float.leastNormalMagnitude)
        var minY: CGFloat = CGFloat(Float.greatestFiniteMagnitude)
        var maxY: CGFloat = CGFloat(Float.leastNormalMagnitude)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: mapSize.width(), y: mapSize.height()))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)
        minY = min(minY, tmpPoint.y)
        maxY = max(maxY, tmpPoint.y)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: 0, y: mapSize.height()))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)
        minY = min(minY, tmpPoint.y)
        maxY = max(maxY, tmpPoint.y)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: mapSize.width(), y: 0))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)
        minY = min(minY, tmpPoint.y)
        maxY = max(maxY, tmpPoint.y)

        tmpPoint = HexPoint.toScreen(hex: HexPoint(x: 0, y: 0))
        minX = min(minX, tmpPoint.x)
        maxX = max(maxX, tmpPoint.x)
        minY = min(minY, tmpPoint.y)
        maxY = max(maxY, tmpPoint.y)

        return CGSize(width: maxX - minX, height: maxY - minY)
    }
}

extension MapModel: Equatable {
    
    public static func == (lhs: MapModel, rhs: MapModel) -> Bool {
        
        lhs.updateStatistics()
        rhs.updateStatistics()
        
        return lhs.size == rhs.size &&
            lhs.numberOfWaterPlots() == rhs.numberOfWaterPlots() &&
            lhs.numberOfLandPlots() == rhs.numberOfLandPlots()
    }
}
