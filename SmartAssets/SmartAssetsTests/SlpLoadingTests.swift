//
//  SlpLoadingTests.swift
//  SmartAILibraryTests
//
//  Created by Michael Rommel on 23.02.22.
//  Copyright © 2022 Michael Rommel. All rights reserved.
//

import XCTest
@testable import SmartAssets

/// Exceptions for the image extension class.
///
/// - creatingPngRepresentationFailed: Is thrown when the creation of the png representation failed.
enum NSImageExtensionError: Error {
    case unwrappingPNGRepresentationFailed
}

extension NSImage {

    /// A PNG representation of the image.
    var pngRepresentation: Data? {
        if let tiff = self.tiffRepresentation, let tiffData = NSBitmapImageRep(data: tiff) {
            return tiffData.representation(using: .png, properties: [:])
        }

        return nil
    }

    // MARK: Saving
    /// Save the images PNG representation the the supplied file URL:
    ///
    /// - Parameter url: The file URL to save the png file to.
    /// - Throws: An unwrappingPNGRepresentationFailed when the image has no png representation.
    public func savePngTo(url: URL) throws {

        if let png = self.pngRepresentation {
            try png.write(to: url, options: .atomicWrite)
        } else {
            throw NSImageExtensionError.unwrappingPNGRepresentationFailed
        }
    }
}

class SlpLoadingTests: XCTestCase {

    private var downloadsFolder: URL = {
        let fileManager = FileManager.default
        let folder = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fileManager.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            do {
                try fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
            } catch { }
        }
        return folder
    }()

    func testLoadMerchantIdleSlp() throws {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "merchant-idle", ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        guard let slpFile = SlpFileReader().load(from: url) else {
            XCTFail("Could not load file")
            return
        }

        XCTAssertEqual(slpFile.frames.count, 50)

        // export slps
        for (index, frame) in slpFile.frames.enumerated() {

            guard let frameImage: TypeImage = frame.image() else {
                XCTFail("Could not get image for frame: \(index)")
                return
            }

            let filename = downloadsFolder.appendingPathComponent("merchant-idle-\(index).png")
            try frameImage.savePngTo(url: filename)
        }
    }

    func testLoadPalette() throws {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "AOE1_50500", ofType: "pal")
        let url = URL(fileURLWithPath: path!)

        guard let slpPalette = SlpPaletteReader().load(from: url) else {
            XCTFail("Could not load file")
            return
        }

        XCTAssertEqual(slpPalette.colors.count, 256)
    }

    func testLoadCaravanAtlasWithPaletteIdleSlp() throws {

        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "caravane-idle", ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        let palettePath = testBundle.path(forResource: "AOE1_50500", ofType: "pal")
        let paletteUrl = URL(fileURLWithPath: palettePath!)

        guard let slpPalette = SlpPaletteReader().load(from: paletteUrl) else {
            XCTFail("Could not load file")
            return
        }

        let atlas = SlpTextureAtlasLoader.atlas(for: url,
                                                part: .southWest,
                                                palette: slpPalette.colors,
                                                player: .customBlue
        )

        XCTAssertEqual(atlas!.textures.count, 12)

        // export slps
        for (index, frameImage) in atlas!.textures.enumerated() {

            let filename = downloadsFolder.appendingPathComponent("caravane-idle-\(index).png")
            try frameImage.savePngTo(url: filename)
        }
    }
}
