//
//  CityExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 14.09.21.
//

import SmartAILibrary

extension City {

    public func iconTexture() -> String {

        guard let player = self.player else {
            fatalError("cant get player")
        }

        var eraName: String = "-ancient"

        switch player.currentEra() {

        case .none, .ancient, .classical:
            eraName = "-ancient"
        case .medieval, .renaissance:
            eraName = "-medieval"
        case .industrial:
            eraName = "-industrial"
        case .modern, .atomic, .information, .future:
            eraName = "-modern"
        }

        var sizeName: String = "-small"

        if self.population() < 4 {
            sizeName = "-small"
        } else if self.population() < 7 {
            sizeName = "-medium"
        } else {
            sizeName = "-large"
        }

        var wallsName: String = "-noWalls"

        if self.has(building: .renaissanceWalls) {
            wallsName = "-renaissanceWalls"
        } else if self.has(building: .medievalWalls) {
            wallsName = "-medievalWalls"
        } else if self.has(building: .ancientWalls) {
            wallsName = "-ancientWalls"
        }

        return "city\(eraName)\(sizeName)\(wallsName)"
    }
}
