//
//  EurekaActivatedPopup.swift
//  SmartColony
//
//  Created by Michael Rommel on 19.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class EurekaActivatedPopupViewModel {
    
    let iconTexture: String
    let titleText: String
    let summaryText: String
    let subtitleText: String
    
    init(techType: TechType) {
        
        self.iconTexture = techType.iconTexture()
        self.titleText = "Eureka!"
        self.summaryText = techType.eurekaDescription()
        self.subtitleText = "Your knowledge of \(techType.name()) has advanced considerably."
    }
    
    init(civicType: CivicType) {
        
        self.iconTexture = civicType.iconTexture()
        self.titleText = "Eureka!"
        self.summaryText = civicType.eurekaDescription()
        self.subtitleText = "Your knowledge of \(civicType.name()) has advanced considerably."
    }
}

class EurekaActivatedPopup: Dialog {
    
    let viewModel: EurekaActivatedPopupViewModel
    
    init(viewModel: EurekaActivatedPopupViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let eurekaActivatedPopupConfiguration = uiParser.parse(from: "EurekaActivatedPopup") else {
            fatalError("cant load EurekaActivatedPopup configuration")
        }
        
        super.init(from: eurekaActivatedPopupConfiguration)
        
        self.set(imageNamed: self.viewModel.iconTexture, identifier: "popup_image")
        self.set(text: self.viewModel.titleText, identifier: "popup_title")
        self.set(text: self.viewModel.summaryText, identifier: "popup_summary")
        self.set(text: self.viewModel.subtitleText, identifier: "popup_subtitle")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
