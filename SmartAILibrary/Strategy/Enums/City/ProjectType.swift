//
//  ProjectType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 14.02.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum ProjectCategory {

    case city
    case district
    case competition
}

private struct ProjectTypeData {

    let name: String
    let effects: [String]
    let era: EraType
    let required: TechType?
    let previous: ProjectType?
    let location: DistrictType?
    let cost: Int
    let unique: Bool
}

public enum ProjectType: Int, Codable {

    // city
    case repairOuterDefenses

    // district
    case breadAndCircuses
    case campusResearchGrants
    // ...

    // competition
    case launchEarthSatellite // step 1
    case launchMoonLanding // step 2
    case launchMarsColony // step 3
    case exoplanetExpedition // step 4
    case terrestrialLaserStation // step 5

    static var all: [ProjectType] {
        return [
            // city
            .repairOuterDefenses,

            // district
            .breadAndCircuses, .campusResearchGrants,

            // competition
            .launchEarthSatellite, .launchMoonLanding, .launchMarsColony,
            .exoplanetExpedition, .terrestrialLaserStation
        ]
    }

    func name() -> String {

        return self.data().name
    }

    func required() -> TechType? {

        return self.data().required
    }

    func location() -> DistrictType? {

        return self.data().location
    }

    // in production units
    func productionCost() -> Int {

        return self.data().cost
    }

    func flavours() -> [Flavor] {

        return []
    }

    // private methods

    private func data() -> ProjectTypeData {

        switch self {

            // city
        case .repairOuterDefenses:
            // https://civilization.fandom.com/wiki/Repair_Outer_Defenses_(Civ6)
            return ProjectTypeData(
                name: "Repair Outer Defenses",
                effects: [
                    "Fully restores HP of Walls around this city and its Encampment"
                ],
                era: .classical,
                required: nil,
                previous: nil,
                location: .cityCenter,
                cost: 50, // ???
                unique: false
            )

            // district
        case .breadAndCircuses:
            // https://civilization.fandom.com/wiki/Bread_and_Circuses_(Civ6)
            return ProjectTypeData(
                name: "Bread and Circuses",
                effects: [
                    "Extra Loyalty produced by Citizens while ongoing",
                    "+20 Loyalty for this city at completion"
                ],
                era: .classical,
                required: nil,
                previous: nil,
                location: .entertainment,
                cost: 25,
                unique: false
            )

        case .campusResearchGrants:
            // https://civilization.fandom.com/wiki/Campus_Research_Grants_(Civ6)
            return ProjectTypeData(
                name: "Campus Research Grants",
                effects: [
                    "Extra [Science] Science while ongoing",
                    "Extra [GreatScientist] Great Scientist points at completion"
                ],
                era: .ancient,
                required: nil,
                previous: nil,
                location: .campus,
                cost: 25,
                unique: false
            )

            // competition
        case .launchEarthSatellite:
            // https://civilization.fandom.com/wiki/Launch_Earth_Satellite_(Civ6)
            return ProjectTypeData(
                name: "Launch Earth Satellite",
                effects: [
                    "Step 1 of Science Victory",
                    "Reveals entire map"
                ],
                era: .atomic,
                required: .rocketry,
                previous: nil,
                location: .spaceport,
                cost: 900,
                unique: true
            )

        case .launchMoonLanding:
            // https://civilization.fandom.com/wiki/Launch_Moon_Landing_(Civ6)
            return ProjectTypeData(
                name: "Launch Moon Landing",
                effects: [
                    "Step 2 of Science Victory",
                    "Provides bonus Culture (= 10× Science per turn) at completion"
                ],
                era: .information,
                required: .satellites,
                previous: .launchEarthSatellite,
                location: .spaceport,
                cost: 1500,
                unique: true
            )

        case .launchMarsColony:
            // https://civilization.fandom.com/wiki/Launch_Mars_Colony_(Civ6)
            return ProjectTypeData(
                name: "Launch Mars Colony",
                effects: [
                    "Step 3 of Science Victory"
                ],
                era: .information,
                required: .nanotechnology,
                previous: .launchMoonLanding,
                location: .spaceport,
                cost: 1800,
                unique: true
            )

        case .exoplanetExpedition:
            // https://civilization.fandom.com/wiki/Exoplanet_Expedition_(Civ6)
            return ProjectTypeData(
                name: "Exoplanet Expedition",
                effects: [
                    "Step 4 of Science Victory"
                ],
                era: .future,
                required: .nanotechnology, // .smartMaterials,
                previous: .launchMarsColony,
                location: .spaceport,
                cost: 2100,
                unique: true
            )

        case .terrestrialLaserStation:
            // https://civilization.fandom.com/wiki/Terrestrial_Laser_Station_(Civ6)
            return ProjectTypeData(
                name: "Terrestrial Laser Station",
                effects: [
                    "Increases speed of Exoplanet Expedition by 1 Light Year/turn while this city is Powered",
                    "Can be completed multiple times."
                ],
                era: .future,
                required: .nanotechnology, // .offworldMission,
                previous: .exoplanetExpedition,
                location: .spaceport,
                cost: 600,
                unique: false
            )
        }
    }
}
