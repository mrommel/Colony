//
//  CityDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 13.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class CityDialog: Dialog {
    
    init() {
    
        let uiParser = UIParser()
        guard let cityDialogConfiguration = uiParser.parse(from: "CityDialog") else {
            fatalError("cant load cityDialogConfiguration configuration")
        }
        super.init(from: cityDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
