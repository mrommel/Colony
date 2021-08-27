//
//  TrackingNSHostingView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

class TrackingNSHostingView<Content>: NSHostingView<Content> where Content: View {

    let onMove: (NSPoint) -> Void

    init(onMove: @escaping (NSPoint) -> Void, rootView: Content) {
        self.onMove = onMove

        super.init(rootView: rootView)

        self.setupTrackingArea()
    }

    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTrackingArea() {
        let options: NSTrackingArea.Options = [.mouseMoved, .activeAlways, .inVisibleRect]
        self.addTrackingArea(NSTrackingArea.init(rect: .zero, options: options, owner: self, userInfo: nil))
    }

    override func mouseMoved(with event: NSEvent) {
        self.onMove(self.convert(event.locationInWindow, from: nil))
    }
}
