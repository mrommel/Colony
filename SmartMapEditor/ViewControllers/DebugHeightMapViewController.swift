//
//  DebugHeightMapViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 23.12.20.
//

import SwiftUI
import Cocoa

class DebugHeightMapViewController: NSViewController {
    
    var viewModel: DebugHeightMapViewModel
    
    init() {
        
        self.viewModel = DebugHeightMapViewModel(size: .standard)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        
        var debugHeightMapView = DebugHeightMapView(viewModel: self.viewModel)
        debugHeightMapView.delegate = self
        debugHeightMapView.bind()
            
        self.view = NSHostingView(rootView: debugHeightMapView)
    }
}

extension DebugHeightMapViewController: EditMetaDataViewDelegate {
    
    func closed() {
        
        self.dismiss(self)
    }
}
