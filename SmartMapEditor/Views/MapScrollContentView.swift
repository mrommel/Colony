//
//  ScrollContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import Cocoa
import SwiftUI
import SmartAILibrary

// https://www.calincrist.com/blog/2020-04-12-how-to-get-notified-for-changes-in-swiftui/
struct MapScrollContentView: NSViewRepresentable {

    @ObservedObject
    var viewModel: EditorContentViewModel

    typealias UIViewType = MapScrollView

    var scrollView: MapScrollView = MapScrollView(frame: .zero)
    var mapView: MapView? = MapView(frame: .zero)

    func makeNSView(context: Context) -> MapScrollView {

        self.scrollView.setAccessibilityEnabled(true)
        self.scrollView.hasVerticalScroller = true
        self.scrollView.hasHorizontalScroller = true

        self.mapView?.delegate = context.coordinator
        self.mapView?.setViewSize(self.viewModel.zoom)
        
        self.viewModel.didChange = { pt in
            self.mapView?.redrawTile(at: pt)
        }
        
        self.scrollView.documentView = self.mapView

        return scrollView
    }

    func updateNSView(_ scrollView: MapScrollView, context: Context) {

        // print("map scroll content view update to: \(self.viewModel.zoom)")
        if let mapView = scrollView.documentView as? MapView {

            mapView.setViewSize(self.viewModel.zoom)
            
            if mapView.map != self.viewModel.map {
                mapView.map = self.viewModel.map
            }
        }
    }

    func makeCoordinator() -> MapScrollContentView.Coordinator {
        
        Coordinator(mapScrollContentView: self)
    }

    final class Coordinator: NSObject, MapViewDelegate {

        var mapScrollContentView: MapScrollContentView?

        init(mapScrollContentView: MapScrollContentView?) {

            self.mapScrollContentView = mapScrollContentView
        }

        func moveBy(dx: CGFloat, dy: CGFloat) {

            self.mapScrollContentView?.scrollView.scrollBy(dx: dx, dy: dy)
        }

        func focus(on tile: Tile) {

            self.mapScrollContentView?.viewModel.setFocus(to: tile)
        }
    }
}
