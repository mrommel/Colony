//
//  MapSeaLevelDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class MapSeaLevelDialog: Dialog {
    
    init() {
        let uiParser = UIParser()
        guard let mapSeaLevelDialogConfiguration = uiParser.parse(from: "MapSeaLevelDialog") else {
            fatalError("cant load MapSeaLevelDialog configuration")
        }
        
        super.init(from: mapSeaLevelDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
