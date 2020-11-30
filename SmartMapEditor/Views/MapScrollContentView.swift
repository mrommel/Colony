//
//  ScrollContentView.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 30.11.20.
//

import Cocoa
import SwiftUI
import SmartAILibrary

class MapScrollView: NSScrollView {

    override init(frame: NSRect) {

        super.init(frame: frame)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollViewDidScroll),
            name: NSScrollView.didLiveScrollNotification,
            object: self
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func scrollViewDidScroll(notification: NSNotification) {
        // print("self.contentView.bounds.origin = \(self.contentView.bounds.origin)")
    }
    
    func scrollBy(dx: CGFloat, dy: CGFloat) {
        self.contentView.bounds.origin = self.contentView.bounds.origin - CGPoint(x: dx, y: dy)
    }
}

struct MapScrollContentView: NSViewRepresentable {

    @Binding var focus: AbstractTile?

    typealias UIViewType = MapScrollView

    var scrollView: MapScrollView? = MapScrollView(frame: .zero)

    func makeNSView(context: Context) -> MapScrollView {

        self.scrollView?.setAccessibilityEnabled(true)
        self.scrollView?.hasVerticalScroller = true
        self.scrollView?.hasHorizontalScroller = true

        let mapView = MapView(frame: NSMakeRect(0, 0, 1000, 1000))
        mapView.delegate = context.coordinator
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
                    mapView.map = map

                    // show okay button
                    print("map - progress: ready")
                }
            }
        }

        return scrollView!
    }

    func updateNSView(_ scrollView: MapScrollView, context: Context) {

    }

    func makeCoordinator() -> MapScrollContentView.Coordinator {
        Coordinator(scrollView: self.scrollView)
    }

    final class Coordinator: NSObject, MapViewDelegate {

        let scrollView: MapScrollView?

        init(scrollView: MapScrollView?) {

            self.scrollView = scrollView
        }

        func moveBy(dx: CGFloat, dy: CGFloat) {

            self.scrollView?.scrollBy(dx: dx, dy: dy)
        }

        func focus(on tile: AbstractTile) {
            //self.scrollView.focus = tile
        }
    }
}
