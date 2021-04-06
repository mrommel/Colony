//
//  ImprovementLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 05.04.21.
//

import SwiftUI

public struct ImprovementLayerView: View {
    
    let viewModel: ImprovementLayerViewModel?
    
    init(viewModel: ImprovementLayerViewModel?) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel?.image ?? NSImage(color: .red, size: NSSize(width: 500, height: 500)))
    }
}
