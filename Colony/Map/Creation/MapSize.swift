//
//  MapSize.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum MapSize {

    // https://civilization.fandom.com/wiki/Map_(Civ5)
	case test // 5x5
	case duel // 40×24
	case tiny // 56×36
	case small // 66×42
	case standard // 80×52
	case large // 104×64
	case huge // 128×80

    static func from(result: DialogResultType) -> MapSize {
        switch result {
            
        case .mapSizeHuge:
            return .huge
        case .mapSizeLarge:
            return .large
        case .mapSizeStandard:
            return .standard
        case .mapSizeSmall:
            return .small
        case .mapSizeTiny:
            return .tiny
        default:
            fatalError("unknown map size \(result)")
        }
    }
    
	public var width: Int {
		switch self {
		case .test:
			return 5
		case .duel:
			return 40
		case .tiny:
			return 56
		case .small:
			return 66
		case .standard:
			return 80
		case .large:
			return 104
		case .huge:
			return 128
		}
	}

	public var height: Int {
		switch self {
		case .test:
			return 5
		case .duel:
			return 24
		case .tiny:
			return 36
		case .small:
			return 42
		case .standard:
			return 52
		case .large:
			return 64
		case .huge:
			return 80
		}
	}
}
