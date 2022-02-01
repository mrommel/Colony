//
//  MapLensLegendItemView.swift
//  SmartMacOSUILibrary
//
//  Created by Michael Rommel on 07.12.21.
//

import SwiftUI

public struct MapLensLegendItemView: View {

    @ObservedObject
    var viewModel: MapLensLegendItemViewModel

    public var body: some View {

        HStack {
            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 16, height: 16)

            Label(self.viewModel.legendTitle)
        }
    }
}
