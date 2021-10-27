//
//  Tooltip.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.10.21.
//

import SwiftUI

// https://stackoverflow.com/questions/63217860/how-to-add-tooltip-on-macos-10-15-with-swiftui
struct ToolTip: NSViewRepresentable {

    let toolTipText: String

    func makeNSView(context: NSViewRepresentableContext<ToolTip>) -> NSView {

        let view = NSView()
        view.toolTip = toolTipText

        return view
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<ToolTip>) {

        // NOOP
    }
}

public extension View {

    func toolTip(_ toolTipText: String) -> some View {

        self.overlay(ToolTip(toolTipText: toolTipText))
    }
}
