//
//  MapClimateDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class MapClimateDialog: Dialog {

    init() {
        let uiParser = UIParser()
        guard let mapClimateDialogConfiguration = uiParser.parse(from: "MapClimateDialog") else {
            fatalError("cant load MapClimateDialog configuration")
        }

        super.init(from: mapClimateDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
