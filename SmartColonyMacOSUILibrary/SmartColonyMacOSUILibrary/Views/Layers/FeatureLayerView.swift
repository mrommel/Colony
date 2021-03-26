//
//  FeatureLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.03.21.
//

import Foundation

import SwiftUI

public struct FeatureLayerView: View {
    
    let viewModel: FeatureLayerViewModel?
    
    init(viewModel: FeatureLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
