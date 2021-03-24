//
//  GameDisplayOptions.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.03.21.
//

import Foundation

public struct GameDisplayOptions {
    
    static let standard: GameDisplayOptions = GameDisplayOptions(showFeatures: false, showResources: false, showBorders: false, showStartPositions: false, showInhabitants: false, showSupportedPeople: false)
    
    let showFeatures: Bool
    let showResources: Bool
    let showBorders: Bool
    
    let showStartPositions: Bool
    let showInhabitants: Bool
    let showSupportedPeople: Bool
    
    public init(showFeatures: Bool, showResources: Bool, showBorders: Bool, showStartPositions: Bool, showInhabitants: Bool, showSupportedPeople: Bool) {
        
        self.showFeatures = showFeatures
        self.showResources = showResources
        self.showBorders = showBorders
        
        self.showStartPositions = showStartPositions
        self.showInhabitants = showInhabitants
        self.showSupportedPeople = showSupportedPeople
    }
}
