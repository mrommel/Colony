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

    // wonders
    case stonehenge

    public static var all: [MapMarkerType] = [

        // districts
        .cityCenter, .holySite, .campus,

        // wonders
        .stonehenge
    ]
}
