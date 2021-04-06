//
//  CityLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

public struct CityLayerView: View {
    
    let viewModel: CityLayerViewModel?
    
    init(viewModel: CityLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
