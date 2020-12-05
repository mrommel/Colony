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

    @Binding var focus: AbstractTile?
    @Binding var mapZoom: CGFloat

    typealias UIViewType = MapScrollView

    var scrollView: MapScrollView? = MapScrollView(frame: .zero)
    var mapView: MapView? = MapView(frame: .zero)

    func makeNSView(context: Context) -> MapScrollView {

        self.scrollView?.setAccessibilityEnabled(true)
        self.scrollView?.hasVerticalScroller = true
        self.scrollView?.hasHorizontalScroller = true

        mapView?.delegate = context.coordinator
        mapView?.setViewSize(self.$mapZoom.wrappedValue)
        self.scrollView?.documentView = mapView

        // load map
        DispatchQueue.global(qos: .background).async {

            let mapOptions = MapOptions(withSize: MapSize.tiny, leader: .alexander, handicap: .settler)
            mapOptions.enhanced.sealevel = .low

            let generator = MapGenerator(with: mapOptions)
            generator.progressHandler = { progress, text in
                //mapLoadingDialog.showProgress(value: progress, text: text)
                print("map - progress: \(progress)")
            }

            if let map = generator.generate() {

                // ensure that this runs on UI thread
                DispatchQueue.main.async {
                    mapView?.map = map

                    // show okay button
                    print("map - progress: ready")
                }
            }
        }

        return scrollView!
    }

    func updateNSView(_ scrollView: MapScrollView, context: Context) {

        // print("map scroll content view update to: \(self.$mapZoom.wrappedValue)")
        self.mapView?.setViewSize(self.$mapZoom.wrappedValue)
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

            self.mapScrollContentView?.scrollView?.scrollBy(dx: dx, dy: dy)
        }

        func focus(on tile: AbstractTile) {

            self.mapScrollContentView?.$focus.wrappedValue = tile
        }
    }
}
