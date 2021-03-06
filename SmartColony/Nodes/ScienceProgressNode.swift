//
//  ScienceProgressNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import SmartAILibrary

class ScienceProgressNode: BaseProgressNode {

    var techType: TechType

    init() {

        self.techType = .none

        super.init(progressBarType: .science, title: "Choose Research", iconTexture: "tech_default", eureka: "---", progress: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(tech: TechType, progress value: Int, turnsRemaining: Int) {

        if self.techType != tech {

            self.iconNode?.texture = SKTexture(imageNamed: tech.iconTexture())
            self.labelNode?.text = tech.name()
            self.eurekaNode?.text = tech.eurekaSummary()

            self.resetIcons()

            let achievements = tech.achievements()

            for buildingType in achievements.buildingTypes {
                self.addIcon(texture: SKTexture(imageNamed: buildingType.iconTexture()))
            }

            for unitType in achievements.unitTypes {
                self.addIcon(texture: unitType.iconTexture())
            }

            for wonderType in achievements.wonderTypes {
                self.addIcon(texture: SKTexture(imageNamed: wonderType.iconTexture()))
            }

            for buildType in achievements.buildTypes {
                self.addIcon(texture: SKTexture(imageNamed: buildType.iconTexture()))
            }

            self.techType = tech
        }

        self.progressNode?.value = max(0, min(value, 100))
        self.turnsRemainingNode?.text = "\(turnsRemaining)"
    }
}
