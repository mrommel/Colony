//
//  ProgressBarNode.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 10.10.21.
//

import SpriteKit
import SmartAssets

class ProgressBarNode: SKNode {

    private static let kProgressAnimationKey = "progressAnimationKey"

    var progressBar: SKCropNode

    init(size: CGSize) {

        progressBar = SKCropNode()
        percentageLabel = SKLabelNode()

        super.init()

        let texture = SKTexture(image: ImageCache.shared.image(for: "grid9-progress"))
        let filledImage = NineGridTextureSprite(texture: texture, color: .black, size: size)
        self.progressBar.addChild(filledImage)

        self.progressBar.maskNode = SKSpriteNode(color: NSColor.white,
            size: CGSize(width: size.width * 2, height: size.height * 2))

        self.progressBar.maskNode?.position = CGPoint(x: -size.width / 2, y: -size.height / 2)
        self.progressBar.zPosition = self.zPosition + 2
        self.progressBar.maskNode?.xScale = 0
        self.addChild(self.progressBar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(progress: CGFloat) {

        self.progressBar.maskNode?.removeAction(forKey: ProgressBarNode.kProgressAnimationKey)

        let value = max(0.0, min(1.0, progress))

        let scaleAction = SKAction.scaleX(to: value, duration: 0.0)
        self.progressBar.maskNode?.run(scaleAction, withKey: ProgressBarNode.kProgressAnimationKey)
    }
}
