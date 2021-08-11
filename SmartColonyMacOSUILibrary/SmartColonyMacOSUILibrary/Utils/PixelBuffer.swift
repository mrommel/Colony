//
//  PixelBuffer.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 08.04.21.
//

import Cocoa

extension NSColor {
    
    final func toRGBAComponents() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
 
        guard let rgbaColor = usingColorSpace(NSColorSpace.sRGB) else {
            fatalError("Could not convert color to RGBA.")
        }
        
        rgbaColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return (r, g, b, a)
    }
}

struct PixelData {
    
    var a: UInt8 = 255
    var r: UInt8
    var g: UInt8
    var b: UInt8

    init(color: NSColor) {

        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        guard let rgbaColor = color.usingColorSpace(NSColorSpace.sRGB) else {
            fatalError("Could not convert color to RGBA.")
        }
        
        rgbaColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        self.a = UInt8(a * 255)
        self.r = UInt8(r * 255)
        self.g = UInt8(g * 255)
        self.b = UInt8(b * 255)
    }
}

public struct PixelBuffer {

    var pixels: [PixelData]
    var width: Int
    var height: Int

    public init?(image: NSImage) {

        guard let cgImage = image.cgImage else { return nil }
        self.width = Int(image.size.width)
        self.height = Int(image.size.height)

        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let imageData = UnsafeMutablePointer<PixelData>.allocate(capacity: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
            return nil
        }
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        pixels = Array(UnsafeBufferPointer(start: imageData, count: self.width * self.height))
    }

    public init(width: Int, height: Int, color: NSColor) {
        self.width = width
        self.height = height

        self.pixels = Array(repeating: PixelData(color: color), count: self.width * self.height)
    }

    public mutating func set(color: NSColor, at index: Int) {
        if index >= self.width * self.height {
            return
        }
        
        self.pixels[index] = PixelData(color: color)
    }

    public mutating func set(color: NSColor, x: Int, y: Int) {
        let index = y * self.width + x

        self.set(color: color, at: index)
    }

    public func toNSImage() -> NSImage? {
        return PixelBuffer.imageFromARGB32Bitmap(pixels: self.pixels, width: self.width, height: self.height)
    }

    // MARK: private methods

    private static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private static let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

    private static func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> NSImage {

        let bitsPerComponent = 8
        let bytesPerPixel = 4
        let bitsPerPixel = bytesPerPixel * bitsPerComponent
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow

        assert(pixels.count == Int(width * height))

        var data = pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data, length: totalBytes)) else {
            fatalError("Can't create image provider")
        }

        guard let cgim = CGImage(width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: bytesPerRow,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        ) else {
            fatalError("Can't create image")
        }

        return NSImage(cgImage: cgim, size: NSSize(width: width, height: height))
    }
}
