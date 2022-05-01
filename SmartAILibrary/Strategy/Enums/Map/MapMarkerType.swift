//
//  MapMarkerType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.04.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum MapMarkerType: String, Codable {

    case none

    // districts
    case cityCenter
    case holySite
    case campus
    case theatherSquare
    case commercialHub
    case encampment
    case harbor
    case industrialZone
    case preserve
    case entertainmentComplex
    // waterPark
    case aqueduct
    case neighborhood
    // canal
    // dam
    // areodrome
    case spaceport
    case governmentPlaza
    // case diplomaticQuarter

    // wonders
    case pyramids
    case oracle
    case stonehenge

    public static var all: [MapMarkerType] = [

        // districts
        .cityCenter, .holySite, .campus, .theatherSquare, .commercialHub, .encampment,
        .harbor, .industrialZone, .preserve, .entertainmentComplex, /* .waterPark, */ .aqueduct,
        .neighborhood, /* .canal, .dam, .areodrome, */ .spaceport, .governmentPlaza, /* .diplomaticQuarter, */

        // wonders
        .stonehenge, .oracle, .pyramids
    ]

    public static var districts: [MapMarkerType] = [

        // districts
        .cityCenter, .holySite, .campus, .theatherSquare, .commercialHub, .encampment,
        .harbor, .industrialZone, .preserve, .entertainmentComplex, /* .waterPark, */ .aqueduct,
        .neighborhood, /* .canal, .dam, .areodrome, */ .spaceport, .governmentPlaza /* .diplomaticQuarter, */
    ]

    public static var wonders: [MapMarkerType] = [

        // wonders
        .stonehenge, .oracle, .pyramids
    ]
}
