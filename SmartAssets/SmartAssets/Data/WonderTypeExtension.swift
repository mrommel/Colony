//
//  WonderTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 13.05.21.
//

import SmartAILibrary

extension WonderType {

    public func iconTexture() -> String {

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
}
