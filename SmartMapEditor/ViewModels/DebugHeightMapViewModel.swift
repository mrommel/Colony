//
//  DebugHeightMapViewModel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 23.12.20.
//

import Cocoa
import SmartAILibrary
import SwiftUI

public struct Pixel {
    public var value: UInt32
    
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        
        self.value = 0
        
        self.red = r
        self.green = b
        self.blue = g
        self.alpha = a
    }
    
    init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        self.value = 0
        
        self.red = UInt8(r * 255.0)
        self.green = UInt8(g * 255.0)
        self.blue = UInt8(b * 255.0)
        self.alpha = UInt8(a * 255.0)
    }

    public var red: UInt8 {
        get {
            return UInt8(value & 0xFF)
        } set {
            value = UInt32(newValue) | (value & 0xFFFFFF00)
        }
    }

    public var green: UInt8 {
        get {
            return UInt8((value >> 8) & 0xFF)
        } set {
            value = (UInt32(newValue) << 8) | (value & 0xFFFF00FF)
        }
    }

    public var blue: UInt8 {
        get {
            return UInt8((value >> 16) & 0xFF)
        } set {
            value = (UInt32(newValue) << 16) | (value & 0xFF00FFFF)
        }
    }

    public var alpha: UInt8 {
        get {
            return UInt8((value >> 24) & 0xFF)
        } set {
            value = (UInt32(newValue) << 24) | (value & 0x00FFFFFF)
        }
    }
}

extension NSColor {
    
    func toColor(_ color: NSColor, percentage: CGFloat) -> NSColor {
        let percentage = max(min(percentage, 100), 0) / 100
        switch percentage {
        case 0: return self
        case 1: return color
        default:
            var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
            
            self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
            color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

            return NSColor(red: CGFloat(r1 + (r2 - r1) * percentage),
                           green: CGFloat(g1 + (g2 - g1) * percentage),
                           blue: CGFloat(b1 + (b2 - b1) * percentage),
                           alpha: CGFloat(a1 + (a2 - a1) * percentage))
        }
    }
}

class DebugHeightMapViewModel: ObservableObject {

    typealias ClosedHandler = () -> Void

    @Published
    var selectedOctavesIndex: Int = 4
    let octaves = ["1", "2", "4", "6", "8", "10", "12", "16", "32"]

    @Published
    var zoom: Double

    @Published
    var persistence: Double

    @Published
    var image: NSImage

    private let mapSize: MapSize
    var closed: ClosedHandler? = nil

    init(size: MapSize) {

        self.selectedOctavesIndex = 4 // "8"
        self.zoom = 1.0
        self.persistence = 1.0

        self.mapSize = size
        
        self.image = NSImage(size: NSSize(width: mapSize.width() * 4, height: mapSize.height() * 4))
        
        let heightMap: HeightMap = HeightMap(width: mapSize.width(), height: mapSize.height())
        heightMap.generate(withOctaves: Int(self.octaves[self.selectedOctavesIndex]) ?? 8, zoom: self.zoom, andPersistence: self.persistence)
        heightMap.normalize()
        
        self.renderImage(from: heightMap)
    }
    
    func octavesChanged(_ newValue: Int) {
        
        self.selectedOctavesIndex = newValue
    }
    
    func renderImage(from heightMap: HeightMap) {

        // Redraw image for correct pixel format
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        var bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.premultipliedLast.rawValue & CGBitmapInfo.alphaInfoMask.rawValue

        let width = Int(self.image.size.width)
        let height = Int(self.image.size.height)
        let bytesPerRow = width * 4

        let imageData = UnsafeMutablePointer<Pixel>.allocate(capacity: width * height)
        
        let pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
        
        let colorGreen = NSColor.green
        let colorBlue = NSColor.blue

        for y in 0..<height {
            for x in 0..<width {
                let index = y * width + x
                
                let percentage: CGFloat = CGFloat((heightMap[x / 4, y / 4] ?? 0.0) * 100.0)

                let color = colorBlue.toColor(colorGreen, percentage: percentage)
                let pixel = Pixel(r: color.redComponent, g: color.greenComponent, b: color.blueComponent, a: color.alphaComponent)
                
                pixels[index] = pixel
            }
        }

        guard let context = CGContext(
            data: pixels.baseAddress,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo,
            releaseCallback: nil,
            releaseInfo: nil
        ) else { return }

        guard let newCGImage = context.makeImage() else { return }
        self.image = NSImage(cgImage: newCGImage, size: NSSize(width: mapSize.width() * 4, height: mapSize.height() * 4))
    }
    
    func update() {

        print("selectedOctavesIndex => \(self.selectedOctavesIndex)")
        let octavesVal = Int(self.octaves[self.selectedOctavesIndex]) ?? 8
        
        print("update with \(octavesVal) octaves")
        
        let heightMap: HeightMap = HeightMap(width: mapSize.width(), height: mapSize.height())
        heightMap.generate(withOctaves: octavesVal, zoom: self.zoom, andPersistence: self.persistence)
        heightMap.normalize()
        
        self.renderImage(from: heightMap)
    }

    func cancel() {

        print("cancel")
        self.closed?()
    }
}
