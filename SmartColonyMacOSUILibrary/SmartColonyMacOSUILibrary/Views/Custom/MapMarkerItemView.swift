//
//  MapMarkerItemView.swift
//  SmartColonyMacOSUILibrary
//
//  Created by Michael Rommel on 01.05.22.
//

import SwiftUI
import SmartAssets

struct MapMarkerItemView: View {

    @ObservedObject
    var viewModel: MapMarkerItemViewModel

    init(viewModel: MapMarkerItemViewModel) {

        self.viewModel = viewModel
    }

    var body: some View {

        HStack(alignment: .center) {

            Image(nsImage: self.viewModel.image())
                .resizable()
                .frame(width: 16, height: 16)
                .onTapGesture {
                    self.viewModel.clickedCenter()
                }

            Text(self.viewModel.markerTitle)
                .frame(width: 84, alignment: .leading)
                .onTapGesture {
                    self.viewModel.clickedCenter()
                }

            Image(nsImage: self.viewModel.removeImage())
                .resizable()
                .frame(width: 16, height: 16)
                .onTapGesture {
                    self.viewModel.clickedRemove()
                }

            Image(nsImage: self.viewModel.centerImage())
                .resizable()
                .frame(width: 16, height: 16)
                .onTapGesture {
                    self.viewModel.clickedCenter()
                }
        }
        .frame(width: 140)
    }
}

/*
struct MapMarkerItemView_Previews: PreviewProvider {
    static var previews: some View {
        MapMarkerItemView()
    }
}*/
