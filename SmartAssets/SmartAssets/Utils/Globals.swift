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
        public static let district: CGFloat = 5.03
        public static let wonder: CGFloat = 5.04
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

public extension Globals {

    struct Icons {

        private static func loadCachedTexture(with textureName: String) -> NSImage {

            if !ImageCache.shared.exists(key: textureName) {
                let bundle = Bundle.init(for: Textures.self)
                ImageCache.shared.add(image: bundle.image(forResource: textureName), for: textureName)
            }

            return ImageCache.shared.image(for: textureName)
        }

        public static var food: NSImage {
            return Icons.loadCachedTexture(with: "food")
        }

        public static var production: NSImage {
            return Icons.loadCachedTexture(with: "production")
        }

        public static var gold: NSImage {
            return Icons.loadCachedTexture(with: "gold")
        }

        public static var housing: NSImage {
            return Icons.loadCachedTexture(with: "housing")
        }

        public static var tourism: NSImage {
            return Icons.loadCachedTexture(with: "tourism")
        }

        public static var science: NSImage {
            return Icons.loadCachedTexture(with: "science")
        }

        public static var culture: NSImage {
            return Icons.loadCachedTexture(with: "culture")
        }

        public static var turns: NSImage {
            return Icons.loadCachedTexture(with: "turns")
        }

        public static var tradeRoute: NSImage {
            return Icons.loadCachedTexture(with: "tradeRoute")
        }

        public static var loyalty: NSImage {
            return Icons.loadCachedTexture(with: "loyalty")
        }

        public static var capital: NSImage {
            return Icons.loadCachedTexture(with: "capital")
        }

        public static var strength: NSImage {
            return Icons.loadCachedTexture(with: "strength")
        }

        public static var questionmark: NSImage {
            return Icons.loadCachedTexture(with: "questionmark")
        }
    }
}

public extension Globals {

    struct Fonts {

        // public static let systemFontBold = NSFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        // public static let systemFontBoldFamilyname = systemFontBold.familyName

        public static let tooltipTitleFont = NSFont.systemFont(ofSize: 16)
        //public static let systemFontFamilyname = systemFont.familyName
    }
}
