//
//  MapLensType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 07.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

public enum MapLensType: Int {

    case none

    case religion
    case continents
    case appeal
    case settler
    case government
    case tourism
    case loyalty

    public static var all: [MapLensType] = [

        .religion,
        .continents,
        .appeal,
        .settler,
        .government,
        .tourism,
        .loyalty
    ]
}
