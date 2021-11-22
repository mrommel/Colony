//
//  Tooltip.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.10.21.
//

import SwiftUI
import CustomToolTip

// https://stackoverflow.com/questions/63217860/how-to-add-tooltip-on-macos-10-15-with-swiftui
struct ToolTip: NSViewRepresentable {

    let toolTipText: NSAttributedString

    func makeNSView(context: NSViewRepresentableContext<ToolTip>) -> NSView {

        let view = NSView()
        view.addCustomToolTip(from: toolTipText)

        return view
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<ToolTip>) {

        // NOOP
    }
}

public extension View {

    func toolTip(_ toolTipText: String) -> some View {

        self.overlay(ToolTip(toolTipText: NSAttributedString(string: toolTipText)))
    }

    func toolTip(_ toolTipText: NSAttributedString) -> some View {

        self.overlay(ToolTip(toolTipText: toolTipText))
    }
}
