//
//  NSColorExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.12.20.
//

import Cocoa

extension NSColor {

    func toColor(_ color: NSColor, percentage: CGFloat) -> NSColor {

        let percentage = max(min(percentage, 100), 0) / 100

        switch percentage {

        case 0: return self
        case 1: return color

        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

            self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            return NSColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}
