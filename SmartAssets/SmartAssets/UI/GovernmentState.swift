//
//  GovernmentState.swift
//  SmartAssets
//
//  Created by Michael Rommel on 12.05.21.
//

import Foundation

public enum GovernmentState {
    
    case selected
    case active
    case disabled
    
    public static var all: [GovernmentState] = [.selected, .active, .disabled]
    
    public func backgroundTexture() -> String {
        
        switch self {
            
        case .selected: return "government-box-selected"
        case .active: return "government-box-active"
        case .disabled: return "government-box-disabled"
        }
    }
}
