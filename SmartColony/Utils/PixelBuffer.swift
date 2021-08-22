//
//  PixelBuffer.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit

struct PixelData {
    
    var alpha: UInt8 = 255
    var red: UInt8
    var green: UInt8
    var blue: UInt8

    init(color: UIColor) {

        let rgba = color.rgba

        self.alpha = UInt8(rgba.alpha * 255)
        self.red = UInt8(rgba.red * 255)
        self.green = UInt8(rgba.green * 255)
        self.blue = UInt8(rgba.blue * 255)
    }
}

struct PixelBuffer {

    var pixels: [PixelData]
    var width: Int
    var height: Int

    init?(image: UIImage) {

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

        guard let imageContext = CGContext(
                data: imageData,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
        ) else {
            return nil
        }
        imageContext.draw(cgImage, in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        pixels = Array(UnsafeBufferPointer(start: imageData, count: self.width * self.height))
    }

    init(width: Int, height: Int, color: UIColor) {
        self.width = width
        self.height = height

        self.pixels = Array(repeating: PixelData(color: color), count: self.width * self.height)
    }

    mutating func set(color: UIColor, at index: Int) {
        self.pixels[index] = PixelData(color: color)
    }

    mutating func set(color: UIColor, x: Int, y: Int) {
        let index = y * self.width + x

        self.set(color: color, at: index)
    }

    func toUIImage() -> UIImage? {
        return PixelBuffer.imageFromARGB32Bitmap(pixels: self.pixels, width: self.width, height: self.height)
    }

    // MARK: private methods

    private static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private static let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

    private static func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage {

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

        return UIImage(cgImage: cgim)
    }
}
