//
//  Label.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.11.21.
//

import SwiftUI
import SmartAssets

extension NSTextAttachment {

    func setImage(height: CGFloat) {

        guard let image = image else { return }

        let ratio = image.size.width / image.size.height

        self.bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: ratio * height, height: height)
    }
}

public struct Label: NSViewRepresentable {

    static let tokenizer = LabelTokenizer()
    let attributedString: NSAttributedString

    public init(text rawText: String) {

        let attributedString = NSMutableAttributedString()

        for token in Label.tokenizer.tokenize(text: rawText) {

            switch token {

            case .text(content: let content):
                attributedString.append(NSAttributedString(string: content))

            case .translation(key: let key):
                let content = NSLocalizedString(key, comment: "automated translation for '\(key)'")
                attributedString.append(NSAttributedString(string: content))

            case .image(type: let type):
                let attachment: NSTextAttachment = NSTextAttachment()
                attachment.image = type.image()
                attachment.setImage(height: 12)

                let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentString)
            }

            attributedString.append(NSAttributedString(string: " "))
        }

        self.attributedString = attributedString
    }

    public init(text rawText: NSAttributedString) {

        self.attributedString = rawText
    }

    public func makeNSView(context: Context) -> NSTextField {

        let textField = NSTextField()

        textField.isBezeled = false
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isSelectable = false

        textField.maximumNumberOfLines = 0
        textField.alignment = .left
        textField.lineBreakMode = .byWordWrapping
        textField.autoresizesSubviews = true

        textField.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(250), for: .horizontal)
        textField.autoresizingMask = [NSView.AutoresizingMask.width, NSView.AutoresizingMask.height]

        return textField
    }

    public func updateNSView(_ nsView: NSTextField, context: Context) {

        nsView.attributedStringValue = self.attributedString
    }

    public func font(_ style: NSFont.TextStyle) -> Label {

        let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedString)
        let completeRange = NSRange(location: 0, length: mutableAttributedString.length)
        let font = NSFont.preferredFont(forTextStyle: style)

        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: font.pointSize), range: completeRange)

        return Label(text: mutableAttributedString)
    }
}
