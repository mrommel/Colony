//
//  MapProgressViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

class MapProgressViewController: NSViewController {

    var viewModel: MapProgressViewModel

    init(mapType: MapType, mapSize: MapSize) {

        self.viewModel = MapProgressViewModel(mapType: mapType, mapSize: mapSize)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {

        var mapProgressView = MapProgressView(viewModel: self.viewModel)
        mapProgressView.delegate = self
        mapProgressView.bind()

        self.view = NSHostingView(rootView: mapProgressView)
    }
}

extension MapProgressViewController: MapProgressViewDelegate {

    func generated(map: MapModel?) {

        DispatchQueue.main.async {

            self.dismiss(self)

            if let window = NSApplication.shared.windows.first,
               let editorViewController = window.contentViewController as? EditorViewController {

                editorViewController.viewModel.set(map: map)
            }
        }
    }
}
