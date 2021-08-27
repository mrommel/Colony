//
//  NewMapViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

class NewMapViewController: NSViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {

        var newMapContentView = NewMapContentView()
        newMapContentView.delegate = self

        self.view = NSHostingView(rootView: newMapContentView)
    }
}

extension NewMapViewController: NewMapContentViewDelegate {

    func clickedGenerate(mapType: MapType, mapSize: MapSize) {

        DispatchQueue.main.async {

            self.dismiss(self)

            if let window = NSApplication.shared.windows.first,
               let editorViewController = window.contentViewController as? EditorViewController {

                let mapProgressViewController = MapProgressViewController(mapType: mapType, mapSize: mapSize)
                editorViewController.presentAsSheet(mapProgressViewController)
            }
        }
    }
}
