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
    
    static func levelIntroductionDialog(for levelMeta: LevelMeta?) -> LevelIntroductionDialog? {
        
        let uiParser = UIParser()
        if let levelIntroductionDialogConfiguration = uiParser.parse(from: "LevelIntroductionDialog") {
            let dialog = LevelIntroductionDialog(from: levelIntroductionDialogConfiguration)
            dialog.displayIntroductionFor(levelMeta: levelMeta)
            return dialog
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
    
    static func battleDialog() -> BattleDialog? {
        
        let uiParser = UIParser()
        if let battleDialogConfiguration = uiParser.parse(from: "BattleDialog") {
            return BattleDialog(from: battleDialogConfiguration)
        }
        
        return nil
    }
    
    static func battleResultDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let battleResultDialogConfiguration = uiParser.parse(from: "BattleResultDialog") {
            return Dialog(from: battleResultDialogConfiguration)
        }
        
        return nil
    }
    
    static func playerInputDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let playerInputDialogConfiguration = uiParser.parse(from: "PlayerInputDialog") {
            return Dialog(from: playerInputDialogConfiguration)
        }
        
        return nil
    }
    
    static func mapTypeDialog() -> MapTypeDialog? {
        
        let uiParser = UIParser()
        if let mapTypeDialogConfiguration = uiParser.parse(from: "MapTypeDialog") {
            let mapTypeDialog = MapTypeDialog(from: mapTypeDialogConfiguration)
            return mapTypeDialog
        }
        
        return nil
    }
    
    static func mapSizeDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let mapSizeDialogConfiguration = uiParser.parse(from: "MapSizeDialog") {
            let mapSizeDialog = Dialog(from: mapSizeDialogConfiguration)
            return mapSizeDialog
        }
        
        return nil
    }
    
    static func mapAgeDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let mapAgeDialogConfiguration = uiParser.parse(from: "MapAgeDialog") {
            let mapAgeDialog = Dialog(from: mapAgeDialogConfiguration)
            return mapAgeDialog
        }
        
        return nil
    }
    
    static func mapRainfallDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let mapRainfallDialogConfiguration = uiParser.parse(from: "MapRainfallDialog") {
            let mapRainfallDialog = Dialog(from: mapRainfallDialogConfiguration)
            return mapRainfallDialog
        }
        
        return nil
    }
    
    static func mapClimateDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let mapClimateDialogConfiguration = uiParser.parse(from: "MapClimateDialog") {
            let mapClimateDialog = Dialog(from: mapClimateDialogConfiguration)
            return mapClimateDialog
        }
        
        return nil
    }
    
    static func mapSeaLevelDialog() -> Dialog? {
        
        let uiParser = UIParser()
        if let mapSeaLevelDialogConfiguration = uiParser.parse(from: "MapSeaLevelDialog") {
            let mapSeaLevelDialog = Dialog(from: mapSeaLevelDialogConfiguration)
            return mapSeaLevelDialog
        }
        
        return nil
    }
    
    static func mapLoadingDialog() -> MapLoadingDialog? {
        
        let uiParser = UIParser()
        if let mapLoadingDialogConfiguration = uiParser.parse(from: "MapLoadingDialog") {
            let mapLoadingDialog = MapLoadingDialog(from: mapLoadingDialogConfiguration)
            return mapLoadingDialog
        }
        
        return nil
    }
}
