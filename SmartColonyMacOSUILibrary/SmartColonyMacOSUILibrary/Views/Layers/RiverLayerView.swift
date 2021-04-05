//
//  RiverLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 26.03.21.
//

import SwiftUI

public struct RiverLayerView: View {
    
    let viewModel: RiverLayerViewModel?
    
    init(viewModel: RiverLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
