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
    
    static func levelIntroductionDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let levelIntroductionDialogConfiguration = uiParser.parse(from: "LevelIntroductionDialog") {
            return Dialog(from: levelIntroductionDialogConfiguration)
        }
        
        return nil
    }
    
    static func cityDialog(for city: City?) -> Dialog? {
        
        let uiParser = UIParser()
        if let cityDialogConfiguration = uiParser.parse(from: "CityDialog") {
            let cityDialog = CityDialog(from: cityDialogConfiguration)
            cityDialog.populate(with: city)
            return cityDialog
        }
        
        return nil
    }
    
    static func continueDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let gameContinueDialogConfiguration = uiParser.parse(from: "GameContinueDialog") {
            return Dialog(from: gameContinueDialogConfiguration)
        }
        
        return nil
    }
}
