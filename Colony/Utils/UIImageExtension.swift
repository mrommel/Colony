//
//  UIImageExtension.swift
//  Colony
//
//  Created by Michael Rommel on 25.06.19.
//  Copyright © 2019 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit

public struct PixelData {
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

class UIImageExtension {
    
    private static let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private static let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    public static func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage {
        
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



