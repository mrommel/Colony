//
//  HexCoordLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 27.03.21.
//

import SwiftUI

public struct HexCoordLayerView: View {
    
    let viewModel: HexCoordLayerViewModel?
    
    init(viewModel: HexCoordLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
