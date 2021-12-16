//
//  Label.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 21.11.21.
//

import SwiftUI
import SmartAssets

public struct Label: NSViewRepresentable {

    static let tokenizer = LabelTokenizer()

    let attributedString: NSAttributedString
    let preferredMaxLayoutWidth: CGFloat
    let textAlignment: NSTextAlignment

    public init(text rawText: String,
                width: CGFloat? = nil,
                alignment: NSTextAlignment? = nil) {

        if let width = width {
            self.preferredMaxLayoutWidth = width
        } else {
            self.preferredMaxLayoutWidth = 200
        }

        if let alignment = alignment {
            self.textAlignment = alignment
        } else {
            self.textAlignment = .center
        }

        self.attributedString = Label.tokenizer.convert(text: rawText)
    }

    public init(text rawText: NSAttributedString,
                width: CGFloat? = nil,
                alignment: NSTextAlignment? = nil) {

        if let width = width {
            self.preferredMaxLayoutWidth = width
        } else {
            self.preferredMaxLayoutWidth = 200
        }

        if let alignment = alignment {
            self.textAlignment = alignment
        } else {
            self.textAlignment = .center
        }

        self.attributedString = rawText
    }

    public func makeNSView(context: Context) -> NSTextField {

        let textField = NSTextField()

        textField.isBezeled = false
        textField.drawsBackground = false
        textField.isEditable = false
        textField.isSelectable = false

        textField.maximumNumberOfLines = 0
        textField.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        textField.alignment = self.textAlignment
        textField.lineBreakMode = .byWordWrapping

        return textField
    }

    public func updateNSView(_ nsView: NSTextField, context: Context) {

        nsView.attributedStringValue = self.attributedString
        nsView.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        nsView.alignment = self.textAlignment

        nsView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nsView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    /// Sets the default font for text in the view.
    ///
    /// Use `font(_:)` to apply a specific font to an individual
    /// Label, or all of the text views in a container.
    ///
    /// In the example below, the first text field has a font set directly,
    /// while the font applied to the following container applies to all of the
    /// text views inside that container:
    ///
    ///     VStack {
    ///         Label(text: "Font applied to a text view.")
    ///             .font(.largeTitle)
    ///
    ///         VStack {
    ///             Label(text: "These two text views have the same font")
    ///             Label(text: "applied to their parent view.")
    ///         }
    ///         .font(.system(size: 16, weight: .light, design: .default))
    ///     }
    ///
    /// - Parameter font: The font to use when displaying this text.
    /// - Returns: Text that uses the font you specify.
    public func font(_ style: NSFont.TextStyle) -> Label {

        let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedString)
        let completeRange = NSRange(location: 0, length: mutableAttributedString.length)
        let font = NSFont.preferredFont(forTextStyle: style)

        mutableAttributedString.addAttribute(NSAttributedString.Key.font, value: NSFont.systemFont(ofSize: font.pointSize), range: completeRange)

        return Label(text: mutableAttributedString)
    }

    public func frame(width: CGFloat? = nil, alignment: Alignment = .center) -> Label {

        var textAlignment: NSTextAlignment = .center

        switch alignment {
        case .center: textAlignment = .center
        case .leading: textAlignment = .left
        case .trailing: textAlignment = .right

        default:
            fatalError("Invalid textAlignment: \(alignment)")
        }

        return Label(
            text: self.attributedString,
            width: width, alignment: textAlignment)
    }
}

#if DEBUG
struct Label_Previews: PreviewProvider {

    static var loremIpsum: String = "Lorem ipsum dolor sit amet, consetetur " +
    "sadipscing elitr, sed diam nonumy eirmod tempor " +
    "invidunt ut labore et dolore magna aliquyam erat, " +
    "sed diam voluptua. At vero eos et accusam et justo " +
    "duo dolores et ea rebum. Stet clita kasd gubergren, " +
    "no sea takimata sanctus est Lorem ipsum dolor sit " +
    "amet. Lorem ipsum dolor sit amet, consetetur sadipscing " +
    "elitr, sed diam nonumy eirmod tempor " +
    "invidunt ut labore et dolore magna aliquyam erat, " +
    "sed diam voluptua. At vero eos et accusam et justo " +
    "duo dolores et ea rebum. Stet clita kasd gubergren, " +
    "no sea takimata sanctus est Lorem ipsum dolor sit " +
    "amet."

    static var previews: some View {

        Label(text: "Normal text")
            .frame(width: 120)

        Label(text: "Footnote text")
            .font(.footnote)
            .frame(width: 120)

        Label(text: "Title1 text")
            .font(.title1)
            .frame(width: 120)

        Label(text: Label_Previews.loremIpsum)
            .frame(width: 120)
            .fixedSize(horizontal: false, vertical: true)
            .previewLayout(.sizeThatFits)

        Label(text: "Attributed parsed [Production]")
            .frame(width: 120)

        Label(text: "Very Long Attributed parsed [Production] without line [Food] breaks")
            .frame(width: 120)

        Label(text: NSAttributedString(string: "Native Attributed"))
            .frame(width: 120)
    }
}
#endif
