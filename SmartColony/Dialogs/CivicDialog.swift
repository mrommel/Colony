//
//  CivicDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 18.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary
import SpriteKit

class CivicDialogDelegate: DialogConfigurationDelegate {

    let civics: AbstractCivics?

    init(civics: AbstractCivics?) {

        self.civics = civics
    }

    func techProgress(of techType: TechType) -> Int {

        return 0
    }

    func civicProgress(of civicType: CivicType) -> Int {

        guard let civics = self.civics else {
            fatalError("cant get civics")
        }

        if civics.currentCivic() == civicType {
            let progressPercentage = civics.currentCultureProgress() / Double(civicType.cost()) * 100.0
            return Int(progressPercentage)
        } else if civics.has(civic: civicType) {
            return 100
        } else if civics.eurekaTriggered(for: civicType) {
            return 50
        } else {
            return 0
        }
    }
}

class CivicDialog: Dialog {

    // nodes
    var scrollNode: ScrollNode?

    // MARK: Constructors

    init(with civics: AbstractCivics?) {

        let uiParser = UIParser()
        guard let civicDialogConfiguration = uiParser.parse(from: "CivicDialog") else {
            fatalError("cant load CivicDialog configuration")
        }

        civicDialogConfiguration.delegate = CivicDialogDelegate(civics: civics)

        super.init(from: civicDialogConfiguration)

        self.check(civics: civics)

        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: private methods

    private func check(civics: AbstractCivics?) {

        guard let civics = civics else {
            fatalError("Cant get techs")
        }

        let possibleCivics = civics.possibleCivics()

        for item in self.children {

            if let civicDisplayNode = item as? CivicDisplayNode {

                if civics.currentCivic() == civicDisplayNode.civicType {
                    civicDisplayNode.selected()
                } else if civics.has(civic: civicDisplayNode.civicType) {
                    civicDisplayNode.researched()
                } else if possibleCivics.contains(civicDisplayNode.civicType) {
                    civicDisplayNode.possible()
                } else {
                    civicDisplayNode.disabled()
                }
            }
        }
    }

    private func setupScrollView() {

        // scroll area
        self.scrollNode = ScrollNode(mode: .horizontally, size: CGSize(width: 320, height: 380), contentSize: CGSize(width: 1500, height: 380))
        self.scrollNode?.position = CGPoint(x: 0, y: -410)
        self.scrollNode?.zPosition = self.zPosition + 1
        self.addChild(self.scrollNode!)

        let offsetX = -self.scrollNode!.size.halfWidth

        let backgroundTexture = SKTexture(imageNamed: "civic_connections")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: CGSize(width: 1500, height: 380))
        backgroundNode.anchorPoint = CGPoint.middleLeft
        backgroundNode.zPosition = 199
        backgroundNode.position = CGPoint(x: offsetX, y: 0)
        self.scrollNode?.addScrolling(child: backgroundNode)

        for item in self.children {

            if let civicDisplayNode = item as? CivicDisplayNode {
                civicDisplayNode.removeFromParent()
                civicDisplayNode.zPosition = 200
                self.scrollNode?.addScrolling(child: civicDisplayNode)
            }
        }
    }
}
