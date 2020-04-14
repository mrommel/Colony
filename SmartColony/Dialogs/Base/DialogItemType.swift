//
//  DialogItemType.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum DialogItemType: String, Codable {

    case button = "button"
    case image = "image"
    case label = "label"
    case textfield = "textfield"
    case progressbar = "progressbar"
    case dropdown = "dropdown"
}
