//
//  UIImageExtension.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit

struct PixelData {
    var a: UInt8 = 255
    var r: UInt8
    var g: UInt8
    var b: UInt8

    init(color: UIColor) {

        let rgba = color.rgba

        self.a = UInt8(rgba.alpha * 255)
        self.r = UInt8(rgba.red * 255)
        self.g = UInt8(rgba.green * 255)
        self.b = UInt8(rgba.blue * 255)
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

        guard let imageContext = CGContext(data: imageData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo) else {
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

extension UIImage {

    func resizeRasterizedTo(targetSize: CGSize) -> UIImage? {

        let size = self.size

        let widthRatio = targetSize.width / self.size.width
        let heightRatio = targetSize.height / self.size.height

        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0)
        guard let scaledContext = UIGraphicsGetCurrentContext() else {
            fatalError("Can't create graphics context")
        }
        scaledContext.interpolationQuality = .none

        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    // https://stackoverflow.com/questions/20021478/add-transparent-space-around-a-uiimage
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right, height:
                    self.size.height + insets.top + insets.bottom), false, self.scale)
        //let context = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}
