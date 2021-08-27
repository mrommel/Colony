//
//  ViewExtension.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import SwiftUI
import Cocoa

extension View {

    func trackingMouse(onMove: @escaping (NSPoint) -> Void) -> some View {
        TrackingAreaView(onMove: onMove) { self }
    }
}
