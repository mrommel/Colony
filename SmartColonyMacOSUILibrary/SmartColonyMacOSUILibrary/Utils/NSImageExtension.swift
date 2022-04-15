//
//  NSImageExtension.swift
//  SmartMacOSUILibrary
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

    convenience init(color: NSColor, size: NSSize) {
        self.init(size: size)
        lockFocus()
        color.drawSwatch(in: NSRect(origin: .zero, size: size))
        unlockFocus()
    }
}

extension NSImage {

    /// Copy the image and resize it to the supplied size, while maintaining it's
    /// original aspect ratio.
    ///
    /// - Parameter size: The target size of the image.
    /// - Returns: The resized image.
    public func resizeMaintainingAspectRatio(withSize targetSize: NSSize) -> NSImage? {
        let newSize: NSSize
        let widthRatio  = targetSize.width / self.width
        let heightRatio = targetSize.height / self.height

        if widthRatio > heightRatio {
            newSize = NSSize(width: floor(self.width * widthRatio),
                             height: floor(self.height * widthRatio))
        } else {
            newSize = NSSize(width: floor(self.width * heightRatio),
                             height: floor(self.height * heightRatio))
        }
        return self.resize(withSize: newSize)
    }

    // MARK: Cropping
    /// Resize the image, to nearly fit the supplied cropping size
    /// and return a cropped copy the image.
    ///
    /// - Parameter size: The size of the new image.
    /// - Returns: The cropped image.
    func crop(toSize targetSize: NSSize) -> NSImage? {
        guard let resizedImage = self.resizeMaintainingAspectRatio(withSize: targetSize) else {
            return nil
        }
        let x     = floor((resizedImage.width - targetSize.width) / 2)
        let y     = floor((resizedImage.height - targetSize.height) / 2)
        let frame = NSRect(x: x, y: y, width: targetSize.width, height: targetSize.height)

        guard let representation = resizedImage.bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }

        let image = NSImage(size: targetSize,
                            flipped: false,
                            drawingHandler: { (destinationRect: NSRect) -> Bool in
            return representation.draw(in: destinationRect)
        })

        return image
    }
}

func drawImageInCGContext(size: CGSize, drawFunc: (_ context: CGContext) -> Void) -> NSImage {

    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    let context = CGContext(
        data: nil,
        width: Int(size.width),
        height: Int(size.height),
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: colorSpace,
        bitmapInfo: bitmapInfo.rawValue)

    drawFunc(context!)

    let image = context!.makeImage()!
    return NSImage(cgImage: image, size: size)
}

// Draw in NSGraphicsContext, a layer on top of CoreGraphics
func drawImageInNSGraphicsContext(size: CGSize, drawFunc: () -> Void) -> NSImage {

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: Int(size.width),
        pixelsHigh: Int(size.height),
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: NSColorSpaceName.calibratedRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0)

    let context = NSGraphicsContext(bitmapImageRep: rep!)

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = context

    drawFunc()

    NSGraphicsContext.restoreGraphicsState()

    let image = NSImage(size: size)
    image.addRepresentation(rep!)

    return image
}
