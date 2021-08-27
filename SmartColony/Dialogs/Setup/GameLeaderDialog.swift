//
//  GameLeaderDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 29.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class GameLeaderDialog: Dialog {

    init() {

        let uiParser = UIParser()
        guard let gameLeaderDialogConfiguration = uiParser.parse(from: "GameLeaderDialog") else {
            fatalError("cant load GameLeaderDialogConfiguration configuration")
        }

        super.init(from: gameLeaderDialogConfiguration)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
