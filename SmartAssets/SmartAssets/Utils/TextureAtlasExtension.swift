//
//  TextureAtlasExtension.swift
//  SmartAssets
//
//  Created by Michael Rommel on 07.04.21.
//

import Cocoa
import SmartAILibrary

extension TextureAtlas {

    func objectTextureAtlas(for action: String, in direction: String = "south-west", mirror: Bool = false) -> ObjectTextureAtlas? {

        let bundle = Bundle.init(for: Textures.self)

        guard let image = bundle.image(forResource: self.unit.id) else {
            fatalError("cant get image for \(action)")
        }

        var textures: [NSImage] = []
        var speed: Double = -1.0

        if let action = self.unit.action.first(where: { $0.enumValue == action }) {

            if let direction = action.direction.first(where: { $0.enumValue == direction }) {

                for sprite in direction.sprite {
                    let rect = CGRect(x: sprite.x, y: sprite.y, width: sprite.w, height: sprite.h)

                    if var croppedImage = image.cropped(boundingBox: rect) {

                        if mirror {
                            croppedImage = croppedImage.leftMirrored()!
                        }

                        let croppedSize = CGSize(width: croppedImage.size.width * 1.5, height: croppedImage.size.height * 1.5)

                        if let resizedImage = croppedImage.resize(withSize: croppedSize) {

                            guard let unitMask = bundle.image(forResource: "unit-mask") else {
                                fatalError("cant get unit-mask")
                            }

                            let posX: CGFloat = unitMask.size.width / 2.0 - resizedImage.size.width * CGFloat(sprite.pX)
                            let posY: CGFloat = unitMask.size.height * 0.25 - resizedImage.size.height * CGFloat(1.0 - sprite.pY)

                            if let image = unitMask.overlayWith(image: resizedImage, posX: posX, posY: posY) {
                                textures.append(image)
                            }
                        }
                    }
                }
            }

            speed = Double(action.speedValue) / 2000
            //speed = 0.05
        }

        return ObjectTextureAtlas(textures: textures, speed: speed)
    }
}
