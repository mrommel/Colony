//
//  ContinentTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 09.12.21.
//

import SmartAILibrary

extension ContinentType {

    public func legendColor() -> TypeColor {

        // return Globals.Colors.coastalWater
        switch self {

        case .none: return Globals.Colors.continentNone

        case .africa: return Globals.Colors.continentAfrica
        case .amasia: return Globals.Colors.continentAmasia
        case .america: return Globals.Colors.continentAmerica
        case .antarctica: return Globals.Colors.continentAntarctica
        case .arctica: return Globals.Colors.continentArctica
        case .asia: return Globals.Colors.continentAsia
        case .asiamerica: return Globals.Colors.continentAsiamerica
        case .atlantica: return Globals.Colors.continentAtlantica
        case .atlantis: return Globals.Colors.continentAtlantis
        case .australia: return Globals.Colors.continentAustralia
        case .avalonia: return Globals.Colors.continentAvalonia
        case .azania: return Globals.Colors.continentAzania
        case .baltica: return Globals.Colors.continentBaltica
        case .cimmeria: return Globals.Colors.continentCimmeria
        case .columbia: return Globals.Colors.continentColumbia
        case .congoCraton: return Globals.Colors.continentCongoCraton
        case .euramerica: return Globals.Colors.continentEuramerica
        case .europe: return Globals.Colors.continentEurope
        case .gondwana: return Globals.Colors.continentGondwana
        case .kalaharia: return Globals.Colors.continentKalaharia
        case .kazakhstania: return Globals.Colors.continentKazakhstania
        case .kernorland: return Globals.Colors.continentKernorland
        case .kumariKandam: return Globals.Colors.continentKumariKandam
        case .laurasia: return Globals.Colors.continentLaurasia
        case .laurentia: return Globals.Colors.continentLaurentia
        case .lemuria: return Globals.Colors.continentLemuria
        case .mu: return Globals.Colors.continentMu
        case .nena: return Globals.Colors.continentNena
        case .northAmerica: return Globals.Colors.continentNorthAmerica
        case .novoPangaea: return Globals.Colors.continentNovoPangaea
        case .nuna: return Globals.Colors.continentNuna
        case .pangaea: return Globals.Colors.continentPangaea
        case .pangaeaUltima: return Globals.Colors.continentPangaeaUltima
        case .pannotia: return Globals.Colors.continentPannotia
        case .rodinia: return Globals.Colors.continentRodinia
        case .siberia: return Globals.Colors.continentSiberia
        case .southAmerica: return Globals.Colors.continentSouthAmerica
        case .terraAustralis: return Globals.Colors.continentTerraAustralis
        case .ur: return Globals.Colors.continentUr
        case .vaalbara: return Globals.Colors.continentVaalbara
        case .vendian: return Globals.Colors.continentVendian
        case .zealandia: return Globals.Colors.continentZealandia
        }
    }

    public func legendText() -> String {

        return self.name()
    }
}
