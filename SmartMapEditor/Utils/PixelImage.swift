//
//  PixelImage.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.12.20.
//

import SmartAILibrary
import Cocoa

public class PixelImage: Array2D<Pixel> {
    
    func image() -> NSImage? {
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        
        let bytesPerRow = self.width * 4
        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: self.width * self.height)
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: self.width * self.height)
        
        // fill from array
        for y in 0..<self.height {
            for x in 0..<self.width {
                let index = y * self.width + x
                
                if let value = self[x, y] {
                    pixels[index] = Pixel(r: value.red, g: value.green, b: value.blue, a: value.alpha)
                } else {
                    pixels[index] = Pixel(r: UInt8(255), g: 0, b: 0, a: 255)
                }
            }
        }
        
        guard let context = CGContext(
            data: pixels.baseAddress,
            width: self.width,
            height: self.height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else { return nil }

        guard let newCGImage = context.makeImage() else { return nil }
        return NSImage(cgImage: newCGImage, size: NSSize(width: self.width, height: self.height))
    }
}

extension PixelImage {

    convenience init(from heightMap: HeightMap) {

        self.init(width: heightMap.width * 4, height: heightMap.height * 4)

        let colorGreen = NSColor.green
        let colorBlue = NSColor.blue

        for y in 0..<self.height {
            for x in 0..<self.width {

                let percentage: CGFloat = CGFloat((heightMap[x / 4, y / 4] ?? 0.0) * 100.0)

                let color = colorBlue.toColor(colorGreen, percentage: percentage)
                let pixel = Pixel(r: color.redComponent, g: color.greenComponent, b: color.blueComponent, a: color.alphaComponent)

                self[x, y] = pixel
            }
        }
    }
}
