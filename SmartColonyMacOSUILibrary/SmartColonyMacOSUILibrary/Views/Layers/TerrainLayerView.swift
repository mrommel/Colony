//
//  TerrainLayerView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 24.03.21.
//

import SwiftUI

public struct TerrainLayerView: View {
    
    @ObservedObject
    var viewModel: TerrainLayerViewModel
    
    init(viewModel: TerrainLayerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Image(nsImage: self.viewModel.image)
    }
}
