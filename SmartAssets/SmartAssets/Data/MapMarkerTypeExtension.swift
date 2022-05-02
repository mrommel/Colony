//
//  MapMarkerTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 30.04.22.
//

import Foundation
import SmartAILibrary

// swiftlint:disable cyclomatic_complexity
extension MapMarkerType {

    public func name() -> String {

        switch self {

        case .none:
            return "None"

        // districts

        case .cityCenter:
            return DistrictType.cityCenter.name()

        case .holySite:
            return DistrictType.holySite.name()

        case .campus:
            return DistrictType.campus.name()

        case .theatherSquare:
            return DistrictType.theatherSquare.name()

        case .encampment:
            return DistrictType.encampment.name()

        case .commercialHub:
            return DistrictType.commercialHub.name()

        case .harbor:
            return DistrictType.harbor.name()

        case .industrialZone:
            return DistrictType.industrialZone.name()

        case .preserve:
            return DistrictType.preserve.name()

        case .entertainmentComplex:
            return DistrictType.entertainmentComplex.name()

        // case .waterPark:

        case .aqueduct:
            return DistrictType.aqueduct.name()

        case .neighborhood:
            return DistrictType.neighborhood.name()

        // canal
        // dam
        // areodrome

        case .spaceport:
            return DistrictType.spaceport.name()

        case .governmentPlaza:
            return DistrictType.governmentPlaza.name()

        // case diplomaticQuarter

        // wonders

        // wonders - ancient
        case .greatBath:
            return WonderType.greatBath.name()

        case .etemenanki:
            return WonderType.etemenanki.name()

        case .pyramids:
            return WonderType.pyramids.name()

        case .hangingGardens:
            return WonderType.hangingGardens.name()

        case .oracle:
            return WonderType.oracle.name()

        case .stonehenge:
            return WonderType.stonehenge.name()

        case .templeOfArtemis:
            return WonderType.templeOfArtemis.name()

            // wonders - classical
        case .greatLighthouse:
            return WonderType.greatLighthouse.name()

        case .greatLibrary:
            return WonderType.greatLibrary.name()

        case .apadana:
            return WonderType.apadana.name()

        case .colosseum:
            return WonderType.colosseum.name()

        case .colossus:
            return WonderType.colossus.name()

        case .jebelBarkal:
            return WonderType.jebelBarkal.name()

        case .mausoleumAtHalicarnassus:
            return WonderType.mausoleumAtHalicarnassus.name()

        case .mahabodhiTemple:
            return WonderType.mahabodhiTemple.name()

        case .petra:
            return WonderType.petra.name()

        case .terracottaArmy:
            return WonderType.terracottaArmy.name()

        case .machuPicchu:
            return WonderType.machuPicchu.name()

        case .statueOfZeus:
            return WonderType.statueOfZeus.name()

            // wonders - medieval
        case .alhambra:
            return WonderType.alhambra.name()

        case .angkorWat:
            return WonderType.angkorWat.name()

        case .chichenItza:
            return WonderType.chichenItza.name()

        case .hagiaSophia:
            return WonderType.hagiaSophia.name()

        case .hueyTeocalli:
            return WonderType.hueyTeocalli.name()

        case .kilwaKisiwani:
            return WonderType.kilwaKisiwani.name()

        case .kotokuIn:
            return WonderType.kotokuIn.name()

        case .meenakshiTemple:
            return WonderType.meenakshiTemple.name()

        case .montStMichel:
            return WonderType.montStMichel.name()

        case .universityOfSankore:
            return WonderType.universityOfSankore.name()

            // wonders - renaissance
        case .casaDeContratacion:
            return WonderType.casaDeContratacion.name()

        case .forbiddenCity:
            return WonderType.forbiddenCity.name()

        case .greatZimbabwe:
            return WonderType.greatZimbabwe.name()

        case .potalaPalace:
            return WonderType.potalaPalace.name()

        case .stBasilsCathedral:
            return WonderType.stBasilsCathedral.name()

        case .tajMahal:
            return WonderType.tajMahal.name()

        case .torreDeBelem:
            return WonderType.torreDeBelem.name()

        case .venetianArsenal:
            return WonderType.venetianArsenal.name()
        }
    }

    public func iconTexture() -> String {

        switch self {

        case .none:
            return DistrictType.cityCenter.iconTexture()

        // districts

        case .cityCenter:
            return DistrictType.cityCenter.iconTexture()

        case .holySite:
            return DistrictType.holySite.iconTexture()

        case .campus:
            return DistrictType.campus.iconTexture()

        case .theatherSquare:
            return DistrictType.theatherSquare.iconTexture()

        case .encampment:
            return DistrictType.encampment.iconTexture()

        case .commercialHub:
            return DistrictType.commercialHub.iconTexture()

        case .harbor:
            return DistrictType.harbor.iconTexture()

        case .industrialZone:
            return DistrictType.industrialZone.iconTexture()

        case .preserve:
            return DistrictType.preserve.iconTexture()

        case .entertainmentComplex:
            return DistrictType.entertainmentComplex.iconTexture()

        // case .waterPark:

        case .aqueduct:
            return DistrictType.aqueduct.iconTexture()

        case .neighborhood:
            return DistrictType.neighborhood.iconTexture()

        // case .canal:
        // case .dam:
        // case .areodrome:

        case .spaceport:
            return DistrictType.spaceport.iconTexture()

        case .governmentPlaza:
            return DistrictType.governmentPlaza.iconTexture()

        // case diplomaticQuarter

        // wonders

            // wonders - ancient
        case .greatBath:
            return WonderType.greatBath.iconTexture()

        case .etemenanki:
            return WonderType.etemenanki.iconTexture()

        case .pyramids:
            return WonderType.pyramids.iconTexture()

        case .hangingGardens:
            return WonderType.hangingGardens.iconTexture()

        case .oracle:
            return WonderType.oracle.iconTexture()

        case .stonehenge:
            return WonderType.stonehenge.iconTexture()

        case .templeOfArtemis:
            return WonderType.templeOfArtemis.iconTexture()

            // wonders - classical
        case .greatLighthouse:
            return WonderType.greatLighthouse.iconTexture()

        case .greatLibrary:
            return WonderType.greatLibrary.iconTexture()

        case .apadana:
            return WonderType.apadana.iconTexture()

        case .colosseum:
            return WonderType.colosseum.iconTexture()

        case .colossus:
            return WonderType.colossus.iconTexture()

        case .jebelBarkal:
            return WonderType.jebelBarkal.iconTexture()

        case .mausoleumAtHalicarnassus:
            return WonderType.mausoleumAtHalicarnassus.iconTexture()

        case .mahabodhiTemple:
            return WonderType.mahabodhiTemple.iconTexture()

        case .petra:
            return WonderType.petra.iconTexture()

        case .terracottaArmy:
            return WonderType.terracottaArmy.iconTexture()

        case .machuPicchu:
            return WonderType.machuPicchu.iconTexture()

        case .statueOfZeus:
            return WonderType.statueOfZeus.iconTexture()

            // wonders - medieval
        case .alhambra:
            return WonderType.alhambra.iconTexture()

        case .angkorWat:
            return WonderType.angkorWat.iconTexture()

        case .chichenItza:
            return WonderType.chichenItza.iconTexture()

        case .hagiaSophia:
            return WonderType.hagiaSophia.iconTexture()

        case .hueyTeocalli:
            return WonderType.hueyTeocalli.iconTexture()

        case .kilwaKisiwani:
            return WonderType.kilwaKisiwani.iconTexture()

        case .kotokuIn:
            return WonderType.kotokuIn.iconTexture()

        case .meenakshiTemple:
            return WonderType.meenakshiTemple.iconTexture()

        case .montStMichel:
            return WonderType.montStMichel.iconTexture()

        case .universityOfSankore:
            return WonderType.universityOfSankore.iconTexture()

            // wonders - renaissance
        case .casaDeContratacion:
            return WonderType.casaDeContratacion.iconTexture()

        case .forbiddenCity:
            return WonderType.forbiddenCity.iconTexture()

        case .greatZimbabwe:
            return WonderType.greatZimbabwe.iconTexture()

        case .potalaPalace:
            return WonderType.potalaPalace.iconTexture()

        case .stBasilsCathedral:
            return WonderType.stBasilsCathedral.iconTexture()

        case .tajMahal:
            return WonderType.tajMahal.iconTexture()

        case .torreDeBelem:
            return WonderType.torreDeBelem.iconTexture()

        case .venetianArsenal:
            return WonderType.venetianArsenal.iconTexture()

        }
    }

    public func markerTexture() -> String {

        switch self {

        case .none:
            return "mapMarker-none"

        // districts

        case .cityCenter:
            return "mapMarker-district-cityCenter"

        case .holySite:
            return "mapMarker-district-holysite"

        case .campus:
            return "mapMarker-district-campus"

        case .theatherSquare:
            return "mapMarker-district-theatherSquare"

        case .encampment:
            return "mapMarker-district-encampment"

        case .commercialHub:
            return "mapMarker-district-commercialHub"

        case .harbor:
            return "mapMarker-district-harbor"

        case .industrialZone:
            return "mapMarker-district-industrialZone"

        case .preserve:
            return "mapMarker-district-preserve"

        case .entertainmentComplex:
            return "mapMarker-district-entertainmentComplex"

        // case .waterPark:

        case .aqueduct:
            return "mapMarker-district-aqueduct"

        case .neighborhood:
            return "mapMarker-district-neighborhood"

        // case .canal:
        // case .dam:
        // case .areodrome:

        case .spaceport:
            return "mapMarker-district-spaceport"

        case .governmentPlaza:
            return "mapMarker-district-governmentPlaza"

        // case .diplomaticQuarter:

        // wonders

            // wonders - ancient
        case .greatBath:
            return "mapMarker-wonder-greatBath"

        case .etemenanki:
            return "mapMarker-wonder-etemenanki"

        case .pyramids:
            return "mapMarker-wonder-pyramids"

        case .hangingGardens:
            return "mapMarker-wonder-hangingGardens"

        case .oracle:
            return "mapMarker-wonder-oracle"

        case .stonehenge:
            return "mapMarker-wonder-stonehenge"

        case .templeOfArtemis:
            return "mapMarker-wonder-templeOfArtemis"

            // wonders - classical
        case .greatLighthouse:
            return "mapMarker-wonder-greatLighthouse"

        case .greatLibrary:
            return "mapMarker-wonder-greatLibrary"

        case .apadana:
            return "mapMarker-wonder-apadana"

        case .colosseum:
            return "mapMarker-wonder-colosseum"

        case .colossus:
            return "mapMarker-wonder-colossus"

        case .jebelBarkal:
            return "mapMarker-wonder-jebelBarkal"

        case .mausoleumAtHalicarnassus:
            return "mapMarker-wonder-mausoleumAtHalicarnassus"

        case .mahabodhiTemple:
            return "mapMarker-wonder-mahabodhiTemple"

        case .petra:
            return "mapMarker-wonder-petra"

        case .terracottaArmy:
            return "mapMarker-wonder-terracottaArmy"

        case .machuPicchu:
            return "mapMarker-wonder-machuPicchu"

        case .statueOfZeus:
            return "mapMarker-wonder-statueOfZeus"

            // wonders - medieval
        case .alhambra:
            return "mapMarker-wonder-alhambra"

        case .angkorWat:
            return "mapMarker-wonder-angkorWat"

        case .chichenItza:
            return "mapMarker-wonder-chichenItza"

        case .hagiaSophia:
            return "mapMarker-wonder-hagiaSophia"

        case .hueyTeocalli:
            return "mapMarker-wonder-hueyTeocalli"

        case .kilwaKisiwani:
            return "mapMarker-wonder-kilwaKisiwani"

        case .kotokuIn:
            return "mapMarker-wonder-kotokuIn"

        case .meenakshiTemple:
            return "mapMarker-wonder-meenakshiTemple"

        case .montStMichel:
            return "mapMarker-wonder-montStMichel"

        case .universityOfSankore:
            return "mapMarker-wonder-universityOfSankore"

            // wonders - renaissance
        case .casaDeContratacion:
            return "mapMarker-wonder-casaDeContratacion"

        case .forbiddenCity:
            return "mapMarker-wonder-forbiddenCity"

        case .greatZimbabwe:
            return "mapMarker-wonder-greatZimbabwe"

        case .potalaPalace:
            return "mapMarker-wonder-potalaPalace"

        case .stBasilsCathedral:
            return "mapMarker-wonder-stBasilsCathedral"

        case .tajMahal:
            return "mapMarker-wonder-tajMahal"

        case .torreDeBelem:
            return "mapMarker-wonder-torreDeBelem"

        case .venetianArsenal:
            return "mapMarker-wonder-venetianArsenal"

        }
    }
}
