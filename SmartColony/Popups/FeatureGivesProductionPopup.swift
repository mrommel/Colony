//
//  FeatureGivesProductionPopup.swift
//  SmartColony
//
//  Created by Michael Rommel on 20.06.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class FeatureGivesProductionPopupViewModel {
    
    let summaryText: String
    
    init(feature: FeatureType, production: Int, for cityName: String) {
        
        self.summaryText = "The removal of \(feature.name()) has gained you \(production) [ICON_PRODUCTION] for your city \(cityName)."
    }
}

class FeatureGivesProductionPopup: Dialog {
 
    let viewModel: FeatureGivesProductionPopupViewModel
    
    init(viewModel: FeatureGivesProductionPopupViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let featureGivesProductionPopupConfiguration = uiParser.parse(from: "FeatureGivesProductionPopup") else {
            fatalError("cant load FeatureGivesProductionPopup configuration")
        }
        
        super.init(from: featureGivesProductionPopupConfiguration)
        
        self.set(imageNamed: "questionmark", identifier: "popup_image")
        self.set(text: "Production gained", identifier: "popup_title")
        self.set(text: self.viewModel.summaryText, identifier: "popup_summary")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
