//
//  CivilizationTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.03.21.
//

import SmartAILibrary

extension CivilizationType {

    public struct CivilizationTypeColors {

        let main: TypeColor
        let accent: TypeColor
    }

    // https://i.redd.it/rnfl2p4m37z21.png
    // https://civilization.fandom.com/wiki/Jersey_System_(Civ6)
    public var colors: CivilizationTypeColors {

        switch self {

        case .barbarian:
            return CivilizationTypeColors(main: TypeColor.geraldine, accent: TypeColor.nero)

        case .greek:
            return CivilizationTypeColors(main: TypeColor.cornflowerBlue, accent: TypeColor.snow)
        case .roman:
            return CivilizationTypeColors(main: TypeColor.magenta, accent: TypeColor.schoolBusYellow)
        case .english:
            return CivilizationTypeColors(main: TypeColor.geraldine, accent: TypeColor.snow)
        case .aztecs:
            return CivilizationTypeColors(main: TypeColor.turquoiseBlue, accent: TypeColor.sangria)
        case .persian:
            return CivilizationTypeColors(main: TypeColor.bilobaFlower, accent: TypeColor.sangria)
        case .french:
            return CivilizationTypeColors(main: TypeColor.navyBlue, accent: TypeColor.witchHaze)
        case .egyptian:
            return CivilizationTypeColors(main: TypeColor.sherpaBlue, accent: TypeColor.witchHaze)
        case .german:
            return CivilizationTypeColors(main: TypeColor.silverFoil, accent: TypeColor.nero)
        case .russian:
            return CivilizationTypeColors(main: TypeColor.schoolBusYellow, accent: TypeColor.nero)
        }
    }

    public var main: TypeColor {

        return self.colors.main
    }

    public var accent: TypeColor {

        return self.colors.accent
    }
}
