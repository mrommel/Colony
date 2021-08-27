//
//  MapSizeDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class MapSizeDialog: Dialog {

    init() {
        let uiParser = UIParser()
        guard let mapSizeDialogConfiguration = uiParser.parse(from: "MapSizeDialog") else {
            fatalError("cant load MapSizeDialog configuration")
        }

        super.init(from: mapSizeDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
