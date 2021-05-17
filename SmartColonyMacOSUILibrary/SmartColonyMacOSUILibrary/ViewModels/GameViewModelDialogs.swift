//
//  GameSceneDialogs.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 16.05.21.
//

import SmartAILibrary

extension GameViewModel {
    
    func showTechDiscoveredPopup(for techType: TechType) {

        self.currentPopupType = .techDiscovered

        /*let techDiscoveredPopupViewModel = TechDiscoveredPopupViewModel(techType: techType)

        let techDiscoveredPopup = TechDiscoveredPopup(viewModel: techDiscoveredPopupViewModel)
        techDiscoveredPopup.zPosition = 250

        techDiscoveredPopup.addOkayAction(handler: {
            self.currentPopupType = .none
            techDiscoveredPopup.close()
        })

        self.cameraNode.add(dialog: techDiscoveredPopup)*/
    }
    
    func showCivicDiscoveredPopup(for civicType: CivicType) {
        
        self.currentPopupType = .civicDiscovered
    }
    
    func showEnteredEraPopup(for eraType: EraType) {
        
        self.currentPopupType = .eraEntered
    }
    
    func showEurekaActivatedPopup(for techType: TechType) {
        
        self.currentPopupType = .eurekaActivated
    }
    
    func showEurekaActivatedPopup(for civicType: CivicType) {
        
        self.currentPopupType = .eurekaActivated
    }
    
    func showGoodyHutRewardPopup(for goodyType: GoodyType, in cityName: String?) {
    
        self.currentPopupType = .goodyHutReward
    }
}
