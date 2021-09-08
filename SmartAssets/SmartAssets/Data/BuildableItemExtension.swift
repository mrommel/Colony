//
//  BuildableItemExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 08.09.21.
//

import SmartAILibrary

extension BuildableItem {

    public func iconTexture() -> String {

        switch self.type {

        case .building:
            if let buildingType = self.buildingType {
                return buildingType.iconTexture()
            }
            return "questionmark"
        case .district:
            if let districtType = self.districtType {
                return districtType.iconTexture()
            }
            return "questionmark"
        case .wonder:
            if let wonderType = self.wonderType {
                return wonderType.iconTexture()
            }
            return "questionmark"
        case .unit:
            if let unitType = self.unitType {
                return unitType.typeTexture()
            }
            return "questionmark"
        case .project:
            return "questionmark"
        }
    }
}
