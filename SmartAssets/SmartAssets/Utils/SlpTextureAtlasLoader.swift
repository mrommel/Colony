//
//  SlpTextureAtlasLoader.swift
//  SmartAssets
//
//  Created by Michael Rommel on 23.02.22.
//

import Foundation

class SlpTextureAtlasLoader {

    public static func atlas(for filename: String, range: Range<Int>, mirror: Bool = false, scale: CGFloat = 1.3, offset: CGPoint = .zero) -> ObjectTextureAtlas? {

        let bundle = Bundle(for: SlpTextureAtlasLoader.self)
        let path = bundle.path(forResource: filename, ofType: "slp")
        let url = URL(fileURLWithPath: path!)

        guard let slpFile = SlpFileReader().load(from: url) else {
            print("cant get slp file")
            return nil
        }

        guard slpFile.frames.count == slpFile.numFrames && slpFile.numFrames > 0 else {
            print("no frames")
            return nil
        }

        guard 0 <= range.startIndex && range.endIndex <= slpFile.frames.count else {
            print("range does not match the amount of images: \(range) => \(slpFile.frames.count)")
            return nil
        }

        print("build atlas \(filename) with size: \(slpFile.frames[0].image()!.size)")

        let selectedImages: [TypeImage] = slpFile.frames[range].map { $0.image() ?? TypeImage() }
        var processedImages: [TypeImage] = []
        var index = 0

        selectedImages.forEach { selectedImage in
            guard let unitMask = bundle.image(forResource: "unit-mask") else {
                fatalError("cant get unit-mask")
            }

            print("build atlas unitMask: \(unitMask.size)")

            let croppedSize = CGSize(width: selectedImage.size.width * scale, height: selectedImage.size.height * scale)
            print("build atlas resized to: \(croppedSize)")

            if let resizedImage = selectedImage.resize(withSize: croppedSize) {

                // let posX: CGFloat = unitMask.size.width / 2.0 - resizedImage.size.width * CGFloat(sprite.pX)
                // let posY: CGFloat = unitMask.size.height * 0.25 - resizedImage.size.height * CGFloat(1.0 - sprite.pY)
                let posX: CGFloat = unitMask.size.width / 2.0 - resizedImage.size.width / 2.0 + offset.x * scale
                let posY: CGFloat = unitMask.size.height / 2.0 - resizedImage.size.height / 2.0 + offset.y * scale - unitMask.size.height / 6.0

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
