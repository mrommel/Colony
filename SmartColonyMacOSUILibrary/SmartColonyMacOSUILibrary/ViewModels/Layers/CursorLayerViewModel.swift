//
//  CursorLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.04.21.
//

import SwiftUI
import SmartAILibrary

class CursorLayerViewModel: BaseLayerViewModel, ObservableObject {
    
    @Published
    var cursor: HexPoint? = nil {
        didSet {
            self.updateCursorOffset()
        }
    }
    
    @Published
    var cursorOffset: CGSize? = nil
    
    override init(game: GameModel?) {
        super.init(game: game)
    }
    
    override func update() {
        
        guard self.game != nil else {
            return
        }
        
        self.updateCursorOffset()
    }
 
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {
        
    }
    
    func updateCursorOffset() {
        
        var screenPoint = (HexPoint.toScreen(hex: self.cursor ?? .zero) * self.factor) + self.shift
        
        screenPoint.y = size.height - screenPoint.y - 144
        
        self.cursorOffset = screenPoint.size()
    }
}
