//
//  GameSceneDialogs.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary

extension GameScene {

    func showTechDiscoveredPopup(for techType: TechType) {

        self.viewModel?.currentPopupType = .techDiscovered

        /*let techDiscoveredPopupViewModel = TechDiscoveredPopupViewModel(techType: techType)

        let techDiscoveredPopup = TechDiscoveredPopup(viewModel: techDiscoveredPopupViewModel)
        techDiscoveredPopup.zPosition = 250

        techDiscoveredPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            techDiscoveredPopup.close()
        })

        self.cameraNode.add(dialog: techDiscoveredPopup)*/
    }
}
