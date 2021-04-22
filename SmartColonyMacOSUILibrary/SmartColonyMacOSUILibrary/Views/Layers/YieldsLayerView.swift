//
//  YieldsLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 22.04.21.
//

import SwiftUI

public struct YieldsLayerView: View {
    
    let viewModel: YieldsLayerViewModel?
    
    init(viewModel: YieldsLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .yellow, size: NSSize(width: 500, height: 500)))
    }
}
