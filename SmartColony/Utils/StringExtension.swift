//
//  StringExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 23.07.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import Foundation

extension String {
    
    func replaceIcons() -> String {
        
        var tmp = self
        
        tmp = self.replacingOccurrences(of: "Civ6StrengthIcon", with: "🛡")
        tmp = self.replacingOccurrences(of: "Civ6Production", with: "⚙")
        tmp = self.replacingOccurrences(of: "Civ6Gold", with: "🪙")
        
        return tmp
    }
}
