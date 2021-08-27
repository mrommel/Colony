//
//  ScienceDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary
import SpriteKit

class TechDialogDelegate: DialogConfigurationDelegate {

    let techs: AbstractTechs?

    init(techs: AbstractTechs?) {

        self.techs = techs
    }

    func techProgress(of techType: TechType) -> Int {

        guard let techs = self.techs else {
            fatalError("cant get techs")
        }

        if techs.currentTech() == techType {
            let progressPercentage = techs.currentScienceProgress() / Double(techType.cost()) * 100.0
            return Int(progressPercentage)
        } else if techs.has(tech: techType) {
            return 100
        } else if techs.eurekaTriggered(for: techType) {
            return 50
        } else {
            return 0
        }
    }

    func civicProgress(of civicType: CivicType) -> Int {

        return 0
    }
}

class TechDialog: Dialog {

    // nodes
    var scrollNode: ScrollNode?

    // MARK: Constructors

    init(with techs: AbstractTechs?) {

        let uiParser = UIParser()
        guard let techDialogConfiguration = uiParser.parse(from: "TechDialog") else {
            fatalError("cant load TechDialog configuration")
        }

        techDialogConfiguration.delegate = TechDialogDelegate(techs: techs)

        super.init(from: techDialogConfiguration)

        self.check(techs: techs)

        self.setupScrollView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: private methods

    private func check(techs: AbstractTechs?) {

        guard let techs = techs else {
            fatalError("Cant get techs")
        }

        let possibleTechs = techs.possibleTechs()

        for item in self.children {

            if let techDisplayNode = item as? TechDisplayNode {

                if techs.currentTech() == techDisplayNode.techType {
                    techDisplayNode.selected()
                } else if techs.has(tech: techDisplayNode.techType) {
                    techDisplayNode.researched()
                } else if possibleTechs.contains(techDisplayNode.techType) {
                    techDisplayNode.possible()
                } else {
                    techDisplayNode.disabled()
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

        let backgroundTexture = SKTexture(imageNamed: "tech_connections")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture, color: .black, size: CGSize(width: 1500, height: 380))
        backgroundNode.anchorPoint = CGPoint.middleLeft
        backgroundNode.zPosition = 199
        backgroundNode.position = CGPoint(x: offsetX, y: 0)
        self.scrollNode?.addScrolling(child: backgroundNode)

        for item in self.children {

            if let techDisplayNode = item as? TechDisplayNode {
                techDisplayNode.removeFromParent()
                techDisplayNode.zPosition = 200
                self.scrollNode?.addScrolling(child: techDisplayNode)
            }
        }
    }
}
