//
//  BuildableItem.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 05.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum BuildableItemType: Int, Codable {

    case unit
    case building
    case wonder
    case district
    case project
}

public class BuildableItem: Codable {

    enum CodingKeys: CodingKey {

        case type
        case unit
        case building
        case wonder
        case district
        case project
        case location
        case production
    }

    public let type: BuildableItemType

    // one or the other
    public let unitType: UnitType?
    public let buildingType: BuildingType?
    public let wonderType: WonderType?
    public let districtType: DistrictType?
    public let projectType: ProjectType?

    public let location: HexPoint? // for districts and wonders

    public var production: Double

    public init(unitType: UnitType) {

        self.type = .unit
        self.unitType = unitType
        self.buildingType = nil
        self.wonderType = nil
        self.districtType = nil
        self.projectType = nil

        self.location = nil

        self.production = 0.0
    }

    public init(buildingType: BuildingType) {

        self.type = .building
        self.unitType = nil
        self.buildingType = buildingType
        self.wonderType = nil
        self.districtType = nil
        self.projectType = nil

        self.location = nil

        self.production = 0.0
    }

    public init(wonderType: WonderType, at location: HexPoint) {

        self.type = .wonder
        self.unitType = nil
        self.buildingType = nil
        self.wonderType = wonderType
        self.districtType = nil
        self.projectType = nil

        self.location = location

        self.production = 0.0
    }

    public init(districtType: DistrictType, at location: HexPoint) {

        self.type = .district
        self.unitType = nil
        self.buildingType = nil
        self.wonderType = nil
        self.districtType = districtType
        self.projectType = nil

        self.location = location

        self.production = 0.0
    }

    public init(projectType: ProjectType, at location: HexPoint) {

        self.type = .building
        self.unitType = nil
        self.buildingType = nil
        self.wonderType = nil
        self.districtType = nil
        self.projectType = projectType

        self.location = location

        self.production = 0.0
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(BuildableItemType.self, forKey: .type)

        switch self.type {

        case .unit:
            self.unitType = try container.decode(UnitType.self, forKey: .unit)
            self.buildingType = nil
            self.wonderType = nil
            self.districtType = nil
            self.projectType = nil
            self.location = nil
        case .building:
            self.unitType = nil
            self.buildingType = try container.decode(BuildingType.self, forKey: .building)
            self.wonderType = nil
            self.districtType = nil
            self.projectType = nil
            self.location = nil
        case .wonder:
            self.unitType = nil
            self.buildingType = nil
            self.wonderType = try container.decode(WonderType.self, forKey: .wonder)
            self.districtType = nil
            self.projectType = nil
            self.location = try container.decode(HexPoint.self, forKey: .location)
        case .district:
            self.unitType = nil
            self.buildingType = nil
            self.wonderType = nil
            self.districtType = try container.decode(DistrictType.self, forKey: .district)
            self.projectType = nil
            self.location = try container.decode(HexPoint.self, forKey: .location)
        case .project:
            self.unitType = nil
            self.buildingType = nil
            self.wonderType = nil
            self.districtType = nil
            self.projectType = try container.decode(ProjectType.self, forKey: .project)
            self.location = nil
        }

        self.production = try container.decode(Double.self, forKey: .production)
    }

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(self.type, forKey: .type)
        try container.encode(self.unitType, forKey: .unit)
        try container.encode(self.buildingType, forKey: .building)
        try container.encode(self.wonderType, forKey: .wonder)
        try container.encode(self.districtType, forKey: .district)
        try container.encode(self.projectType, forKey: .project)
        try container.encode(self.production, forKey: .production)
        try container.encode(self.location, forKey: .location)
    }

    func add(production productionDelta: Double) {

        self.production += productionDelta
    }

    func productionLeft() -> Double {

        switch self.type {

        case .unit:
            if let unitType = self.unitType {
                return Double(unitType.productionCost()) - self.production
            }

            return 0.0
        case .building:
            if let buildingType = self.buildingType {
                return Double(buildingType.productionCost()) - self.production
            }

            return 0.0
        case .wonder:
            if let wonderType = self.wonderType {
                return Double(wonderType.productionCost()) - self.production
            }

            return 0.0
        case .district:
            if let districtType = self.districtType {
                return Double(districtType.productionCost()) - self.production
            }

            return 0.0
        case .project:
            if let projectType = self.projectType {
                return Double(projectType.productionCost()) - self.production
            }

            return 0.0
        }
    }

    func ready() -> Bool {

        return self.productionLeft() <= 0
    }
}

extension BuildableItem: Hashable {

    public static func == (lhs: BuildableItem, rhs: BuildableItem) -> Bool {

        if lhs.type != rhs.type {
            return false
        }

        switch lhs.type {

        case .unit:
            return lhs.unitType == rhs.unitType
        case .building:
            return lhs.buildingType == rhs.buildingType
        case .wonder:
            return lhs.wonderType == rhs.wonderType && lhs.location! == rhs.location!
        case .project:
            return lhs.projectType == rhs.projectType
        case .district:
            return lhs.districtType == rhs.districtType && lhs.location! == rhs.location!
        }
    }

    public func hash(into hasher: inout Hasher) {

        hasher.combine(self.type)
        hasher.combine(self.unitType)
        hasher.combine(self.buildingType)
        hasher.combine(self.wonderType)
        hasher.combine(self.projectType)
        hasher.combine(self.districtType)
        hasher.combine(self.location)
    }
}

extension BuildableItem: CustomDebugStringConvertible {

    public var debugDescription: String {

        switch self.type {

        case .unit:
            if let unitType = self.unitType {
                return "Unit: \(unitType)"
            }

            return "Unit: ???"
        case .building:
            if let buildingType = self.buildingType {
                return "Building: \(buildingType)"
            }

            return "Building: ???"
        case .wonder:
            if let wonderType = self.wonderType {
                return "wonder: \(wonderType) at: \(self.location!)"
            }

        return "wonder: ???"
        case .district:
            if let districtType = self.districtType {
                return "District: \(districtType) at: \(self.location!)"
            }

            return "District: ???"
        case .project:
            if let projectType = self.projectType {
                return "Project: \(projectType)"
            }

            return "Project: n/a"
        }
    }
}
