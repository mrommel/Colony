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
    private var tooltipConfig = DefaultTooltipConfig()

    public init(_ textRef: String?, side: TooltipSide = .bottom, @ViewBuilder content: () -> Content) {

        self.content = content()
        if let text = textRef {
            self.tooltipText = NSAttributedString(string: text)
        } else {
            self.tooltipText = NSAttributedString(string: "-")
        }
        self.side = side
        self.tooltipConfig.borderColor = Color(red: 0.072, green: 0.119, blue: 0.155)
        self.tooltipConfig.backgroundColor = Color(red: 0.894, green: 0.894, blue: 0.894)
        self.tooltipConfig.side = side
    }

    public init(_ attributedTextRef: NSAttributedString?, side: TooltipSide = .bottom, @ViewBuilder content: () -> Content) {

        self.content = content()
        if let attributedText = attributedTextRef {
            self.tooltipText = attributedText
        } else {
            self.tooltipText = NSAttributedString(string: "-")
        }
        self.side = side
        self.tooltipConfig.borderColor = Color(red: 0.072, green: 0.119, blue: 0.155)
        self.tooltipConfig.backgroundColor = Color(red: 0.894, green: 0.894, blue: 0.894)
        self.tooltipConfig.side = side
    }

    public var body: some View {

        self.content
            .onHover { over in
                self.tooltipShown = over
            }
            .tooltip(self.tooltipShown, side: self.side, config: self.tooltipConfig) {
                Label(self.tooltipText)
            }
    }
}
