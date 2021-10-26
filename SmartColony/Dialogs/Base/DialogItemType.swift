//
//  DialogItemType.swift
//  SmartColony
//
//  Created by Michael Rommel on 14.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

enum DialogItemType: String, Codable {

    case button
    case image
    case label
    case textfield
    case progressbar
    case dropdown
    case yieldInfo
    case techInfo
    case civicInfo
}
