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
    
    init() {
        
        self.iconTexture = "tech_animalHusbandry"
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
