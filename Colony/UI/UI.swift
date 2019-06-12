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
}
