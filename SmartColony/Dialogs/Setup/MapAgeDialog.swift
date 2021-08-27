//
//  MapAgeDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class MapAgeDialog: Dialog {

    init() {
        let uiParser = UIParser()
        guard let mapAgeDialogConfiguration = uiParser.parse(from: "MapAgeDialog") else {
            fatalError("cant load MapAgeDialog configuration")
        }

        super.init(from: mapAgeDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
