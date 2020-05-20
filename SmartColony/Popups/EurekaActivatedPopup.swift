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
    
    init(techType: TechType) {
        
        self.iconTexture = techType.iconTexture()
        self.titleText = "Eureka!"
        self.summaryText = techType.eurekaDescription()
    }
    
    init(civicType: CivicType) {
        
        self.iconTexture = civicType.iconTexture()
        self.titleText = "Eureka!"
        self.summaryText = civicType.eurekaDescription()
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
