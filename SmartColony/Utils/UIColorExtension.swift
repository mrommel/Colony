//
//  UIColorExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 04.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIColor {

    /**
     Creates an UIColor from HEX String in "#363636" format
     
     - parameter hexString: HEX String in "#363636" format
     - returns: UIColor from HexString
     */
    convenience init(hexString: String) {

        var hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString as String)

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let redValue = Int(color >> 16) & mask
        let greenValue = Int(color >> 8) & mask
        let blueValue = Int(color) & mask

        let red = CGFloat(redValue) / 255.0
        let green = CGFloat(greenValue) / 255.0
        let blue = CGFloat(blueValue) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    /**
     Creates an UIColor Object based on provided RGB value in integer
     - parameter red:   Red Value in integer (0-255)
     - parameter green: Green Value in integer (0-255)
     - parameter blue:  Blue Value in integer (0-255)
     - returns: UIColor with specified RGB values
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

public extension UIColor {

    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (hue, saturation, b, alpha)
    }
}

public extension UIColor {

    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hex string: String, alpha: CGFloat = 1.0) {
        var hex = string.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }

        if hex.count < 3 {
            hex = "\(hex)\(hex)\(hex)"
        }

        if hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil {
            
            if hex.count == 3 {

                let startIndex = hex.index(hex.startIndex, offsetBy: 1)
                let endIndex = hex.index(hex.startIndex, offsetBy: 2)

                let redHex = String(hex[..<startIndex])
                let greenHex = String(hex[startIndex..<endIndex])
                let blueHex = String(hex[endIndex...])

                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }

            let startIndex = hex.index(hex.startIndex, offsetBy: 2)
            let endIndex = hex.index(hex.startIndex, offsetBy: 4)
            let redHex = String(hex[..<startIndex])
            let greenHex = String(hex[startIndex..<endIndex])
            let blueHex = String(hex[endIndex...])

            var redInt: UInt64 = 0
            var greenInt: UInt64 = 0
            var blueInt: UInt64 = 0

            Scanner(string: redHex).scanHexInt64(&redInt)
            Scanner(string: greenHex).scanHexInt64(&greenInt)
            Scanner(string: blueHex).scanHexInt64(&blueInt)

            self.init(red: CGFloat(redInt) / 255.0,
                green: CGFloat(greenInt) / 255.0,
                blue: CGFloat(blueInt) / 255.0,
                alpha: CGFloat(alpha))
            
        } else {
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }

    var hexValue: String {
        var color = self

        if color.cgColor.numberOfComponents < 4 {
            let components = color.cgColor.components!
            color = UIColor(red: components[0], green: components[0], blue: components[0], alpha: components[1])
        }
        if color.cgColor.colorSpace!.model != .rgb {
            return "#FFFFFF"
        }
        let components = color.cgColor.components!
        return String(format: "#%02X%02X%02X", Int(components[0] * 255.0), Int(components[1] * 255.0), Int(components[2] * 255.0))
    }
}

struct Color16 {

    let value: UInt16
    let alpha: CGFloat = 0 // 0..1

    init(value: UInt16) {
        self.value = value
    }

    init(red: UInt8, green: UInt8, blue: UInt8) {

        let fRed: CGFloat = CGFloat(red) / 255
        let fGreen: CGFloat = CGFloat(green) / 255
        let fBlue: CGFloat = CGFloat(blue) / 255

        self.value = UInt16(fRed * 31 + 0.5) << 11 + UInt16(fGreen * 63 + 0.5) << 5 + UInt16(fBlue * 31 + 0.5)
    }
    
    init(color: UIColor) {
        
        let (red, green, blue, _) = color.rgba
        
        self.init(red: UInt8(red), green: UInt8(green), blue: UInt8(blue))
    }

    //var

    var red: UInt8 {
        let red5 = (value >> 11) & 31 // 5 bits
        let red8 = CGFloat(red5) * 255 / 31 + 0.5
        return UInt8(red8)
    }

    var green: UInt8 {
        let green6 = (value >> 5) & 63 // 6 bits
        let green8 = CGFloat(green6) * 255 / 63 + 0.5
        return UInt8(green8)
    }

    var blue: UInt8 {
        let blue5 = value & 31 // 5 bits
        let blue8 = CGFloat(blue5) * 255 / 31 + 0.5
        return UInt8(blue8)
    }

    static func lerp(min: Color16, max: Color16, value: CGFloat) -> Color16 {

        let invValue = 1.0 - value

        let red = CGFloat(min.red) * value + CGFloat(max.red) * invValue
        let green = CGFloat(min.green) * value + CGFloat(max.green) * invValue
        let blue = CGFloat(min.blue) * value + CGFloat(max.blue) * invValue

        return Color16(red: UInt8(red), green: UInt8(green), blue: UInt8(blue))
    }
}

struct Color32 {

    let red: UInt8
    let green: UInt8
    let blue: UInt8
    let alpha: UInt8

    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(color: Color16) {
        self.red = color.red
        self.green = color.green
        self.blue = color.blue
        self.alpha = UInt8(color.alpha * 255)
    }
}
