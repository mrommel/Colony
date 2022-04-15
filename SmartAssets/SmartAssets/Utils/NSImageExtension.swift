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

/// Exceptions for the image extension class.
///
/// - creatingPngRepresentationFailed: Is thrown when the creation of the png representation failed.
enum NSImageExtensionError: Error {
    case unwrappingPNGRepresentationFailed
}

extension NSImage {

    /// A PNG representation of the image.
    var pngRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }

        return nil
    }

    // MARK: Saving
    /// Save the images PNG representation the the supplied file URL:
    ///
    /// - Parameter url: The file URL to save the png file to.
    /// - Throws: An unwrappingPNGRepresentationFailed when the image has no png representation.
    public func savePngTo(url: URL) throws {

        if let png = self.pngRepresentation {
            try png.write(to: url, options: .atomicWrite)
        } else {
            throw NSImageExtensionError.unwrappingPNGRepresentationFailed
        }
    }

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
        let newSize: NSSize? = NSSize(width: (existingSize?.width)!, height: (existingSize?.height)!)
        let flipedImage = NSImage(size: newSize!)
        flipedImage.lockFocus()

        let transform = NSAffineTransform.init()
        transform.translateX(by: (existingSize?.width)!, yBy: 0.0)
        transform.scaleX(by: -1.0, yBy: 1.0)
        transform.concat()

        let rect: NSRect = NSRect(x: 0, y: 0, width: (newSize?.width)!, height: (newSize?.height)!)
        existingImage?.draw(at: NSPoint.zero, from: rect, operation: .sourceOver, fraction: 1.0)
        flipedImage.unlockFocus()
        return flipedImage
    }

    func overlayWith(image: NSImage, posX: CGFloat, posY: CGFloat) -> NSImage? {

        self.lockFocus()

        image.draw(in: NSRect(x: posX, y: posY, width: image.width, height: image.height))

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

        guard let image = self.copy() as? NSImage else {
            fatalError("cant copy image")
        }
        image.lockFocus()

        tintColor.set()

        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceIn)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}
