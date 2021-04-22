//
//  ResourceMarkerLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI

public struct ResourceMarkerLayerView: View {
    
    let viewModel: ResourceMarkerLayerViewModel?
    
    init(viewModel: ResourceMarkerLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .yellow, size: NSSize(width: 500, height: 500)))
    }
}
