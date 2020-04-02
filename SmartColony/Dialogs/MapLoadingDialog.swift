//
//  MapLoadingDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class MapLoadingDialog: Dialog {
    
    init() {
        let uiParser = UIParser()
        guard let mapLoadingDialogConfiguration = uiParser.parse(from: "MapLoadingDialog") else {
            fatalError("cant load MapLoadingDialog configuration")
        }
        
        super.init(from: mapLoadingDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showProgress(value: Double, text: String) {
        
        self.set(progress: value, identifier: "progress")
        self.set(text: text, identifier: "text")
    }
}
