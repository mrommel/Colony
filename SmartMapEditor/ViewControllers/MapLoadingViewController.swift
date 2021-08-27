//
//  MapLoadingViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 09.12.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

class MapLoadingViewController: NSViewController {

    var viewModel: MapLoadingViewModel

    init(url: URL?) {

        self.viewModel = MapLoadingViewModel(url: url)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {

        var mapLoadingView = MapLoadingView(viewModel: self.viewModel)
        mapLoadingView.delegate = self
        mapLoadingView.bind()

        self.view = NSHostingView(rootView: mapLoadingView)
    }
}

extension MapLoadingViewController: MapLoadingViewDelegate {

    func loaded(map: MapModel?) {

        self.dismiss(self)

        if let window = NSApplication.shared.windows.first,
           let editorViewController = window.contentViewController as? EditorViewController {

            editorViewController.viewModel.set(map: map)
        }
    }
}
