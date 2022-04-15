//
//  SlpTextureAtlasLoader.swift
//  SmartAssets
//
//  Created by Michael Rommel on 23.02.22.
//

import Foundation

enum SlpTextureAtlasPart {

    case south // first
    case southWest // second
    case west // third
    case northWest // forth
    case north // fifth
}

class SlpTextureAtlasLoader {

    public static func atlas(for filename: String,
                             part: SlpTextureAtlasPart,
                             mirror: Bool = false,
                             scale: CGFloat = 1.5,
                             offset: CGPoint = .zero,
                             palette: [TypeColor] = SlpPalette.default.colors,
                             player: SlpPlayer = SlpPlayer.defaultBlue) -> ObjectTextureAtlas? {

        let bundle = Bundle(for: SlpTextureAtlasLoader.self)
        let path = bundle.path(forResource: filename, ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        return SlpTextureAtlasLoader.atlas(for: url,
                                           part: part,
                                           mirror: mirror,
                                           scale: scale,
                                           offset: offset,
                                           palette: palette,
                                           player: player
        )
    }

    public static func atlas(for url: URL,
                             part: SlpTextureAtlasPart,
                             mirror: Bool = false,
                             scale: CGFloat = 1.5,
                             offset: CGPoint = .zero,
                             palette: [TypeColor] = SlpPalette.default.colors,
                             player: SlpPlayer = SlpPlayer.defaultBlue) -> ObjectTextureAtlas? {

        guard let slpFile = SlpFileReader().load(from: url, player: player) else {
            print("cant get slp file")
            return nil
        }

        guard slpFile.frames.count == slpFile.numFrames && slpFile.numFrames > 0 else {
            print("no frames")
            return nil
        }

        // print("build atlas \(url.path) with size: \(slpFile.frames[0].image()!.size)")

        var rangeStart = 0
        var rangeEnd = 1
        let rangeLength = slpFile.frames.count / 5

        switch part {

        case .south:
            rangeStart = 0
            rangeEnd = rangeLength
        case .southWest:
            rangeStart = rangeLength
            rangeEnd = 2 * rangeLength
        case .west:
            rangeStart = 2 * rangeLength
            rangeEnd = 3 * rangeLength
        case .northWest:
            rangeStart = 3 * rangeLength
            rangeEnd = 4 * rangeLength
        case .north:
            rangeStart = 4 * rangeLength
            rangeEnd = 5 * rangeLength
        }

        let range: Range<Int> = rangeStart..<rangeEnd

        return SlpTextureAtlasLoader.atlas(
            from: slpFile,
            range: range,
            mirror: mirror,
            scale: scale,
            offset: offset,
            palette: palette,
            player: player)
    }

    public static func atlas(for filename: String,
                             range: Range<Int>,
                             mirror: Bool = false,
                             scale: CGFloat = 1.5,
                             offset: CGPoint = .zero,
                             palette: [TypeColor] = SlpPalette.default.colors,
                             player: SlpPlayer = SlpPlayer.defaultBlue) -> ObjectTextureAtlas? {

        let bundle = Bundle(for: SlpTextureAtlasLoader.self)
        let path = bundle.path(forResource: filename, ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        guard let slpFile = SlpFileReader().load(from: url, player: player) else {
            print("cant get slp file")
            return nil
        }

        guard slpFile.frames.count == slpFile.numFrames && slpFile.numFrames > 0 else {
            print("no frames")
            return nil
        }

        // print("build atlas \(filename) with size: \(slpFile.frames[0].image()!.size)")

        return SlpTextureAtlasLoader.atlas(
            from: slpFile,
            range: range,
            mirror: mirror,
            scale: scale,
            offset: offset,
            palette: palette,
            player: player)
    }

    /* private static var downloadsFolder: URL = {
        let fileManager = FileManager.default
        let folder = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask)[0]

        var isDirectory: ObjCBool = false
        if !(fileManager.fileExists(atPath: folder.path, isDirectory: &isDirectory) && isDirectory.boolValue) {
            do {
                try fileManager.createDirectory(at: folder, withIntermediateDirectories: false, attributes: nil)
            } catch { }
        }
        return folder
    }() */

    private static func atlas(from slpFile: SlpFile,
                              range: Range<Int>,
                              mirror: Bool = false,
                              scale: CGFloat = 1.5,
                              offset: CGPoint = .zero,
                              palette: [TypeColor] = SlpPalette.default.colors,
                              player: SlpPlayer = SlpPlayer.defaultBlue) -> ObjectTextureAtlas? {

        let bundle = Bundle(for: SlpTextureAtlasLoader.self)

        guard 0 <= range.startIndex && range.endIndex <= slpFile.frames.count else {
            print("range does not match the amount of images: \(range) => \(slpFile.frames.count)")
            return nil
        }

        let selectedImages: [TypeImage] = slpFile.frames[range].map { $0.image(with: palette) ?? TypeImage() }
        var processedImages: [TypeImage] = []

        selectedImages.enumerated().forEach { (index, selectedImage) in

            guard let unitMask = bundle.image(forResource: "unit-mask") else {
                fatalError("cant get unit-mask")
            }

            let hotspotX = CGFloat(slpFile.frames[index].header.hotSpotX) * scale
            let hotspotY = CGFloat(slpFile.frames[index].header.hotSpotY) * scale
            let resizedSize = CGSize(width: selectedImage.size.width * scale, height: selectedImage.size.height * scale)

            if let resizedImage = selectedImage.resize(withSize: resizedSize) {

                // debug
                // let filename = SlpTextureAtlasLoader.downloadsFolder.appendingPathComponent("caravane-idle-scaled-\(index).png")
                // try! resizedImage.savePngTo(url: filename)

                let posX: CGFloat = unitMask.size.width / 2.0 - hotspotX + offset.x
                let posY: CGFloat = unitMask.size.height / 2.0 - hotspotY + offset.y + 20
                // print("hotspotx for \(index): \(hotspotX)")

                if var image = unitMask.overlayWith(image: resizedImage, posX: posX, posY: posY) {

                    if mirror {
                        image = image.leftMirrored()!
                    }

                    processedImages.append(image)
                }
            }
        }

        return ObjectTextureAtlas(textures: processedImages)
    }
}
