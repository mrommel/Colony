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

        var eraName: String = "ancient"

        switch player.currentEra() {

        case .none, .ancient, .classical:
            eraName = "ancient"
        case .medieval, .renaissance:
            eraName = "medieval"
        case .industrial:
            eraName = "industrial"
        case .modern, .atomic, .information, .future:
            eraName = "modern"
        }

        var cityTextureName: String = "city-ancient-small"
        if self.population() < 4 {
            cityTextureName = "city-\(eraName)-small"
        } else if self.population() < 7 {
            cityTextureName = "city-\(eraName)-medium"
        } else {
            cityTextureName = "city-\(eraName)-large"
        }

        return cityTextureName
    }
}
