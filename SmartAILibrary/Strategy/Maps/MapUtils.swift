//
//  MapUtils.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 28.09.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public class MapUtils {

    public static func mapFilled(with terrain: TerrainType, sized size: MapSize) -> MapModel {

        let mapModel = MapModel(size: size)

        for x in 0..<size.width() {
            for y in 0..<size.height() {

                mapModel.set(terrain: terrain, at: HexPoint(x: x, y: y))
            }
        }

        return mapModel
    }

    public static func discover(mapModel: inout MapModel, by player: AbstractPlayer?, in gameModel: GameModel?) {

        let mapSize = mapModel.size

        for x in 0..<mapSize.width() {
            for y in 0..<mapSize.height() {

                let tile = mapModel.tile(at: HexPoint(x: x, y: y))
                tile?.discover(by: player, in: gameModel)
            }
        }
    }
}
