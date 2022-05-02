//
//  MapMarkerType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 30.04.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import Foundation

public enum MapMarkerType: String, Codable {

    case none

    // districts
    case cityCenter
    case holySite
    case campus
    case theatherSquare
    case commercialHub
    case encampment
    case harbor
    case industrialZone
    case preserve
    case entertainmentComplex
    // waterPark
    case aqueduct
    case neighborhood
    // canal
    // dam
    // areodrome
    case spaceport
    case governmentPlaza
    // case diplomaticQuarter

    // wonders - ancient
    case greatBath
    case etemenanki
    case pyramids
    case hangingGardens
    case oracle
    case stonehenge
    case templeOfArtemis

    // wonders - classical
    case greatLighthouse
    case greatLibrary
    case apadana
    case colosseum
    case colossus
    case jebelBarkal
    case mausoleumAtHalicarnassus
    case mahabodhiTemple
    case petra
    case terracottaArmy
    case machuPicchu
    case statueOfZeus

    // wonders - medieval
    case alhambra
    case angkorWat
    case chichenItza
    case hagiaSophia
    case hueyTeocalli
    case kilwaKisiwani
    case kotokuIn
    case meenakshiTemple
    case montStMichel
    case universityOfSankore

    // wonders - renaissance
    case casaDeContratacion
    case forbiddenCity
    case greatZimbabwe
    case potalaPalace
    case stBasilsCathedral
    case tajMahal
    case torreDeBelem
    case venetianArsenal

    // wonders - industrial
    // Big Ben
    // Bolshoi Theatre
    // Hermitage
    // Országház
    // Oxford University
    // Panama Canal
    // Ruhr Valley
    // Statue of Liberty

    // wonders - modern
    // Broadway
    // Cristo Redentor
    // Eiffel Tower
    // Golden Gate Bridge

    // wonders - atomic
    // Amundsen-Scott Research Station
    // Biosphère
    // Estádio do Maracanã
    // Sydney Opera House

    public static var all: [MapMarkerType] = [

        // districts
        .cityCenter, .holySite, .campus, .theatherSquare, .commercialHub, .encampment,
        .harbor, .industrialZone, .preserve, .entertainmentComplex, /* .waterPark, */ .aqueduct,
        .neighborhood, /* .canal, .dam, .areodrome, */ .spaceport, .governmentPlaza, /* .diplomaticQuarter, */

        // wonders - ancient
        .greatBath, .etemenanki, .pyramids, .hangingGardens, .oracle, .stonehenge, .templeOfArtemis,

        // wonders - classical
        .greatLighthouse, .greatLibrary, .apadana, .colosseum, .colossus, .jebelBarkal,
        .mausoleumAtHalicarnassus, .mahabodhiTemple, .petra, .terracottaArmy, .machuPicchu,
        .statueOfZeus,

        // wonders - medieval
        .alhambra, .angkorWat, .chichenItza, .hagiaSophia, .hueyTeocalli, .kilwaKisiwani, .kotokuIn,
        .meenakshiTemple, .montStMichel, .universityOfSankore,

        // wonders - renaissance
        .casaDeContratacion, .forbiddenCity, .greatZimbabwe, .potalaPalace, .stBasilsCathedral,
        .tajMahal, .torreDeBelem, .venetianArsenal
    ]

    public static var districts: [MapMarkerType] = [

        // districts
        .cityCenter, .holySite, .campus, .theatherSquare, .commercialHub, .encampment,
        .harbor, .industrialZone, .preserve, .entertainmentComplex, /* .waterPark, */ .aqueduct,
        .neighborhood, /* .canal, .dam, .areodrome, */ .spaceport, .governmentPlaza /* .diplomaticQuarter, */
    ]

    public static var wonders: [MapMarkerType] = [

        // wonders - ancient
        .greatBath, .etemenanki, .pyramids, .hangingGardens, .oracle, .stonehenge, .templeOfArtemis,

        // wonders - classical
        .greatLighthouse, .greatLibrary, .apadana, .colosseum, .colossus, .jebelBarkal,
        .mausoleumAtHalicarnassus, .mahabodhiTemple, .petra, .terracottaArmy, .machuPicchu,
        .statueOfZeus,

        // wonders - medieval
        .alhambra, .angkorWat, .chichenItza, .hagiaSophia, .hueyTeocalli, .kilwaKisiwani, .kotokuIn,
        .meenakshiTemple, .montStMichel, .universityOfSankore,

        // wonders - renaissance
        .casaDeContratacion, .forbiddenCity, .greatZimbabwe, .potalaPalace, .stBasilsCathedral,
        .tajMahal, .torreDeBelem, .venetianArsenal
    ]
}
