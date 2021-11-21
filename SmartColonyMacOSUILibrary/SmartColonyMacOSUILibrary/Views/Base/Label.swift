//
//  Label.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.11.21.
//

import SwiftUI
import SmartAssets

public struct Label: NSViewRepresentable {

    //fileprivate var configuration = { (view: TheNSView) in }
    let text: NSAttributedString

    public init(text rawText: String) {

        var test = ""
        let tokenizer = LabelTokenizer()
        var attributedString = NSMutableAttributedString()

        for token in tokenizer.tokenize(text: rawText) {

            switch token {

            case .text(content: let content):
                attributedString.append(NSAttributedString(string: content))
            case .image(type: let type):
                let attachment: NSTextAttachment = NSTextAttachment()
                attachment.image = type.image()
                // attachment.setImageHeight(height: 20)

                let attachmentString: NSAttributedString = NSAttributedString(attachment: attachment)
                attributedString.append(attachmentString)
                //test += "-" + type + "."
            }
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
