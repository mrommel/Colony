//
//  TooltipNode.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 03.06.21.
//

import SpriteKit
import SmartAssets

extension NSAttributedString {

    func height(for width: CGFloat) -> CGFloat {

        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return boundingBox.height
    }

    public func width(for height: CGFloat) -> CGFloat {

        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )

        return boundingBox.width
    }
}

class TooltipNode: SKNode {

    private static let tokenizer = LabelTokenizer()

    var backgroundNode: SKSpriteNode?
    //var messageLabelNode: SKLabelNode?
    var messageLabelNode: SKSpriteNode?

    init(text: String) {

        super.init()

        let attributedText = TooltipNode.tokenizer.convert(text: text, with: Globals.Attributs.tooltipMapAttributs, extraSpace: true)
        let height: CGFloat = 20
        let width: CGFloat = attributedText.width(for: height)
        let size = CGSize(width: width, height: height)

        let boxTexture = SKTexture(image: ImageCache.shared.image(for: "box-gold"))
        let boundingBox = CGSize(width: width, height: height)

        self.backgroundNode = NineGridTextureSprite(texture: boxTexture, color: .black, size: boundingBox)
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = self.zPosition + 1
        self.addChild(self.backgroundNode!)

        let image = drawImageInNSGraphicsContext(size: size) {

            let options: NSString.DrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
            let strHeight: CGFloat = attributedText.boundingRect(with: size, options: options, context: nil).height
            let yOffset: CGFloat = (height - strHeight) / 2.0

            attributedText.draw(with: CGRect(x: 0, y: yOffset, width: width, height: strHeight), options: options, context: nil)
        }

        let texture: SKTexture = SKTexture(cgImage: image.cgImage!)

        self.messageLabelNode = SKSpriteNode(texture: texture, size: CGSize(width: width, height: height))
        self.messageLabelNode?.position = CGPoint(x: 0, y: 0)
        self.messageLabelNode?.zPosition = self.zPosition + 2
        self.addChild(self.messageLabelNode!)

        // self.setScale(0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
