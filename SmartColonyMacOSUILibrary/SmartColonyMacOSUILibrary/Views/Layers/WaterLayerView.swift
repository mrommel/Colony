//
//  WaterLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI

public struct WaterLayerView: View {
    
    let viewModel: WaterLayerViewModel?
    
    init(viewModel: WaterLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .yellow, size: NSSize(width: 500, height: 500)))
    }
}
