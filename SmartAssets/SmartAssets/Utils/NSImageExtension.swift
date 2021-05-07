//
//  NSImageExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 06.04.21.
//

import Cocoa

extension NSImage {
    
    var cgImage: CGImage? {
        
        var proposedRect = CGRect(origin: .zero, size: self.size)
        return cgImage(forProposedRect: &proposedRect, context: nil, hints: nil)
    }
    
    /// The height of the image.
    var height: CGFloat {
        return size.height
    }

    /// The width of the image.
    var width: CGFloat {
        return size.width
    }
}

extension NSImage {
    
    // MARK: Resizing
    /// Resize the image to the given size.
    ///
    /// - Parameter size: The size to resize the image to.
    /// - Returns: The resized image.
    public func resize(withSize targetSize: NSSize) -> NSImage? {
        let frame = NSRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        guard let representation = self.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let image = NSImage(size: targetSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })

        return image
    }
    
    func cropped(boundingBox rect: CGRect) -> NSImage? {
        
        let tmpImage: CGImage? = self.cgImage?.cropping(to: rect)
        
        return NSImage(cgImage: tmpImage!, size: rect.size)
    }
    
    func leftMirrored() -> NSImage? {
        
        let existingImage: NSImage? = self
        let existingSize: NSSize? = existingImage?.size
        let newSize: NSSize? = NSMakeSize((existingSize?.width)!, (existingSize?.height)!)
        let flipedImage = NSImage(size: newSize!)
        flipedImage.lockFocus()
        
        let t = NSAffineTransform.init()
        t.translateX(by: (existingSize?.width)!, yBy: 0.0)
        t.scaleX(by: -1.0, yBy: 1.0)
        t.concat()
        
        let rect: NSRect = NSMakeRect(0, 0, (newSize?.width)!, (newSize?.height)!)
        existingImage?.draw(at: NSZeroPoint, from: rect, operation: .sourceOver, fraction: 1.0)
        flipedImage.unlockFocus()
        return flipedImage
    }
    
    func overlayWith(image: NSImage, posX: CGFloat, posY: CGFloat) -> NSImage? {
        
        self.lockFocus()
        
        image.draw(in: NSMakeRect(posX, posY, image.width, image.height))
        
        self.unlockFocus()
        
        return self
    }
}

// This will work with Swift 5
extension NSImage {
    
    public func tint(with tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        tintColor.set()
        
        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceIn)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
}
