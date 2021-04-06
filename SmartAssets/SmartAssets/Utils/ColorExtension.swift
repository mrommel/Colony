//
//  ColorExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.03.21.
//

import Foundation

#if os(macOS)
    import AppKit
    public typealias TypeColor = NSColor
#else
    import UIKit
    public typealias TypeColor = UIColor
#endif

extension TypeColor {
    
    // https://civilization.fandom.com/wiki/Jersey_System_(Civ6)
    public static var geraldine: TypeColor = TypeColor(hex: "#e57574")! // Pink
    public static var venetianRed: TypeColor = TypeColor(hex: "#ca1415")! // Red
    public static var sangria: TypeColor = TypeColor(hex: "#780001")! // Dark Red
    public static var supernova: TypeColor = TypeColor(hex: "#ffb23c")! // Light Orange
    public static var pumpkin: TypeColor = TypeColor(hex: "#ff8112")! // Orange
    public static var saddleBrown: TypeColor = TypeColor(hex: "#783d02")! // Brown
    public static var witchHaze: TypeColor = TypeColor(hex: "#eae19d")! // Light Yellow
    public static var schoolBusYellow: TypeColor = TypeColor(hex: "#f7d801")! // Yellow
    public static var olive: TypeColor = TypeColor(hex: "#867202")! // Olive
    public static var lightGreen: TypeColor = TypeColor(hex: "#79e077")! // Light Green
    public static var kellyGreen: TypeColor = TypeColor(hex: "#61bf22")! // Green
    public static var crusoe: TypeColor = TypeColor(hex: "#156c30")! // Dark Green
    public static var turquoiseBlue: TypeColor = TypeColor(hex: "#7dece3")! // Cyan
    public static var caribbeanGreen: TypeColor = TypeColor(hex: "#00c09b")! // Turquoise
    public static var sherpaBlue: TypeColor = TypeColor(hex: "#014f51")! // Teal
    public static var cornflowerBlue: TypeColor = TypeColor(hex: "#74a3f3")! // Light Blue
    public static var navyBlue: TypeColor = TypeColor(hex: "#004fce")! // Blue
    public static var saphire: TypeColor = TypeColor(hex: "#012a6c")! // Dark Blue
    public static var bilobaFlower: TypeColor = TypeColor(hex: "#b780e6")! // Light Purple
    public static var darkViolet: TypeColor = TypeColor(hex: "#6d00cd")! // Purple
    public static var purple: TypeColor = TypeColor(hex: "#370065")! // Dark Purple
    public static var violet: TypeColor = TypeColor(hex: "#ff99ff")! // Light Magenta
    public static var fuchsia: TypeColor = TypeColor(hex: "#ff00ff")! // Magenta
    public static var magenta: TypeColor = TypeColor(hex: "#750073")! // Dark Magenta
    public static var snow: TypeColor = TypeColor(hex: "#f9f9f9")! // White
    public static var silverFoil: TypeColor = TypeColor(hex: "#aeaeae")! // Gray
    public static var matterhornGray: TypeColor = TypeColor(hex: "#535353")! // Dark Gray
    public static var nero: TypeColor = TypeColor(hex: "#181818")! // Black
    
    internal convenience init?(hex: String) {
        let hex = String(hex.description)
        
        guard let rgb = TypeColor.rgbValue(from: hex) else {
            return nil
        }
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    private static func rgbValue(from hex: String) -> UInt64? {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return rgbValue
    }
}
