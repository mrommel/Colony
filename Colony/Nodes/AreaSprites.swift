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

	private var sprites: [SKSpriteNode]
    private let color: UIColor

    init(colored color: UIColor) {

		self.sprites = []
        self.color = color

		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func texture(for point: HexPoint, in area: HexArea) -> String {

		var textureName = "hex_border_"

		if !area.contains(where: { $0 == point.neighbor(in: .north) }) {
			textureName += "n_"
		}

		if !area.contains(where: { $0 == point.neighbor(in: .northeast) }) {
			textureName += "ne_"
		}

		if !area.contains(where: { $0 == point.neighbor(in: .southeast) }) {
			textureName += "se_"
		}

		if !area.contains(where: { $0 == point.neighbor(in: .south) }) {
			textureName += "s_"
		}

		if !area.contains(where: { $0 == point.neighbor(in: .southwest) }) {
			textureName += "sw_"
		}

		if !area.contains(where: { $0 == point.neighbor(in: .northwest) }) {
			textureName += "nw_"
		}

		if textureName == "hex_border_" {
			return "hex_border_all"
		}

		textureName.removeLast()
		return textureName
	}

    func rebuild(with area: HexArea, and fogManager: FogManager?) {

        /*guard let fogManager = fogManager else {
            return
        }*/
        
		// remove old sprites
		for sprite in self.sprites {
			sprite.removeFromParent()
		}
		self.sprites.removeAll()

		for point in area {

            /*if !fogManager.currentlyVisible(at: point, by: <#Civilization#>) {
                continue
            }*/
            
            let position = HexMapDisplay.shared.toScreen(hex: point)
            
            let textureName = self.texture(for: point, in: area)
            let sprite = SKSpriteNode(imageNamed: textureName)
            sprite.position = position
            sprite.zPosition = GameScene.Constants.ZLevels.area
            sprite.anchorPoint = CGPoint(x: 0, y: 0)
            sprite.colorBlendFactor = 0.8
            sprite.color = self.color
            self.addChild(sprite)
            
            self.sprites.append(sprite)
		}
	}
}
