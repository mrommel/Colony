//
//  CursorLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 13.04.21.
//

import SwiftUI
import SmartAILibrary

class CursorLayerViewModel: BaseLayerViewModel {
    
    override func update(from game: GameModel?) {
        
        guard game != nil else {
            return
        }
        
        // NOOP
    }
 
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {
        
    }
    
    func calcCursorOffset(of cursor: HexPoint) -> CGSize {
        
        var screenPoint = (HexPoint.toScreen(hex: cursor) * self.factor) + self.shift
        
        screenPoint.y = size.height - screenPoint.y - 144

        return screenPoint.size()
    }
}
