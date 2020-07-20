//
//  UnitTypeExtension.swift
//  SmartColony
//
//  Created by Michael Rommel on 08.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import CoreGraphics
import SmartAILibrary
import UIKit
import SpriteKit
import CoreImage
import Accelerate

extension UIImage {

    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {

    // https://medium.com/ymedialabs-innovation/resizing-techniques-and-image-quality-that-every-ios-developer-should-know-e061f33f7aba
    func resize(to size: CGSize) -> UIImage? {
        let cgImage = self.cgImage!

        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            sourceBuffer.data.deallocate() //.dealloc(Int(sourceBuffer.height) * Int(sourceBuffer.height) * 4)
        }

        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }

        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)

        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }

        // create a CGImage from vImage_Buffer
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }

        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        return resizedImage
    }
}

extension UIImage {

    func overlayWith(image: UIImage, posX: CGFloat, posY: CGFloat) -> UIImage {
        let newWidth = size.width < posX + image.size.width ? posX + image.size.width : size.width
        let newHeight = size.height < posY + image.size.height ? posY + image.size.height : size.height
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        image.draw(in: CGRect(origin: CGPoint(x: posX, y: posY), size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func leftMirrored() -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: self.size.width, y: self.size.height)
        context.scaleBy(x: -self.scale, y: -self.scale)

        context.draw(self.cgImage!, in: CGRect(origin:CGPoint.zero, size: self.size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage
    }
}

extension TextureAtlas {

    func gameObjectAtlas(for action: String, in direction: String = "south-west", mirror: Bool = false) -> GameObjectAtlas? {

        guard let unitMask = UIImage(named: "unit_mask") else {
            fatalError("cant get unit_mask")
        }

        guard let image = UIImage(named: self.unit.id) else {
            fatalError("cant get image for \(action)")
        }

        var textures: [SKTexture] = []
        var speed: Double = -1.0

        if let action = self.unit.action.first(where: { $0.enumValue == action }) {

            if let direction = action.direction.first(where: { $0.enumValue == direction }) {

                for sprite in direction.sprite {
                    let rect = CGRect(x: sprite.x, y: sprite.y, width: sprite.w, height: sprite.h)

                    if var croppedImage = image.cropped(boundingBox: rect) {

                        if mirror {
                            croppedImage = croppedImage.leftMirrored()!
                        }
                        
                        if let resizedImage = croppedImage.resize(to: CGSize(width: croppedImage.size.width * 0.75, height: croppedImage.size.height * 0.75)) {

                            let posX: CGFloat = unitMask.size.width / 2.0 - resizedImage.size.width * CGFloat(sprite.pX)
                            let posY: CGFloat = unitMask.size.height * 0.75 - resizedImage.size.height * CGFloat(sprite.pY)

                            let img = unitMask.overlayWith(image: resizedImage, posX: posX, posY: posY)

                            textures.append(SKTexture(image: img))
                        }
                    }
                }
            }

            speed = 0.1 // Double(action.speedValue) / 1000
        }

        return GameObjectAtlas(textures: textures, speed: speed)
    }
}

extension UnitType {

    var spriteName: String {

        switch self {

            // barbarian
        case .barbarianWarrior: return "warrior-idle-0"
        case .barbarianArcher: return "archer-idle-0"

            // ancient
        case .settler: return "settler-idle-0"
        case .builder: return "builder-idle-0"

        case .scout: return "archer-idle-0"
        case .warrior: return "warrior-idle-0"
        case .slinger: return "archer-idle-0"
        case .archer: return "archer-idle-0"
        case .spearman: return "archer-idle-0"
        case .heavyChariot: return "archer-idle-0"
        case .galley: return "archer-idle-0"

            // industrial
        case .medic: return "archer-idle-0"

            // great people
        case .admiral: return "archer-idle-0"
        case .artist: return "archer-idle-0"
        case .engineer: return "archer-idle-0"
        case .general: return "archer-idle-0"
        case .merchant: return "archer-idle-0"
        case .musician: return "archer-idle-0"
        case .prophet: return "archer-idle-0"
        case .scientist: return "archer-idle-0"
        case .writer: return "archer-idle-0"

        }
    }

    var idleAtlas: GameObjectAtlas? {

        switch self {

            // barbarian
        case .barbarianWarrior:
            return GameObjectAtlas(atlasName: "Warrior", template: "warrior-idle-", range: 0..<10)
            
        case .barbarianArcher:
            return GameObjectAtlas(atlasName: "Archer", template: "archer-idle-", range: 0..<10)

            // ancient
        case .settler:
            return GameObjectAtlas(atlasName: "Settler", template: "settler-idle-", range: 0..<15)
            
        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "builder")
            return textureAtlas?.gameObjectAtlas(for: "idle")
            
        case .scout:
            let textureAtlas = TextureAtlasLoader.load(named: "scout")
            return textureAtlas?.gameObjectAtlas(for: "idle")
            
        case .warrior:
            let textureAtlas = TextureAtlasLoader.load(named: "warrior")
            return textureAtlas?.gameObjectAtlas(for: "idle")
            
        case .slinger:
            return nil
            
        case .archer:
            let textureAtlas = TextureAtlasLoader.load(named: "archer")
            return textureAtlas?.gameObjectAtlas(for: "idle")
            
        case .spearman:
            let textureAtlas = TextureAtlasLoader.load(named: "spearman")
            return textureAtlas?.gameObjectAtlas(for: "idle")
            
        case .heavyChariot: return nil
        case .galley: return nil

            // industrial
        case .medic: return nil

            // great people
        case .artist: return nil
        case .admiral: return nil
        case .engineer: return nil
        case .general: return nil
        case .merchant: return nil
        case .musician: return nil
        case .prophet: return nil
        case .scientist: return nil
        case .writer: return nil
        }
    }

    var walkDownAtlas: GameObjectAtlas? {

        switch self {
            
            // barbarian
            case .barbarianWarrior: return nil
            case .barbarianArcher: return nil

                // ancient
            case .settler:
                return nil
            
            case .builder:
                let textureAtlas = TextureAtlasLoader.load(named: "builder")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "south")

            case .scout:
                let textureAtlas = TextureAtlasLoader.load(named: "scout")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "south")
            
            case .warrior:
                let textureAtlas = TextureAtlasLoader.load(named: "warrior")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "south")
            
            case .slinger:
                return nil
            
            case .archer:
                let textureAtlas = TextureAtlasLoader.load(named: "archer")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "south")
            
            case .spearman:
                let textureAtlas = TextureAtlasLoader.load(named: "spearman")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "south")
            case .heavyChariot: return nil
            case .galley: return nil

                // industrial
            case .medic: return nil

                // great people
            case .artist: return nil
            case .admiral: return nil
            case .engineer: return nil
            case .general: return nil
            case .merchant: return nil
            case .musician: return nil
            case .prophet: return nil
            case .scientist: return nil
            case .writer: return nil
        }
    }
    
    var walkUpAtlas: GameObjectAtlas? {

        switch self {
            
            // barbarian
            case .barbarianWarrior: return nil
            case .barbarianArcher: return nil

                // ancient
            case .settler:
                return nil
            
            case .builder:
                let textureAtlas = TextureAtlasLoader.load(named: "builder")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "north")

            case .scout:
                let textureAtlas = TextureAtlasLoader.load(named: "scout")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "north")
            
            case .warrior:
                let textureAtlas = TextureAtlasLoader.load(named: "warrior")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "north")
            
            case .slinger:
                return nil
            
            case .archer:
                let textureAtlas = TextureAtlasLoader.load(named: "archer")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "north")
            
            case .spearman:
                let textureAtlas = TextureAtlasLoader.load(named: "spearman")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "north")
            
            case .heavyChariot: return nil
            case .galley: return nil

                // industrial
            case .medic: return nil

                // great people
            case .artist: return nil
            case .admiral: return nil
            case .engineer: return nil
            case .general: return nil
            case .merchant: return nil
            case .musician: return nil
            case .prophet: return nil
            case .scientist: return nil
            case .writer: return nil
        }
    }
    
    var walkRightAtlas: GameObjectAtlas? {

        switch self {
            
            // barbarian
            case .barbarianWarrior: return nil
            case .barbarianArcher: return nil

                // ancient
            case .settler:
                    return nil
            
            case .builder:
                let textureAtlas = TextureAtlasLoader.load(named: "builder")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west", mirror: true)

            case .scout:
                let textureAtlas = TextureAtlasLoader.load(named: "scout")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west", mirror: true)
            
            case .warrior:
                let textureAtlas = TextureAtlasLoader.load(named: "warrior")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west", mirror: true)
            
            case .slinger:
                    return nil
            
            case .archer:
                let textureAtlas = TextureAtlasLoader.load(named: "archer")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west", mirror: true)
            
            case .spearman:
                let textureAtlas = TextureAtlasLoader.load(named: "spearman")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west", mirror: true)
            
            case .heavyChariot: return nil
            case .galley: return nil

                // industrial
            case .medic: return nil

                // great people
            case .artist: return nil
            case .admiral: return nil
            case .engineer: return nil
            case .general: return nil
            case .merchant: return nil
            case .musician: return nil
            case .prophet: return nil
            case .scientist: return nil
            case .writer: return nil
        }
    }
    
    var walkLeftAtlas: GameObjectAtlas? {

        switch self {
            
            // barbarian
            case .barbarianWarrior: return nil
            case .barbarianArcher: return nil

                // ancient
            case .settler: return nil
            
            case .builder:
                let textureAtlas = TextureAtlasLoader.load(named: "builder")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west")

            case .scout:
                let textureAtlas = TextureAtlasLoader.load(named: "scout")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west")
            
            case .warrior:
                let textureAtlas = TextureAtlasLoader.load(named: "warrior")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west")
            
            case .slinger:
                    return nil
            
            case .archer:
                let textureAtlas = TextureAtlasLoader.load(named: "archer")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west")
            
            case .spearman:
                let textureAtlas = TextureAtlasLoader.load(named: "spearman")
                return textureAtlas?.gameObjectAtlas(for: "walk", in: "west")
            
            case .heavyChariot: return nil
            case .galley: return nil

                // industrial
            case .medic: return nil

                // great people
            case .artist: return nil
            case .admiral: return nil
            case .engineer: return nil
            case .general: return nil
            case .merchant: return nil
            case .musician: return nil
            case .prophet: return nil
            case .scientist: return nil
            case .writer: return nil
        }
    }
}
