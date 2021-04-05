//
//  ResourceLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SwiftUI

public struct ResourceLayerView: View {
    
    let viewModel: ResourceLayerViewModel?
    
    init(viewModel: ResourceLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
