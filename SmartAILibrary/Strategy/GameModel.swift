//
//  GameModel.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 22.01.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GameModel {

    let victoryTypes: [VictoryType]
    var turnsElapsed: Int
    let players: [AbstractPlayer]
    private let barbarianPlayerVal: AbstractPlayer

    private let map: MapModel
    private var messagesVal: [AbstractGameMessage]
    private let tacticalAnalysisMapVal: TacticalAnalysisMap

    init(victoryTypes: [VictoryType], turnsElapsed: Int, players: [AbstractPlayer], on map: MapModel) {
        self.victoryTypes = victoryTypes
        self.turnsElapsed = turnsElapsed
        self.players = players
        self.map = map

        self.messagesVal = []
        self.barbarianPlayerVal = Player(leader: .barbar)

        self.tacticalAnalysisMapVal = TacticalAnalysisMap(with: self.map.size)
        self.map.analyze()
    }

    func turn() {

        for player in self.players {

            self.tacticalAnalysisMapVal.refresh(for: player, in: self)
            
            player.turn(in: self)

            var goldPerTurn = 0.0
            var sciencePerTurn = 0.0

            // loop all cities of this player
            for city in self.map.cities(for: player) {

                if let cityYields = city?.turn(in: self) {

                    // FIXME sum yields to player
                    goldPerTurn += cityYields.gold
                    player.religion?.add(faith: cityYields.faith)
                    sciencePerTurn += cityYields.science
                }
            }

            player.treasury?.add(gold: goldPerTurn)

            // is player in depts?
            if player.treasury!.value() < 0.0 {

            }

            player.techs?.add(science: sciencePerTurn)
            try! player.techs?.checkScienceProgress(in: self)

            // loop all units of this player
            for unit in self.map.units(for: player) {

                unit?.turn(in: self)
            }
        }

        self.turnsElapsed += 1
    }

    // MARK: message handling

    func add(message: AbstractGameMessage) {

        self.messagesVal.append(message)
    }

    // MARK: getter

    func militaryStrength(for player: AbstractPlayer) -> Double {

        return Double(player.leader.flavor(for: .offense)) * 27.0 + Double.random(minimum: 0.0, maximum: 5.0) // FIXME
    }

    func cultureStrength(for player: AbstractPlayer) -> Double {

        return Double(player.leader.flavor(for: .culture)) * 14.0 + Double.random(minimum: 0.0, maximum: 5.0) // FIXME
    }
    
    // MARK: city methods
    
    func add(city: AbstractCity?) {

        self.map.add(city: city)
    }

    func cities(of player: AbstractPlayer) -> [AbstractCity?] {

        return self.map.cities(for: player)
    }
    
    func city(at location: HexPoint) -> AbstractCity? {

        return self.map.city(at: location)
    }

    func capital(of player: AbstractPlayer) -> AbstractCity? {

        if let cap = self.map.cities(for: player).first(where: { $0?.capital == true }) {
            return cap
        }

        return nil
    }

    func area(of location: HexPoint) -> HexArea? {

        return self.map.area(of: location)
    }

    // MARK: unit methods

    func add(unit: AbstractUnit?) {

        self.map.add(unit: unit)
    }

    func units(of player: AbstractPlayer) -> [AbstractUnit?] {

        return self.map.units(for: player)
    }

    func unit(at point: HexPoint) -> AbstractUnit? {

        return self.map.unit(at: point)
    }
    
    func remove(unit: AbstractUnit?) {
        
        self.map.remove(unit: unit)
    }

    // MARK: tile methods

    func valid(point: HexPoint) -> Bool {

        return self.map.valid(point: point)
    }

    func tile(at point: HexPoint) -> AbstractTile? {

        return self.map.tile(at: point)
    }
    
    func terrain(at point: HexPoint) -> TerrainType? {

        return self.map.tile(at: point)?.terrain()
    }

    func river(at point: HexPoint) -> Bool {

        guard let tile = self.map.tile(at: point) else {
            return false
        }

        if tile.isRiver() {
            return true
        }

        let neighborNW = point.neighbor(in: .northwest)
        if let tileNW = self.map.tile(at: neighborNW) {
            if tileNW.isRiverInSouthEast() {
                return true
            }
        }

        let neighborSW = point.neighbor(in: .southwest)
        if let tileSW = self.map.tile(at: neighborSW) {
            if tileSW.isRiverInNorthEast() {
                return true
            }
        }

        let neighborS = point.neighbor(in: .south)
        if let tileS = self.map.tile(at: neighborS) {
            if tileS.isRiverInNorth() {
                return true
            }
        }

        return false
    }

    func homeFront(at point: HexPoint, for player: AbstractPlayer) -> Bool {

        // if plot is not valid, no home front
        if !self.valid(point: point) {
            return false
        }

        // check ownership
        if let tile = self.map.tile(at: point) {
            if tile.owner()?.leader == player.leader {
                return true
            }
        }

        for cityRef in self.cities(of: player) {

            if let city = cityRef {
                if point.distance(to: city.location) < 5 { // AI_DIPLO_PLOT_RANGE_FROM_CITY_HOME_FRONT
                    return true
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

    // percentage of size compared standard map
    func mapSizeModifier() -> Int {

        let numberOfTilesStandard = MapSize.standard.numberOfTiles()
        let numberOfTilesMap = self.map.size.numberOfTiles()

        return 100 * numberOfTilesMap / numberOfTilesStandard
    }

    func mapSize() -> MapSize {

        return self.map.size
    }

    func messages() -> [AbstractGameMessage] {

        return self.messagesVal
    }

    func barbarianPlayer() -> AbstractPlayer {

        return self.barbarianPlayerVal
    }

    func areas() -> [HexArea] {

        return self.map.areas
    }
    
    func tiles(in area: HexArea) -> [AbstractTile?] {
        
        return area.map({ self.map.tile(at: $0 ) })
    }

    func citySiteEvaluator() -> CitySiteEvaluator {

        return CitySiteEvaluator(map: self.map)
    }

    func isEnemyVisible(at location: HexPoint, for player: AbstractPlayer?) -> Bool {

        return self.visibleEnemy(at: location, for: player) != nil
    }
    
    func visibleEnemy(at location: HexPoint, for player: AbstractPlayer?) -> AbstractUnit? {

        guard let diplomacyAI = player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }

        if let tile = self.tile(at: location) {
            if tile.isVisible(to: player) {
                if let enemyUnit = self.unit(at: location) {
                    if diplomacyAI.isAtWar(with: enemyUnit.player) {
                        return enemyUnit
                    }
                }
            }
        }

        return nil
    }

    func tacticalAnalysisMap() -> TacticalAnalysisMap {
        
        return self.tacticalAnalysisMapVal
    }
    
    func ignoreUnitsPathfinderDataSource(for movementType: UnitMovementType, for player: AbstractPlayer?) -> PathfinderDataSource {

        return MoveTypeIgnoreUnitsPathfinderDataSource(in: self.map, for: movementType, for: player)
    }
    
    func friendlyCityAdjacent(to point: HexPoint, for player: AbstractPlayer?) -> AbstractCity? {
        
        guard let diplomacyAI = player?.diplomacyAI else {
            fatalError("cant get diplomacyAI")
        }
        
        for neighbor in point.neighbors() {
            
            if let city = self.city(at: neighbor) {
            
                if !diplomacyAI.isAtWar(with: city.player) {
                    
                    return city
                }
            }
        }
        
        return nil
    }
    
    func isAdjacentDiscovered(of point: HexPoint, for player: AbstractPlayer?) -> Bool {
        
        for neighbor in point.neighbors() {
            guard let tile = self.map.tile(at: neighbor) else {
                continue
            }
            
            if tile.isDiscovered(by: player) {
                return true
            }
        }
        
        return false
    }
}

class MoveTypeIgnoreUnitsPathfinderDataSource: PathfinderDataSource {

    let mapModel: MapModel?
    let movementType: UnitMovementType
    let player: AbstractPlayer?
    let ignoreSight: Bool

    init(in mapModel: MapModel?, for movementType: UnitMovementType, for player: AbstractPlayer?, ignoreSight: Bool = true) {

        self.mapModel = mapModel
        self.movementType = movementType
        self.player = player
        self.ignoreSight = ignoreSight
    }

    func walkableAdjacentTilesCoords(forTileCoord coord: HexPoint) -> [HexPoint] {

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }

        var walkableCoords = [HexPoint]()

        for direction in HexDirection.all {
            let neighbor = coord.neighbor(in: direction)

            if mapModel.valid(point: neighbor) {

                // are there obstacles

                if let toTile = mapModel.tile(at: neighbor) {
                    
                    // use sight?
                    if !self.ignoreSight {

                        // skip if not in sight or discovered
                        if !toTile.isDiscovered(by: self.player) {
                            continue
                        }
                        
                        if !toTile.isVisible(to: self.player) {
                            continue
                        }
                    }
                    
                    if let fromTile = mapModel.tile(at: coord) {
                        
                        if toTile.movementCost(for: self.movementType, from: fromTile)  < UnitMovementType.max {
                            walkableCoords.append(neighbor)
                        }
                    }
                }
            }
        }

        return walkableCoords
    }

    func costToMove(fromTileCoord: HexPoint, toAdjacentTileCoord toTileCoord: HexPoint) -> Double {

        guard let mapModel = self.mapModel else {
            fatalError("cant get mapModel")
        }
        
        if let toTile = mapModel.tile(at: toTileCoord),
            let fromTile = mapModel.tile(at: fromTileCoord) {
            
            return toTile.movementCost(for: self.movementType, from: fromTile)
        }

        return UnitMovementType.max
    }
}
