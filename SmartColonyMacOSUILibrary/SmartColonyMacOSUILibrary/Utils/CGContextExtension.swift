//
//  CGContextExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 28.02.21.
//

import Foundation

extension CGContext {
    
    func drawText(text: String, at point: CGPoint, with attributes: [NSAttributedString.Key : Any]) {
        
        self.saveGState()

        // Parameters
        let margin: CGFloat = 5

        // Text
        let attributedString = NSAttributedString(string: text, attributes: attributes)

        // Render
        let line = CTLineCreateWithAttributedString(attributedString)
        // let stringRect = CTLineGetImageBounds(line, self)

        self.textPosition = CGPoint(x: point.x - margin, y: point.y + margin)

        CTLineDraw(line, self)

        self.restoreGState()
    }
}
