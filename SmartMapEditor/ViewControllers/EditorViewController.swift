//
//  EditorViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import Cocoa
import SwiftUI
import SmartAILibrary

class EditorViewController: NSViewController {

    let viewModel: EditorViewModel

    init() {

        self.viewModel = EditorViewModel()

        super.init(nibName: nil, bundle: nil)

        self.viewModel.mapChanged = { map in

            if let host = self.view as? NSHostingView<EditorContentView> {
                host.rootView.set(map: map)
            }
        }

        self.viewModel.showStartLocationsChanged = { option in

            if let host = self.view as? NSHostingView<EditorContentView> {
                host.rootView.setShowStartLocations(to: option)
            }
        }

        self.viewModel.showInhabitantsChanged = { option in

            if let host = self.view as? NSHostingView<EditorContentView> {
                host.rootView.setShowInhabitants(to: option)
            }
        }

        self.viewModel.showSupportedPeopleChanged = { option in

            if let host = self.view as? NSHostingView<EditorContentView> {
                host.rootView.setShowSupportedPeople(to: option)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {

        let editorContentView = EditorContentView()

        self.view = NSHostingView(rootView: editorContentView)
    }
}
