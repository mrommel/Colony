//
//  MapSavingViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 09.12.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

class MapSavingViewController: NSViewController {

    var viewModel: MapSavingViewModel

    init(map: MapModel?, to url: URL?) {

        self.viewModel = MapSavingViewModel(map: map, to: url)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {

        var mapSavingView = MapSavingView(viewModel: self.viewModel)
        mapSavingView.delegate = self
        mapSavingView.bind()

        self.view = NSHostingView(rootView: mapSavingView)
    }
}

extension MapSavingViewController: MapSavingViewDelegate {

    func saved(with success: Bool) {

        self.dismiss(self)
    }
}
