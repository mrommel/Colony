//
//  CultureProgressNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 11.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary
import SpriteKit

class CultureProgressNode: BaseProgressNode {

    var civicType: CivicType

    init() {

        self.civicType = .codeOfLaws

        super.init(progressBarType: .culture, title: "Choose Research", iconTexture: "civic_default", eureka: "---", progress: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(civic: CivicType, progress value: Int, turnsRemaining: Int) {

        if self.civicType != civic {
            self.iconNode?.texture = SKTexture(imageNamed: civic.iconTexture())
            self.labelNode?.text = civic.name()
            self.eurekaNode?.text = civic.eurekaSummary()
            self.turnsRemainingNode?.text = "\(turnsRemaining)"

            self.resetIcons()

            let achievements = civic.achievements()

            for buildingType in achievements.buildingTypes {
                self.addIcon(named: buildingType.iconTexture())
            }

            for unitType in achievements.unitTypes {
                self.addIcon(named: unitType.iconTexture())
            }

            for wonderType in achievements.wonderTypes {
                self.addIcon(named: wonderType.iconTexture())
            }

            for buildType in achievements.buildTypes {
                self.addIcon(named: buildType.iconTexture())
            }

            for policyCardsType in achievements.policyCards {
                self.addIcon(named: policyCardsType.iconTexture())
            }

            self.civicType = civic
        }

        self.progressNode?.value = value
    }
}
