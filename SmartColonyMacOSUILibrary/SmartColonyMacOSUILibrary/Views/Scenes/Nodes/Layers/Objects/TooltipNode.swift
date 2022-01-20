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

extension String {

  func boundingRect(with size: CGSize, attributes: [NSAttributedString.Key: Any]) -> CGRect {
      let options: NSString.DrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
      let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
      return rect
  }
}

// https://stackoverflow.com/questions/57263134/sklabelnode-possible-to-insert-nstextattachment-or-icon-into-block-of-text
class AdvancedLabelNode: SKLabelNode {

    init(attributedText: NSAttributedString) {
        super.init()
        self.attributedText = attributedText

        var lengths: [CGFloat] = []
        var iconIndices: [Int] = []
        var iconIndex: Int = 0
        let completeRange = NSRange(location: 0, length: attributedText.length)

        attributedText.enumerateAttributes(in: completeRange, options: []) { (value, range, _) in

            let part: String = String(attributedText.string[Range(range, in: attributedText.string)!])
            let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: 20.0)
            let size = part.boundingRect(with: constraintRect, attributes: value)
            lengths.append(size.width)

            if value[NSAttributedString.Key.attachment] != nil {
                iconIndices.append(iconIndex)
            }

            iconIndex += 1
        }

        for index in 1..<lengths.count {
            lengths[index] = lengths[index - 1] + lengths[index]
        }

        iconIndex = 0 // reset

        attributedText.enumerateAttribute(NSAttributedString.Key.attachment, in: completeRange, options: []) { (value, _, _) in

            if let attachment = value as? NSTextAttachment, let image = attachment.image {

                let texture = SKTexture(image: image)
                let imageSpriteNode = SKSpriteNode(texture: texture)
                imageSpriteNode.size = attachment.bounds.size
                imageSpriteNode.position = CGPoint(x: lengths[iconIndices[iconIndex]] - 6 - (self.frame.width / 2), y: 0)
                imageSpriteNode.zPosition = self.zPosition + 0.01
                self.addChild(imageSpriteNode)

                iconIndex += 1
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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
