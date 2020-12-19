//
//  EditMetaDataViewController.swift
//  SmartMapEditor
//
//  Created by Michael Rommel on 19.12.20.
//

import SwiftUI
import Cocoa
import SmartAILibrary

class EditMetaDataViewController: NSViewController {

    var viewModel: EditMetaDataViewModel
    
    init(of map: MapModel?) {
        
        self.viewModel = EditMetaDataViewModel(of: map)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        
        var editMetaDataView = EditMetaDataView(viewModel: self.viewModel)
        editMetaDataView.delegate = self
        editMetaDataView.bind()
            
        self.view = NSHostingView(rootView: editMetaDataView)
    }
}

extension EditMetaDataViewController: EditMetaDataViewDelegate {
    
    func closed() {
        
        self.dismiss(self)
    }
}
