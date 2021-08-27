//
//  MapTypeDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 01.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class MapTypeDialog: Dialog {

    init() {
        let uiParser = UIParser()
        guard let mapTypeDialogConfiguration = uiParser.parse(from: "MapTypeDialog") else {
            fatalError("cant load MapTypeDialog configuration")
        }

        super.init(from: mapTypeDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
