//
//  CGImageExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 21.03.21.
//

import Cocoa

extension CGImage {
    
    func mapColor(color0: NSColor, color1: NSColor) -> CGImage? {
            
        guard let filter = CIFilter(name: "CIFalseColor" ) else {
            return nil
        }
        
        let ciiimage = CIImage(cgImage: self)
        
        filter.setValue(ciiimage, forKey: kCIInputImageKey)
        filter.setValue(CIColor(color: color0), forKey: "inputColor0")
        filter.setValue(CIColor(color: color1), forKey: "inputColor1")

        let resultImage = filter.outputImage
        
        let cicontext = CIContext(options: nil)
        let imageRef: CGImage? =  cicontext.createCGImage(resultImage!, from: CGRect(origin: CGPoint.zero, size: NSSize(width: self.width, height: self.height)))

        return imageRef
    }
}
