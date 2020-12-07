//
//  TrackingAreaView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

struct TrackingAreaView<Content>: View where Content: View {
    
    let onMove: (NSPoint) -> Void
    let content: () -> Content

    init(onMove: @escaping (NSPoint) -> Void, @ViewBuilder content: @escaping () -> Content) {
        self.onMove = onMove
        self.content = content
    }

    var body: some View {
        TrackingAreaRepresentable(onMove: onMove, content: self.content())
    }
}
