//
//  Tooltip.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.10.21.
//

import SwiftUI
import SmartAssets
import SwiftUITooltip

/// container view to show tooltip string / attributed string
///
/// TooltipContainerView("tooltip text") {
///    Text("content text")
/// }
public struct TooltipContainerView<Content: View>: View {

    private var tooltipText: NSAttributedString
    @ViewBuilder var content: Content

    @State private var tooltipShown: Bool = false
    @State private var side: TooltipSide = .bottom

    public init(_ textRef: String?, side: TooltipSide = .bottom, @ViewBuilder content: () -> Content) {

        self.content = content()
        if let text = textRef {
            self.tooltipText = NSAttributedString(string: text)
        } else {
            self.tooltipText = NSAttributedString(string: "-")
        }
        self.side = side
    }

    public init(_ attributedTextRef: NSAttributedString?, side: TooltipSide = .bottom, @ViewBuilder content: () -> Content) {

        self.content = content()
        if let attributedText = attributedTextRef {
            self.tooltipText = attributedText
        } else {
            self.tooltipText = NSAttributedString(string: "-")
        }
        self.side = side
    }

    public var body: some View {

        self.content
            .onHover { over in
                self.tooltipShown = over
            }
            .tooltip(self.tooltipShown, side: self.side) {
                Label(self.tooltipText)
            }
    }
}
