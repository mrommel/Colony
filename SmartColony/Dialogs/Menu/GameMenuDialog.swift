//
//  GameMenuDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 27.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GameMenuDialog: Dialog {

    init() {

        let uiParser = UIParser()
        guard let gameMenuDialogConfiguration = uiParser.parse(from: "GameMenuDialog") else {
            fatalError("cant load GameMenuDialog configuration")
        }

        super.init(from: gameMenuDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
