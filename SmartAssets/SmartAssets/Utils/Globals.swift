//
//  Globals.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import Cocoa

public struct Globals {

    public struct ZLevels {

        public static let terrain: CGFloat = 1.0
        public static let water: CGFloat = 1.1
        public static let underwater: CGFloat = 1.2
        public static let caldera: CGFloat = 1.5

        public static let snow: CGFloat = 2.0

        public static let focus: CGFloat = 3.0

        public static let river: CGFloat = 4.0
        public static let road: CGFloat = 4.1
        public static let feature: CGFloat = 4.2
        public static let path: CGFloat = 4.3
        public static let resource: CGFloat = 4.9

        public static let improvement: CGFloat = 5.0 // 4.25 - https://github.com/mrommel/Colony/issues/44
        public static let resourceMarker: CGFloat = 5.1
        public static let route: CGFloat = 5.2
        public static let border: CGFloat = 5.3
        public static let mountain: CGFloat = 5.4
        public static let cityName: CGFloat = 5.5
        public static let city: CGFloat = 5.8
        public static let yields: CGFloat = 5.9

        public static let hexCoords: CGFloat = 5.95 // debug

        public static let unit: CGFloat = 6.0

        public static let unitType: CGFloat = 8.0

        public static let unitStrength: CGFloat = 10.0

        public static let citizen: CGFloat = 20.0

        public static let labels: CGFloat = 50.0

        public static let tooltips: CGFloat = 50.0

        public static let sceneElements: CGFloat = 51.0
        public static let dialogs: CGFloat = 52.0
        public static let progressIndicator: CGFloat = 60.0
        public static let notifications: CGFloat = 60.0
        public static let leaders: CGFloat = 60.0
        public static let bottomElements: CGFloat = 61.0
        public static let combatElements: CGFloat = 70.0
    }

    struct Visibility {
        static let currently: CGFloat = 1.0
        static let discovered: CGFloat = 0.5
    }

    struct Constants {
        static let initialScale: Double = 0.25
    }
}
