//
//  MapType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 31.03.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

public enum MapType {

    case empty
    case earth
    case pangaea
    case continents
    case archipelago
    case inlandsea
    case custom

    public static var all: [MapType] {

        return [.empty, .earth, .pangaea, .continents, .archipelago, .inlandsea, .custom]
    }
}
