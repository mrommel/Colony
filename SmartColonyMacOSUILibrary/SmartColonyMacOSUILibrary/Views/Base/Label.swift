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
    let text: NSAttributedString

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

        self.text = attributedString
    }

    public func makeNSView(context: Context) -> NSTextField {

        let label = NSTextField()
        label.isBezeled = false
        label.drawsBackground = false
        label.isEditable = false
        label.isSelectable = false
        return label
    }

    public func updateNSView(_ nsView: NSTextField, context: Context) {

        nsView.attributedStringValue = text
    }
}
