//
//  UI.swift
//  Colony
//
//  Created by Michael Rommel on 11.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import Foundation

class UI {
    
    static func defeatDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let defeatDialogConfiguration = uiParser.parse(from: "DefeatDialog") {
            return Dialog(from: defeatDialogConfiguration)
        }
        
        return nil
    }
    
    static func victoryDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let victoryDialogConfiguration = uiParser.parse(from: "VictoryDialog") {
            return Dialog(from: victoryDialogConfiguration)
        }
        
        return nil
    }
    
    static func quitConfirmationDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let quitConfirmationDialogConfiguration = uiParser.parse(from: "QuitConfirmationDialog") {
            return Dialog(from: quitConfirmationDialogConfiguration)
        }
        
        return nil
    }
}
