//
//  SlpTextureAtlasLoader.swift
//  SmartAssets
//
//  Created by Michael Rommel on 23.02.22.
//

import Foundation

enum SlpTextureAtlasPart {

    case first // north
    case second // northWest
    case third // west
    case forth // southWest
    case fifth // south
}

class SlpTextureAtlasLoader {

    public static func atlas(for filename: String,
                             part: SlpTextureAtlasPart,
                             mirror: Bool = false,
                             scale: CGFloat = 1.3,
                             offset: CGPoint = .zero,
                             palette: [TypeColor] = SlpPalette.default.colors,
                             player: SlpPlayer = SlpPlayer.blue) -> ObjectTextureAtlas? {

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

        print("build atlas \(filename) with size: \(slpFile.frames[0].image()!.size)")

        var rangeStart = 0
        var rangeEnd = 1
        let rangeLength = slpFile.frames.count / 5

        switch part {

        case .first:
            rangeStart = 0
            rangeEnd = rangeLength
        case .second:
            rangeStart = rangeLength
            rangeEnd = 2 * rangeLength
        case .third:
            rangeStart = 2 * rangeLength
            rangeEnd = 3 * rangeLength
        case .forth:
            rangeStart = 3 * rangeLength
            rangeEnd = 4 * rangeLength
        case .fifth:
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
                             scale: CGFloat = 1.3,
                             offset: CGPoint = .zero,
                             palette: [TypeColor] = SlpPalette.default.colors,
                             player: SlpPlayer = SlpPlayer.blue) -> ObjectTextureAtlas? {

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

        print("build atlas \(filename) with size: \(slpFile.frames[0].image()!.size)")

        return SlpTextureAtlasLoader.atlas(
            from: slpFile,
            range: range,
            mirror: mirror,
            scale: scale,
            offset: offset,
            palette: palette,
            player: player)
    }

    private static func atlas(from slpFile: SlpFile,
                              range: Range<Int>,
                              mirror: Bool = false,
                              scale: CGFloat = 1.3,
                              offset: CGPoint = .zero,
                              palette: [TypeColor] = SlpPalette.default.colors,
                              player: SlpPlayer = SlpPlayer.blue) -> ObjectTextureAtlas? {

        let bundle = Bundle(for: SlpTextureAtlasLoader.self)

        guard 0 <= range.startIndex && range.endIndex <= slpFile.frames.count else {
            print("range does not match the amount of images: \(range) => \(slpFile.frames.count)")
            return nil
        }

        let firstImageSize = slpFile.frames[0].image()!.size
        // print("build atlas \(filename) with size: \(slpFile.frames[0].image()!.size)")

        let selectedImages: [TypeImage] = slpFile.frames[range].map { $0.image(with: palette) ?? TypeImage() }
        var processedImages: [TypeImage] = []
        var index = 0

        selectedImages.forEach { selectedImage in

            /*guard selectedImage.size == firstImageSize else {
             fatalError("images have different sizes")
             }*/

            guard let unitMask = bundle.image(forResource: "unit-mask") else {
                fatalError("cant get unit-mask")
            }

            print("hotspot: \(slpFile.frames[index].header.hotSpotX), \(slpFile.frames[index].header.hotSpotY)")
            print("size: \(slpFile.frames[index].header.size())")

            print("build atlas unitMask: \(unitMask.size)")

            let croppedSize = CGSize(width: selectedImage.size.width * scale, height: selectedImage.size.height * scale)
            print("build atlas resized to: \(croppedSize)")

            if let resizedImage = selectedImage.resize(withSize: croppedSize) {

                // let posX: CGFloat = unitMask.size.width / 2.0 - resizedImage.size.width * CGFloat(sprite.pX)
                // let posY: CGFloat = unitMask.size.height * 0.25 - resizedImage.size.height * CGFloat(1.0 - sprite.pY)
                let posX: CGFloat = unitMask.size.width / 2.0 - firstImageSize.width * scale / 2.0 + offset.x * scale
                let posY: CGFloat = unitMask.size.height / 2.0 - firstImageSize.height * scale / 2.0 + offset.y * scale - unitMask.size.height / 6.0

                if var image = unitMask.overlayWith(image: resizedImage, posX: posX, posY: posY) {

                    if mirror {
                        image = image.leftMirrored()!
                    }

                    processedImages.append(image)
                }
            }

            index += 1
        }

        return ObjectTextureAtlas(textures: processedImages)
    }
}
