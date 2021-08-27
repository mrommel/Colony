//
//  CircularProgressBarNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit

enum ProgressBarType {

    case science
    case culture
    case attackerHealth
    case defenderHealth

    func textureName(for value: Int) -> String {

        switch self {
        case .science:
            return "science_progress_\(value)"
        case .culture:
            return "culture_progress_\(value)"
        case .attackerHealth:
            return "attacker_health\(value)"
        case .defenderHealth:
            return "defender_health\(value)"
        }
    }
}

// https://hmaidasani.github.io/RadialChartImageGenerator/
class CircularProgressBarNode: SKSpriteNode {

    private var _value: Int = 0
    private let type: ProgressBarType

    var value: Int {
        set {
            self._value = newValue
            self.updateSprite()
        }
        get {
            return self._value
        }
    }

    init(type: ProgressBarType, size: CGSize) {

        self._value = 0
        self.type = type

        let texture = SKTexture(imageNamed: "")
        super.init(texture: texture, color: .black, size: size)

        self.updateSprite()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func updateSprite() {

        let textureName = self.type.textureName(for: self._value)

        self.texture = SKTexture(imageNamed: textureName)
    }
}
