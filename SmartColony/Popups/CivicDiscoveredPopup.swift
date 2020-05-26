//
//  CivicDiscoveredPopup.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SmartAILibrary

class CivicDiscoveredPopupViewModel {
    
    let iconTexture: String
    let titleText: String
    let summaryText: String
    let subtitleText: String
    let unlockedIcons: [String]
    let quoteText: String
    
    init(civicType: CivicType) {
        
        self.iconTexture = civicType.iconTexture()
        self.titleText = "Research completed"
        self.summaryText = civicType.name()
        self.subtitleText = "Unlocked by this Civic:"
        self.unlockedIcons = []
        self.quoteText = civicType.quoteText()
    }
}

class CivicDiscoveredPopup: Dialog {
    
    let viewModel: CivicDiscoveredPopupViewModel
    
    init(viewModel: CivicDiscoveredPopupViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let civicDiscoveredPopupConfiguration = uiParser.parse(from: "CivicDiscoveredPopup") else {
            fatalError("cant load CivicDiscoveredPopup configuration")
        }
        
        super.init(from: civicDiscoveredPopupConfiguration)
        
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

