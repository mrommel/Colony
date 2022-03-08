//
//  NSColorExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.12.20.
//

import Cocoa

extension NSColor {

    func toColor(_ color: NSColor, percentage: CGFloat) -> NSColor {

        let percentage = percentage.clamped(to: 0...100) / 100

        switch percentage {

        case 0: return self
        case 1: return color

        default:
            var (redOne, greenOne, blueOne, alphaOne): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (redTwo, greenTwo, blueTwo, alphaTwo): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

            self.getRed(&redOne, green: &greenOne, blue: &blueOne, alpha: &alphaOne)
            color.getRed(&redTwo, green: &greenTwo, blue: &blueTwo, alpha: &alphaTwo)

            return NSColor(red: CGFloat(redOne + (redTwo - redOne) * percentage),
                           green: CGFloat(greenOne + (greenTwo - greenOne) * percentage),
                           blue: CGFloat(blueOne + (blueTwo - blueOne) * percentage),
                           alpha: CGFloat(alphaOne + (alphaTwo - alphaOne) * percentage))
        }
    }
}
