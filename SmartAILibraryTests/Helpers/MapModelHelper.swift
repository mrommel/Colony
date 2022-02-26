//
//  MapModelHelper.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 07.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

@testable import SmartAILibrary

class MapModelHelper {

    struct Rectangle {

        let x: Int
        let y: Int
        let width: Int
        let height: Int

        func isInside(x: Int, y: Int) -> Bool {

            return self.x <= x && x < self.x + self.width && self.y <= y && y < self.y + self.height
        }

        func isInside(point: HexPoint) -> Bool {

            return self.isInside(x: point.x, y: point.y)
        }

        func isAdjacentTo(x: Int, y: Int) -> Bool {

            if self.isInside(x: x, y: y) {
                return false
            }

            let point = HexPoint(x: x, y: y)

            for neightbor in point.neighbors() {
                if self.isInside(point: neightbor) {
                    return true
                }
            }

            return false
         }
    }

    // generates a small map (52x42)
    // with
    static func smallMap() -> MapModel {

        // climate zones
        let climateArtic1: Rectangle = Rectangle(x: 0, y: 0, width: 52, height: 1)
        let climateTundra1: Rectangle = Rectangle(x: 0, y: 1, width: 52, height: 5)
        let climateMedium1: Rectangle = Rectangle(x: 0, y: 6, width: 52, height: 7)
        let climateSubtropic1: Rectangle = Rectangle(x: 0, y: 13, width: 52, height: 5)
        // let climateTropic: Rectangle = Rectangle(x: 0, y: 18, width: 52, height: 6)
        let climateSubtropic2: Rectangle = Rectangle(x: 0, y: 24, width: 52, height: 5)
        let climateMedium2: Rectangle = Rectangle(x: 0, y: 30, width: 52, height: 7)
        let climateTundra2: Rectangle = Rectangle(x: 0, y: 35, width: 52, height: 5)
        let climateArtic2: Rectangle = Rectangle(x: 0, y: 41, width: 52, height: 1)

        // continents
        let continent0: Rectangle = Rectangle(x: 0, y: 0, width: 52, height: 1) // artic
        let continent1: Rectangle = Rectangle(x: 0, y: 0, width: 10, height: 8)
        let continent2_1: Rectangle = Rectangle(x: 15, y: 0, width: 10, height: 25) // 15,0 -> 25, 25
        let continent2_2: Rectangle = Rectangle(x: 20, y: 12, width: 15, height: 13) // 20,12 -> 35,25
        let continent2_3: Rectangle = Rectangle(x: 30, y: 8, width: 15, height: 17) // 30,8 -> 45,25
        let continent3: Rectangle = Rectangle(x: 10, y: 30, width: 30, height: 12)
        let continent4: Rectangle = Rectangle(x: 0, y: 41, width: 52, height: 1) // antarctic

        // "Berlin", at: HexPoint(x: 15, y: 8), capital: true, owner: playerAlexander)
        // "Leipzig", at: HexPoint(x: 20, y: 25), capital: false, owner: playerAlexander)
        // "Paris", at: HexPoint(x: 35, y: 25), capital: false, owner: playerTrajan)
        //    00  02  04  06  08  10  12  14  16  18  20  22  24  26  28  30  32  34  36  38  40  42  44  46  48  50  52
        // 00 ----------------------------------------------------------------------------------------------------------
        // 01 ----------------------        ----------------------
        // 02 ----------------------        ----------------------
        // 03 ----------------------        ----------------------
        // 04 ----------------------        ----------------------
        // 05 ----------------------        ----------------------
        // 06 ----------------------        ----------------------
        // 07 ----------------------        ----------------------
        // 08 ----------------------        -X--------------------        --------------------------------
        // 09                               ----------------------        --------------------------------
        // 10                               ----------------------        --------------------------------
        // 11                               ----------------------        --------------------------------
        // 12                               --------------------------------------------------------------
        // 13                               --------------------------------------------------------------
        // 14                               --------------------------------------------------------------
        // 15                               --------------------------------------------------------------
        // 16                               --------------------------------------------------------------
        // 17                               --------------------------------------------------------------
        // 18                               --------------------------------------------------------------
        // 19                               --------------------------------------------------------------
        // 20                               --------------------------------------------------------------
        // 21                               --------------------------------------------------------------
        // 22                               --------------------------------------------------------------
        // 23                               --------------------------------------------------------------
        // 24                               --------------------------------------------------------------
        // 25                               -----------X-----------------------------X--------------------
        // 26                                         --------------------------------
        // 27                                         --------------------------------
        // 28                                         --------------------------------
        // 29                                         --------------------------------
        // 30                                         --------------------------------
        // 31                                         --------------------------------
        // 32                                         --------------------------------
        // 33                                         --------------------------------
        // 34                                         --------------------------------
        // 35                                         --------------------------------
        // 36
        // ..
        // 42 ----------------------------------------------------------------------------------------------------------

        let mapModel = MapModel(size: .small, seed: 42)

        let mapSize = mapModel.size
        for x in 0..<mapSize.width() {

            for y in 0..<mapSize.height() {

                // check if land
                if continent0.isInside(x: x, y: y) ||
                    continent1.isInside(x: x, y: y) ||
                    continent2_1.isInside(x: x, y: y) ||
                    continent2_2.isInside(x: x, y: y) ||
                    continent2_3.isInside(x: x, y: y) ||
                    continent3.isInside(x: x, y: y) ||
                    continent4.isInside(x: x, y: y) {

                    if climateArtic1.isInside(x: x, y: y) || climateArtic2.isInside(x: x, y: y) {
                        mapModel.set(terrain: .snow, at: HexPoint(x: x, y: y))
                    } else if climateTundra1.isInside(x: x, y: y) || climateTundra2.isInside(x: x, y: y) {
                        mapModel.set(terrain: .tundra, at: HexPoint(x: x, y: y))

                        if (x + y * 3 + x * y) % 3 == 0 {
                            mapModel.set(feature: .forest, at: HexPoint(x: x, y: y))
                        }

                    } else if climateMedium1.isInside(x: x, y: y) || climateMedium2.isInside(x: x, y: y) {
                        mapModel.set(terrain: .grass, at: HexPoint(x: x, y: y))

                        if (x + y * 3 + x * y) % 2 == 0 {
                            mapModel.set(feature: .forest, at: HexPoint(x: x, y: y))
                        }

                    } else if climateSubtropic1.isInside(x: x, y: y) || climateSubtropic2.isInside(x: x, y: y) {
                        mapModel.set(terrain: .plains, at: HexPoint(x: x, y: y))

                        if (x + y * 3 + x * y) % 2 == 0 {
                            mapModel.set(feature: .rainforest, at: HexPoint(x: x, y: y))
                        }

                    } else {
                        mapModel.set(terrain: .desert, at: HexPoint(x: x, y: y))

                        if (x + y * 3 + x * y) % 4 == 0 {
                            mapModel.set(feature: .oasis, at: HexPoint(x: x, y: y))
                        }
                    }

                } else if continent0.isAdjacentTo(x: x, y: y) ||
                            continent1.isAdjacentTo(x: x, y: y) ||
                            continent2_1.isAdjacentTo(x: x, y: y) ||
                            continent2_2.isAdjacentTo(x: x, y: y) ||
                            continent2_3.isAdjacentTo(x: x, y: y) ||
                            continent3.isAdjacentTo(x: x, y: y) ||
                            continent4.isAdjacentTo(x: x, y: y) {

                    // shore
                    mapModel.set(terrain: .shore, at: HexPoint(x: x, y: y))
                } else {

                    // ocean
                    mapModel.set(terrain: .ocean, at: HexPoint(x: x, y: y))
                }
            }
        }

        // rivers

        // resources

        return mapModel
    }
}
