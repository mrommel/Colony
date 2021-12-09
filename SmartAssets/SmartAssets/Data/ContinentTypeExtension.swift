//
//  ContinentTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 09.12.21.
//

import SmartAILibrary

extension ContinentType {

    public func legendColor() -> TypeColor {

        return Globals.Colors.coastalWater
    }

    public func legendText() -> String {

        return "Continent"
    }
}
