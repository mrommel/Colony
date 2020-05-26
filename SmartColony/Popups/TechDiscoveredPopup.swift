//
//  TechDiscoveredPopup.swift
//  SmartColony
//
//  Created by Michael Rommel on 25.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class TechDiscoveredPopupViewModel {
    
    let iconTexture: String
    let titleText: String
    let summaryText: String
    let subtitleText: String
    let unlockedIcons: [String]
    let quoteText: String
    
    init(techType: TechType) {
        
        self.iconTexture = techType.iconTexture()
        self.titleText = "Research completed"
        self.summaryText = techType.name()
        self.subtitleText = "Unlocked by this Tech:"
        self.unlockedIcons = []
        self.quoteText = techType.quoteText()
    }
}

class TechDiscoveredPopup: Dialog {
    
    let viewModel: TechDiscoveredPopupViewModel
    
    init(viewModel: TechDiscoveredPopupViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let techDiscoveredPopupConfiguration = uiParser.parse(from: "TechDiscoveredPopup") else {
            fatalError("cant load TechDiscoveredPopup configuration")
        }
        
        super.init(from: techDiscoveredPopupConfiguration)
        
        self.set(imageNamed: self.viewModel.iconTexture, identifier: "popup_image")
        self.set(text: self.viewModel.titleText, identifier: "popup_title")
        self.set(text: self.viewModel.summaryText, identifier: "popup_summary")
        self.set(text: self.viewModel.subtitleText, identifier: "popup_subtitle")
        // ...
        self.set(text: self.viewModel.quoteText, identifier: "popup_quote")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
