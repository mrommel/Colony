#!/usr/bin/swift

import Foundation
import Cocoa

/*
 run
 cd ~/Prog/Colony/SmartAssets/SmartAssets
 ./CheckScript.swift ~/Prog/Colony\ Resource/Features_ice
 */

/*
 convert sepimage-0.png sepimage-1.png  -background transparent -layers flatten imagecopy.png

 convert feature_ice-to-water-ne@3x.png feature_ice-to-water-s@3x.png feature_ice-to-water-nw@3x.png
    -background transparent -layers flatten feature_ice-to-water-ne-s-nw@3x.png
 convert feature_ice-to-water-ne@2x.png feature_ice-to-water-s@2x.png feature_ice-to-water-nw@2x.png
    -background transparent -layers flatten feature_ice-to-water-ne-s-nw@2x.png
 convert feature_ice-to-water-ne@1x.png feature_ice-to-water-s@1x.png feature_ice-to-water-nw@1x.png
    -background transparent -layers flatten feature_ice-to-water-ne-s-nw@1x.png
 */

enum ANSIColors: String {

    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"

    func name() -> String {

        switch self {
        case .black: return "Black"
        case .red: return "Red"
        case .green: return "Green"
        case .yellow: return "Yellow"
        case .blue: return "Blue"
        case .magenta: return "Magenta"
        case .cyan: return "Cyan"
        case .white: return "White"
        }
    }

    static func all() -> [ANSIColors] {
        return [.black, .red, .green, .yellow, .blue, .magenta, .cyan, .white]
    }
}

func + (left: ANSIColors, right: String) -> String {
    return left.rawValue + right
}

extension NSImage {

    public func write(to url: URL, size: NSSize) throws {

        let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSColorSpaceName.deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )!
        bitmap.size = NSSize(width: size.width, height: size.height)

        NSGraphicsContext.saveGraphicsState()

        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        self.draw(in: NSRect(origin: NSPoint(), size: size), from: NSRect(), operation: .copy, fraction: 1)
        NSGraphicsContext.restoreGraphicsState()

        try bitmap.representation(using: .png, properties: [.compressionFactor: 1.0])?.write(to: url, options: [])
    }
}

extension NSURL {

    var fileName: String? {

        return self.deletingPathExtension?.lastPathComponent ?? self.lastPathComponent
    }
}

// https://fivestars.blog/code/ultimate-guide-swift-executables.html

let arguments: [String] = Array(CommandLine.arguments.dropFirst())
guard !arguments.isEmpty else {

    print("You must provide a path to a directory as first argiment")
    exit(EXIT_FAILURE)
}

let path: String = arguments[0]
let dir = URL(fileURLWithPath: path)

var files = try FileManager.default.contentsOfDirectory(
    at: dir,
    includingPropertiesForKeys: nil,
    options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants]
)

files = files.filter({ $0.pathExtension == "png" })

files.forEach({ (file) in

    let baseFileName = file.path
        .replacingOccurrences(of: "@2x", with: "")
        .replacingOccurrences(of: "@3x", with: "")
        .replacingOccurrences(of: ".png", with: "")

    if file.lastPathComponent.contains("_") {

        // rename
        let newFilename = URL(fileURLWithPath: file.path.replacingOccurrences(of: "_", with: "-"))

        do {
            // try sourceImage.write(to: URL(fileURLWithPath: newName1x), size: targetSize)
            try FileManager.default.moveItem(at: file, to: newFilename)
            print(ANSIColors.green + "renamed: \(newFilename)")
        } catch {
            print(ANSIColors.red + "failed: \(newFilename)")
        }

    } else {

        // ////////////////////////////////////
        // only @3x images
        if file.lastPathComponent.contains("@3x") {

            let sourceImage = NSImage(contentsOfFile: file.path)!

            let newName2x = baseFileName + "@2x.png"
            if !FileManager.default.fileExists(atPath: newName2x) {

                let targetSize = CGSize(width: 96, height: 96)
                do {
                    try sourceImage.write(to: URL(fileURLWithPath: newName2x), size: targetSize)
                    print(ANSIColors.green + "generated: \(newName2x)")
                } catch {
                    print(ANSIColors.red + "failed: \(newName2x)")
                }
            } else {
                print(ANSIColors.blue + "have: \(newName2x)")
            }

            let newName1x = baseFileName + "@1x.png"
            if !FileManager.default.fileExists(atPath: newName1x) {

                let targetSize = CGSize(width: 48, height: 48)
                do {
                    try sourceImage.write(to: URL(fileURLWithPath: newName1x), size: targetSize)
                    print(ANSIColors.green + "generated: \(newName1x)")
                } catch {
                    print(ANSIColors.red + "failed: \(newName1x)")
                }
            } else {
                print(ANSIColors.blue + "have: \(newName1x)")
            }
        }

        // ////////////////////////////////////
        // only @2x images
        if file.lastPathComponent.contains("@2x") {

            let sourceImage = NSImage(contentsOfFile: file.path)!

            let newName3x = baseFileName + "@3x.png"
            if !FileManager.default.fileExists(atPath: newName3x) {

                let targetSize = CGSize(width: 144, height: 144)
                do {
                    try sourceImage.write(to: URL(fileURLWithPath: newName3x), size: targetSize)
                    print(ANSIColors.green + "generated: \(newName3x)")
                } catch {
                    print(ANSIColors.red + "failed: \(newName3x)")
                }
            } else {
                print(ANSIColors.blue + "have: \(newName3x)")
            }

            let newName1x = baseFileName + "@1x.png"
            if !FileManager.default.fileExists(atPath: newName1x) {

                let targetSize = CGSize(width: 48, height: 48)
                do {
                    try sourceImage.write(to: URL(fileURLWithPath: newName1x), size: targetSize)
                    print(ANSIColors.green + "generated: \(newName1x)")
                } catch {
                    print(ANSIColors.red + "failed: \(newName1x)")
                }
            } else {
                print(ANSIColors.blue + "have: \(newName1x)")
            }
        }
    }
})
