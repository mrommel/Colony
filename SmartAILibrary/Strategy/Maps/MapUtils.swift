//
//  MapUtils.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class MapUtils {

    public static func mapFilled(with terrain: TerrainType, sized size: MapSize, seed: Int) -> MapModel {

        let mapModel = MapModel(size: size, seed: seed)

        for x in 0..<size.width() {
            for y in 0..<size.height() {

                mapModel.set(terrain: terrain, at: HexPoint(x: x, y: y))
            }
        }

        return mapModel
    }

    public static func simple(seed: Int) -> MapModel {

        let size = MapSize.duel
        let mapModel = MapModel(size: size, seed: seed)

        for x in 0..<size.width() {
            for y in 0..<size.height() {

                mapModel.set(terrain: .shore, at: HexPoint(x: x, y: y))
            }
        }

        for point in HexPoint(x: 5, y: 2).areaWith(radius: 3) {
            if mapModel.valid(point: point) {
                mapModel.set(terrain: .grass, at: point)
            }
        }

        for point in HexPoint(x: 5, y: 12).areaWith(radius: 3) {
            if mapModel.valid(point: point) {
                mapModel.set(terrain: .grass, at: point)
            }
        }

        mapModel.analyze()

        return mapModel
    }

    public static func add(area: HexArea, with terrain: TerrainType, to mapModel: MapModel?) {

        for point in area {
            if mapModel?.valid(point: point) ?? false {
                mapModel?.set(terrain: terrain, at: point)
            }
        }
    }

    public static func discover(mapModel: inout MapModel, by player: AbstractPlayer?, in gameModel: GameModel?) {

        let mapSize = mapModel.size

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {
                mapModel.discover(by: player, at: HexPoint(x: x, y: y), in: gameModel)
            }
        }
    }

    public static func discover(area: HexArea, mapModel: inout MapModel, by player: AbstractPlayer?, in gameModel: GameModel?) {

        for pt in area {
            mapModel.discover(by: player, at: pt, in: gameModel)
        }
    }
}
