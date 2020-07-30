//
//  ScrollNode.swift
//  SmartColony
//
//  Created by Michael Rommel on 21.04.20.
//  Copyright © 2020 Michael Rommel. All rights reserved.
//

import SpriteKit
import UIKit

enum ScrollMode {

    case vertically
    case horizontally
}

class ScrollNode: SKCropNode {

    // variables
    let mode: ScrollMode
    let size: CGSize
    var contentSize: CGSize

    // nodes
    var backgroundNode: SKSpriteNode?
    var scrollNode: SKNode?

    init(mode: ScrollMode = .vertically, size: CGSize, contentSize: CGSize) {

        self.mode = mode
        self.size = size
        self.contentSize = contentSize

        super.init()

        let maskTexture = SKTexture(image: self.maskTexture(size: self.size)!)
        self.maskNode = SKSpriteNode(texture: maskTexture, size: self.size)

        self.isUserInteractionEnabled = true

        // background
        let textureName = "scroll_background"
        self.backgroundNode = NineGridTextureSprite(imageNamed: textureName, size: size)
        self.backgroundNode?.position = CGPoint(x: 0.0, y: 0.0)
        self.backgroundNode?.zPosition = self.zPosition
        super.addChild(self.backgroundNode!)

        self.scrollNode = SKNode()
        self.scrollNode?.position = CGPoint(x: 0.0, y: 0.0)
        self.scrollNode?.zPosition = self.zPosition + 1.0
        super.addChild(self.scrollNode!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first!

        let touchLocation = touch.location(in: self)

        if !self.backgroundNode!.contains(touchLocation) {
            return
        }

        let previousLocation = touch.previousLocation(in: self)
        
        if self.mode == .vertically {
            let deltaY = (touchLocation.y) - (previousLocation.y)

            if abs(deltaY) < 0.1 {
                return
            }

            var newPositionY = self.scrollNode!.position.y + deltaY

            if newPositionY > self.contentSize.height - self.size.height {
                newPositionY = self.contentSize.height - self.size.height
            }

            if newPositionY < 0.0 {
                newPositionY = 0.0
            }

            self.scrollNode?.position.y = newPositionY

        } else if self.mode == .horizontally {

            let deltaX = (touchLocation.x) - (previousLocation.x)

            if abs(deltaX) < 0.1 {
                return
            }

            var newPositionX = self.scrollNode!.position.x + deltaX

            /*if newPositionX > self.contentSize.width - self.size.width {
                newPositionX = self.contentSize.width - self.size.width
            }*/
            
            //print("newPositionX=\(newPositionX) - self.contentSize.width=\(self.contentSize.width) - self.size.width=\(self.size.width)")

            if newPositionX > 0.0 {
                newPositionX = 0.0
            }

            self.scrollNode?.position.x = newPositionX
        }
    }

    func addScrolling(child: SKNode) {

        self.scrollNode?.addChild(child)
    }

    override func addChild(_ node: SKNode) {

        fatalError("use addScrolling(child:) instead")
    }

    private func maskTexture(size: CGSize) -> UIImage? {

        var pixelBuffer = PixelBuffer(width: Int(size.width), height: Int(size.height), color: .clear)

        for x in 1..<Int(size.width - 1) {
            for y in 1..<Int(size.height - 1) {
                pixelBuffer.set(color: .black, x: x, y: y)
            }
        }

        return pixelBuffer.toUIImage()
    }
}
