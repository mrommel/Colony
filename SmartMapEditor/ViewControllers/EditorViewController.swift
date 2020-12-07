//
//  EditorViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 07.12.20.
//

import Cocoa
import SwiftUI
import SmartAILibrary

class EditorViewModel {
    
    typealias MapChangeHandler = (MapModel?) -> Void
    
    var mapChanged: MapChangeHandler? = nil
    
    func set(map: MapModel?) {

        self.mapChanged?(map)
    }
}

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
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        
        let editorContentView = EditorContentView()
        
        self.view = NSHostingView(rootView: editorContentView)
    }
}
