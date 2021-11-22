//
//  WonderTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension WonderType {

    public func toolTip() -> NSAttributedString {

        let toolTopText = NSMutableAttributedString()

        let title = NSAttributedString(string: self.name(), attributes: [NSAttributedString.Key.font: Globals.Fonts.tooltipTitleFont])
        toolTopText.append(title)

        let effects = NSAttributedString(string: self.effects().reduce("\n\n", { $0 + $1 + "\n" }))
        toolTopText.append(effects)

        return toolTopText
    }

    public func iconTexture() -> String {

        switch self {

        case .none: return "wonderType-default"

            // ancient
        case .greatBath: return "wonderType-greatBath"
        case .etemenanki: return "wonderType-etemenanki"
        case .pyramids: return "wonderType-pyramids"
        case .hangingGardens: return "wonderType-hangingGardens"
        case .oracle: return "wonderType-oracle"
        case .stonehenge: return "wonderType-stonehenge"
        case .templeOfArtemis: return "wonderType-templeOfArtemis"

            // classical
        case .greatLighthouse: return "wonderType-greatLighthouse"
        case .greatLibrary: return "wonderType-greatLibrary"
        case .apadana: return "wonderType-apadana"
        case .colosseum: return "wonderType-colosseum"
        case .colossus: return "wonderType-colossus"
        case .jebelBarkal: return "wonderType-jebelBarkal"
        case .mausoleumAtHalicarnassus: return "wonderType-mausoleumAtHalicarnassus"
        case .mahabodhiTemple: return "wonderType-mahabodhiTemple"
        case .petra: return "wonderType-petra"
        case .terracottaArmy: return "wonderType-terracottaArmy"
        case .machuPicchu: return "wonderType-machuPicchu"
        case .statueOfZeus: return "wonderType-statueOfZeus"

            // medieval
        case .alhambra: return "wonderType-alhambra"
        case .angkorWat: return "wonderType-angkorWat"
        case .chichenItza: return "wonderType-chichenItza"
        case .hagiaSophia: return "wonderType-hagiaSophia"
        case .hueyTeocalli: return "wonderType-hueyTeocalli"
        case .kilwaKisiwani: return "wonderType-kilwaKisiwani"
        case .kotokuIn: return "wonderType-kotokuIn"
        case .meenakshiTemple: return "wonderType-meenakshiTemple"
        case .montStMichel: return "wonderType-montStMichel"
        case .universityOfSankore: return "wonderType-universityOfSankore"

            // renaissance
        case .casaDeContratacion: return "wonderType-casaDeContratacion"
        case .forbiddenCity: return "wonderType-forbiddenCity"
        case .greatZimbabwe: return "wonderType-greatZimbabwe"
        case .potalaPalace: return "wonderType-potalaPalace"
        case .stBasilsCathedral: return "wonderType-stBasilsCathedral"
        case .tajMahal: return "wonderType-tajMahal"
        case .torreDeBelem: return "wonderType-torreDeBelem"
        case .venetianArsenal: return "wonderType-venetianArsenal"

        }
    }

    public func textureName() -> String {

        switch self {

        case .none: return "wonder-default"

            // ancient
        case .greatBath: return "wonder-greatBath"
        case .etemenanki: return "wonder-etemenanki"
        case .pyramids: return "wonder-pyramids"
        case .hangingGardens: return "wonder-hangingGardens"
        case .oracle: return "wonder-oracle"
        case .stonehenge: return "wonder-stonehenge"
        case .templeOfArtemis: return "wonder-templeOfArtemis"

            // classical
        case .greatLighthouse: return "wonder-greatLighthouse"
        case .greatLibrary: return "wonder-greatLibrary"
        case .apadana: return "wonder-apadana"
        case .colosseum: return "wonder-colosseum"
        case .colossus: return "wonder-colossus"
        case .jebelBarkal: return "wonder-jebelBarkal"
        case .mausoleumAtHalicarnassus: return "wonder-mausoleumAtHalicarnassus"
        case .mahabodhiTemple: return "wonder-mahabodhiTemple"
        case .petra: return "wonder-petra"
        case .terracottaArmy: return "wonder-terracottaArmy"
        case .machuPicchu: return "wonder-machuPicchu"
        case .statueOfZeus: return "wonder-statueOfZeus"

            // medieval
        case .alhambra: return "wonder-alhambra"
        case .angkorWat: return "wonder-angkorWat"
        case .chichenItza: return "wonder-chichenItza"
        case .hagiaSophia: return "wonder-hagiaSophia"
        case .hueyTeocalli: return "wonder-hueyTeocalli"
        case .kilwaKisiwani: return "wonder-kilwaKisiwani"
        case .kotokuIn: return "wonder-kotokuIn"
        case .meenakshiTemple: return "wonder-meenakshiTemple"
        case .montStMichel: return "wonder-montStMichel"
        case .universityOfSankore: return "wonder-universityOfSankore"

            // renaissance
        case .casaDeContratacion: return "wonder-casaDeContratacion"
        case .forbiddenCity: return "wonder-forbiddenCity"
        case .greatZimbabwe: return "wonder-greatZimbabwe"
        case .potalaPalace: return "wonder-potalaPalace"
        case .stBasilsCathedral: return "wonder-stBasilsCathedral"
        case .tajMahal: return "wonder-tajMahal"
        case .torreDeBelem: return "wonder-torreDeBelem"
        case .venetianArsenal: return "wonder-venetianArsenal"

        }
    }

    public func buildingTextureName() -> String {

        switch self {

        case .none: return "wonder-building-default"

            // ancient
        case .greatBath: return "wonder-building-greatBath"
        case .etemenanki: return "wonder-building-etemenanki"
        case .pyramids: return "wonder-building-pyramids"
        case .hangingGardens: return "wonder-building-hangingGardens"
        case .oracle: return "wonder-building-oracle"
        case .stonehenge: return "wonder-building-stonehenge"
        case .templeOfArtemis: return "wonder-building-templeOfArtemis"

            // classical
        case .greatLighthouse: return "wonder-building-greatLighthouse"
        case .greatLibrary: return "wonder-building-greatLibrary"
        case .apadana: return "wonder-building-apadana"
        case .colosseum: return "wonder-building-colosseum"
        case .colossus: return "wonder-building-colossus"
        case .jebelBarkal: return "wonder-building-jebelBarkal"
        case .mausoleumAtHalicarnassus: return "wonder-building-mausoleumAtHalicarnassus"
        case .mahabodhiTemple: return "wonder-building-mahabodhiTemple"
        case .petra: return "wonder-building-petra"
        case .terracottaArmy: return "wonder-building-terracottaArmy"
        case .machuPicchu: return "wonder-building-machuPicchu"
        case .statueOfZeus: return "wonder-building-statueOfZeus"

            // medieval
        case .alhambra: return "wonder-building-alhambra"
        case .angkorWat: return "wonder-building-angkorWat"
        case .chichenItza: return "wonder-building-chichenItza"
        case .hagiaSophia: return "wonder-building-hagiaSophia"
        case .hueyTeocalli: return "wonder-building-hueyTeocalli"
        case .kilwaKisiwani: return "wonder-building-kilwaKisiwani"
        case .kotokuIn: return "wonder-building-kotokuIn"
        case .meenakshiTemple: return "wonder-building-meenakshiTemple"
        case .montStMichel: return "wonder-building-montStMichel"
        case .universityOfSankore: return "wonder-building-universityOfSankore"

            // renaissance
        case .casaDeContratacion: return "wonder-building-casaDeContratacion"
        case .forbiddenCity: return "wonder-building-forbiddenCity"
        case .greatZimbabwe: return "wonder-building-greatZimbabwe"
        case .potalaPalace: return "wonder-building-potalaPalace"
        case .stBasilsCathedral: return "wonder-building-stBasilsCathedral"
        case .tajMahal: return "wonder-building-tajMahal"
        case .torreDeBelem: return "wonder-building-torreDeBelem"
        case .venetianArsenal: return "wonder-building-venetianArsenal"

        }
    }
}
