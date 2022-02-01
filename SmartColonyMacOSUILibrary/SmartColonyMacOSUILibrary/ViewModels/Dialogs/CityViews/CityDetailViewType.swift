//
//  CityDetailViewType.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.11.21.
//

import Foundation

enum CityDetailViewType {

    case production
    case goldPurchase
    case faithPurchase
    case buildings
    case growth
    case citizen
    case religion
    case loyalty

    static var all: [CityDetailViewType] = [
        .production, .goldPurchase, .faithPurchase, .buildings, .growth, .citizen, .religion, .loyalty
    ]

    func name() -> String {

        switch self {

        case .production:
            return "[Production] Production"
        case .goldPurchase:
            return "[Gold] Purchase"
        case .faithPurchase:
            return "[Faith] Purchase"
        case .buildings:
            return "Buildings"
        case .growth:
            return "Growth"
        case .citizen:
            return "Citizen"
        case .religion:
            return "Religion"
        case .loyalty:
            return "Loyalty"
        }
    }
}
