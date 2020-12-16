//
//  Civ5MapImportingViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 16.12.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

class Civ5MapImportingViewController: NSViewController {

    var viewModel: Civ5MapImportingViewModel
    
    init(url: URL?) {
        
        self.viewModel = Civ5MapImportingViewModel(url: url)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        
        var civ5mapLoadingView = Civ5MapImportingView(viewModel: self.viewModel)
        civ5mapLoadingView.delegate = self
        civ5mapLoadingView.bind()
            
        self.view = NSHostingView(rootView: civ5mapLoadingView)
    }
}

extension Civ5MapImportingViewController: Civ5MapImportingViewDelegate {
    
    func imported(map: MapModel?) {
        
        self.dismiss(self)
        
        if let window = NSApplication.shared.windows.first,
           let editorViewController = window.contentViewController as? EditorViewController {
            
            editorViewController.viewModel.set(map: map)
        }
    }
}
