//
//  TrackingAreaRepresentable.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

struct TrackingAreaRepresentable<Content>: NSViewRepresentable where Content: View {
    
    let onMove: (NSPoint) -> Void
    let content: Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        return TrackingNSHostingView(onMove: onMove, rootView: self.content)
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
    }
}
