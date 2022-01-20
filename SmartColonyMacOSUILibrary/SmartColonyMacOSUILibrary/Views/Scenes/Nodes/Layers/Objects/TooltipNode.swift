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

// https://stackoverflow.com/questions/57263134/sklabelnode-possible-to-insert-nstextattachment-or-icon-into-block-of-text
class AdvancedLabelNode: SKLabelNode {

    init(attributedText: NSAttributedString) {
        super.init()
        self.attributedText = attributedText

        let completeRange = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttributes(in: completeRange, options: []) { (value, range, _) in

            print("value: \(value), range = \(range)")
            let part = attributedText.string.substring(with: Range(range, in: attributedText.string)!)
            print("part: '\(part)'")
        }

        attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: completeRange, options: []) { (value, range, stop) in

            if let attachment = value as? NSTextAttachment, let image = attachment.image {

                print("image bounds = \(attachment.bounds), range = \(range), stop = \(stop)")
                let texture = SKTexture(image: image)
                let imageSpriteNode = SKSpriteNode(texture: texture)
                imageSpriteNode.size = attachment.bounds.size
                imageSpriteNode.position = CGPoint(x: CGFloat(range.location) * 5.6 - (self.frame.width / 2), y: 0)
                imageSpriteNode.zPosition = self.zPosition + 0.01
                self.addChild(imageSpriteNode)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*override var zPosition: CGFloat {
        set {

        }
    }*/
}

class TooltipNode: SKNode {

    private static let tokenizer = LabelTokenizer()

    var backgroundNode: SKSpriteNode?
    var messageLabelNode: SKLabelNode?

    init(text: String) {

        super.init()

        let attributedText = TooltipNode.tokenizer.convert(text: text, with: Globals.Attributs.tooltipMapAttributs, extraSpace: true)
        let height: CGFloat = 20
        let width: CGFloat = attributedText.width(for: height)

        let boxTexture = SKTexture(image: ImageCache.shared.image(for: "box-gold"))
        let boundingBox = CGSize(width: width, height: height)

        self.backgroundNode = NineGridTextureSprite(texture: boxTexture, color: .black, size: boundingBox)
        self.backgroundNode?.position = CGPoint(x: 0, y: 0)
        self.backgroundNode?.zPosition = self.zPosition + 1
        self.addChild(self.backgroundNode!)

        self.messageLabelNode = AdvancedLabelNode(attributedText: attributedText)
        self.messageLabelNode?.position = CGPoint(x: 0, y: 0)
        self.messageLabelNode?.zPosition = self.zPosition + 2
        self.messageLabelNode?.horizontalAlignmentMode = .center
        self.messageLabelNode?.verticalAlignmentMode = .center
        self.messageLabelNode?.numberOfLines = 0
        self.messageLabelNode?.lineBreakMode = .byWordWrapping
        self.messageLabelNode?.preferredMaxLayoutWidth = width
        self.addChild(self.messageLabelNode!)

        self.setScale(0.5)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
