//
//  EnteredEraPopup.swift
//  SmartColony
//
//  Created by Michael Rommel on 26.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

import SmartAILibrary

class EnteredEraPopupViewModel {
    
    init(eraType: EraType) {
        
    }
}

class EnteredEraPopup: Dialog {
 
    let viewModel: EnteredEraPopupViewModel
    
    init(viewModel: EnteredEraPopupViewModel) {
        
        self.viewModel = viewModel
        
        let uiParser = UIParser()
        guard let enteredEraPopupConfiguration = uiParser.parse(from: "EnteredEraPopup") else {
            fatalError("cant load EnteredEraPopup configuration")
        }
        
        super.init(from: enteredEraPopupConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
