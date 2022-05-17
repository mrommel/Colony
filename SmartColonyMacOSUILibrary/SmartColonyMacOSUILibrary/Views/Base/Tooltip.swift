//
//  Tooltip.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.10.21.
//

import SwiftUI
import SmartAssets
import SwiftUITooltip

/// add view modifier to show tooltip string / attributed string
///
/// view
///    .tooltip("content text")
///
extension View {

    public func tooltip(_ textRef: String?, side: TooltipSide = .bottom) -> some View {
        TooltipContainerView(textRef, side: side) { self }
    }

    public func tooltip(_ attributedTextRef: NSAttributedString?, side: TooltipSide = .bottom) -> some View {
        TooltipContainerView(attributedTextRef, side: side) { self }
    }
}

/// container view to show tooltip string / attributed string
///
/// TooltipContainerView("tooltip text") {
///    Text("content text")
/// }
private struct TooltipContainerView<Content: View>: View {

    private var tooltipText: NSAttributedString
    @ViewBuilder var content: Content

    @State private var tooltipShown: Bool = false
    private var tooltipConfig = DefaultTooltipConfig()

    init(_ textRef: String?, side: TooltipSide = .bottom, @ViewBuilder content: () -> Content) {

        self.content = content()
        if let text = textRef {
            self.tooltipText = NSAttributedString(string: text)
        } else {
            self.tooltipText = NSAttributedString(string: "-")
        }

        self.tooltipConfig.borderColor = Color(red: 0.072, green: 0.119, blue: 0.155)
        self.tooltipConfig.backgroundColor = Color(red: 0.894, green: 0.894, blue: 0.894)
        self.tooltipConfig.side = side
    }

    init(_ attributedTextRef: NSAttributedString?, side: TooltipSide = .bottom, @ViewBuilder content: () -> Content) {

        self.content = content()
        if let attributedText = attributedTextRef {
            self.tooltipText = attributedText
        } else {
            self.tooltipText = NSAttributedString(string: "-")
        }

        self.tooltipConfig.borderColor = Color(red: 0.072, green: 0.119, blue: 0.155)
        self.tooltipConfig.backgroundColor = Color(red: 0.894, green: 0.894, blue: 0.894)
        self.tooltipConfig.side = side
    }

    var body: some View {

        self.content
            .onHover { over in
                self.tooltipShown = over
            }
            .tooltip(self.tooltipShown, config: self.tooltipConfig) {
                Label(self.tooltipText)
            }
    }
}
