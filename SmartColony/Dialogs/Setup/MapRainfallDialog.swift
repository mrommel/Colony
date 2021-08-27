//
//  MapRainfallDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class MapRainfallDialog: Dialog {

    init() {
        let uiParser = UIParser()
        guard let mapRainfallDialogConfiguration = uiParser.parse(from: "MapRainfallDialog") else {
            fatalError("cant load MapRainfallDialog configuration")
        }

        super.init(from: mapRainfallDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
