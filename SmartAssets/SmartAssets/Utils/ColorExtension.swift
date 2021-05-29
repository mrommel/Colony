//
//  ColorExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 10.03.21.
//

import Foundation
import SwiftUI

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
    
    public struct Terrain {
    
        public static var ocean: TypeColor = TypeColor(hex: "#3f607f")!
        public static var shore: TypeColor = TypeColor(hex: "#5c80a2")!
        public static var plains: TypeColor = TypeColor(hex: "#77753c")!
        public static var grass: TypeColor = TypeColor(hex: "#869655")!
        public static var desert: TypeColor = TypeColor(hex: "#e2c170")!
        public static var tundra: TypeColor = TypeColor(hex: "#696c4d")!
        public static var snow: TypeColor = TypeColor(hex: "#d1e4f2")!
        
        public static var mountains: TypeColor = TypeColor(hex: "#b69856")!
        
        public static var background: TypeColor = TypeColor(hex: "#ad8a66")!
        
        public static var pergament: TypeColor = TypeColor(hex: "#ddbf80")!
    }
    
    public struct UI {
        
        public static var veryDarkBlue: TypeColor = TypeColor(hex: "#16344f")!
        public static var midnight: TypeColor = TypeColor(hex: "#01223b")!
        public static var nileBlue: TypeColor = TypeColor(hex: "#172d4d")!
    }
    
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

extension TypeColor {
    
    private func makeColor(componentDelta: CGFloat) -> TypeColor {
        
        var red: CGFloat = 0
        var blue: CGFloat = 0
        var green: CGFloat = 0
        var alpha: CGFloat = 0
        
        // Extract r,g,b,a components from the
        // current UIColor
        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )
        
        // Create a new UIColor modifying each component
        // by componentDelta, making the new UIColor either
        // lighter or darker.
        return TypeColor(
            red: add(componentDelta, toComponent: red),
            green: add(componentDelta, toComponent: green),
            blue: add(componentDelta, toComponent: blue),
            alpha: alpha
        )
    }
}

extension TypeColor {
    
    // Add value to component ensuring the result is
    // between 0 and 1
    private func add(_ value: CGFloat, toComponent: CGFloat) -> CGFloat {
        
        return max(0, min(1, toComponent + value))
    }
}

extension TypeColor {
    
    public func lighter(componentDelta: CGFloat = 0.1) -> TypeColor {
        
        return makeColor(componentDelta: componentDelta)
    }
    
    public func darker(componentDelta: CGFloat = 0.1) -> TypeColor {
        
        return makeColor(componentDelta: -1 * componentDelta)
    }
}
