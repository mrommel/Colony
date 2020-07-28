//
//  GameDifficultDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 29.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation
import SmartAILibrary

class GameHandicapDialog: Dialog {

    init() {

        let uiParser = UIParser()
        guard let gameHandicapDialogConfiguration = uiParser.parse(from: "GameHandicapDialog") else {
            fatalError("cant load GameHandicapDialog configuration")
        }

        super.init(from: gameHandicapDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
