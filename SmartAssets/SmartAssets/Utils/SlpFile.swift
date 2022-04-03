//
//  SlpFile.swift
//  SmartAssets
//
//  Created by Michael Rommel on 22.02.22.
//

import Foundation
import BinarySwift
import AppKit
import SmartAILibrary

extension String {

    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}

public enum SlpPlayer {

    case defaultBlue
    case defaultRed
    case defaultGreen
    case defaultYellow
    case defaultOrange
    case defaultCyan
    case defaultMagenta
    case defaultGray

    case customBlue
    case customRed
    case customYellow
    case customBrown
    case customOrange
    case customGreen
    case customGray
    case customCyan

    func value() -> Int {

        switch self {

        case .defaultBlue: return 1
        case .defaultRed: return 2
        case .defaultGreen: return 3
        case .defaultYellow: return 4
        case .defaultOrange: return 5
        case .defaultCyan: return 6
        case .defaultMagenta: return 7
        case .defaultGray: return 8

        case .customBlue: return 1
        case .customRed: return 2
        case .customYellow: return 3
        case .customBrown: return 4
        case .customOrange: return 5
        case .customGreen: return 6
        case .customGray: return 7
        case .customCyan: return 8
        }
    }
}

public class SlpPaletteReader {

    public init() {
    }

    public func load(from url: URL?) -> SlpPalette? {

        if let paletteUrl = url {

            do {
                let binaryData = try Data(contentsOf: paletteUrl, options: .mappedIfSafe)

                return self.load(from: binaryData)
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }

    // https://github.com/handsomematt/OpenEmpires/blob/master/GenieLib/SLPFile.cs
    private func load(from data: Data) -> SlpPalette? {

        guard let string = String(data: data, encoding: .utf8) else {
            fatalError("cant get string from data")
        }

        let stringList = string.lines

        do {
            return try SlpPalette(stringList: stringList)
        } catch {
            print("error while reading SlpPalette: \(error)")
        }

        return nil
    }
}

// https://github.com/genie-js/jascpal/blob/master/src/Palette.js
// swiftlint:disable colon
public class SlpPalette {

    public static let `default`: SlpPalette = SlpPalette(
        header: "JASC-PAL\n",
        version: 0100,
        numColors: 256,
        colors: [
            TypeColor(red:   0 / 255.0, green:   0 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  74 / 255.0, blue: 161 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  97 / 255.0, blue: 155 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  74 / 255.0, blue: 187 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  84 / 255.0, blue: 176 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  90 / 255.0, blue: 184 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 110 / 255.0, blue: 176 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 110 / 255.0, blue: 187 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  84 / 255.0, blue: 197 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  98 / 255.0, blue: 210 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:   0 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:  47 / 255.0, green:  47 / 255.0, blue:  47 / 255.0, alpha: 1.0),
            TypeColor(red:  67 / 255.0, green:  67 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red:  87 / 255.0, green:  87 / 255.0, blue:  87 / 255.0, alpha: 1.0),
            TypeColor(red:  37 / 255.0, green:  16 / 255.0, blue:   6 / 255.0, alpha: 1.0),
            TypeColor(red:  47 / 255.0, green:  26 / 255.0, blue:  17 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:   0 / 255.0, blue:  82 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  21 / 255.0, blue: 130 / 255.0, alpha: 1.0),
            TypeColor(red:  19 / 255.0, green:  49 / 255.0, blue: 161 / 255.0, alpha: 1.0),
            TypeColor(red:  48 / 255.0, green:  93 / 255.0, blue: 182 / 255.0, alpha: 1.0),
            TypeColor(red:  74 / 255.0, green: 121 / 255.0, blue: 208 / 255.0, alpha: 1.0),
            TypeColor(red: 110 / 255.0, green: 166 / 255.0, blue: 235 / 255.0, alpha: 1.0),
            TypeColor(red: 151 / 255.0, green: 206 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 205 / 255.0, green: 250 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red:  64 / 255.0, green:  43 / 255.0, blue:  23 / 255.0, alpha: 1.0),
            TypeColor(red:  67 / 255.0, green:  51 / 255.0, blue:  27 / 255.0, alpha: 1.0),
            TypeColor(red:  70 / 255.0, green:  32 / 255.0, blue:   6 / 255.0, alpha: 1.0),
            TypeColor(red:  75 / 255.0, green:  57 / 255.0, blue:  42 / 255.0, alpha: 1.0),
            TypeColor(red:  84 / 255.0, green:  64 / 255.0, blue:  43 / 255.0, alpha: 1.0),
            TypeColor(red:  87 / 255.0, green:  69 / 255.0, blue:  37 / 255.0, alpha: 1.0),
            TypeColor(red:  87 / 255.0, green:  57 / 255.0, blue:  27 / 255.0, alpha: 1.0),
            TypeColor(red:  94 / 255.0, green:  74 / 255.0, blue:  48 / 255.0, alpha: 1.0),
            TypeColor(red:  65 / 255.0, green:   0 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 105 / 255.0, green:  11 / 255.0, blue:  0 / 255.0, alpha: 1.0),
            TypeColor(red: 160 / 255.0, green:  21 / 255.0, blue:  0 / 255.0, alpha: 1.0),
            TypeColor(red: 230 / 255.0, green:  11 / 255.0, blue:  0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green:   0 / 255.0, blue:  0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 160 / 255.0, blue: 160 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 220 / 255.0, blue: 220 / 255.0, alpha: 1.0),
            TypeColor(red:  97 / 255.0, green:  77 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red: 103 / 255.0, green:  58 / 255.0, blue:  21 / 255.0, alpha: 1.0),
            TypeColor(red: 113 / 255.0, green:  75 / 255.0, blue:  51 / 255.0, alpha: 1.0),
            TypeColor(red: 113 / 255.0, green:  75 / 255.0, blue:  13 / 255.0, alpha: 1.0),
            TypeColor(red: 115 / 255.0, green: 105 / 255.0, blue:  84 / 255.0, alpha: 1.0),
            TypeColor(red: 125 / 255.0, green:  97 / 255.0, blue:  72 / 255.0, alpha: 1.0),
            TypeColor(red: 125 / 255.0, green:  74 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 129 / 255.0, green: 116 / 255.0, blue:  95 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:   0 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:   7 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  32 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  59 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  87 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 114 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 141 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 169 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 134 / 255.0, green: 126 / 255.0, blue: 118 / 255.0, alpha: 1.0),
            TypeColor(red: 135 / 255.0, green:  64 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 136 / 255.0, green: 108 / 255.0, blue:  79 / 255.0, alpha: 1.0),
            TypeColor(red: 144 / 255.0, green: 100 / 255.0, blue:  12 / 255.0, alpha: 1.0),
            TypeColor(red: 146 / 255.0, green: 125 / 255.0, blue: 105 / 255.0, alpha: 1.0),
            TypeColor(red: 153 / 255.0, green: 106 / 255.0, blue:  55 / 255.0, alpha: 1.0),
            TypeColor(red: 159 / 255.0, green: 121 / 255.0, blue:  88 / 255.0, alpha: 1.0),
            TypeColor(red: 166 / 255.0, green:  74 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:  80 / 255.0, green:  51 / 255.0, blue:  26 / 255.0, alpha: 1.0),
            TypeColor(red: 140 / 255.0, green:  78 / 255.0, blue:   9 / 255.0, alpha: 1.0),
            TypeColor(red: 191 / 255.0, green: 123 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 199 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 247 / 255.0, blue:  37 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue:  97 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue: 166 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue: 227 / 255.0, alpha: 1.0),
            TypeColor(red: 167 / 255.0, green: 135 / 255.0, blue: 102 / 255.0, alpha: 1.0),
            TypeColor(red: 172 / 255.0, green: 144 / 255.0, blue: 115 / 255.0, alpha: 1.0),
            TypeColor(red: 175 / 255.0, green: 126 / 255.0, blue:  36 / 255.0, alpha: 1.0),
            TypeColor(red: 175 / 255.0, green: 151 / 255.0, blue: 128 / 255.0, alpha: 1.0),
            TypeColor(red: 185 / 255.0, green: 151 / 255.0, blue: 146 / 255.0, alpha: 1.0),
            TypeColor(red: 186 / 255.0, green: 166 / 255.0, blue: 135 / 255.0, alpha: 1.0),
            TypeColor(red: 187 / 255.0, green:  84 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 187 / 255.0, green: 156 / 255.0, blue: 125 / 255.0, alpha: 1.0),
            TypeColor(red: 110 / 255.0, green:  23 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 150 / 255.0, green:  36 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 210 / 255.0, green:  55 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green:  80 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 130 / 255.0, blue:   1 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 180 / 255.0, blue:  21 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 210 / 255.0, blue:  75 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 235 / 255.0, blue: 160 / 255.0, alpha: 1.0),
            TypeColor(red: 189 / 255.0, green: 150 / 255.0, blue: 111 / 255.0, alpha: 1.0),
            TypeColor(red: 191 / 255.0, green: 169 / 255.0, blue: 115 / 255.0, alpha: 1.0),
            TypeColor(red: 195 / 255.0, green: 174 / 255.0, blue: 156 / 255.0, alpha: 1.0),
            TypeColor(red: 196 / 255.0, green: 170 / 255.0, blue: 146 / 255.0, alpha: 1.0),
            TypeColor(red: 196 / 255.0, green: 128 / 255.0, blue:  88 / 255.0, alpha: 1.0),
            TypeColor(red: 196 / 255.0, green: 166 / 255.0, blue: 135 / 255.0, alpha: 1.0),
            TypeColor(red: 197 / 255.0, green: 187 / 255.0, blue: 176 / 255.0, alpha: 1.0),
            TypeColor(red: 204 / 255.0, green: 160 / 255.0, blue:  36 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  16 / 255.0, blue:  16 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  37 / 255.0, blue:  41 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  80 / 255.0, blue:  80 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 120 / 255.0, blue: 115 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 172 / 255.0, blue: 150 / 255.0, alpha: 1.0),
            TypeColor(red:  38 / 255.0, green: 223 / 255.0, blue: 170 / 255.0, alpha: 1.0),
            TypeColor(red: 109 / 255.0, green: 252 / 255.0, blue: 191 / 255.0, alpha: 1.0),
            TypeColor(red: 186 / 255.0, green: 255 / 255.0, blue: 222 / 255.0, alpha: 1.0),
            TypeColor(red: 206 / 255.0, green: 169 / 255.0, blue: 133 / 255.0, alpha: 1.0),
            TypeColor(red: 207 / 255.0, green: 105 / 255.0, blue:  12 / 255.0, alpha: 1.0),
            TypeColor(red: 207 / 255.0, green: 176 / 255.0, blue: 156 / 255.0, alpha: 1.0),
            TypeColor(red: 208 / 255.0, green: 155 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red: 215 / 255.0, green: 186 / 255.0, blue: 155 / 255.0, alpha: 1.0),
            TypeColor(red: 216 / 255.0, green: 162 / 255.0, blue: 121 / 255.0, alpha: 1.0),
            TypeColor(red: 217 / 255.0, green: 114 / 255.0, blue:  24 / 255.0, alpha: 1.0),
            TypeColor(red: 217 / 255.0, green: 187 / 255.0, blue: 166 / 255.0, alpha: 1.0),
            TypeColor(red:  47 / 255.0, green:   0 / 255.0, blue:  46 / 255.0, alpha: 1.0),
            TypeColor(red:  79 / 255.0, green:   0 / 255.0, blue:  75 / 255.0, alpha: 1.0),
            TypeColor(red: 133 / 255.0, green:  12 / 255.0, blue: 121 / 255.0, alpha: 1.0),
            TypeColor(red: 170 / 255.0, green:  47 / 255.0, blue: 155 / 255.0, alpha: 1.0),
            TypeColor(red: 211 / 255.0, green:  58 / 255.0, blue: 201 / 255.0, alpha: 1.0),
            TypeColor(red: 241 / 255.0, green: 108 / 255.0, blue: 232 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 169 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 210 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 218 / 255.0, green: 156 / 255.0, blue: 105 / 255.0, alpha: 1.0),
            TypeColor(red: 222 / 255.0, green: 177 / 255.0, blue: 136 / 255.0, alpha: 1.0),
            TypeColor(red: 225 / 255.0, green: 177 / 255.0, blue:  90 / 255.0, alpha: 1.0),
            TypeColor(red: 226 / 255.0, green: 195 / 255.0, blue: 170 / 255.0, alpha: 1.0),
            TypeColor(red: 232 / 255.0, green: 180 / 255.0, blue: 120 / 255.0, alpha: 1.0),
            TypeColor(red: 235 / 255.0, green: 202 / 255.0, blue: 181 / 255.0, alpha: 1.0),
            TypeColor(red: 235 / 255.0, green: 216 / 255.0, blue: 190 / 255.0, alpha: 1.0),
            TypeColor(red: 237 / 255.0, green: 199 / 255.0, blue: 165 / 255.0, alpha: 1.0),
            TypeColor(red:  28 / 255.0, green:  28 / 255.0, blue:  28 / 255.0, alpha: 1.0),
            TypeColor(red:  67 / 255.0, green:  67 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red: 106 / 255.0, green: 106 / 255.0, blue: 106 / 255.0, alpha: 1.0),
            TypeColor(red: 145 / 255.0, green: 145 / 255.0, blue: 145 / 255.0, alpha: 1.0),
            TypeColor(red: 185 / 255.0, green: 185 / 255.0, blue: 185 / 255.0, alpha: 1.0),
            TypeColor(red: 223 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 247 / 255.0, green: 211 / 255.0, blue: 191 / 255.0, alpha: 1.0),
            TypeColor(red: 248 / 255.0, green: 201 / 255.0, blue: 138 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 206 / 255.0, blue: 157 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 225 / 255.0, blue: 201 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 238 / 255.0, blue: 217 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 226 / 255.0, blue: 161 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 243 / 255.0, blue: 220 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue: 243 / 255.0, alpha: 1.0),
            TypeColor(red:  21 / 255.0, green:  21 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:  37 / 255.0, green:  37 / 255.0, blue:  17 / 255.0, alpha: 1.0),
            TypeColor(red:  27 / 255.0, green:  47 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:  47 / 255.0, green:  57 / 255.0, blue:  17 / 255.0, alpha: 1.0),
            TypeColor(red:  67 / 255.0, green:  77 / 255.0, blue:   7 / 255.0, alpha: 1.0),
            TypeColor(red:  77 / 255.0, green:  77 / 255.0, blue:  47 / 255.0, alpha: 1.0),
            TypeColor(red:  44 / 255.0, green:  77 / 255.0, blue:   3 / 255.0, alpha: 1.0),
            TypeColor(red:  94 / 255.0, green:  84 / 255.0, blue:  53 / 255.0, alpha: 1.0),
            TypeColor(red:  95 / 255.0, green:  97 / 255.0, blue:  39 / 255.0, alpha: 1.0),
            TypeColor(red:  97 / 255.0, green:  97 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red:  67 / 255.0, green:  97 / 255.0, blue:  29 / 255.0, alpha: 1.0),
            TypeColor(red: 106 / 255.0, green: 115 / 255.0, blue:  57 / 255.0, alpha: 1.0),
            TypeColor(red: 116 / 255.0, green: 115 / 255.0, blue:  75 / 255.0, alpha: 1.0),
            TypeColor(red:  87 / 255.0, green: 116 / 255.0, blue:   7 / 255.0, alpha: 1.0),
            TypeColor(red: 118 / 255.0, green: 130 / 255.0, blue:  65 / 255.0, alpha: 1.0),
            TypeColor(red: 130 / 255.0, green: 136 / 255.0, blue:  77 / 255.0, alpha: 1.0),
            TypeColor(red: 138 / 255.0, green: 139 / 255.0, blue:  87 / 255.0, alpha: 1.0),
            TypeColor(red: 148 / 255.0, green: 155 / 255.0, blue: 100 / 255.0, alpha: 1.0),
            TypeColor(red: 156 / 255.0, green: 156 / 255.0, blue: 139 / 255.0, alpha: 1.0),
            TypeColor(red: 128 / 255.0, green: 157 / 255.0, blue:  84 / 255.0, alpha: 1.0),
            TypeColor(red: 149 / 255.0, green: 166 / 255.0, blue:  97 / 255.0, alpha: 1.0),
            TypeColor(red: 175 / 255.0, green: 165 / 255.0, blue: 106 / 255.0, alpha: 1.0),
            TypeColor(red: 176 / 255.0, green: 176 / 255.0, blue: 159 / 255.0, alpha: 1.0),
            TypeColor(red: 146 / 255.0, green: 176 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red: 194 / 255.0, green: 190 / 255.0, blue: 148 / 255.0, alpha: 1.0),
            TypeColor(red: 165 / 255.0, green: 196 / 255.0, blue: 108 / 255.0, alpha: 1.0),
            TypeColor(red: 166 / 255.0, green: 196 / 255.0, blue:  77 / 255.0, alpha: 1.0),
            TypeColor(red: 206 / 255.0, green: 187 / 255.0, blue: 128 / 255.0, alpha: 1.0),
            TypeColor(red: 206 / 255.0, green: 204 / 255.0, blue: 155 / 255.0, alpha: 1.0),
            TypeColor(red: 204 / 255.0, green: 217 / 255.0, blue:  77 / 255.0, alpha: 1.0),
            TypeColor(red: 221 / 255.0, green: 218 / 255.0, blue: 166 / 255.0, alpha: 1.0),
            TypeColor(red: 196 / 255.0, green: 226 / 255.0, blue: 116 / 255.0, alpha: 1.0),
            TypeColor(red: 247 / 255.0, green: 204 / 255.0, blue:  17 / 255.0, alpha: 1.0),
            TypeColor(red:   3 / 255.0, green:  28 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   7 / 255.0, green:  38 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   7 / 255.0, green:  47 / 255.0, blue:   7 / 255.0, alpha: 1.0),
            TypeColor(red:  19 / 255.0, green:  48 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:  27 / 255.0, green:  57 / 255.0, blue:  17 / 255.0, alpha: 1.0),
            TypeColor(red:  47 / 255.0, green:  57 / 255.0, blue:  47 / 255.0, alpha: 1.0),
            TypeColor(red:  28 / 255.0, green:  62 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:  14 / 255.0, green:  68 / 255.0, blue:  14 / 255.0, alpha: 1.0),
            TypeColor(red:  41 / 255.0, green:  69 / 255.0, blue:  28 / 255.0, alpha: 1.0),
            TypeColor(red:  33 / 255.0, green:  73 / 255.0, blue:  18 / 255.0, alpha: 1.0),
            TypeColor(red:  47 / 255.0, green:  87 / 255.0, blue:  47 / 255.0, alpha: 1.0),
            TypeColor(red:  77 / 255.0, green:  97 / 255.0, blue:  57 / 255.0, alpha: 1.0),
            TypeColor(red:  67 / 255.0, green:  97 / 255.0, blue:  67 / 255.0, alpha: 1.0),
            TypeColor(red:  87 / 255.0, green: 116 / 255.0, blue:  77 / 255.0, alpha: 1.0),
            TypeColor(red:  70 / 255.0, green: 119 / 255.0, blue:  48 / 255.0, alpha: 1.0),
            TypeColor(red:  85 / 255.0, green: 119 / 255.0, blue:  52 / 255.0, alpha: 1.0),
            TypeColor(red: 106 / 255.0, green: 136 / 255.0, blue:  97 / 255.0, alpha: 1.0),
            TypeColor(red: 196 / 255.0, green: 236 / 255.0, blue: 166 / 255.0, alpha: 1.0),
            TypeColor(red:  23 / 255.0, green:  53 / 255.0, blue:  33 / 255.0, alpha: 1.0),
            TypeColor(red:  43 / 255.0, green:  84 / 255.0, blue:  64 / 255.0, alpha: 1.0),
            TypeColor(red:  37 / 255.0, green: 116 / 255.0, blue:  57 / 255.0, alpha: 1.0),
            TypeColor(red:  23 / 255.0, green:  43 / 255.0, blue:  53 / 255.0, alpha: 1.0),
            TypeColor(red:   2 / 255.0, green:  33 / 255.0, blue:  53 / 255.0, alpha: 1.0),
            TypeColor(red:   2 / 255.0, green:  23 / 255.0, blue:  53 / 255.0, alpha: 1.0),
            TypeColor(red:  33 / 255.0, green:  64 / 255.0, blue:  64 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  34 / 255.0, blue:  97 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  51 / 255.0, blue: 115 / 255.0, alpha: 1.0),
            TypeColor(red:  43 / 255.0, green:  64 / 255.0, blue:  74 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  43 / 255.0, blue:  74 / 255.0, alpha: 1.0),
            TypeColor(red:   4 / 255.0, green:   6 / 255.0, blue:   9 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 123 / 255.0, blue: 189 / 255.0, alpha: 1.0),
            TypeColor(red:  64 / 255.0, green:  84 / 255.0, blue:  84 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 115 / 255.0, blue: 207 / 255.0, alpha: 1.0),
            TypeColor(red:  23 / 255.0, green:  23 / 255.0, blue:  74 / 255.0, alpha: 1.0),
            TypeColor(red:  12 / 255.0, green:  23 / 255.0, blue:  64 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:   0 / 255.0, blue:   2 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  64 / 255.0, blue: 125 / 255.0, alpha: 1.0),
            TypeColor(red:   2 / 255.0, green:  23 / 255.0, blue:  84 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 138 / 255.0, blue: 186 / 255.0, alpha: 1.0),
            TypeColor(red:  64 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 146 / 255.0, blue: 197 / 255.0, alpha: 1.0),
            TypeColor(red:  94 / 255.0, green: 105 / 255.0, blue: 105 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  74 / 255.0, blue: 125 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 125 / 255.0, blue: 207 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 120 / 255.0, blue: 227 / 255.0, alpha: 1.0),
            TypeColor(red:  84 / 255.0, green: 115 / 255.0, blue: 125 / 255.0, alpha: 1.0),
            TypeColor(red:  64 / 255.0, green: 105 / 255.0, blue: 125 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  64 / 255.0, blue: 146 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:  53 / 255.0, blue: 135 / 255.0, alpha: 1.0),
            TypeColor(red: 115 / 255.0, green: 156 / 255.0, blue: 156 / 255.0, alpha: 1.0),
            TypeColor(red:  84 / 255.0, green: 146 / 255.0, blue: 176 / 255.0, alpha: 1.0),
            TypeColor(red: 146 / 255.0, green: 176 / 255.0, blue: 187 / 255.0, alpha: 1.0),
            TypeColor(red: 207 / 255.0, green: 248 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 105 / 255.0, green: 166 / 255.0, blue: 197 / 255.0, alpha: 1.0),
            TypeColor(red: 125 / 255.0, green: 197 / 255.0, blue: 217 / 255.0, alpha: 1.0),
            TypeColor(red: 156 / 255.0, green: 197 / 255.0, blue: 217 / 255.0, alpha: 1.0),
            TypeColor(red: 109 / 255.0, green: 126 / 255.0, blue:  33 / 255.0, alpha: 1.0),
            TypeColor(red: 113 / 255.0, green: 153 / 255.0, blue:  36 / 255.0, alpha: 1.0),
            TypeColor(red:  21 / 255.0, green: 118 / 255.0, blue:  21 / 255.0, alpha: 1.0),
            TypeColor(red:  51 / 255.0, green: 151 / 255.0, blue:  39 / 255.0, alpha: 1.0),
            TypeColor(red:  70 / 255.0, green: 181 / 255.0, blue:  59 / 255.0, alpha: 1.0),
            TypeColor(red:  89 / 255.0, green: 223 / 255.0, blue:  89 / 255.0, alpha: 1.0),
            TypeColor(red: 131 / 255.0, green: 245 / 255.0, blue: 120 / 255.0, alpha: 1.0),
            TypeColor(red: 174 / 255.0, green: 255 / 255.0, blue: 174 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 255 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green:   0 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 213 / 255.0, blue:   0 / 255.0, alpha: 1.0),
            TypeColor(red: 226 / 255.0, green: 154 / 255.0, blue:  73 / 255.0, alpha: 1.0),
            TypeColor(red: 241 / 255.0, green: 164 / 255.0, blue:  82 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 171 / 255.0, blue:  88 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 197 / 255.0, blue: 113 / 255.0, alpha: 1.0),
            TypeColor(red:  85 / 255.0, green: 125 / 255.0, blue:  57 / 255.0, alpha: 1.0),
            TypeColor(red: 129 / 255.0, green: 151 / 255.0, blue:  49 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green:   0 / 255.0, blue: 255 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 139 / 255.0, blue: 210 / 255.0, alpha: 1.0),
            TypeColor(red:   0 / 255.0, green: 160 / 255.0, blue: 243 / 255.0, alpha: 1.0),
            TypeColor(red: 255 / 255.0, green: 255 / 255.0, blue: 255 / 255.0, alpha: 1.0)
        ]
    )

    public static func palette(named filename: String) -> SlpPalette? {

        let testBundle = Bundle(for: self)
        let path = testBundle.path(forResource: filename, ofType: "pal")
        let url = URL(fileURLWithPath: path!)

        guard let slpPalette = SlpPaletteReader().load(from: url) else {
            print("Could not load file")
            return nil
        }

        return slpPalette
    }

    public let header: String
    public let version: Int32
    public let numColors: Int32
    public let colors: [TypeColor]

    init(header: String, version: Int32, numColors: Int32, colors: [TypeColor]) {

        guard numColors == colors.count else {
            fatalError("number of colors does not match")
        }

        self.header = header
        self.version = version
        self.numColors = numColors
        self.colors = colors
    }

    init(stringList: [String]) throws {

        self.header = stringList[0]
        self.version = Int32(stringList[1]) ?? 0
        self.numColors = Int32(stringList[2]) ?? 0

        var tmpColors: [TypeColor] = []
        tmpColors.reserveCapacity(stringList.count - 3)
        for index in 3..<stringList.count {

            let line = stringList[index]
            let colorArr = line.split { $0 == " " }.map(String.init)

            guard 3 == colorArr.count else {
                fatalError("number of color parts does not match 3")
            }

            let redValue: CGFloat = CGFloat(Int(colorArr[0])!) / 255.0
            let greenValue: CGFloat = CGFloat(Int(colorArr[1])!) / 255.0
            let blueValue: CGFloat = CGFloat(Int(colorArr[2])!) / 255.0

            tmpColors.append(TypeColor(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0))
        }
        self.colors = tmpColors

        guard self.numColors == self.colors.count else {
            fatalError("number of colors does not match")
        }
    }
}

public class SlpFileReader {

    public init() {
    }

    public func load(from url: URL?, player: SlpPlayer = SlpPlayer.defaultBlue) -> SlpFile? {

        if let civ5MapUrl = url {

            do {
                let binaryData = try Data(contentsOf: civ5MapUrl, options: .mappedIfSafe)

                return self.load(from: binaryData, player: player)
            } catch {
                print("Error reading \(error)")
            }
        }

        return nil
    }

    // https://github.com/handsomematt/OpenEmpires/blob/master/GenieLib/SLPFile.cs
    private func load(from data: Data, player: SlpPlayer = SlpPlayer.defaultBlue) -> SlpFile? {

        let binaryData = BinaryData(data: data, bigEndian: false)
        let reader = BinaryDataReader(binaryData)

        do {
            return try SlpFile(reader: reader, player: player)
        } catch {
            print("error while reading SlpFile: \(error)")
        }

        return nil
    }
}

public class SlpFile {

    public let version: Int32
    public let numFrames: Int32
    public let comment: String

    public let frames: [SlpFrame]

    init(reader: BinaryDataReader, player: SlpPlayer = SlpPlayer.defaultBlue) throws {

        self.version = try reader.read()
        self.numFrames = try reader.read()
        self.comment = try reader.readUTF8(24)

        // print("version=\(self.version), numFrames=\(self.numFrames), comment=\(self.comment)")

        var tmpFrames: [SlpFrame] = []
        tmpFrames.reserveCapacity(Int(numFrames))

        // first read the frame headers
        for _ in 0..<self.numFrames {

            let frameHeader = try SlpFrameHeader(reader: reader)
            let frame = SlpFrame(header: frameHeader)
            tmpFrames.append(frame)
        }

        // print("got \(self.numFrames) headers")

        for index in 0..<self.numFrames {

            let frameHeader = tmpFrames[Int(index)].header
            let frameData = try SlpFrameData(reader: reader, header: frameHeader, player: player)
            tmpFrames[Int(index)].data = frameData
        }

        self.frames = tmpFrames
    }

    init(version: Int32, numFrames: Int32, comment: String, frames: [SlpFrame]) {

        self.version = version
        self.numFrames = numFrames
        self.comment = comment

        self.frames = frames
    }
}

public class SlpFrameHeader {

    public let cmdTableOffset: Int32
    public let outlineTableOffset: Int32
    public let paletteOffset: Int32
    public let properties: Int32

    public let width: Int32
    public let height: Int32
    public let hotSpotX: Int32
    public let hotSpotY: Int32

    init(reader: BinaryDataReader) throws {

        self.cmdTableOffset = try reader.read()
        self.outlineTableOffset = try reader.read()
        self.paletteOffset = try reader.read()
        self.properties = try reader.read()

        self.width = try reader.read()
        self.height = try reader.read()
        self.hotSpotX = try reader.read()
        self.hotSpotY = try reader.read()
    }

    public func size() -> NSSize {

        return NSSize(width: CGFloat(self.width), height: CGFloat(self.height))
    }
}

enum SlpRenderCommandType {

    case nextline // RENDER_NEXTLINE
    case color(index: UInt8) // RENDER_COLOR
    case skip(amount: UInt8) // RENDER_SKIP
    case playerColor(index: UInt8) // RENDER_PLAYER_COLOR
    case fill(amount: UInt8, index: UInt8) // RENDER_FILL
    case playerFill(amount: UInt8, index: UInt8) // RENDER_PLAYER_FILL
    case shadow(amount: UInt8) // RENDER_SHADOW
    case outline(amount: UInt8) // RENDER_OUTLINE
}

public class SlpFrameData {

    private var leftEdges: [UInt16]
    private var rightEdges: [UInt16]

    public var indicesArray: [UInt8]

    init() {

        self.leftEdges = []
        self.rightEdges = []

        self.indicesArray = []
    }

    init(reader: BinaryDataReader, header: SlpFrameHeader, player: SlpPlayer = SlpPlayer.defaultBlue) throws {

        // print("-- parse frame")
        // print("-- width: \(header.width)")
        // print("-- height: \(header.height)")

        // Initialize our indices array as a table full of transparent colours.
        self.indicesArray = [UInt8](repeating: UInt8(255), count: Int(header.width * header.height)) // transparent index

        try reader.seek(Int(header.outlineTableOffset))

        self.leftEdges = [UInt16](repeating: UInt16(0), count: Int(header.height))
        self.rightEdges = [UInt16](repeating: UInt16(0), count: Int(header.height))

        for index in 0..<Int(header.height) {

            self.leftEdges[index] = try reader.read()
            self.rightEdges[index] = try reader.read()

            // print("- row: \(index) => left: \(self.leftEdges[index]) - right: \(self.rightEdges[index])")
        }

        // Command offsets
        var commandOffsets: [UInt32] = [UInt32](repeating: UInt32(0), count: Int(header.height))
        try reader.seek(Int(header.cmdTableOffset))
        for index in 0..<Int(header.height) {
            commandOffsets[index] = try reader.read()
        }

        let commands: Queue<SlpRenderCommandType> = Queue<SlpRenderCommandType>()

        for y in 0..<Int(header.height) {

            try reader.seek(Int(commandOffsets[y]))

            while reader.canRead { // whilst the row is still not ended

                let cmd: UInt8 = try reader.read()
                let lowNibble = cmd & 0x0f
                let highNibble = cmd & 0xf0
                let lowBits = cmd & 0x03 // 0b00…0011

                if lowNibble == 0x0f { // SLP_END_OF_ROW

                    commands.enqueue(SlpRenderCommandType.nextline)
                    break
                } else if lowBits == 0x00 { // SLP_COLOR_LIST

                    // An array of palette indices. This is about as bitmap as it gets in SLPs.
                    let numpixels0 = cmd >> 2
                    for _ in 0..<numpixels0 where reader.canRead {
                        let byteVal: UInt8 = try reader.read()
                        commands.enqueue(SlpRenderCommandType.color(index: byteVal))
                    }

                } else if lowBits == 0x01 { // SLP_SKIP

                    // The specified number of pixels are transparent.
                    var numpixels1: UInt8 = cmd >> 2
                    if numpixels1 == 0 {
                        numpixels1 = try reader.read()
                    }

                    commands.enqueue(SlpRenderCommandType.skip(amount: numpixels1))

                } else if lowNibble == 0x02 { // SLP_COLOR_LIST_EX

                    // An array of palette indexes. Supports a greater number of pixels than the above color list.
                    let offset: UInt8 = try reader.read()
                    let numpixels2 = (highNibble << 4) + offset
                    for _ in 0..<numpixels2 where reader.canRead {
                        let byteVal: UInt8 = try reader.read()
                        commands.enqueue(SlpRenderCommandType.color(index: byteVal))
                    }

                } else if lowNibble == 0x03 { // SLP_SKIP_EX

                    // The specified number of pixels are transparent. Supports a greater number of pixels than the above skip.
                    let offset: UInt8 = try reader.read()
                    let numpixels3 = (highNibble << 4) + offset
                    commands.enqueue(SlpRenderCommandType.skip(amount: numpixels3))

                } else if lowNibble == 0x06 { // SLP_COLOR_LIST_PLAYER

                    // An array of player color indexes. The actual palette index is given by adding ([player number] * 16) + 16 to these values.
                    var numpixels6 = (cmd & 0xF0) >> 4
                    if numpixels6 == 0 {
                        numpixels6 = try reader.read()
                    }

                    for _ in 0..<numpixels6 where reader.canRead {
                        let byteVal: UInt8 = try reader.read()
                        commands.enqueue(SlpRenderCommandType.playerColor(index: byteVal))
                    }

                } else if lowNibble == 0x07 { // SLP_FILL

                    // Fills the specified number of pixels with the following palette index.
                    var numpixels7: UInt8 = (cmd & 0xF0) >> 4
                    if numpixels7 == 0 {
                        numpixels7 = try reader.read()
                    }

                    let colorindex: UInt8 = try reader.read()

                    commands.enqueue(SlpRenderCommandType.fill(amount: numpixels7, index: colorindex))

                } else if lowNibble == 0x0a { // SLP_FILL_PLAYER

                    // // Same as above, but using the player color formula (see Player color list).
                    var numpixelsa: UInt8 = (cmd & 0xF0) >> 4
                    if numpixelsa == 0 {
                        numpixelsa = try reader.read()
                    }

                    // the value below is incorrect
                    // this is just a relative player palette colour
                    // a function should be made to translate this into a usable palette colour
                    // or handled manually to allow for any RGBA colour to be used for a team
                    // color.
                    let playercolorindex: UInt8 = try reader.read()

                    commands.enqueue(SlpRenderCommandType.playerFill(amount: numpixelsa, index: playercolorindex))

                } else if lowNibble == 0x0b { // SLP_SHADOW

                    var numpixelsb: UInt8 = (cmd & 0xF0) >> 4
                    if numpixelsb == 0 {
                        numpixelsb = try reader.read()
                    }

                    commands.enqueue(SlpRenderCommandType.shadow(amount: numpixelsb))

                } else if lowNibble == 0x0e { // SLP_EXTENDED

                    if highNibble == 0x40 { // SLP_EX_OUTLINE1
                        commands.enqueue(SlpRenderCommandType.outline(amount: 1))
                    } else if highNibble == 0x60 { // SLP_EX_OUTLINE2
                        commands.enqueue(SlpRenderCommandType.outline(amount: 2))
                    } else if highNibble == 0x50 { // SLP_EX_FILL_OUTLINE1
                        let outlinespanamount: UInt8 = try reader.read()
                        for _ in 0..<outlinespanamount {
                            commands.enqueue(SlpRenderCommandType.outline(amount: 1))
                        }
                    } else if highNibble == 0x70 { // SLP_EX_FILL_OUTLINE2
                        let outlinespanamount: UInt8 = try reader.read()
                        for _ in 0..<outlinespanamount {
                            commands.enqueue(SlpRenderCommandType.outline(amount: 2))
                        }
                    }
                }
            }
        }

        // Render a frame to a buffer.
        var y = 0
        var x: UInt16 = self.leftEdges[0]

        while let command = commands.dequeue() {
            // print(command)

            switch command {

            case .nextline:
                y += 1
                if y < self.leftEdges.count {
                    x = self.leftEdges[y] // move to start point of next line
                }

            case .color(let index):
                self.indicesArray[y * Int(header.width) + Int(x)] = index
                x += 1

            case .skip(let amount):
                x += UInt16(amount)

            case .playerColor(let index):
                self.indicesArray[y * Int(header.width) + Int(x)] = index + UInt8(16 * player.value())
                x += 1

            case .fill(let amount, let index):
                for _ in 0..<amount {
                    self.indicesArray[y * Int(header.width) + Int(x)] = index
                    x += 1
                }

            case .playerFill(let amount, let index):
                for _ in 0..<amount {
                    self.indicesArray[y * Int(header.width) + Int(x)] = index + UInt8(16 * player.value())
                    x += 1
                }

            case .shadow(let amount):
                for _ in 0..<amount {
                    // self.indicesArray[y * Int(header.width) + Int(x)] = red
                    x += 1
                }

            case .outline(let amount):
                for _ in 0..<amount {
                    // self.indicesArray[y * Int(header.width) + Int(x)] = black
                    x += 1
                }
            }
        }
    }
}

public class SlpFrame {

    public let header: SlpFrameHeader
    public var data: SlpFrameData

    init(header: SlpFrameHeader) {

        self.header = header
        self.data = SlpFrameData()
    }
}
