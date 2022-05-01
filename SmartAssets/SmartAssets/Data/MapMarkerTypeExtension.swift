//
//  MapMarkerTypeExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 30.04.22.
//

import Foundation
import SmartAILibrary

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

        case .stonehenge:
            return WonderType.stonehenge.name()

        case .oracle:
            return WonderType.oracle.name()

        case .pyramids:
            return WonderType.pyramids.name()
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

        case .stonehenge:
            return WonderType.stonehenge.iconTexture()

        case .oracle:
            return WonderType.oracle.iconTexture()

        case .pyramids:
            return WonderType.pyramids.iconTexture()
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

        case .stonehenge:
            return "mapMarker-wonder-stonehenge"

        case .oracle:
            return "mapMarker-wonder-oracle"

        case .pyramids:
            return "mapMarker-wonder-pyramids"
        }
    }
}
