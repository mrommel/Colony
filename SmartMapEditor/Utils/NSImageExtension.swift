//
//  NSImageExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 27.11.20.
//

import Cocoa
import CoreGraphics

extension NSImage {
    
    var cgImage: CGImage? {
        
        var proposedRect = CGRect(origin: .zero, size: self.size)
        return cgImage(forProposedRect: &proposedRect, context: nil, hints: nil)
    }
}
