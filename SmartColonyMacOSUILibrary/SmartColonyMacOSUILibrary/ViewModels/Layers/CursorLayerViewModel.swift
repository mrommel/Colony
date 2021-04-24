//
//  CursorLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.04.21.
//

import SwiftUI
import SmartAILibrary

class CursorLayerViewModel: BaseLayerViewModel {
 
    override func update(from game: GameModel?, showCompleteMap: Bool) {
        
        guard let game = game else {
            return
        }
        
        if self.size == .zero {
            self.updateSizeAndShift(from: game)
        }
    }
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {
        
    }
    
    func calcCursorOffset(of cursor: HexPoint) -> CGSize {
        
        var screenPoint = (HexPoint.toScreen(hex: cursor) * self.factor) + self.shift
        
        screenPoint.y = size.height - screenPoint.y - 144

        return screenPoint.size()
    }
}
