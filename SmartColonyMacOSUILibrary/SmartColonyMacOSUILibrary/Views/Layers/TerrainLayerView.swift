//
//  TerrainLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.03.21.
//

import SwiftUI

public struct TerrainLayerView: View {
    
    let viewModel: TerrainLayerViewModel?
    
    init(viewModel: TerrainLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
