//
//  Pixel.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 26.12.20.
//

import Foundation
import Cocoa

// this must be a struct - because we want the thin memory structure for image processing
public struct Pixel: Codable {
    
    public var value: UInt32
    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        
        self.value = 0
        
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        
        self.value = 0
        
        self.red = UInt8(min(max(red, 0.0), 1.0) * 255.0)
        self.green = UInt8(min(max(green, 0.0), 1.0) * 255.0)
        self.blue = UInt8(min(max(blue, 0.0), 1.0) * 255.0)
        self.alpha = UInt8(min(max(alpha, 0.0), 1.0) * 255.0)
    }

    public var red: UInt8 {
        
        get {
            return UInt8(self.value & 0xFF)
        } set {
            self.value = UInt32(newValue) | (self.value & 0xFFFFFF00)
        }
    }

    public var green: UInt8 {
        
        get {
            return UInt8((value >> 8) & 0xFF)
        } set {
            self.value = (UInt32(newValue) << 8) | (self.value & 0xFFFF00FF)
        }
    }

    public var blue: UInt8 {
        get {
            return UInt8((self.value >> 16) & 0xFF)
        } set {
            self.value = (UInt32(newValue) << 16) | (self.value & 0xFF00FFFF)
        }
    }

    public var alpha: UInt8 {
        get {
            return UInt8((self.value >> 24) & 0xFF)
        } set {
            self.value = (UInt32(newValue) << 24) | (self.value & 0x00FFFFFF)
        }
    }
    
    public func color() -> NSColor {
        
        return NSColor(
            red: CGFloat(self.red) / 255.0,
            green: CGFloat(self.green) / 255.0,
            blue: CGFloat(self.blue) / 255.0,
            alpha: CGFloat(self.alpha) / 255.0
        )
    }
    
    public func hexRGB() -> String {
        
        return String(format: "%02X", self.red) + String(format: "%02X", self.green) + String(format: "%02X", self.blue)
    }
    
    public func hexRGBA() -> String {
        
        return String(format: "%02X", self.red) + String(format: "%02X", self.green) + String(format: "%02X", self.blue) +
            String(format: "%02X", self.alpha)
    }
}

extension Pixel: Equatable {
    
    public static func == (lhs: Pixel, rhs: Pixel) -> Bool {
        
        return lhs.value == rhs.value
    }
}

extension Pixel: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        return "Pixel(#\(hexRGBA()))"
    }
}
