//
//  GameNameDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 31.05.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class GameNameDialog: Dialog {
    
    init() {
        let uiParser = UIParser()
        guard let gameNameDialogConfiguration = uiParser.parse(from: "GameNameDialog") else {
            fatalError("cant load GameNameDialog configuration")
        }
        
        super.init(from: gameNameDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gameName() -> String {
        
        return self.getTextFieldInput()
    }
    
    func isValid() -> Bool {
        
        let gameName = self.gameName()
        
        if gameName.count < 3 {
            return false
        }
        
        return true
    }
}
