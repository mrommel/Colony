//
//  HexCoordLayerViewModel.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.03.21.
//

import Cocoa
import SmartAILibrary

class HexCoordLayerViewModel: BaseLayerViewModel {
    
    override func render(tile: AbstractTile, into context: CGContext?, at tileRect: CGRect, in game: GameModel) {

        let color = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let bgcolor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        let font = CTFontCreateWithName("Chalkboard" as CFString, 14.0, nil)
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center

        let attributes: [NSAttributedString.Key : Any] = [
            .font: font,
            .foregroundColor: color,
            .backgroundColor: bgcolor,
            .paragraphStyle: style
        ]
        
        context?.drawText(text: "\(tile.point.x), \(tile.point.y)", at: tileRect.center, with: attributes)
        // context?.drawText(text: String(format: "%.1f, %.1f", tileRect.origin.x, tileRect.origin.y), at: CGPoint(x: tileRect.center.x - 48, y: tileRect.center.y - 40) , with: attributes)
        
        let x = tileRect.center.x
        let y = tileRect.center.y - 30 // tileRect.minY + (tileRect.height * 3 / 4) / 2
        
        context?.beginPath()
        context?.move(to: CGPoint(x: x - 10, y: y))
        context?.addLine(to: CGPoint(x: x + 10, y: y))
    
        context?.move(to: CGPoint(x: x, y: y - 10))
        context?.addLine(to: CGPoint(x: x, y: y + 10))
        
        context?.strokePath()
        
    }
}
