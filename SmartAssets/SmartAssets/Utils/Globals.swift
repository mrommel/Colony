//
//  Globals.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.04.21.
//

import Cocoa
import SwiftUI

public struct Globals {

    public struct ZLevels {

        public static let terrain: CGFloat = 1.0
        public static let grid: CGFloat = 1.1
        public static let underwater: CGFloat = 1.2
        public static let caldera: CGFloat = 1.5

        public static let snow: CGFloat = 2.0

        public static let feature: CGFloat = 3.0
        public static let river: CGFloat = 3.1
        public static let border: CGFloat = 3.2
        public static let path: CGFloat = 3.3
        public static let resource: CGFloat = 3.4
        public static let improvement: CGFloat = 3.5
        public static let route: CGFloat = 3.6
        public static let focus: CGFloat = 3.7
        public static let featureUpper: CGFloat = 3.8
        public static let mountain: CGFloat = 3.9

        public static let cityName: CGFloat = 5.0
        public static let city: CGFloat = 5.1
        public static let cityAttack: CGFloat = 5.2

        public static let districtEmpty: CGFloat = 6.01
        public static let districtFirst: CGFloat = 6.02
        public static let districtSecond: CGFloat = 6.03
        public static let districtThird: CGFloat = 6.04
        public static let districtIcon: CGFloat = 6.05
        public static let wonder: CGFloat = 6.1
        public static let resourceMarker: CGFloat = 6.2
        public static let yieldsMarker: CGFloat = 6.3
        public static let hexCoordLabel: CGFloat = 6.95 // debug

        public static let mapLens: CGFloat = 7.0
        public static let mapMarker: CGFloat = 7.1

        public static let unit: CGFloat = 8.0
        public static let unitType: CGFloat = 8.1
        public static let unitStrength: CGFloat = 8.2

        public static let citizen: CGFloat = 20.0

        public static let labels: CGFloat = 50.0

        public static let tooltips: CGFloat = 50.5

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

        public static var faith: NSImage {
            return Icons.loadCachedTexture(with: "faith")
        }

        public static var culture: NSImage {
            return Icons.loadCachedTexture(with: "culture")
        }

        public static var power: NSImage {
            return Icons.loadCachedTexture(with: "power")
        }

        public static var turns: NSImage {
            return Icons.loadCachedTexture(with: "turns")
        }

        public static var tradeRoute: NSImage {
            return Icons.loadCachedTexture(with: "tradeRoute")
        }

        public static var tradingPost: NSImage {
            return Icons.loadCachedTexture(with: "tradingPost")
        }

        public static var loyalty: NSImage {
            return Icons.loadCachedTexture(with: "loyalty")
        }

        public static var amenities: NSImage {
            return Icons.loadCachedTexture(with: "amenities")
        }

        public static var capital: NSImage {
            return Icons.loadCachedTexture(with: "capital")
        }

        public static var strength: NSImage {
            return Icons.loadCachedTexture(with: "strength")
        }

        public static var rangedStrength: NSImage {
            return Icons.loadCachedTexture(with: "rangedStrength")
        }

        public static var religiousStrength: NSImage {
            return Icons.loadCachedTexture(with: "religiousStrength")
        }

        public static var movement: NSImage {
            return Icons.loadCachedTexture(with: "movement")
        }

        public static var citizen: NSImage {
            return Icons.loadCachedTexture(with: "citizen")
        }

        public static var governor: NSImage {
            return Icons.loadCachedTexture(with: "governor")
        }

        public static var promotion: NSImage {
            return Icons.loadCachedTexture(with: "promotion")
        }

        public static var diplomaticFavor: NSImage {
            return Icons.loadCachedTexture(with: "diplomaticFavor")
        }

        public static var envoy: NSImage {
            return Icons.loadCachedTexture(with: "envoy")
        }

        public static var grievances: NSImage {
            return Icons.loadCachedTexture(with: "grievances")
        }

        public static var greatPerson: NSImage {
            return Icons.loadCachedTexture(with: "greatPerson")
        }

        public static var greatAdmiral: NSImage {
            return Icons.loadCachedTexture(with: "greatAdmiral")
        }

        public static var greatArtist: NSImage {
            return Icons.loadCachedTexture(with: "greatArtist")
        }

        public static var greatEngineer: NSImage {
            return Icons.loadCachedTexture(with: "greatEngineer")
        }

        public static var greatGeneral: NSImage {
            return Icons.loadCachedTexture(with: "greatGeneral")
        }

        public static var greatMerchant: NSImage {
            return Icons.loadCachedTexture(with: "greatMerchant")
        }

        public static var greatMusician: NSImage {
            return Icons.loadCachedTexture(with: "greatMusician")
        }

        public static var greatProphet: NSImage {
            return Icons.loadCachedTexture(with: "greatProphet")
        }

        public static var greatScientist: NSImage {
            return Icons.loadCachedTexture(with: "greatScientist")
        }

        public static var greatWriter: NSImage {
            return Icons.loadCachedTexture(with: "greatWriter")
        }

        public static var relic: NSImage {
            return Icons.loadCachedTexture(with: "relic")
        }

        public static var artifact: NSImage {
            return Icons.loadCachedTexture(with: "artifact")
        }

        public static var greatWorkOfWriting: NSImage {
            return Icons.loadCachedTexture(with: "greatWorkWriting")
        }

        public static var questionmark: NSImage {
            return Icons.loadCachedTexture(with: "questionmark")
        }

        public static var checkmark: NSImage {
            return Icons.loadCachedTexture(with: "checkmark")
        }

        public static var darkAge: NSImage {
            return Icons.loadCachedTexture(with: "dark-age")
        }

        public static var normalAge: NSImage {
            return Icons.loadCachedTexture(with: "normal-age")
        }

        public static var goldenAge: NSImage {
            return Icons.loadCachedTexture(with: "golden-age")
        }

        public static var inspiration: NSImage {
            return Icons.loadCachedTexture(with: "inspiration")
        }

        public static var eureka: NSImage {
            return Icons.loadCachedTexture(with: "eureka")
        }

        public static var horses: NSImage {
            return Icons.loadCachedTexture(with: "horses")
        }

        public static var niter: NSImage {
            return Icons.loadCachedTexture(with: "niter")
        }

        public static var coal: NSImage {
            return Icons.loadCachedTexture(with: "coal")
        }

        public static var aluminum: NSImage {
            return Icons.loadCachedTexture(with: "aluminum")
        }

        public static var oil: NSImage {
            return Icons.loadCachedTexture(with: "oil")
        }

        public static var uranium: NSImage {
            return Icons.loadCachedTexture(with: "uranium")
        }

        public static var iron: NSImage {
            return Icons.loadCachedTexture(with: "iron")
        }
    }
}

public extension Globals {

    struct Fonts {

        public static let tooltipTitleFont = NSFont.systemFont(ofSize: 14)
        public static let tooltipContentFont = NSFont.systemFont(ofSize: 10)
        public static let tooltipMapFont = NSFont.systemFont(ofSize: 14)
        public static let cityBannerFont = NSFont.systemFont(ofSize: 5)
    }

    struct Attributs {

        public static let tooltipTitleAttributs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Globals.Fonts.tooltipTitleFont,
            NSAttributedString.Key.foregroundColor: Globals.Colors.tooltipTitleColor
        ]

        public static let tooltipContentAttributs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Globals.Fonts.tooltipContentFont,
            NSAttributedString.Key.foregroundColor: Globals.Colors.tooltipContentColor
        ]

        public static let tooltipMapAttributs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Globals.Fonts.tooltipMapFont,
            NSAttributedString.Key.foregroundColor: Globals.Colors.tooltipMapColor
        ]

        public static let cityBannerAttributs: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: Globals.Fonts.cityBannerFont,
            NSAttributedString.Key.foregroundColor: Globals.Colors.cityBannerColor
        ]
    }
}

public extension Globals {

    struct Colors {

        public static let buttonBackground: TypeColor = TypeColor.matterhornGray.withAlphaComponent(0.5)
        public static let buttonSelectedBackground: TypeColor = TypeColor.crusoe.withAlphaComponent(0.5)

        public static let progressColor: TypeColor = TypeColor.white
        public static let progressBackground: TypeColor = TypeColor.matterhornGray.withAlphaComponent(0.5)

        public static let toolTipBackgroundColor: TypeColor = TypeColor.white
        public static let toolTipBorderColor: TypeColor = TypeColor.white
        public static let tooltipTitleColor: TypeColor = TypeColor.matterhornGray
        public static let tooltipContentColor: TypeColor = TypeColor.matterhornGray
        public static let tooltipMapColor: TypeColor = TypeColor.white
        public static let cityBannerColor: TypeColor = TypeColor.white

        public static let notificationDetailTitleColor: TypeColor = TypeColor(hex: "#2e2422")!
        public static let notificationDetailBodyColor: TypeColor = TypeColor(hex: "#3e3731")!

        // UI
        public static var districtActive: TypeColor = TypeColor.UI.veryDarkBlue
        public static var dialogBackground: TypeColor = TypeColor.UI.midnight
        public static var dialogCenter: TypeColor = TypeColor.UI.nileBlue
        public static var dialogBorder: TypeColor = TypeColor.supernova

        // great person
        public static var greatPersonBackground: TypeColor = TypeColor.UI.eclipse

        // Overview
        public static var overviewBackground: TypeColor = TypeColor.Terrain.pergament

        // Lenses
        public static var breathtakingAppeal: TypeColor = TypeColor.Lenses.green
        public static var charmingAppeal: TypeColor = TypeColor.Lenses.lightGreen
        public static var averageAppeal: TypeColor = TypeColor.Lenses.average
        public static var uninvitingAppeal: TypeColor = TypeColor.Lenses.lightRed
        public static var disgustingAppeal: TypeColor = TypeColor.Lenses.red

        // settler
        public static var freshWater: TypeColor = TypeColor.Lenses.green
        public static var coastalWater: TypeColor = TypeColor.Lenses.lightGreen
        public static var noWater: TypeColor = TypeColor.Lenses.average
        public static var tooCloseToAnotherCity: TypeColor = TypeColor.Lenses.red
        public static var invalidTerrain: TypeColor = TypeColor.Lenses.red

        // religion
        public static var noneReligion: TypeColor = TypeColor.silverFoil
        public static var atheismReligion: TypeColor = TypeColor.silverFoil
        public static var buddhismReligion: TypeColor = TypeColor.magenta
        public static var catholicismReligion: TypeColor = TypeColor.venetianRed
        public static var confucianismReligion: TypeColor = TypeColor.lightGreen
        public static var hinduismReligion: TypeColor = TypeColor.Lenses.green // #
        public static var islamReligion: TypeColor = TypeColor.Lenses.green // #
        public static var judaismReligion: TypeColor = TypeColor.Lenses.green // #
        public static var easternOrthodoxyReligion: TypeColor = TypeColor.kellyGreen
        public static var protestantismReligion: TypeColor = TypeColor.supernova
        public static var shintoReligion: TypeColor = TypeColor.Lenses.green // #
        public static var sikhismReligion: TypeColor = TypeColor.Lenses.green // #
        public static var taoismReligion: TypeColor = TypeColor.geraldine
        public static var zoroastrianismReligion: TypeColor = TypeColor.darkViolet
        public static var customReligion: TypeColor = TypeColor.silverFoil

        // continents
        public static var continentNone: TypeColor = TypeColor.silverFoil

        public static var continentAfrica: TypeColor = TypeColor.geraldine
        public static var continentAmasia: TypeColor = TypeColor.venetianRed
        public static var continentAmerica: TypeColor = TypeColor.sangria
        public static var continentAntarctica: TypeColor = TypeColor.supernova
        public static var continentArctica: TypeColor = TypeColor.pumpkin
        public static var continentAsia: TypeColor = TypeColor.saddleBrown
        public static var continentAsiamerica: TypeColor = TypeColor.witchHaze
        public static var continentAtlantica: TypeColor = TypeColor.schoolBusYellow
        public static var continentAtlantis: TypeColor = TypeColor.olive
        public static var continentAustralia: TypeColor = TypeColor.lightGreen
        public static var continentAvalonia: TypeColor = TypeColor.kellyGreen
        public static var continentAzania: TypeColor = TypeColor.crusoe
        public static var continentBaltica: TypeColor = TypeColor.turquoiseBlue
        public static var continentCimmeria: TypeColor = TypeColor.caribbeanGreen
        public static var continentColumbia: TypeColor = TypeColor.sherpaBlue
        public static var continentCongoCraton: TypeColor = TypeColor.cornflowerBlue
        public static var continentEuramerica: TypeColor = TypeColor.navyBlue
        public static var continentEurope: TypeColor = TypeColor.saphire
        public static var continentGondwana: TypeColor = TypeColor.bilobaFlower
        public static var continentKalaharia: TypeColor = TypeColor.darkViolet
        public static var continentKazakhstania: TypeColor = TypeColor.purple
        public static var continentKernorland: TypeColor = TypeColor.violet
        public static var continentKumariKandam: TypeColor = TypeColor.fuchsia
        public static var continentLaurasia: TypeColor = TypeColor.magenta

        public static var continentLaurentia: TypeColor = TypeColor.geraldine
        public static var continentLemuria: TypeColor = TypeColor.venetianRed
        public static var continentMu: TypeColor = TypeColor.sangria
        public static var continentNena: TypeColor = TypeColor.supernova
        public static var continentNorthAmerica: TypeColor = TypeColor.pumpkin
        public static var continentNovoPangaea: TypeColor = TypeColor.saddleBrown
        public static var continentNuna: TypeColor = TypeColor.witchHaze
        public static var continentPangaea: TypeColor = TypeColor.schoolBusYellow
        public static var continentPangaeaUltima: TypeColor = TypeColor.olive
        public static var continentPannotia: TypeColor = TypeColor.lightGreen
        public static var continentRodinia: TypeColor = TypeColor.kellyGreen
        public static var continentSiberia: TypeColor = TypeColor.crusoe
        public static var continentSouthAmerica: TypeColor = TypeColor.turquoiseBlue
        public static var continentTerraAustralis: TypeColor = TypeColor.caribbeanGreen
        public static var continentUr: TypeColor = TypeColor.sherpaBlue
        public static var continentVaalbara: TypeColor = TypeColor.cornflowerBlue
        public static var continentVendian: TypeColor = TypeColor.navyBlue
        public static var continentZealandia: TypeColor = TypeColor.saphire

        public static var governmentChiefdom: TypeColor = TypeColor.supernova
        public static var governmentAutocracy: TypeColor = TypeColor.turquoiseBlue
        public static var governmentOligarchy: TypeColor = TypeColor.saphire
        public static var governmentClassicalRepublic: TypeColor = TypeColor.sherpaBlue
        public static var governmentMerchantRepublic: TypeColor = TypeColor.lightGreen
        public static var governmentMonarchy: TypeColor = TypeColor.bilobaFlower
        public static var governmentTheocracy: TypeColor = TypeColor.geraldine
        public static var governmentFascism: TypeColor = TypeColor.matterhornGray
        public static var governmentCommunism: TypeColor = TypeColor.venetianRed
        public static var governmentDemocracy: TypeColor = TypeColor.silverFoil

        public static var tourismLens: TypeColor = TypeColor.schoolBusYellow
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
