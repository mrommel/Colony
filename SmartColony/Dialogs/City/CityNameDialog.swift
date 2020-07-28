//
//  CityNameDialog.swift
//  SmartColony
//
//  Created by Michael Rommel on 17.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

class CityNameDialog: Dialog {
    
    init() {
        let uiParser = UIParser()
        guard let cityNameDialogConfiguration = uiParser.parse(from: "CityNameDialog") else {
            fatalError("cant load CityNameDialog configuration")
        }
        
        super.init(from: cityNameDialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getCityName() -> String {
        
        return self.getTextFieldInput()
    }
    
    func isValid() -> Bool {
        
        let cityName = self.getCityName()
        
        if cityName.count < 3 {
            return false
        }
        
        return true
    }
}
