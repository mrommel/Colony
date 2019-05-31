//
//  AreaSprites.swift
//  agents
//
//  Created by Michael Rommel on 05.03.18.
//  Copyright © 2018 Michael Rommel. All rights reserved.
//

import Foundation
import SpriteKit

class AreaSprites: SKNode {

	private let mapDisplay: HexMapDisplay?
	private var sprites: [SKSpriteNode]

	init(with mapDisplay: HexMapDisplay?) {

		self.mapDisplay = mapDisplay
		self.sprites = []

		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func texture(for point: HexPoint, in points: [HexPoint]) -> String {

		var textureName = "hex_border_"

		if !points.contains(where: { $0 == point.neighbor(in: .north) }) {
			textureName += "n_"
		}

		if !points.contains(where: { $0 == point.neighbor(in: .northeast) }) {
			textureName += "ne_"
		}

		if !points.contains(where: { $0 == point.neighbor(in: .southeast) }) {
			textureName += "se_"
		}

		if !points.contains(where: { $0 == point.neighbor(in: .south) }) {
			textureName += "s_"
		}

		if !points.contains(where: { $0 == point.neighbor(in: .southwest) }) {
			textureName += "sw_"
		}

		if !points.contains(where: { $0 == point.neighbor(in: .northwest) }) {
			textureName += "nw_"
		}

		if textureName == "hex_border_" {
			return "hex_border_all"
		}

		textureName.removeLast()
		return textureName
	}

	func rebuild(with points: [HexPoint]) {

		// remove old sprites
		for sprite in self.sprites {
			sprite.removeFromParent()
		}
		self.sprites.removeAll()

		for point in points {

			if let position = self.mapDisplay?.toScreen(hex: point) {

				let textureName = self.texture(for: point, in: points)
				let sprite = SKSpriteNode(imageNamed: textureName)
				sprite.position = position
				sprite.zPosition = GameSceneConstants.ZLevels.area
				sprite.anchorPoint = CGPoint(x: 0, y: 0)
				self.addChild(sprite)

				self.sprites.append(sprite)
			}
		}
	}
}
