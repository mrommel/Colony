//
//  GameSceneDelegates.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

extension GameScene: LeftHeaderBarNodeDelegate {

    func toogleScienceButton() {
        
        self.scienceProgressNodeHidden = !self.scienceProgressNodeHidden
        self.updateLayout()
    }

    func toggleCultureButton() {
        
        self.cultureProgressNodeHidden = !self.cultureProgressNodeHidden
        self.updateLayout()
    }
    
    func governmentButtonClicked() {
        
        self.showGovernment()
    }
}

extension GameScene: RightHeaderBarNodeDelegate {
}

extension GameScene: BottomRightBarDelegate {

    func focus(on point: HexPoint) {

        self.centerCamera(on: point)
    }

    func showYields() {
        self.mapNode?.showYields()
    }

    func hideYields() {
        self.mapNode?.hideYields()
    }

    func showWater() {
        self.mapNode?.showWater()
    }

    func hideWater() {
        self.mapNode?.hideWater()
    }
}
