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

    public func name() -> String {

        switch self.type {

        case .building:
            if let buildingType = self.buildingType {
                return buildingType.name().localized()
            }
            return "-"
        case .unit:
            if let unitType = self.unitType {
                return unitType.name().localized()
            }
            return "-"
        case .wonder:
            if let wonderType = self.wonderType {
                return wonderType.name().localized()
            }
            return "-"
        case .district:
            if let districtType = self.districtType {
                return districtType.name().localized()
            }
            return "-"
        case .project:
            return "-"
        }
    }

    public func effects() -> [String] {

        switch self.type {

        case .building:
            if let buildingType = self.buildingType {
                return buildingType.effects()
            }
            return []
        case .unit:
            if let unitType = self.unitType {
                return unitType.effects()
            }
            return []
        case .wonder:
            if let wonderType = self.wonderType {
                return wonderType.effects().map { $0.localized() }
            }
            return []
        case .district:
            if let districtType = self.districtType {
                return districtType.effects()
            }
            return []
        case .project:
            return []
        }
    }
}
