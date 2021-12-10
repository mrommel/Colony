//
//  ContinentType.swift
//  SmartAILibrary
//
//  Created by Michael Rommel on 09.12.21.
//  Copyright © 2021 Michael Rommel. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
public enum ContinentType: Int, Codable {

    case none = 0

    case africa
    case amasia
    case america
    case antarctica
    case arctica
    case asia
    case asiamerica
    case atlantica
    case atlantis
    case australia
    case avalonia
    case azania
    case baltica
    case cimmeria
    case columbia
    case congoCraton
    case euramerica
    case europe
    case gondwana
    case kalaharia
    case kazakhstania
    case kernorland
    case kumariKandam
    case laurasia
    case laurentia
    case lemuria
    case mu
    case nena
    case northAmerica
    case novoPangaea
    case nuna
    case pangaea
    case pangaeaUltima
    case pannotia
    case rodinia
    case siberia
    case southAmerica
    case terraAustralis
    case ur
    case vaalbara
    case vendian
    case zealandia

    public static var all: [ContinentType] = [

        .africa, .amasia, .america, .antarctica, .arctica, .asia, .asiamerica, .atlantica,
        .atlantis, .australia, .avalonia, .azania, .baltica, .cimmeria, .columbia, .congoCraton,
        .euramerica, .europe, .gondwana, .kalaharia, .kazakhstania, .kernorland, .kumariKandam,
        .laurasia, .laurentia, .lemuria, .mu, .nena, .northAmerica, .novoPangaea, .nuna, .pangaea,
        .pangaeaUltima, .pannotia, .rodinia, .siberia, .southAmerica, .terraAustralis, .ur,
        .vaalbara, .vendian, .zealandia
    ]

    public func name() -> String {

        switch self {

        case .none: return "None"

        case .africa: return "Africa"
        case .amasia: return "Amasia"
        case .america: return "America"
        case .antarctica: return "Antarctica"
        case .arctica: return "Arctica"
        case .asia: return "Asia"
        case .asiamerica: return "Asiamerica"
        case .atlantica: return "Atlantica"
        case .atlantis: return "Atlantis"
        case .australia: return "Australia"
        case .avalonia: return "Avalonia"
        case .azania: return "Azania"
        case .baltica: return "Baltica"
        case .cimmeria: return "Cimmeria"
        case .columbia: return "Columbia"
        case .congoCraton: return "Congo Craton"
        case .euramerica: return "Euramerica"
        case .europe: return "Europe"
        case .gondwana: return "Gondwana"
        case .kalaharia: return "Kalaharia"
        case .kazakhstania: return "Kazakhstania"
        case .kernorland: return "Kernorland"
        case .kumariKandam: return "Kumari Kandam"
        case .laurasia: return "Kumari Kandam"
        case .laurentia: return "Laurentia"
        case .lemuria: return "Lemuria"
        case .mu: return "Mu"
        case .nena: return "Nena"
        case .northAmerica: return "North America"
        case .novoPangaea: return "Novopangaea"
        case .nuna: return "Nuna"
        case .pangaea: return "Pangaea"
        case .pangaeaUltima: return "Pangaea Ultima"
        case .pannotia: return "Pannotia"
        case .rodinia: return "Rodinia"
        case .siberia: return "Siberia"
        case .southAmerica: return "South America"
        case .terraAustralis: return "Terra Australis"
        case .ur: return "Ur"
        case .vaalbara: return "Vaalbara"
        case .vendian: return "Vendian"
        case .zealandia: return "Zealandia"
        }
    }
}
