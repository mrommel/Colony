//
//  GameSceneViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.05.21.
//

import SmartAILibrary

public class GameSceneViewModel: ObservableObject {
    
    @Published
    var game: GameModel?
    
    var selectedUnit: AbstractUnit? = nil
    
    public init() {
        
        self.game = nil
    }
    
    public func doTurn() {
        
        print("do turn")
    }
}
