//
//  FlowDirection.swift
//  agents
//
//  Created by Michael Rommel on 04.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation

enum FlowDirection: String {

	case none = ""
	case any = "*"

	// flow of river on north edge
	case west = "w"
	case east = "e"

	// flow of river on ne edge
	case northWest = "nw"
	case southEast = "se"

	// flow of river on se edge
	case northEast = "ne"
	case southWest = "sw"

	public static func enumFrom(string: String) -> FlowDirection {
		switch string {
		case "west":
			return .west
		case "east":
			return .east
		case "northWest":
			return .northWest
		case "southEast":
			return .southEast
		case "northEast":
			return .northEast
		case "southWest":
			return .southWest
		case "none":
			return .none

		default:
			print("--> FlowDirection.enumFromString \(string) not handled")
			return .none
		}
	}

	public var stringValue: String {
		switch self {
		case .west:
			return "west"
		case .east:
			return "east"
		case .northWest:
			return "northWest"
		case .southEast:
			return "southEast"
		case .northEast:
			return "northEast"
		case .southWest:
			return "southWest"
		case .none:
			return "none"
		default:
			print("no string for FlowDirection: \(self)")
			return "---"
		}
	}
}

enum FlowDirectionError: Error, Equatable {
	case unsupported(flow: FlowDirection, in: HexDirection)
}

func == (lhs: FlowDirectionError, rhs: FlowDirectionError) -> Bool {
	switch (lhs, rhs) {
	case (.unsupported(let leftFlow, let leftDir), .unsupported(let rightFlow, let rightDir)):
		return leftFlow == rightFlow && leftDir == rightDir
	}
}
