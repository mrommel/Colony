//
//  PlayerInputDialog.swift
//  Colony
//
//  Created by Michael Rommel on 22.10.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit

class PlayerInputDialog: Dialog {
    
    override init(from dialogConfiguration: DialogConfiguration) {
        super.init(from: dialogConfiguration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(warning text: String) {
        print("warning: \(text)")
        
        if let scene = self.scene as? BaseScene {
            scene.show(message: text)
        }
    }
    
    func isValid() -> Bool {
        
        let username = self.getUsername()
        if !UserUsecase.isValid(name: username) {
            return false
        }
        
        let civilization = self.getCivilization()
        if civilization == .none {
            return false
        }
        
        return true
    }
    
    func getUsername() -> String {
        
        return self.getTextFieldInput()
    }
    
    func getCivilization() -> Civilization {
        
        if let selectedItem = self.selectedItem {
            if let civilization = Civilization(rawValue: selectedItem.title) {
                return civilization
            }
        }
        
        return .none
    }
}
