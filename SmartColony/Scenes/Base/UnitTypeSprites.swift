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

extension UIImage {

    func cropped(boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
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

    func resize(to targetSize: CGSize) -> UIImage {
        
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension TextureAtlas {

    func gameObjectAtlas(for action: String, in direction: String = "south-west") -> GameObjectAtlas? {

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

                    if let croppedImage = image.cropped(boundingBox: rect) {
                        
                        let resizedImage = croppedImage.resize(to: CGSize(width: croppedImage.size.width * 0.75, height: croppedImage.size.height * 0.75))
                        
                        let posX: CGFloat = unitMask.size.width / 2.0 - resizedImage.size.width * CGFloat(sprite.pX)
                        let posY: CGFloat = unitMask.size.height * 0.75 - resizedImage.size.height * CGFloat(sprite.pY)
                        
                        let img = unitMask.overlayWith(image: resizedImage, posX: posX, posY: posY)
                        
                        textures.append(SKTexture(image: img))
                    }
                }
            }

            speed = 0.25 // Double(action.speedValue) / 1000
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
        case .barbarianWarrior: return GameObjectAtlas(atlasName: "Warrior", template: "warrior-idle-", range: 0..<10)
        case .barbarianArcher: return GameObjectAtlas(atlasName: "Archer", template: "archer-idle-", range: 0..<10)

            // ancient
        case .settler: return GameObjectAtlas(atlasName: "Settler", template: "settler-idle-", range: 0..<15)
            // case .builder: return GameObjectAtlas(atlasName: "Builder", template: "builder-idle-", range: 0..<15)
        case .builder:
            let textureAtlas = TextureAtlasLoader.load(named: "villager")
            return textureAtlas?.gameObjectAtlas(for: "idle")
        case .scout: return nil
        case .warrior: return GameObjectAtlas(atlasName: "Warrior", template: "warrior-idle-", range: 0..<10)
        case .slinger: return nil
        case .archer: return GameObjectAtlas(atlasName: "Archer", template: "archer-idle-", range: 0..<10)
        case .spearman: return nil
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
        
        if self == .builder {
            let textureAtlas = TextureAtlasLoader.load(named: "villager")
            return textureAtlas?.gameObjectAtlas(for: "walk", in: "south-west")
        }
        
        return nil
    }

    var anchorPoint: CGPoint {

        return CGPoint(x: 0.0, y: 0.0)
    }
}
