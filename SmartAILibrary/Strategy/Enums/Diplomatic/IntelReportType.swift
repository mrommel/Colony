//
//  IntelReportType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 20.03.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum IntelReportType: Int, Identifiable {

    case action = 0
    case overview = 1
    case gossip = 2
    case accessLevel = 3
    case government = 4
    case agendas = 5
    case ownRelationship = 6
    case otherRelationships = 7

    public var id: Self { self }

    public static var tabs: [IntelReportType] = [

        .action,
        .overview,
        .gossip,
        .accessLevel,
        .ownRelationship
    ]

    public static var icons: [IntelReportType] = [

        .gossip,
        .accessLevel,
        .government,
        .agendas,
        .ownRelationship,
        .otherRelationships
    ]
}
