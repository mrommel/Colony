//
//  Globals.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.03.21.
//

import SmartAssets
import SwiftUI

public extension Globals {

    struct Colors {

        public static let buttonBackground: TypeColor = TypeColor.matterhornGray.withAlphaComponent(0.5)
        public static let buttonSelectedBackground: TypeColor = TypeColor.crusoe.withAlphaComponent(0.5)

        public static let progressColor: TypeColor = TypeColor.white
        public static let progressBackground: TypeColor = TypeColor.matterhornGray.withAlphaComponent(0.5)

        // UI
        public static var districtActive: TypeColor = TypeColor.UI.veryDarkBlue
        public static var dialogBackground: TypeColor = TypeColor.UI.midnight
        public static var dialogCenter: TypeColor = TypeColor.UI.nileBlue
        public static var dialogBorder: TypeColor = TypeColor.supernova

        // Overview
        public static var overviewBackground: TypeColor = TypeColor.Terrain.pergament
    }
}

public extension Globals {

    struct Style {

        public static var dialogGradient: Gradient = Gradient(colors: [Color(Globals.Colors.dialogCenter), Color(Globals.Colors.dialogBackground)])

        public static var dialogBackground: RadialGradient = RadialGradient(
            gradient: Globals.Style.dialogGradient,
            center: .center,
            startRadius: 100,
            endRadius: 200)
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

        public static var gold: NSImage {
            return Icons.loadCachedTexture(with: "gold")
        }

        public static var turns: NSImage {
            return Icons.loadCachedTexture(with: "turns")
        }

        public static var tradeRoute: NSImage {
            return Icons.loadCachedTexture(with: "tradeRoute")
        }

        public static var loyalty: NSImage {
            return loadCachedTexture(with: "loyalty")
        }
    }
}

public extension Globals {

    struct Fonts {

        /*public static let systemFontBold = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        public static let systemFontBoldFamilyname = systemFontBold.familyName
        
        public static let systemFont = UIFont.systemFont(ofSize: 24)
        public static let systemFontFamilyname = systemFont.familyName
        
        public static let customFontBold = UIFont(name: "Alte DIN 1451 Mittelschrift", size: 24)
        public static let customFontBoldFamilyname = "Alte DIN 1451 Mittelschrift"
        
        public static let customFont = UIFont(name: "Alte DIN 1451 Mittelschrift", size: 24)
        public static let customFontFamilyname = "Alte DIN 1451 Mittelschrift"*/
    }
}
